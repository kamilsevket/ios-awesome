import XCTest
import SwiftUI
@testable import DesignSystem

final class DSWheelPickerTests: XCTestCase {

    private let testNumbers = Array(1...10)
    private let testStrings = ["Apple", "Banana", "Cherry", "Date"]

    // MARK: - Initialization Tests

    func testWheelPickerInitializationWithNumbers() {
        let picker = DSWheelPicker(
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        XCTAssertNotNil(picker)
    }

    func testWheelPickerInitializationWithStrings() {
        let picker = DSWheelPicker(
            selection: .constant(testStrings[0]),
            items: testStrings
        ) { string in
            Text(string)
        }
        XCTAssertNotNil(picker)
    }

    func testWheelPickerWithLabel() {
        let picker = DSWheelPicker(
            "Select Number",
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        XCTAssertNotNil(picker)
    }

    // MARK: - Modifier Tests

    func testPickerSizeModifier() {
        let picker = DSWheelPicker(
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        .pickerSize(.large)
        XCTAssertNotNil(picker)
    }

    func testPickerVariantModifier() {
        let picker = DSWheelPicker(
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        .pickerVariant(.outlined)
        XCTAssertNotNil(picker)
    }

    func testRowHeightModifier() {
        let picker = DSWheelPicker(
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        .rowHeight(250)
        XCTAssertNotNil(picker)
    }

    func testHapticFeedbackModifier() {
        let picker = DSWheelPicker(
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        .hapticFeedback(false)
        XCTAssertNotNil(picker)
    }

    func testShowsSelectionIndicatorModifier() {
        let picker = DSWheelPicker(
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        .showsSelectionIndicator(false)
        XCTAssertNotNil(picker)
    }

    func testAllModifiersChained() {
        let picker = DSWheelPicker(
            "Select",
            selection: .constant(testNumbers[0]),
            items: testNumbers
        ) { number in
            Text("\(number)")
        }
        .pickerSize(.medium)
        .pickerVariant(.filled)
        .rowHeight(200)
        .hapticFeedback(true)
        .showsSelectionIndicator(true)
        XCTAssertNotNil(picker)
    }
}

// MARK: - DSMultiWheelPicker Tests

final class DSMultiWheelPickerTests: XCTestCase {

    private let hours = Array(0...23)
    private let minutes = Array(0...59)

    func testMultiWheelPickerInitialization() {
        var hour = 10
        var minute = 30

        let picker = DSMultiWheelPicker(
            selections: [.init(get: { hour }, set: { hour = $0 }),
                        .init(get: { minute }, set: { minute = $0 })],
            columns: [hours, minutes]
        ) { column, value in
            Text(String(format: "%02d", value))
        }
        XCTAssertNotNil(picker)
    }

    func testMultiWheelPickerWithLabel() {
        var hour = 10
        var minute = 30

        let picker = DSMultiWheelPicker(
            "Select Time",
            selections: [.init(get: { hour }, set: { hour = $0 }),
                        .init(get: { minute }, set: { minute = $0 })],
            columns: [hours, minutes]
        ) { column, value in
            Text(String(format: "%02d", value))
        }
        XCTAssertNotNil(picker)
    }

    func testMultiWheelPickerSizeModifier() {
        var hour = 10
        var minute = 30

        let picker = DSMultiWheelPicker(
            selections: [.init(get: { hour }, set: { hour = $0 }),
                        .init(get: { minute }, set: { minute = $0 })],
            columns: [hours, minutes]
        ) { column, value in
            Text(String(format: "%02d", value))
        }
        .pickerSize(.large)
        XCTAssertNotNil(picker)
    }

    func testMultiWheelPickerVariantModifier() {
        var hour = 10
        var minute = 30

        let picker = DSMultiWheelPicker(
            selections: [.init(get: { hour }, set: { hour = $0 }),
                        .init(get: { minute }, set: { minute = $0 })],
            columns: [hours, minutes]
        ) { column, value in
            Text(String(format: "%02d", value))
        }
        .pickerVariant(.outlined)
        XCTAssertNotNil(picker)
    }

    func testMultiWheelPickerHapticFeedbackModifier() {
        var hour = 10
        var minute = 30

        let picker = DSMultiWheelPicker(
            selections: [.init(get: { hour }, set: { hour = $0 }),
                        .init(get: { minute }, set: { minute = $0 })],
            columns: [hours, minutes]
        ) { column, value in
            Text(String(format: "%02d", value))
        }
        .hapticFeedback(false)
        XCTAssertNotNil(picker)
    }
}
