import SwiftUI

// MARK: - DSMasonryGrid

/// A Pinterest-style masonry grid layout that arranges items
/// with varying heights in columns of equal width.
///
/// Items are placed in the column with the smallest height,
/// creating a visually balanced layout.
///
/// ## Usage
/// ```swift
/// DSMasonryGrid(items, columns: 2) { item in
///     MasonryItemView(item)
/// }
/// ```
public struct DSMasonryGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let columns: Int
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let content: (Data.Element) -> Content

    @Binding private var selection: Set<Data.Element.ID>
    private let selectionMode: DSGridSelectionMode

    // MARK: - Initialization

    /// Creates a masonry grid with the specified number of columns.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - columns: Number of columns in the grid
    ///   - spacing: Uniform spacing between items
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        columns: Int = 2,
        spacing: CGFloat = Spacing.sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = max(1, columns)
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
        self.content = content
        self._selection = .constant([])
        self.selectionMode = .none
    }

    /// Creates a masonry grid with custom horizontal and vertical spacing.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - columns: Number of columns in the grid
    ///   - horizontalSpacing: Spacing between columns
    ///   - verticalSpacing: Spacing between rows
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        columns: Int = 2,
        horizontalSpacing: CGFloat = Spacing.sm,
        verticalSpacing: CGFloat = Spacing.sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = max(1, columns)
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
        self._selection = .constant([])
        self.selectionMode = .none
    }

    /// Creates a selectable masonry grid.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - columns: Number of columns
    ///   - selection: Binding to selected item IDs
    ///   - selectionMode: Selection mode
    ///   - spacing: Spacing between items
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        columns: Int = 2,
        selection: Binding<Set<Data.Element.ID>>,
        selectionMode: DSGridSelectionMode = .single,
        spacing: CGFloat = Spacing.sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = max(1, columns)
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
        self.content = content
        self._selection = selection
        self.selectionMode = selectionMode
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .top, spacing: horizontalSpacing) {
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: verticalSpacing) {
                    ForEach(itemsForColumn(columnIndex)) { item in
                        itemView(for: item)
                    }
                }
            }
        }
    }

    // MARK: - Private Methods

    private func itemsForColumn(_ columnIndex: Int) -> [Data.Element] {
        let dataArray = Array(data)
        var result: [Data.Element] = []

        for (index, item) in dataArray.enumerated() {
            if index % columns == columnIndex {
                result.append(item)
            }
        }

        return result
    }

    @ViewBuilder
    private func itemView(for item: Data.Element) -> some View {
        let isSelected = selection.contains(item.id)

        if selectionMode != .none {
            content(item)
                .onTapGesture {
                    handleSelection(for: item)
                }
                .accessibilityAddTraits(isSelected ? .isSelected : [])
        } else {
            content(item)
        }
    }

    private func handleSelection(for item: Data.Element) {
        let itemId = item.id

        switch selectionMode {
        case .none:
            break

        case .single:
            if selection.contains(itemId) {
                selection.remove(itemId)
            } else {
                selection = [itemId]
            }

        case .multiple:
            if selection.contains(itemId) {
                selection.remove(itemId)
            } else {
                selection.insert(itemId)
            }

        case .multiple(let max):
            if selection.contains(itemId) {
                selection.remove(itemId)
            } else if selection.count < max {
                selection.insert(itemId)
            }
        }
    }
}

// MARK: - DSWaterfallGrid

/// An alternative masonry implementation that calculates column placement
/// based on actual item heights for more balanced layouts.
///
/// This variant uses a preference key system to measure item heights
/// and dynamically balance columns.
public struct DSWaterfallGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let columns: Int
    private let spacing: CGFloat
    private let content: (Data.Element) -> Content

    @State private var heights: [Data.Element.ID: CGFloat] = [:]
    @State private var columnAssignments: [Data.Element.ID: Int] = [:]

    // MARK: - Initialization

    /// Creates a waterfall grid with dynamic height balancing.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - columns: Number of columns
    ///   - spacing: Spacing between items
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        columns: Int = 2,
        spacing: CGFloat = Spacing.sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = max(1, columns)
        self.spacing = spacing
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(0..<columns, id: \.self) { columnIndex in
                LazyVStack(spacing: spacing) {
                    ForEach(itemsForColumn(columnIndex)) { item in
                        content(item)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .preference(
                                            key: HeightPreferenceKey.self,
                                            value: [item.id: geometry.size.height]
                                        )
                                }
                            )
                    }
                }
            }
        }
        .onPreferenceChange(HeightPreferenceKey.self) { preferences in
            for (id, height) in preferences {
                heights[id] = height
            }
            recalculateColumnAssignments()
        }
    }

    // MARK: - Private Methods

    private func itemsForColumn(_ columnIndex: Int) -> [Data.Element] {
        let dataArray = Array(data)

        // If no assignments yet, use simple round-robin
        if columnAssignments.isEmpty {
            var result: [Data.Element] = []
            for (index, item) in dataArray.enumerated() {
                if index % columns == columnIndex {
                    result.append(item)
                }
            }
            return result
        }

        // Use calculated assignments
        return dataArray.filter { columnAssignments[$0.id] == columnIndex }
    }

    private func recalculateColumnAssignments() {
        var columnHeights = Array(repeating: CGFloat(0), count: columns)
        var newAssignments: [Data.Element.ID: Int] = [:]

        for item in data {
            let shortestColumnIndex = columnHeights.enumerated()
                .min(by: { $0.element < $1.element })?
                .offset ?? 0

            newAssignments[item.id] = shortestColumnIndex

            if let itemHeight = heights[item.id] {
                columnHeights[shortestColumnIndex] += itemHeight + spacing
            }
        }

        columnAssignments = newAssignments
    }
}

// MARK: - Height Preference Key

private struct HeightPreferenceKey: PreferenceKey {
    typealias Value = [AnyHashable: CGFloat]

    static var defaultValue: Value = [:]

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { _, new in new }
    }
}

// MARK: - DSAdaptiveMasonryGrid

/// A masonry grid that adapts column count based on available width.
public struct DSAdaptiveMasonryGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let minColumnWidth: CGFloat
    private let maxColumns: Int
    private let spacing: CGFloat
    private let content: (Data.Element) -> Content

    @State private var columnCount: Int = 2

    // MARK: - Initialization

    /// Creates an adaptive masonry grid.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - minColumnWidth: Minimum width for each column
    ///   - maxColumns: Maximum number of columns
    ///   - spacing: Spacing between items
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        minColumnWidth: CGFloat = 150,
        maxColumns: Int = 4,
        spacing: CGFloat = Spacing.sm,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.minColumnWidth = minColumnWidth
        self.maxColumns = maxColumns
        self.spacing = spacing
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            DSMasonryGrid(
                data,
                columns: calculateColumnCount(for: geometry.size.width),
                spacing: spacing,
                content: content
            )
        }
    }

    // MARK: - Private Methods

    private func calculateColumnCount(for width: CGFloat) -> Int {
        guard width > 0 else { return 1 }

        let totalSpacing = spacing * CGFloat(maxColumns - 1)
        let availableWidth = width - totalSpacing
        let calculatedColumns = Int(availableWidth / minColumnWidth)

        return max(1, min(calculatedColumns, maxColumns))
    }
}
