import SwiftUI

// MARK: - Pagination State

/// Represents the current state of pagination
public enum DSPaginationState: Equatable {
    case idle
    case loading
    case loaded
    case error(String)
    case finished

    public var isLoading: Bool {
        self == .loading
    }

    public var canLoadMore: Bool {
        switch self {
        case .idle, .loaded:
            return true
        case .loading, .error, .finished:
            return false
        }
    }
}

// MARK: - Pagination Configuration

/// Configuration options for pagination behavior
public struct DSPaginationConfig {
    /// Number of items from the end that triggers loading
    public let threshold: Int

    /// Minimum time between load requests (prevents rapid-fire calls)
    public let debounceInterval: TimeInterval

    /// Whether to show a loading indicator at the bottom
    public let showsLoadingIndicator: Bool

    /// Creates pagination configuration
    /// - Parameters:
    ///   - threshold: Number of items from end to trigger loading (default: 3)
    ///   - debounceInterval: Minimum time between loads (default: 0.5s)
    ///   - showsLoadingIndicator: Whether to show loading indicator (default: true)
    public init(
        threshold: Int = 3,
        debounceInterval: TimeInterval = 0.5,
        showsLoadingIndicator: Bool = true
    ) {
        self.threshold = threshold
        self.debounceInterval = debounceInterval
        self.showsLoadingIndicator = showsLoadingIndicator
    }

    public static let `default` = DSPaginationConfig()
}

// MARK: - DSPaginatedList

/// A list component with built-in infinite scroll/pagination support
///
/// DSPaginatedList provides automatic pagination with:
/// - Configurable load threshold
/// - Loading indicator at bottom
/// - Error state handling
/// - Pull to refresh support
/// - Debounced load requests
///
/// Example usage:
/// ```swift
/// @State var items: [Item] = []
/// @State var paginationState: DSPaginationState = .idle
///
/// DSPaginatedList(
///     items,
///     state: $paginationState
/// ) { item in
///     ItemRow(item)
/// } onLoadMore: {
///     await loadMoreItems()
/// }
/// ```
public struct DSPaginatedList<Data: RandomAccessCollection, RowContent: View>: View
    where Data.Element: Identifiable
{
    // MARK: - Properties

    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    @Binding private var state: DSPaginationState
    private var config: DSPaginationConfig = .default
    private var onLoadMore: (() async -> Void)?
    private var onRefresh: (() async -> Void)?
    private var onRetry: (() -> Void)?
    private var backgroundColor: Color = DSColors.backgroundPrimary
    private var separatorStyle: DSSeparatorStyle = .singleLine

    @State private var lastLoadTime: Date = .distantPast

    // MARK: - Initialization

    /// Creates a paginated list
    /// - Parameters:
    ///   - data: The collection of data to display
    ///   - state: Binding to the pagination state
    ///   - rowContent: A view builder for row content
    ///   - onLoadMore: Async closure called when more data should be loaded
    public init(
        _ data: Data,
        state: Binding<DSPaginationState>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent,
        onLoadMore: @escaping () async -> Void
    ) {
        self.data = data
        self._state = state
        self.rowContent = rowContent
        self.onLoadMore = onLoadMore
    }

    // MARK: - Body

    public var body: some View {
        listContent
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
    }

    // MARK: - Private Views

    @ViewBuilder
    private var listContent: some View {
        if let onRefresh = onRefresh {
            List {
                listRows
            }
            .refreshable {
                await onRefresh()
            }
        } else {
            List {
                listRows
            }
        }
    }

    @ViewBuilder
    private var listRows: some View {
        ForEach(Array(data.enumerated().map { ($0.offset, $0.element) }), id: \.1.id) { index, item in
            rowContent(item)
                .listRowBackground(backgroundColor)
                .listRowSeparator(separatorStyle.visibility)
                .listRowInsets(EdgeInsets(
                    top: DSSpacing.sm,
                    leading: DSSpacing.lg,
                    bottom: DSSpacing.sm,
                    trailing: DSSpacing.lg
                ))
                .onAppear {
                    checkAndLoadMore(currentIndex: index)
                }
        }

        // Footer view for loading/error states
        footerView
            .listRowBackground(backgroundColor)
            .listRowSeparator(.hidden)
    }

    @ViewBuilder
    private var footerView: some View {
        switch state {
        case .loading:
            if config.showsLoadingIndicator {
                loadingFooter
            }
        case .error(let message):
            errorFooter(message: message)
        case .finished:
            finishedFooter
        case .idle, .loaded:
            EmptyView()
        }
    }

    private var loadingFooter: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text("Loading more...")
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
                .padding(.leading, DSSpacing.sm)
            Spacer()
        }
        .padding(.vertical, DSSpacing.lg)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading more items")
    }

    private func errorFooter(message: String) -> some View {
        VStack(spacing: DSSpacing.sm) {
            Image(systemName: "exclamationmark.triangle")
                .font(.title2)
                .foregroundColor(DSColors.error)

            Text(message)
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
                .multilineTextAlignment(.center)

            if let onRetry = onRetry {
                Button("Retry") {
                    triggerHapticFeedback()
                    onRetry()
                }
                .font(.caption.weight(.medium))
                .foregroundColor(DSColors.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DSSpacing.lg)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Failed to load: \(message). Double tap to retry.")
    }

    private var finishedFooter: some View {
        Text("No more items")
            .font(.caption)
            .foregroundColor(DSColors.textTertiary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, DSSpacing.md)
            .accessibilityLabel("End of list")
    }

    // MARK: - Private Methods

    private func checkAndLoadMore(currentIndex: Int) {
        guard state.canLoadMore else { return }

        let threshold = data.count - config.threshold
        guard currentIndex >= threshold else { return }

        // Debounce check
        let now = Date()
        guard now.timeIntervalSince(lastLoadTime) >= config.debounceInterval else { return }

        lastLoadTime = now
        state = .loading

        Task {
            await onLoadMore?()
        }
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Modifiers

public extension DSPaginatedList {
    /// Sets the pagination configuration
    /// - Parameter config: The pagination configuration
    /// - Returns: A modified list with the specified configuration
    func paginationConfig(_ config: DSPaginationConfig) -> Self {
        var copy = self
        copy.config = config
        return copy
    }

    /// Adds pull to refresh
    /// - Parameter action: The async action to perform on refresh
    /// - Returns: A modified list with pull to refresh
    func onRefresh(_ action: @escaping () async -> Void) -> Self {
        var copy = self
        copy.onRefresh = action
        return copy
    }

    /// Adds retry action for error state
    /// - Parameter action: The action to perform on retry
    /// - Returns: A modified list with retry support
    func onRetry(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy.onRetry = action
        return copy
    }

    /// Sets the background color
    /// - Parameter color: The background color
    /// - Returns: A modified list with the specified background color
    func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }

    /// Sets the separator style
    /// - Parameter style: The separator style
    /// - Returns: A modified list with the specified separator style
    func separatorStyle(_ style: DSSeparatorStyle) -> Self {
        var copy = self
        copy.separatorStyle = style
        return copy
    }
}

// MARK: - Infinite Scroll View Modifier

/// A view modifier that adds infinite scroll behavior to any ScrollView
public struct DSInfiniteScrollModifier: ViewModifier {
    @Binding var state: DSPaginationState
    let threshold: CGFloat
    let onLoadMore: () async -> Void

    public init(
        state: Binding<DSPaginationState>,
        threshold: CGFloat = 100,
        onLoadMore: @escaping () async -> Void
    ) {
        self._state = state
        self.threshold = threshold
        self.onLoadMore = onLoadMore
    }

    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named("infiniteScroll")).maxY
                    )
                }
            )
            .coordinateSpace(name: "infiniteScroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { maxY in
                guard state.canLoadMore else { return }

                if maxY < threshold {
                    state = .loading
                    Task {
                        await onLoadMore()
                    }
                }
            }
    }
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - View Extension

public extension View {
    /// Adds infinite scroll behavior to a ScrollView
    /// - Parameters:
    ///   - state: Binding to the pagination state
    ///   - threshold: Distance from bottom to trigger loading
    ///   - onLoadMore: Async closure called when more data should be loaded
    /// - Returns: A view with infinite scroll behavior
    func dsInfiniteScroll(
        state: Binding<DSPaginationState>,
        threshold: CGFloat = 100,
        onLoadMore: @escaping () async -> Void
    ) -> some View {
        modifier(DSInfiniteScrollModifier(
            state: state,
            threshold: threshold,
            onLoadMore: onLoadMore
        ))
    }
}

// MARK: - Preview

#if DEBUG
struct DSPaginatedList_Previews: PreviewProvider {
    static var previews: some View {
        DSPaginatedListPreviewContainer()
            .previewDisplayName("Light Mode")

        DSPaginatedListPreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DSPaginatedListPreviewContainer: View {
    @State private var items: [PaginationPreviewItem] = (1...15).map {
        PaginationPreviewItem(id: $0, title: "Item \($0)")
    }
    @State private var state: DSPaginationState = .idle
    @State private var page = 1

    var body: some View {
        NavigationView {
            VStack {
                // State indicator
                HStack {
                    Text("State:")
                        .font(.caption)
                    Text("\(String(describing: state))")
                        .font(.caption.monospaced())
                        .foregroundColor(stateColor)
                    Spacer()
                    Button("Reset") {
                        items = (1...15).map { PaginationPreviewItem(id: $0, title: "Item \($0)") }
                        state = .idle
                        page = 1
                    }
                    .font(.caption)
                }
                .padding(.horizontal)

                DSPaginatedList(
                    items,
                    state: $state
                ) { item in
                    HStack {
                        Text(item.title)
                            .foregroundColor(DSColors.textPrimary)
                        Spacer()
                        Text("#\(item.id)")
                            .font(.caption)
                            .foregroundColor(DSColors.textTertiary)
                    }
                } onLoadMore: {
                    await loadMore()
                }
                .onRefresh {
                    await refresh()
                }
                .onRetry {
                    state = .idle
                }
                .separatorStyle(.singleLineInset)
            }
            .navigationTitle("Pagination Demo")
        }
    }

    private var stateColor: Color {
        switch state {
        case .idle:
            return DSColors.textTertiary
        case .loading:
            return DSColors.warning
        case .loaded:
            return DSColors.success
        case .error:
            return DSColors.error
        case .finished:
            return DSColors.info
        }
    }

    private func loadMore() async {
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        page += 1

        // Simulate error on page 4
        if page == 4 {
            state = .error("Failed to load page \(page)")
            return
        }

        // Simulate end of data on page 5
        if page > 5 {
            state = .finished
            return
        }

        let newItems = (1...10).map {
            PaginationPreviewItem(
                id: items.count + $0,
                title: "Item \(items.count + $0)"
            )
        }
        items.append(contentsOf: newItems)
        state = .loaded
    }

    private func refresh() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        items = (1...15).map { PaginationPreviewItem(id: $0, title: "Item \($0)") }
        state = .idle
        page = 1
    }
}

private struct PaginationPreviewItem: Identifiable {
    let id: Int
    let title: String
}
#endif
