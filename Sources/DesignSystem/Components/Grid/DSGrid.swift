import SwiftUI

// MARK: - DSGrid

/// A flexible grid component that wraps SwiftUI's LazyVGrid
/// with design system styling and configuration support.
///
/// ## Usage
/// ```swift
/// DSGrid(items, columns: .fixed(3)) { item in
///     GridItemView(item)
/// }
///
/// DSGrid(items, columns: .adaptive(minimum: 150)) { item in
///     GridItemView(item)
/// }
/// ```
public struct DSGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    // MARK: - Properties

    private let data: Data
    private let columns: DSGridColumns
    private let spacing: DSGridSpacing
    private let alignment: HorizontalAlignment
    private let pinnedViews: PinnedScrollableViews
    private let content: (Data.Element) -> Content

    // MARK: - Selection State

    @Binding private var selection: Set<Data.Element.ID>
    private let selectionMode: DSGridSelectionMode

    // MARK: - Initialization

    /// Creates a grid with the specified data and column configuration.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - columns: Column configuration (fixed, adaptive, or flexible)
    ///   - spacing: Spacing configuration between items
    ///   - alignment: Horizontal alignment of items within the grid
    ///   - pinnedViews: Views to pin during scrolling (headers/footers)
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        columns: DSGridColumns,
        spacing: DSGridSpacing = .sm,
        alignment: HorizontalAlignment = .center,
        pinnedViews: PinnedScrollableViews = [],
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.alignment = alignment
        self.pinnedViews = pinnedViews
        self.content = content
        self._selection = .constant([])
        self.selectionMode = .none
    }

    /// Creates a selectable grid with single or multiple selection.
    /// - Parameters:
    ///   - data: The collection of identifiable data to display
    ///   - columns: Column configuration
    ///   - selection: Binding to the selected item IDs
    ///   - selectionMode: The selection mode (single, multiple, or multiple with max)
    ///   - spacing: Spacing configuration
    ///   - alignment: Horizontal alignment
    ///   - pinnedViews: Pinned views configuration
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        columns: DSGridColumns,
        selection: Binding<Set<Data.Element.ID>>,
        selectionMode: DSGridSelectionMode = .single,
        spacing: DSGridSpacing = .sm,
        alignment: HorizontalAlignment = .center,
        pinnedViews: PinnedScrollableViews = [],
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.alignment = alignment
        self.pinnedViews = pinnedViews
        self.content = content
        self._selection = selection
        self.selectionMode = selectionMode
    }

    // MARK: - Body

    public var body: some View {
        LazyVGrid(
            columns: columns.gridItems(spacing: spacing.horizontal),
            alignment: alignment,
            spacing: spacing.vertical,
            pinnedViews: pinnedViews
        ) {
            ForEach(data) { item in
                gridItemContent(for: item)
            }
        }
    }

    // MARK: - Private Methods

    @ViewBuilder
    private func gridItemContent(for item: Data.Element) -> some View {
        let isSelected = selection.contains(item.id)

        if selectionMode != .none {
            content(item)
                .onTapGesture {
                    handleSelection(for: item)
                }
                .accessibilityAddTraits(isSelected ? .isSelected : [])
                .accessibilityHint(selectionHint(isSelected: isSelected))
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

    private func selectionHint(isSelected: Bool) -> String {
        switch selectionMode {
        case .none:
            return ""
        case .single:
            return isSelected ? "Tap to deselect" : "Tap to select"
        case .multiple, .multiple:
            return isSelected ? "Tap to deselect" : "Tap to add to selection"
        }
    }
}

// MARK: - DSGrid with Index

/// Grid variant that provides item index in the content builder
public struct DSGridIndexed<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let columns: DSGridColumns
    private let spacing: DSGridSpacing
    private let alignment: HorizontalAlignment
    private let content: (Data.Element, Int) -> Content

    public init(
        _ data: Data,
        columns: DSGridColumns,
        spacing: DSGridSpacing = .sm,
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping (Data.Element, Int) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        LazyVGrid(
            columns: columns.gridItems(spacing: spacing.horizontal),
            alignment: alignment,
            spacing: spacing.vertical
        ) {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                content(item, index)
            }
        }
    }
}

// MARK: - ScrollableGrid

/// A grid wrapped in a ScrollView for convenience
public struct DSScrollableGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    private let data: Data
    private let columns: DSGridColumns
    private let spacing: DSGridSpacing
    private let alignment: HorizontalAlignment
    private let showsIndicators: Bool
    private let content: (Data.Element) -> Content

    @Binding private var selection: Set<Data.Element.ID>
    private let selectionMode: DSGridSelectionMode

    public init(
        _ data: Data,
        columns: DSGridColumns,
        spacing: DSGridSpacing = .sm,
        alignment: HorizontalAlignment = .center,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.alignment = alignment
        self.showsIndicators = showsIndicators
        self.content = content
        self._selection = .constant([])
        self.selectionMode = .none
    }

    public init(
        _ data: Data,
        columns: DSGridColumns,
        selection: Binding<Set<Data.Element.ID>>,
        selectionMode: DSGridSelectionMode = .single,
        spacing: DSGridSpacing = .sm,
        alignment: HorizontalAlignment = .center,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.columns = columns
        self.spacing = spacing
        self.alignment = alignment
        self.showsIndicators = showsIndicators
        self.content = content
        self._selection = selection
        self.selectionMode = selectionMode
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            if selectionMode != .none {
                DSGrid(
                    data,
                    columns: columns,
                    selection: $selection,
                    selectionMode: selectionMode,
                    spacing: spacing,
                    alignment: alignment,
                    content: content
                )
                .padding(Spacing.md)
            } else {
                DSGrid(
                    data,
                    columns: columns,
                    spacing: spacing,
                    alignment: alignment,
                    content: content
                )
                .padding(Spacing.md)
            }
        }
    }
}
