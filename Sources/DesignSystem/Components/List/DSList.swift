import SwiftUI

// MARK: - List Style

/// Defines the visual style of the list
public enum DSListStyle {
    case plain
    case insetGrouped
    case grouped
    case sidebar

    /// Applies the appropriate SwiftUI list style to a view
    @available(iOS 14.0, *)
    @ViewBuilder
    func apply<Content: View>(to content: Content) -> some View {
        switch self {
        case .plain:
            content.listStyle(.plain)
        case .insetGrouped:
            content.listStyle(.insetGrouped)
        case .grouped:
            content.listStyle(.grouped)
        case .sidebar:
            content.listStyle(.sidebar)
        }
    }
}

// MARK: - Separator Style

/// Defines the separator style for list items
public enum DSSeparatorStyle {
    case none
    case singleLine
    case singleLineInset

    var visibility: Visibility {
        switch self {
        case .none:
            return .hidden
        case .singleLine, .singleLineInset:
            return .visible
        }
    }

    var insets: EdgeInsets {
        switch self {
        case .none, .singleLine:
            return EdgeInsets()
        case .singleLineInset:
            return EdgeInsets(top: 0, leading: DSSpacing.lg, bottom: 0, trailing: 0)
        }
    }
}

// MARK: - DSList

/// A customizable list component for the design system
///
/// DSList provides a consistent list implementation with support for:
/// - Multiple visual styles (plain, insetGrouped, grouped, sidebar)
/// - Separator customization
/// - Pull to refresh
/// - Delete and move actions
/// - Edit mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSList(items) { item in
///     ItemRow(item)
/// }
/// .separatorStyle(.singleLineInset)
/// .onDelete { indexSet in
///     items.remove(atOffsets: indexSet)
/// }
/// .onMove { from, to in
///     items.move(fromOffsets: from, toOffset: to)
/// }
/// ```
public struct DSList<Data: RandomAccessCollection, RowContent: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let rowContent: (Data.Element) -> RowContent
    private var listStyle: DSListStyle = .plain
    private var separatorStyle: DSSeparatorStyle = .singleLine
    private var separatorColor: Color = DSColors.border
    private var backgroundColor: Color = DSColors.backgroundPrimary
    private var onDelete: ((IndexSet) -> Void)?
    private var onMove: ((IndexSet, Int) -> Void)?
    private var onRefresh: (() async -> Void)?
    private var isEditMode: Binding<EditMode>?

    // MARK: - Initialization

    /// Creates a new DSList
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - rowContent: A view builder that creates the row content for each item
    public init(
        _ data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self.data = data
        self.rowContent = rowContent
    }

    // MARK: - Body

    public var body: some View {
        listStyle.apply(to: listContent)
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
            .environment(\.editMode, isEditMode ?? .constant(.inactive))
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
        ForEach(data) { item in
            rowContent(item)
                .listRowBackground(backgroundColor)
                .listRowSeparator(separatorStyle.visibility)
                .listRowSeparatorTint(separatorColor)
                .listRowInsets(EdgeInsets(
                    top: DSSpacing.sm,
                    leading: DSSpacing.lg,
                    bottom: DSSpacing.sm,
                    trailing: DSSpacing.lg
                ))
        }
        .onDelete(perform: onDelete)
        .onMove(perform: onMove)
    }
}

// MARK: - Modifiers

public extension DSList {
    /// Sets the list style
    /// - Parameter style: The list style to use
    /// - Returns: A modified list with the specified style
    func listStyle(_ style: DSListStyle) -> Self {
        var copy = self
        copy.listStyle = style
        return copy
    }

    /// Sets the separator style
    /// - Parameter style: The separator style to use
    /// - Returns: A modified list with the specified separator style
    func separatorStyle(_ style: DSSeparatorStyle) -> Self {
        var copy = self
        copy.separatorStyle = style
        return copy
    }

    /// Sets the separator color
    /// - Parameter color: The color for separators
    /// - Returns: A modified list with the specified separator color
    func separatorColor(_ color: Color) -> Self {
        var copy = self
        copy.separatorColor = color
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

    /// Adds a delete action
    /// - Parameter action: The action to perform when items are deleted
    /// - Returns: A modified list with delete support
    func onDelete(_ action: @escaping (IndexSet) -> Void) -> Self {
        var copy = self
        copy.onDelete = action
        return copy
    }

    /// Adds a move action
    /// - Parameter action: The action to perform when items are moved
    /// - Returns: A modified list with move/reorder support
    func onMove(_ action: @escaping (IndexSet, Int) -> Void) -> Self {
        var copy = self
        copy.onMove = action
        return copy
    }

    /// Adds pull to refresh
    /// - Parameter action: The async action to perform on refresh
    /// - Returns: A modified list with pull to refresh support
    func onRefresh(_ action: @escaping () async -> Void) -> Self {
        var copy = self
        copy.onRefresh = action
        return copy
    }

    /// Binds the edit mode
    /// - Parameter editMode: The edit mode binding
    /// - Returns: A modified list with edit mode support
    func editMode(_ editMode: Binding<EditMode>) -> Self {
        var copy = self
        copy.isEditMode = editMode
        return copy
    }
}

// MARK: - DSList with String IDs

public extension DSList where Data.Element: Hashable {
    /// Creates a new DSList with hashable items (uses element as its own ID)
    /// - Parameters:
    ///   - data: The collection of hashable data to display
    ///   - rowContent: A view builder that creates the row content for each item
    init(
        _ data: Data,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Data.Element: Identifiable {
        self.data = data
        self.rowContent = rowContent
    }
}

// MARK: - Preview

#if DEBUG
struct DSList_Previews: PreviewProvider {
    static var previews: some View {
        DSListPreviewContainer()
            .previewDisplayName("Light Mode")

        DSListPreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DSListPreviewContainer: View {
    @State private var items = (1...10).map { PreviewItem(id: $0, title: "Item \($0)", subtitle: "Description for item \($0)") }
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            DSList(items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: DSSpacing.xs) {
                        Text(item.title)
                            .font(.body)
                            .foregroundColor(DSColors.textPrimary)
                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundColor(DSColors.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(DSColors.textTertiary)
                }
            }
            .separatorStyle(.singleLineInset)
            .onDelete { indexSet in
                items.remove(atOffsets: indexSet)
            }
            .onMove { from, to in
                items.move(fromOffsets: from, toOffset: to)
            }
            .onRefresh {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            .editMode($editMode)
            .navigationTitle("DSList Demo")
            .toolbar {
                EditButton()
            }
        }
    }
}

private struct PreviewItem: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
}
#endif
