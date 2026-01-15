import XCTest
import SwiftUI
@testable import DesignSystem

final class DSGridTests: XCTestCase {

    // MARK: - Test Data

    struct TestItem: Identifiable, Hashable {
        let id: Int
        let title: String
    }

    let testItems = [
        TestItem(id: 1, title: "Item 1"),
        TestItem(id: 2, title: "Item 2"),
        TestItem(id: 3, title: "Item 3"),
        TestItem(id: 4, title: "Item 4"),
        TestItem(id: 5, title: "Item 5"),
        TestItem(id: 6, title: "Item 6")
    ]

    // MARK: - DSGridColumns Tests

    func testFixedColumnsCreatesCorrectGridItems() {
        let columns = DSGridColumns.fixed(3)
        let gridItems = columns.gridItems()
        XCTAssertEqual(gridItems.count, 3)
    }

    func testFixedColumnsMinimumIsOne() {
        let columns = DSGridColumns.fixed(0)
        let gridItems = columns.gridItems()
        XCTAssertEqual(gridItems.count, 1)
    }

    func testFixedColumnsNegativeBecomesOne() {
        let columns = DSGridColumns.fixed(-5)
        let gridItems = columns.gridItems()
        XCTAssertEqual(gridItems.count, 1)
    }

    func testAdaptiveColumnsCreatesOneAdaptiveItem() {
        let columns = DSGridColumns.adaptive(minimum: 150)
        let gridItems = columns.gridItems()
        XCTAssertEqual(gridItems.count, 1)
    }

    func testAdaptiveColumnsWithMaximum() {
        let columns = DSGridColumns.adaptive(minimum: 150, maximum: 300)
        let gridItems = columns.gridItems()
        XCTAssertEqual(gridItems.count, 1)
    }

    func testFlexibleColumnsCreatesCorrectCount() {
        let columns = DSGridColumns.flexible(count: 4, minimumSize: 100)
        let gridItems = columns.gridItems()
        XCTAssertEqual(gridItems.count, 4)
    }

    func testColumnsWithCustomSpacing() {
        let columns = DSGridColumns.fixed(3)
        let gridItems = columns.gridItems(spacing: 20)
        XCTAssertEqual(gridItems.count, 3)
    }

    // MARK: - DSGridSpacing Tests

    func testUniformSpacing() {
        let spacing = DSGridSpacing(uniform: 16)
        XCTAssertEqual(spacing.horizontal, 16)
        XCTAssertEqual(spacing.vertical, 16)
    }

    func testCustomSpacing() {
        let spacing = DSGridSpacing(horizontal: 8, vertical: 16)
        XCTAssertEqual(spacing.horizontal, 8)
        XCTAssertEqual(spacing.vertical, 16)
    }

    func testPresetSpacingNone() {
        XCTAssertEqual(DSGridSpacing.none.horizontal, 0)
        XCTAssertEqual(DSGridSpacing.none.vertical, 0)
    }

    func testPresetSpacingXs() {
        XCTAssertEqual(DSGridSpacing.xs.horizontal, Spacing.xs)
        XCTAssertEqual(DSGridSpacing.xs.vertical, Spacing.xs)
    }

    func testPresetSpacingSm() {
        XCTAssertEqual(DSGridSpacing.sm.horizontal, Spacing.sm)
        XCTAssertEqual(DSGridSpacing.sm.vertical, Spacing.sm)
    }

    func testPresetSpacingMd() {
        XCTAssertEqual(DSGridSpacing.md.horizontal, Spacing.md)
        XCTAssertEqual(DSGridSpacing.md.vertical, Spacing.md)
    }

    func testPresetSpacingLg() {
        XCTAssertEqual(DSGridSpacing.lg.horizontal, Spacing.lg)
        XCTAssertEqual(DSGridSpacing.lg.vertical, Spacing.lg)
    }

    // MARK: - DSGridSelectionMode Tests

    func testSelectionModeNoneEquality() {
        XCTAssertEqual(DSGridSelectionMode.none, DSGridSelectionMode.none)
    }

    func testSelectionModeSingleEquality() {
        XCTAssertEqual(DSGridSelectionMode.single, DSGridSelectionMode.single)
    }

    func testSelectionModeMultipleEquality() {
        XCTAssertEqual(DSGridSelectionMode.multiple, DSGridSelectionMode.multiple)
    }

    func testSelectionModeMultipleMaxEquality() {
        XCTAssertEqual(DSGridSelectionMode.multiple(max: 5), DSGridSelectionMode.multiple(max: 5))
    }

    func testSelectionModeMultipleMaxInequality() {
        XCTAssertNotEqual(DSGridSelectionMode.multiple(max: 5), DSGridSelectionMode.multiple(max: 10))
    }

    func testSelectionModeNoneNotEqualToSingle() {
        XCTAssertNotEqual(DSGridSelectionMode.none, DSGridSelectionMode.single)
    }

    // MARK: - DSGrid View Creation Tests

    func testDSGridCreationWithFixedColumns() {
        let grid = DSGrid(testItems, columns: .fixed(3)) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSGridCreationWithAdaptiveColumns() {
        let grid = DSGrid(testItems, columns: .adaptive(minimum: 150)) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSGridCreationWithSelection() {
        var selection: Set<Int> = []
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let grid = DSGrid(
            testItems,
            columns: .fixed(3),
            selection: binding,
            selectionMode: .multiple
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSGridIndexed Tests

    func testDSGridIndexedCreation() {
        let grid = DSGridIndexed(testItems, columns: .fixed(2)) { item, index in
            VStack {
                Text(item.title)
                Text("Index: \(index)")
            }
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSScrollableGrid Tests

    func testDSScrollableGridCreation() {
        let grid = DSScrollableGrid(testItems, columns: .fixed(3)) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSScrollableGridWithSelection() {
        var selection: Set<Int> = []
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let grid = DSScrollableGrid(
            testItems,
            columns: .fixed(3),
            selection: binding,
            selectionMode: .single
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSAdaptiveGrid Tests

    func testDSAdaptiveGridCreation() {
        let grid = DSAdaptiveGrid(testItems, minimumItemWidth: 150) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSAdaptiveGridWithMaxWidth() {
        let grid = DSAdaptiveGrid(
            testItems,
            minimumItemWidth: 150,
            maximumItemWidth: 300
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSAdaptiveGridWithSelection() {
        var selection: Set<Int> = []
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let grid = DSAdaptiveGrid(
            testItems,
            minimumItemWidth: 150,
            selection: binding,
            selectionMode: .multiple
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSResponsiveGrid Tests

    func testDSResponsiveGridCreation() {
        let grid = DSResponsiveGrid(
            testItems,
            compactColumns: 2,
            regularColumns: 4
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSResponsiveGridWithSelection() {
        var selection: Set<Int> = []
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let grid = DSResponsiveGrid(
            testItems,
            compactColumns: 2,
            regularColumns: 4,
            selection: binding,
            selectionMode: .single
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSAutoGrid Tests

    func testDSAutoGridCreation() {
        let grid = DSAutoGrid(
            testItems,
            idealItemWidth: 160,
            minColumns: 1,
            maxColumns: 6
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSMasonryGrid Tests

    func testDSMasonryGridCreation() {
        let grid = DSMasonryGrid(testItems, columns: 2) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSMasonryGridWithCustomSpacing() {
        let grid = DSMasonryGrid(
            testItems,
            columns: 3,
            horizontalSpacing: 8,
            verticalSpacing: 16
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSMasonryGridWithSelection() {
        var selection: Set<Int> = []
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let grid = DSMasonryGrid(
            testItems,
            columns: 2,
            selection: binding,
            selectionMode: .multiple
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSMasonryGridMinimumColumns() {
        let grid = DSMasonryGrid(testItems, columns: 0) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSWaterfallGrid Tests

    func testDSWaterfallGridCreation() {
        let grid = DSWaterfallGrid(testItems, columns: 2) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    func testDSWaterfallGridWithSpacing() {
        let grid = DSWaterfallGrid(testItems, columns: 3, spacing: 16) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSAdaptiveMasonryGrid Tests

    func testDSAdaptiveMasonryGridCreation() {
        let grid = DSAdaptiveMasonryGrid(
            testItems,
            minColumnWidth: 150,
            maxColumns: 4
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(grid)
    }

    // MARK: - DSGridSection Tests

    func testGridSectionWithHeaderAndFooter() {
        let section = DSGridSection(
            id: "test",
            itemCount: 5,
            header: { Text("Header") },
            footer: { Text("Footer") }
        )

        XCTAssertEqual(section.id, "test")
        XCTAssertEqual(section.itemCount, 5)
        XCTAssertNotNil(section.header)
        XCTAssertNotNil(section.footer)
    }

    func testGridSectionWithHeaderOnly() {
        let section = DSGridSection(
            id: "test",
            itemCount: 3,
            header: { Text("Header") }
        )

        XCTAssertEqual(section.itemCount, 3)
        XCTAssertNotNil(section.header)
        XCTAssertNil(section.footer)
    }

    func testGridSectionWithFooterOnly() {
        let section = DSGridSection(
            id: "test",
            itemCount: 3,
            footer: { Text("Footer") }
        )

        XCTAssertEqual(section.itemCount, 3)
        XCTAssertNil(section.header)
        XCTAssertNotNil(section.footer)
    }

    func testGridSectionWithNoHeaderOrFooter() {
        let section = DSGridSection<EmptyView, EmptyView>(
            id: "test",
            itemCount: 3
        )

        XCTAssertEqual(section.itemCount, 3)
        XCTAssertNil(section.header)
        XCTAssertNil(section.footer)
    }

    // MARK: - DSCollectionLayout Tests

    func testCollectionLayoutGrid() {
        let layout = DSCollectionLayout.grid(columns: 3)
        let uiLayout = layout.createLayout()
        XCTAssertNotNil(uiLayout)
    }

    func testCollectionLayoutAdaptive() {
        let layout = DSCollectionLayout.adaptive(minItemWidth: 150)
        let uiLayout = layout.createLayout()
        XCTAssertNotNil(uiLayout)
    }

    func testCollectionLayoutList() {
        let layout = DSCollectionLayout.list(rowHeight: 60)
        let uiLayout = layout.createLayout()
        XCTAssertNotNil(uiLayout)
    }

    func testCollectionLayoutWaterfall() {
        let layout = DSCollectionLayout.waterfall(columns: 2)
        let uiLayout = layout.createLayout()
        XCTAssertNotNil(uiLayout)
    }

    // MARK: - DSCollectionView Tests

    func testDSCollectionViewCreation() {
        let collectionView = DSCollectionView(
            items: testItems,
            layout: .grid(columns: 3)
        ) { item in
            Text(item.title)
        }
        XCTAssertNotNil(collectionView)
    }

    func testDSCollectionViewWithCallbacks() {
        var selectedItem: TestItem?
        var prefetchedItems: [TestItem] = []

        let collectionView = DSCollectionView(
            items: testItems,
            layout: .adaptive(minItemWidth: 150)
        ) { item in
            Text(item.title)
        } onSelect: { item in
            selectedItem = item
        } onPrefetch: { items in
            prefetchedItems = items
        }

        XCTAssertNotNil(collectionView)
    }

    // MARK: - DSSectionedCollectionView Tests

    struct TestSection: Identifiable, Hashable {
        let id: String
        let title: String
    }

    func testDSSectionedCollectionViewCreation() {
        let sections: [(section: TestSection, items: [TestItem])] = [
            (TestSection(id: "1", title: "Section 1"), Array(testItems.prefix(3))),
            (TestSection(id: "2", title: "Section 2"), Array(testItems.suffix(3)))
        ]

        let collectionView = DSSectionedCollectionView(
            sections: sections,
            layout: .grid(columns: 2)
        ) { item in
            Text(item.title)
        }

        XCTAssertNotNil(collectionView)
    }
}
