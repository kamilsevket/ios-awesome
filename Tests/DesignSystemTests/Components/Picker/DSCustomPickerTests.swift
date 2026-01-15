import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - Test Helpers

private struct TestItem: Hashable, Identifiable {
    let id: String
    let name: String
}

final class DSCustomPickerTests: XCTestCase {

    private let testItems = [
        TestItem(id: "1", name: "Option 1"),
        TestItem(id: "2", name: "Option 2"),
        TestItem(id: "3", name: "Option 3"),
    ]

    // MARK: - Initialization Tests

    func testCustomPickerInitialization() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        XCTAssertNotNil(picker)
    }

    func testCustomPickerWithLabel() {
        let picker = DSCustomPicker(
            "Select Option",
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        XCTAssertNotNil(picker)
    }

    // MARK: - Display Mode Tests

    func testMenuDisplayMode() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .displayMode(.menu)
        XCTAssertNotNil(picker)
    }

    func testSegmentedDisplayMode() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .displayMode(.segmented)
        XCTAssertNotNil(picker)
    }

    func testInlineDisplayMode() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .displayMode(.inline)
        XCTAssertNotNil(picker)
    }

    // MARK: - Modifier Tests

    func testPickerSizeModifier() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .pickerSize(.large)
        XCTAssertNotNil(picker)
    }

    func testPickerVariantModifier() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .pickerVariant(.outlined)
        XCTAssertNotNil(picker)
    }

    func testPlaceholderModifier() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .placeholder("Choose...")
        XCTAssertNotNil(picker)
    }

    // MARK: - Custom Content Tests

    func testCustomContentWithHStack() {
        let picker = DSCustomPicker(
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            HStack {
                Image(systemName: "star")
                Text(item.name)
            }
        }
        XCTAssertNotNil(picker)
    }

    func testAllModifiersChained() {
        let picker = DSCustomPicker(
            "Select",
            selection: .constant(testItems[0]),
            items: testItems
        ) { item in
            Text(item.name)
        }
        .displayMode(.inline)
        .pickerSize(.medium)
        .pickerVariant(.filled)
        .placeholder("Select...")
        XCTAssertNotNil(picker)
    }
}

// MARK: - CustomPickerDisplayMode Tests

final class CustomPickerDisplayModeTests: XCTestCase {

    func testAllDisplayModesExist() {
        let menu = CustomPickerDisplayMode.menu
        let segmented = CustomPickerDisplayMode.segmented
        let inline = CustomPickerDisplayMode.inline

        XCTAssertNotNil(menu)
        XCTAssertNotNil(segmented)
        XCTAssertNotNil(inline)
    }
}
