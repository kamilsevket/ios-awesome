import XCTest
import SwiftUI
@testable import DesignSystem

final class DSDatePickerTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDatePickerInitializationWithDefaults() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
        XCTAssertNotNil(picker)
    }

    func testDatePickerInitializationWithLabel() {
        let date = Date()
        let picker = DSDatePicker("Select Date", selection: .constant(date))
        XCTAssertNotNil(picker)
    }

    // MARK: - Modifier Tests

    func testDisplayModeModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .displayMode(.inline)
        XCTAssertNotNil(picker)
    }

    func testMinimumDateModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .minimumDate(.now)
        XCTAssertNotNil(picker)
    }

    func testMaximumDateModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .maximumDate(.now)
        XCTAssertNotNil(picker)
    }

    func testDateRangeModifier() {
        let date = Date()
        let range = Date()...Date().addingTimeInterval(86400 * 30)
        let picker = DSDatePicker(selection: .constant(date))
            .dateRange(range)
        XCTAssertNotNil(picker)
    }

    func testPickerSizeModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .pickerSize(.large)
        XCTAssertNotNil(picker)
    }

    func testPickerVariantModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .pickerVariant(.outlined)
        XCTAssertNotNil(picker)
    }

    func testDisplayedComponentsModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .displayedComponents(.date)
        XCTAssertNotNil(picker)
    }

    func testLocaleModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .locale(Locale(identifier: "tr_TR"))
        XCTAssertNotNil(picker)
    }

    func testCalendarModifier() {
        let date = Date()
        let picker = DSDatePicker(selection: .constant(date))
            .calendar(Calendar(identifier: .gregorian))
        XCTAssertNotNil(picker)
    }

    // MARK: - Chained Modifiers

    func testAllModifiersChained() {
        let date = Date()
        let picker = DSDatePicker("Select Date", selection: .constant(date))
            .displayMode(.graphical)
            .minimumDate(.now)
            .maximumDate(Date().addingTimeInterval(86400 * 365))
            .pickerSize(.medium)
            .pickerVariant(.filled)
            .displayedComponents([.date, .hourAndMinute])
            .locale(.current)
            .calendar(.current)
        XCTAssertNotNil(picker)
    }
}

// MARK: - DSTimePicker Tests

final class DSTimePickerTests: XCTestCase {

    func testTimePickerInitialization() {
        let date = Date()
        let picker = DSTimePicker(selection: .constant(date))
        XCTAssertNotNil(picker)
    }

    func testTimePickerWithLabel() {
        let date = Date()
        let picker = DSTimePicker("Select Time", selection: .constant(date))
        XCTAssertNotNil(picker)
    }

    func testTimePickerDisplayModeModifier() {
        let date = Date()
        let picker = DSTimePicker(selection: .constant(date))
            .displayMode(.wheel)
        XCTAssertNotNil(picker)
    }

    func testTimePickerMinuteIntervalModifier() {
        let date = Date()
        let picker = DSTimePicker(selection: .constant(date))
            .minuteInterval(15)
        XCTAssertNotNil(picker)
    }

    func testTimePickerHourIntervalModifier() {
        let date = Date()
        let picker = DSTimePicker(selection: .constant(date))
            .hourInterval(2)
        XCTAssertNotNil(picker)
    }

    func testTimePickerAllModifiers() {
        let date = Date()
        let picker = DSTimePicker("Meeting Time", selection: .constant(date))
            .displayMode(.compact)
            .pickerSize(.medium)
            .pickerVariant(.outlined)
            .minuteInterval(5)
            .hourInterval(1)
            .locale(.current)
            .calendar(.current)
        XCTAssertNotNil(picker)
    }
}

// MARK: - DSDateTimePicker Tests

final class DSDateTimePickerTests: XCTestCase {

    func testDateTimePickerInitialization() {
        let date = Date()
        let picker = DSDateTimePicker(selection: .constant(date))
        XCTAssertNotNil(picker)
    }

    func testDateTimePickerWithLabel() {
        let date = Date()
        let picker = DSDateTimePicker("Schedule", selection: .constant(date))
        XCTAssertNotNil(picker)
    }

    func testDateTimePickerDisplayModes() {
        let date = Date()

        let compact = DSDateTimePicker(selection: .constant(date))
            .displayMode(.compact)
        XCTAssertNotNil(compact)

        let inline = DSDateTimePicker(selection: .constant(date))
            .displayMode(.inline)
        XCTAssertNotNil(inline)

        let stacked = DSDateTimePicker(selection: .constant(date))
            .displayMode(.stacked)
        XCTAssertNotNil(stacked)

        let sideBySide = DSDateTimePicker(selection: .constant(date))
            .displayMode(.sideBySide)
        XCTAssertNotNil(sideBySide)
    }

    func testDateTimePickerAllModifiers() {
        let date = Date()
        let picker = DSDateTimePicker("Appointment", selection: .constant(date))
            .displayMode(.stacked)
            .minimumDate(.now)
            .maximumDate(Date().addingTimeInterval(86400 * 30))
            .pickerSize(.large)
            .pickerVariant(.filled)
            .locale(.current)
            .calendar(.current)
        XCTAssertNotNil(picker)
    }
}
