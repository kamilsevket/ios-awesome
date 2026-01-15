import XCTest
import SwiftUI
@testable import DesignSystem

final class DSDropdownMenuTests: XCTestCase {

    // MARK: - DSDropdownMenuItem Tests

    func testDropdownMenuItemInitialization() {
        let item = DSDropdownMenuItem(
            id: "edit",
            title: "Edit",
            icon: Image(systemName: "pencil"),
            subtitle: "Edit this item",
            isDestructive: false,
            isDisabled: false
        )

        XCTAssertEqual(item.id, "edit")
        XCTAssertEqual(item.title, "Edit")
        XCTAssertEqual(item.subtitle, "Edit this item")
        XCTAssertFalse(item.isDestructive)
        XCTAssertFalse(item.isDisabled)
    }

    func testDropdownMenuItemDefaultValues() {
        let item = DSDropdownMenuItem(title: "Test")

        XCTAssertEqual(item.title, "Test")
        XCTAssertNil(item.icon)
        XCTAssertNil(item.subtitle)
        XCTAssertFalse(item.isDestructive)
        XCTAssertFalse(item.isDisabled)
    }

    func testDropdownMenuItemDestructive() {
        let item = DSDropdownMenuItem(
            title: "Delete",
            icon: Image(systemName: "trash"),
            isDestructive: true
        )

        XCTAssertTrue(item.isDestructive)
    }

    func testDropdownMenuItemDisabled() {
        let item = DSDropdownMenuItem(
            title: "Disabled Action",
            isDisabled: true
        )

        XCTAssertTrue(item.isDisabled)
    }

    func testDropdownMenuItemEquality() {
        let item1 = DSDropdownMenuItem(id: "test", title: "Test 1")
        let item2 = DSDropdownMenuItem(id: "test", title: "Test 2")
        let item3 = DSDropdownMenuItem(id: "other", title: "Test 1")

        XCTAssertEqual(item1, item2) // Same ID
        XCTAssertNotEqual(item1, item3) // Different ID
    }

    func testDropdownMenuItemUniqueID() {
        let item1 = DSDropdownMenuItem(title: "Test 1")
        let item2 = DSDropdownMenuItem(title: "Test 2")

        XCTAssertNotEqual(item1.id, item2.id)
    }

    // MARK: - DSDropdownMenu Tests

    func testDropdownMenuCreation() {
        let items = [
            DSDropdownMenuItem(title: "Edit"),
            DSDropdownMenuItem(title: "Delete", isDestructive: true)
        ]

        var selectedItem: DSDropdownMenuItem?

        let _ = DSDropdownMenu(items: items, onSelect: { item in
            selectedItem = item
        }) {
            Text("Actions")
        }

        XCTAssertNil(selectedItem) // No selection initially
    }

    func testDropdownMenuWithDefaultIcon() {
        let items = [DSDropdownMenuItem(title: "Test")]

        let _ = DSDropdownMenu(items: items, onSelect: { _ in })

        // Should compile without errors - using default ellipsis icon
        XCTAssertTrue(true)
    }

    func testDropdownMenuItemsWithSubtitles() {
        let items = [
            DSDropdownMenuItem(title: "Download", subtitle: "Save to device"),
            DSDropdownMenuItem(title: "Share", subtitle: "Send to others")
        ]

        XCTAssertEqual(items[0].subtitle, "Save to device")
        XCTAssertEqual(items[1].subtitle, "Send to others")
    }

    func testDropdownMenuItemsWithIcons() {
        let items = [
            DSDropdownMenuItem(title: "Edit", icon: Image(systemName: "pencil")),
            DSDropdownMenuItem(title: "Delete", icon: Image(systemName: "trash"))
        ]

        XCTAssertNotNil(items[0].icon)
        XCTAssertNotNil(items[1].icon)
    }

    // MARK: - Edge Cases

    func testEmptyDropdownMenu() {
        let items: [DSDropdownMenuItem] = []

        let _ = DSDropdownMenu(items: items, onSelect: { _ in }) {
            Text("Empty")
        }

        XCTAssertTrue(items.isEmpty)
    }

    func testDropdownMenuWithManyItems() {
        let items = (0..<100).map { index in
            DSDropdownMenuItem(title: "Item \(index)")
        }

        XCTAssertEqual(items.count, 100)
    }
}
