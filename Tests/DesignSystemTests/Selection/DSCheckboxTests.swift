import XCTest
import SwiftUI
@testable import DesignSystem

final class DSCheckboxTests: XCTestCase {

    // MARK: - DSCheckboxState Tests

    func testCheckboxStateEquality() {
        XCTAssertEqual(DSCheckboxState.checked, DSCheckboxState.checked)
        XCTAssertEqual(DSCheckboxState.unchecked, DSCheckboxState.unchecked)
        XCTAssertEqual(DSCheckboxState.indeterminate, DSCheckboxState.indeterminate)
        XCTAssertNotEqual(DSCheckboxState.checked, DSCheckboxState.unchecked)
        XCTAssertNotEqual(DSCheckboxState.checked, DSCheckboxState.indeterminate)
    }

    // MARK: - DSCheckboxSize Tests

    func testCheckboxSizeBoxSize() {
        XCTAssertEqual(DSCheckboxSize.small.boxSize, 18)
        XCTAssertEqual(DSCheckboxSize.medium.boxSize, 22)
        XCTAssertEqual(DSCheckboxSize.large.boxSize, 26)
    }

    func testCheckboxSizeIconSize() {
        XCTAssertEqual(DSCheckboxSize.small.iconSize, 12)
        XCTAssertEqual(DSCheckboxSize.medium.iconSize, 14)
        XCTAssertEqual(DSCheckboxSize.large.iconSize, 18)
    }

    func testCheckboxSizeCornerRadius() {
        XCTAssertEqual(DSCheckboxSize.small.cornerRadius, 4)
        XCTAssertEqual(DSCheckboxSize.medium.cornerRadius, 5)
        XCTAssertEqual(DSCheckboxSize.large.cornerRadius, 6)
    }

    func testCheckboxSizeIsCaseIterable() {
        XCTAssertEqual(DSCheckboxSize.allCases.count, 3)
        XCTAssertTrue(DSCheckboxSize.allCases.contains(.small))
        XCTAssertTrue(DSCheckboxSize.allCases.contains(.medium))
        XCTAssertTrue(DSCheckboxSize.allCases.contains(.large))
    }

    // MARK: - Checkbox Initialization Tests

    func testCheckboxWithBoolBinding() {
        var isChecked = false
        let binding = Binding(get: { isChecked }, set: { isChecked = $0 })
        let checkbox = DSCheckbox(isChecked: binding, label: "Test")
        XCTAssertNotNil(checkbox)
    }

    func testCheckboxWithStateBinding() {
        var state: DSCheckboxState = .unchecked
        let binding = Binding(get: { state }, set: { state = $0 })
        let checkbox = DSCheckbox(state: binding, label: "Test")
        XCTAssertNotNil(checkbox)
    }

    func testCheckboxWithAllParameters() {
        var isChecked = true
        let binding = Binding(get: { isChecked }, set: { isChecked = $0 })
        let checkbox = DSCheckbox(
            isChecked: binding,
            label: "Full Test",
            size: .large,
            labelPosition: .leading,
            isDisabled: true,
            checkedColor: .red,
            uncheckedBorderColor: .gray,
            action: {}
        )
        XCTAssertNotNil(checkbox)
    }

    // MARK: - Label Position Tests

    func testLabelPositionOptions() {
        XCTAssertNotNil(DSCheckboxLabelPosition.leading)
        XCTAssertNotNil(DSCheckboxLabelPosition.trailing)
    }
}
