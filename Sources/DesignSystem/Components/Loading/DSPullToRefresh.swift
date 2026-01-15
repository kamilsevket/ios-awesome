import SwiftUI

/// A wrapper view that adds pull-to-refresh functionality to scrollable content.
///
/// Use `DSPullToRefresh` to wrap your scrollable content and provide
/// a refresh action that will be triggered when the user pulls down.
///
/// Example usage:
/// ```swift
/// DSPullToRefresh(isRefreshing: $isRefreshing) {
///     await loadData()
/// } content: {
///     LazyVStack {
///         ForEach(items) { item in
///             ItemRow(item: item)
///         }
///     }
/// }
/// ```
public struct DSPullToRefresh<Content: View>: View {
    // MARK: - Properties

    /// Binding to control the refresh state
    @Binding private var isRefreshing: Bool

    /// Async action to perform on refresh
    private let onRefresh: () async -> Void

    /// Content view builder
    private let content: () -> Content

    /// Tint color for the refresh indicator
    private let tintColor: Color

    // MARK: - State

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a pull-to-refresh wrapper.
    /// - Parameters:
    ///   - isRefreshing: Binding to control the refresh state.
    ///   - tintColor: Tint color for the refresh indicator. Defaults to primary color.
    ///   - onRefresh: Async action to perform when pulled to refresh.
    ///   - content: Content view builder.
    public init(
        isRefreshing: Binding<Bool>,
        tintColor: Color = DSColors.primary,
        onRefresh: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isRefreshing = isRefreshing
        self.tintColor = tintColor
        self.onRefresh = onRefresh
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            content()
        }
        .refreshable {
            isRefreshing = true
            await onRefresh()
            isRefreshing = false
        }
        .tint(tintColor)
    }
}

/// A custom pull-to-refresh view with more control over the refresh indicator.
///
/// Use `DSCustomPullToRefresh` when you need custom styling or behavior
/// for the pull-to-refresh indicator.
public struct DSCustomPullToRefresh<Content: View, Indicator: View>: View {
    // MARK: - Properties

    @Binding private var isRefreshing: Bool
    private let threshold: CGFloat
    private let onRefresh: () async -> Void
    private let content: () -> Content
    private let indicator: (CGFloat) -> Indicator

    // MARK: - State

    @State private var pullOffset: CGFloat = 0
    @State private var isTriggered = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a custom pull-to-refresh wrapper.
    /// - Parameters:
    ///   - isRefreshing: Binding to control the refresh state.
    ///   - threshold: Pull distance threshold to trigger refresh. Defaults to 80.
    ///   - onRefresh: Async action to perform when pulled to refresh.
    ///   - content: Content view builder.
    ///   - indicator: Custom indicator view builder. Receives progress (0-1) as parameter.
    public init(
        isRefreshing: Binding<Bool>,
        threshold: CGFloat = 80,
        onRefresh: @escaping () async -> Void,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder indicator: @escaping (CGFloat) -> Indicator
    ) {
        self._isRefreshing = isRefreshing
        self.threshold = threshold
        self.onRefresh = onRefresh
        self.content = content
        self.indicator = indicator
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { outerGeometry in
            ScrollView {
                ZStack(alignment: .top) {
                    // Pull indicator
                    indicator(min(pullOffset / threshold, 1))
                        .frame(height: threshold)
                        .opacity(pullOffset > 0 ? 1 : 0)
                        .offset(y: -threshold + min(pullOffset, threshold))

                    // Content with offset tracking
                    content()
                        .anchorPreference(key: ScrollOffsetPreferenceKey.self, value: .top) { anchor in
                            outerGeometry[anchor].y
                        }
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
                pullOffset = max(0, offset)

                if pullOffset >= threshold && !isTriggered && !isRefreshing {
                    triggerRefresh()
                }

                if pullOffset == 0 {
                    isTriggered = false
                }
            }
        }
    }

    // MARK: - Private Methods

    private func triggerRefresh() {
        isTriggered = true
        isRefreshing = true

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        Task {
            await onRefresh()
            isRefreshing = false
        }
    }
}

// MARK: - Default Pull Indicator

/// A default pull-to-refresh indicator with circular progress.
public struct DSPullIndicator: View {
    // MARK: - Properties

    /// Progress value from 0 to 1
    let progress: CGFloat

    /// Whether refresh is in progress
    let isRefreshing: Bool

    /// Tint color
    let color: Color

    // MARK: - Initialization

    public init(
        progress: CGFloat,
        isRefreshing: Bool = false,
        color: Color = DSColors.primary
    ) {
        self.progress = progress
        self.isRefreshing = isRefreshing
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        VStack {
            Spacer()

            if isRefreshing {
                DSCircularProgress(size: .medium, color: color)
            } else {
                DSCircularProgress(
                    value: Double(progress),
                    size: .medium,
                    color: color
                )
            }

            Spacer()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isRefreshing ? "Refreshing" : "Pull to refresh")
        .accessibilityValue(isRefreshing ? "In progress" : "\(Int(progress * 100)) percent")
    }
}

// MARK: - Previews

#if DEBUG
struct DSPullToRefresh_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshPreviewWrapper()
            .previewDisplayName("Pull to Refresh")
    }
}

private struct PullToRefreshPreviewWrapper: View {
    @State private var isRefreshing = false
    @State private var items = (1...20).map { "Item \($0)" }

    var body: some View {
        NavigationView {
            DSPullToRefresh(isRefreshing: $isRefreshing) {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                items.shuffle()
            } content: {
                LazyVStack(spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .navigationTitle("Pull to Refresh")
        }
    }
}
#endif
