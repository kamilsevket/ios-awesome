import XCTest
import Foundation
@testable import DesignSystem

final class DSDateFormattersTests: XCTestCase {

    // MARK: - Date Formatter Tests

    func testShortDateFormatter() {
        let formatter = DSDateFormatters.shortDate
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .short)
        XCTAssertEqual(formatter.timeStyle, .none)
    }

    func testMediumDateFormatter() {
        let formatter = DSDateFormatters.mediumDate
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .medium)
        XCTAssertEqual(formatter.timeStyle, .none)
    }

    func testLongDateFormatter() {
        let formatter = DSDateFormatters.longDate
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .long)
        XCTAssertEqual(formatter.timeStyle, .none)
    }

    func testFullDateFormatter() {
        let formatter = DSDateFormatters.fullDate
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .full)
        XCTAssertEqual(formatter.timeStyle, .none)
    }

    // MARK: - Time Formatter Tests

    func testShortTimeFormatter() {
        let formatter = DSDateFormatters.shortTime
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .none)
        XCTAssertEqual(formatter.timeStyle, .short)
    }

    func testMediumTimeFormatter() {
        let formatter = DSDateFormatters.mediumTime
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .none)
        XCTAssertEqual(formatter.timeStyle, .medium)
    }

    // MARK: - DateTime Formatter Tests

    func testShortDateTimeFormatter() {
        let formatter = DSDateFormatters.shortDateTime
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .short)
        XCTAssertEqual(formatter.timeStyle, .short)
    }

    func testMediumDateTimeFormatter() {
        let formatter = DSDateFormatters.mediumDateTime
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .medium)
        XCTAssertEqual(formatter.timeStyle, .short)
    }

    func testLongDateTimeFormatter() {
        let formatter = DSDateFormatters.longDateTime
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateStyle, .long)
        XCTAssertEqual(formatter.timeStyle, .short)
    }

    // MARK: - ISO8601 Tests

    func testISO8601Formatter() {
        let formatter = DSDateFormatters.iso8601
        XCTAssertNotNil(formatter)

        let date = Date()
        let string = formatter.string(from: date)
        XCTAssertFalse(string.isEmpty)
    }

    func testISO8601DateOnlyFormatter() {
        let formatter = DSDateFormatters.iso8601DateOnly
        XCTAssertNotNil(formatter)

        let date = Date()
        let string = formatter.string(from: date)
        XCTAssertFalse(string.isEmpty)
        XCTAssertFalse(string.contains("T")) // Should not contain time separator
    }

    // MARK: - Relative Formatter Tests

    func testRelativeFormatter() {
        let formatter = DSDateFormatters.relative
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.unitsStyle, .full)
    }

    func testRelativeAbbreviatedFormatter() {
        let formatter = DSDateFormatters.relativeAbbreviated
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.unitsStyle, .abbreviated)
    }

    // MARK: - Custom Format Tests

    func testCustomFormat() {
        let formatter = DSDateFormatters.custom(format: "yyyy-MM-dd")
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.dateFormat, "yyyy-MM-dd")
    }

    func testCustomFormatWithLocale() {
        let locale = Locale(identifier: "tr_TR")
        let formatter = DSDateFormatters.custom(format: "MMMM d, yyyy", locale: locale)
        XCTAssertNotNil(formatter)
        XCTAssertEqual(formatter.locale, locale)
    }

    func testLocalizedTemplate() {
        let formatter = DSDateFormatters.localized(template: "MMMMd")
        XCTAssertNotNil(formatter)
    }

    // MARK: - Caching Tests

    func testFormatterCaching() {
        let formatter1 = DSDateFormatters.shortDate
        let formatter2 = DSDateFormatters.shortDate

        // Same formatter should be returned (cached)
        XCTAssertTrue(formatter1 === formatter2)
    }

    func testCustomFormatCaching() {
        let formatter1 = DSDateFormatters.custom(format: "yyyy-MM-dd")
        let formatter2 = DSDateFormatters.custom(format: "yyyy-MM-dd")

        // Same custom format should return cached formatter
        XCTAssertTrue(formatter1 === formatter2)
    }

    func testDifferentCustomFormatsNotCached() {
        let formatter1 = DSDateFormatters.custom(format: "yyyy-MM-dd")
        let formatter2 = DSDateFormatters.custom(format: "dd/MM/yyyy")

        // Different formats should return different formatters
        XCTAssertFalse(formatter1 === formatter2)
    }

    func testClearCache() {
        let formatter1 = DSDateFormatters.shortDate
        DSDateFormatters.clearCache()
        let formatter2 = DSDateFormatters.shortDate

        // After clearing cache, should be different instances
        XCTAssertFalse(formatter1 === formatter2)
    }
}

// MARK: - Date Extension Tests

final class DateExtensionTests: XCTestCase {

    func testFormattedWithFormatter() {
        let date = Date()
        let result = date.formatted(with: DSDateFormatters.shortDate)
        XCTAssertFalse(result.isEmpty)
    }

    func testFormattedWithFormat() {
        let date = Date()
        let result = date.formatted(format: "yyyy-MM-dd")
        XCTAssertFalse(result.isEmpty)
        XCTAssertTrue(result.contains("-"))
    }

    func testRelativeFormatted() {
        let date = Date()
        let result = date.relativeFormatted()
        XCTAssertFalse(result.isEmpty)
    }

    func testRelativeFormattedAbbreviated() {
        let date = Date().addingTimeInterval(-86400 * 2) // 2 days ago
        let result = date.relativeFormatted(abbreviated: true)
        XCTAssertFalse(result.isEmpty)
    }

    // MARK: - Date Range Validation Tests

    func testIsWithinRange() {
        let now = Date()
        let start = now.addingTimeInterval(-3600)
        let end = now.addingTimeInterval(3600)

        XCTAssertTrue(now.isWithin(start: start, end: end))
    }

    func testIsNotWithinRange() {
        let now = Date()
        let start = now.addingTimeInterval(3600)
        let end = now.addingTimeInterval(7200)

        XCTAssertFalse(now.isWithin(start: start, end: end))
    }

    func testIsBefore() {
        let now = Date()
        let future = now.addingTimeInterval(3600)

        XCTAssertTrue(now.isBefore(future))
        XCTAssertFalse(future.isBefore(now))
    }

    func testIsAfter() {
        let now = Date()
        let past = now.addingTimeInterval(-3600)

        XCTAssertTrue(now.isAfter(past))
        XCTAssertFalse(past.isAfter(now))
    }

    func testIsToday() {
        let today = Date()
        XCTAssertTrue(today.isToday)

        let tomorrow = Date().addingTimeInterval(86400)
        XCTAssertFalse(tomorrow.isToday)
    }

    func testIsPast() {
        let past = Date().addingTimeInterval(-3600)
        XCTAssertTrue(past.isPast)

        let future = Date().addingTimeInterval(3600)
        XCTAssertFalse(future.isPast)
    }

    func testIsFuture() {
        let future = Date().addingTimeInterval(3600)
        XCTAssertTrue(future.isFuture)

        let past = Date().addingTimeInterval(-3600)
        XCTAssertFalse(past.isFuture)
    }
}

// MARK: - DSDateTemplate Tests

final class DSDateTemplateTests: XCTestCase {

    func testAllTemplatesExist() {
        XCTAssertEqual(DSDateTemplate.monthDay, "MMMMd")
        XCTAssertEqual(DSDateTemplate.monthDayYear, "MMMMdyyyy")
        XCTAssertEqual(DSDateTemplate.abbreviatedMonthDay, "MMMd")
        XCTAssertEqual(DSDateTemplate.dayOfWeek, "EEEE")
        XCTAssertEqual(DSDateTemplate.abbreviatedDayOfWeek, "EEE")
        XCTAssertEqual(DSDateTemplate.dayOfWeekTime, "EEEEjm")
        XCTAssertEqual(DSDateTemplate.hourMinute, "jm")
        XCTAssertEqual(DSDateTemplate.hourOnly, "j")
        XCTAssertEqual(DSDateTemplate.yearMonth, "yyyyMMMM")
        XCTAssertEqual(DSDateTemplate.yearOnly, "yyyy")
    }

    func testTemplatesWithLocalizedFormatter() {
        let date = Date()

        let monthDay = DSDateFormatters.localized(template: DSDateTemplate.monthDay).string(from: date)
        XCTAssertFalse(monthDay.isEmpty)

        let dayOfWeek = DSDateFormatters.localized(template: DSDateTemplate.dayOfWeek).string(from: date)
        XCTAssertFalse(dayOfWeek.isEmpty)

        let hourMinute = DSDateFormatters.localized(template: DSDateTemplate.hourMinute).string(from: date)
        XCTAssertFalse(hourMinute.isEmpty)
    }
}
