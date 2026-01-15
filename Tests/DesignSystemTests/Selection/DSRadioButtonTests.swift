import XCTest
import SwiftUI
@testable import DesignSystem

final class DSRadioButtonTests: XCTestCase {

    // MARK: - Test Data

    enum TestOption: String, CaseIterable {
        case optionA
        case optionB
        case optionC
    }

    // MARK: - DSRadioButtonSize Tests

    func testRadioButtonSizeOuterSize() {
        XCTAssertEqual(DSRadioButtonSize.small.outerSize, 18)
        XCTAssertEqual(DSRadioButtonSize.medium.outerSize, 22)
        XCTAssertEqual(DSRadioButtonSize.large.outerSize, 26)
    }

    func testRadioButtonSizeInnerSize() {
        XCTAssertEqual(DSRadioButtonSize.small.innerSize, 8)
        XCTAssertEqual(DSRadioButtonSize.medium.innerSize, 10)
        XCTAssertEqual(DSRadioButtonSize.large.innerSize, 12)
    }

    func testRadioButtonSizeIsCaseIterable() {
        XCTAssertEqual(DSRadioButtonSize.allCases.count, 3)
        XCTAssertTrue(DSRadioButtonSize.allCases.contains(.small))
        XCTAssertTrue(DSRadioButtonSize.allCases.contains(.medium))
        XCTAssertTrue(DSRadioButtonSize.allCases.contains(.large))
    }

    // MARK: - RadioButton Initialization Tests

    func testRadioButtonWithOptionalSelection() {
        var selection: TestOption? = nil
        let binding = Binding(get: { selection }, set: { selection = $0 })
        let radioButton = DSRadioButton(
            value: TestOption.optionA,
            selection: binding,
            label: "Option A"
        )
        XCTAssertNotNil(radioButton)
    }

    func testRadioButtonWithNonOptionalSelection() {
        var selection: TestOption = .optionA
        let binding = Binding(get: { selection }, set: { selection = $0 })
        let radioButton = DSRadioButton(
            value: TestOption.optionA,
            selection: binding,
            label: "Option A"
        )
        XCTAssertNotNil(radioButton)
    }

    func testRadioButtonWithAllParameters() {
        var selection: TestOption? = .optionA
        let binding = Binding(get: { selection }, set: { selection = $0 })
        let radioButton = DSRadioButton(
            value: TestOption.optionB,
            selection: binding,
            label: "Full Test",
            size: .large,
            labelPosition: .leading,
            isDisabled: true,
            selectedColor: .green,
            unselectedBorderColor: .gray,
            action: {}
        )
        XCTAssertNotNil(radioButton)
    }

    // MARK: - Label Position Tests

    func testLabelPositionOptions() {
        XCTAssertNotNil(DSRadioButtonLabelPosition.leading)
        XCTAssertNotNil(DSRadioButtonLabelPosition.trailing)
    }

    // MARK: - Selection Tests

    func testRadioButtonSelectionState() {
        var selection: TestOption? = .optionA
        XCTAssertEqual(selection, .optionA)

        selection = .optionB
        XCTAssertEqual(selection, .optionB)
        XCTAssertNotEqual(selection, .optionA)
    }
}
