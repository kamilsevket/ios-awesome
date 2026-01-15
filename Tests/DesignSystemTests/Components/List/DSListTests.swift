import XCTest
import SwiftUI
@testable import DesignSystem

final class DSListTests: XCTestCase {

    // MARK: - DSListStyle Tests

    func testListStylePlain() {
        let style = DSListStyle.plain
        XCTAssertNotNil(style)
    }

    func testListStyleInsetGrouped() {
        let style = DSListStyle.insetGrouped
        XCTAssertNotNil(style)
    }

    func testListStyleGrouped() {
        let style = DSListStyle.grouped
        XCTAssertNotNil(style)
    }

    func testListStyleSidebar() {
        let style = DSListStyle.sidebar
        XCTAssertNotNil(style)
    }

    // MARK: - DSSeparatorStyle Tests

    func testSeparatorStyleNoneVisibility() {
        let style = DSSeparatorStyle.none
        XCTAssertEqual(style.visibility, .hidden)
    }

    func testSeparatorStyleSingleLineVisibility() {
        let style = DSSeparatorStyle.singleLine
        XCTAssertEqual(style.visibility, .visible)
    }

    func testSeparatorStyleSingleLineInsetVisibility() {
        let style = DSSeparatorStyle.singleLineInset
        XCTAssertEqual(style.visibility, .visible)
    }

    func testSeparatorStyleNoneInsets() {
        let style = DSSeparatorStyle.none
        let insets = style.insets
        XCTAssertEqual(insets.leading, 0)
        XCTAssertEqual(insets.trailing, 0)
    }

    func testSeparatorStyleSingleLineInsetHasLeadingInset() {
        let style = DSSeparatorStyle.singleLineInset
        let insets = style.insets
        XCTAssertEqual(insets.leading, DSSpacing.lg)
    }

    // MARK: - DSList Initialization Tests

    func testListInitializationWithData() {
        let items = [
            TestListItem(id: 1, name: "Item 1"),
            TestListItem(id: 2, name: "Item 2")
        ]

        let list = DSList(items) { item in
            Text(item.name)
        }
        XCTAssertNotNil(list)
    }

    func testListInitializationWithEmptyData() {
        let items: [TestListItem] = []

        let list = DSList(items) { item in
            Text(item.name)
        }
        XCTAssertNotNil(list)
    }

    // MARK: - DSList Modifier Chain Tests

    func testListStyleModifier() {
        let items = [TestListItem(id: 1, name: "Test")]
        let list = DSList(items) { item in
            Text(item.name)
        }
        .listStyle(.insetGrouped)

        XCTAssertNotNil(list)
    }

    func testSeparatorStyleModifier() {
        let items = [TestListItem(id: 1, name: "Test")]
        let list = DSList(items) { item in
            Text(item.name)
        }
        .separatorStyle(.singleLineInset)

        XCTAssertNotNil(list)
    }

    func testSeparatorColorModifier() {
        let items = [TestListItem(id: 1, name: "Test")]
        let list = DSList(items) { item in
            Text(item.name)
        }
        .separatorColor(.red)

        XCTAssertNotNil(list)
    }

    func testBackgroundColorModifier() {
        let items = [TestListItem(id: 1, name: "Test")]
        let list = DSList(items) { item in
            Text(item.name)
        }
        .backgroundColor(.blue)

        XCTAssertNotNil(list)
    }

    func testOnDeleteModifier() {
        let items = [TestListItem(id: 1, name: "Test")]
        var deleteCalled = false

        let list = DSList(items) { item in
            Text(item.name)
        }
        .onDelete { _ in
            deleteCalled = true
        }

        XCTAssertNotNil(list)
        XCTAssertFalse(deleteCalled, "Delete should not be called during initialization")
    }

    func testOnMoveModifier() {
        let items = [TestListItem(id: 1, name: "Test")]
        var moveCalled = false

        let list = DSList(items) { item in
            Text(item.name)
        }
        .onMove { _, _ in
            moveCalled = true
        }

        XCTAssertNotNil(list)
        XCTAssertFalse(moveCalled, "Move should not be called during initialization")
    }

    func testOnRefreshModifier() {
        let items = [TestListItem(id: 1, name: "Test")]

        let list = DSList(items) { item in
            Text(item.name)
        }
        .onRefresh {
            // Async refresh action
        }

        XCTAssertNotNil(list)
    }

    func testCombinedModifiers() {
        let items = [TestListItem(id: 1, name: "Test")]

        let list = DSList(items) { item in
            Text(item.name)
        }
        .listStyle(.grouped)
        .separatorStyle(.singleLineInset)
        .separatorColor(.gray)
        .backgroundColor(.white)
        .onDelete { _ in }
        .onMove { _, _ in }
        .onRefresh { }

        XCTAssertNotNil(list)
    }
}

// MARK: - Test Helper

private struct TestListItem: Identifiable {
    let id: Int
    let name: String
}
