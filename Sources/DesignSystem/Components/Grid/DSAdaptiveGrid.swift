import SwiftUI

// MARK: - DSAdaptiveGrid

/// An adaptive grid that automatically adjusts the number of columns
/// based on available width and minimum item size.
///
/// This grid provides a responsive layout that works well across
/// different device sizes and orientations.
///
/// ## Usage
/// ```swift
/// DSAdaptiveGrid(items, minimumItemWidth: 150) { item in
///     GridItemView(item)
/// }
/// ```
public struct DSAdaptiveGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let minimumItemWidth: CGFloat
    private let maximumItemWidth: CGFloat?
    private let spacing: DSGridSpacing
    private let content: (Data.Element) -> Content

    @Binding private var selection: Set<Data.Element.ID>
    private let selectionMode: DSGridSelectionMode

    // MARK: - Initialization

    /// Creates an adaptive grid with automatic column calculation.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - minimumItemWidth: Minimum width for each item
    ///   - maximumItemWidth: Optional maximum width for each item
    ///   - spacing: Spacing configuration
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        minimumItemWidth: CGFloat = 150,
        maximumItemWidth: CGFloat? = nil,
        spacing: DSGridSpacing = .sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.minimumItemWidth = minimumItemWidth
        self.maximumItemWidth = maximumItemWidth
        self.spacing = spacing
        self.content = content
        self._selection = .constant([])
        self.selectionMode = .none
    }

    /// Creates a selectable adaptive grid.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - minimumItemWidth: Minimum width for each item
    ///   - maximumItemWidth: Optional maximum width for each item
    ///   - selection: Binding to the selected item IDs
    ///   - selectionMode: The selection mode
    ///   - spacing: Spacing configuration
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        minimumItemWidth: CGFloat = 150,
        maximumItemWidth: CGFloat? = nil,
        selection: Binding<Set<Data.Element.ID>>,
        selectionMode: DSGridSelectionMode = .single,
        spacing: DSGridSpacing = .sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.minimumItemWidth = minimumItemWidth
        self.maximumItemWidth = maximumItemWidth
        self.spacing = spacing
        self.content = content
        self._selection = selection
        self.selectionMode = selectionMode
    }

    // MARK: - Body

    public var body: some View {
        let columns = DSGridColumns.adaptive(minimum: minimumItemWidth, maximum: maximumItemWidth)

        if selectionMode != .none {
            DSGrid(
                data,
                columns: columns,
                selection: $selection,
                selectionMode: selectionMode,
                spacing: spacing,
                content: content
            )
        } else {
            DSGrid(
                data,
                columns: columns,
                spacing: spacing,
                content: content
            )
        }
    }
}

// MARK: - DSResponsiveGrid

/// A grid that automatically adapts column count based on screen size breakpoints.
public struct DSResponsiveGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let compactColumns: Int
    private let regularColumns: Int
    private let spacing: DSGridSpacing
    private let content: (Data.Element) -> Content

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @Binding private var selection: Set<Data.Element.ID>
    private let selectionMode: DSGridSelectionMode

    // MARK: - Initialization

    /// Creates a responsive grid with different column counts for different size classes.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - compactColumns: Number of columns in compact width (iPhone portrait)
    ///   - regularColumns: Number of columns in regular width (iPad, iPhone landscape)
    ///   - spacing: Spacing configuration
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        compactColumns: Int = 2,
        regularColumns: Int = 4,
        spacing: DSGridSpacing = .sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.compactColumns = compactColumns
        self.regularColumns = regularColumns
        self.spacing = spacing
        self.content = content
        self._selection = .constant([])
        self.selectionMode = .none
    }

    /// Creates a selectable responsive grid.
    public init(
        _ data: Data,
        compactColumns: Int = 2,
        regularColumns: Int = 4,
        selection: Binding<Set<Data.Element.ID>>,
        selectionMode: DSGridSelectionMode = .single,
        spacing: DSGridSpacing = .sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.compactColumns = compactColumns
        self.regularColumns = regularColumns
        self.spacing = spacing
        self.content = content
        self._selection = selection
        self.selectionMode = selectionMode
    }

    // MARK: - Body

    public var body: some View {
        let columnCount = horizontalSizeClass == .compact ? compactColumns : regularColumns
        let columns = DSGridColumns.fixed(columnCount)

        if selectionMode != .none {
            DSGrid(
                data,
                columns: columns,
                selection: $selection,
                selectionMode: selectionMode,
                spacing: spacing,
                content: content
            )
        } else {
            DSGrid(
                data,
                columns: columns,
                spacing: spacing,
                content: content
            )
        }
    }
}

// MARK: - DSAutoGrid

/// A grid that automatically calculates the optimal number of columns
/// based on available width, with manual control over column sizing.
public struct DSAutoGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let idealItemWidth: CGFloat
    private let minColumns: Int
    private let maxColumns: Int
    private let spacing: DSGridSpacing
    private let content: (Data.Element) -> Content

    @State private var availableWidth: CGFloat = 0

    // MARK: - Initialization

    /// Creates an auto grid with optimal column calculation.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - idealItemWidth: The ideal width for each item
    ///   - minColumns: Minimum number of columns
    ///   - maxColumns: Maximum number of columns
    ///   - spacing: Spacing configuration
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        idealItemWidth: CGFloat = 160,
        minColumns: Int = 1,
        maxColumns: Int = 6,
        spacing: DSGridSpacing = .sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.idealItemWidth = idealItemWidth
        self.minColumns = minColumns
        self.maxColumns = maxColumns
        self.spacing = spacing
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            DSGrid(
                data,
                columns: .fixed(calculateColumnCount(for: geometry.size.width)),
                spacing: spacing,
                content: content
            )
            .onAppear {
                availableWidth = geometry.size.width
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                availableWidth = newWidth
            }
        }
    }

    // MARK: - Private Methods

    private func calculateColumnCount(for width: CGFloat) -> Int {
        guard width > 0 else { return minColumns }

        let totalSpacing = spacing.horizontal * CGFloat(maxColumns - 1)
        let availableItemWidth = width - totalSpacing
        let calculatedColumns = Int(availableItemWidth / idealItemWidth)

        return min(max(calculatedColumns, minColumns), maxColumns)
    }
}
