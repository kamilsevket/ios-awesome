import XCTest
import SwiftUI
@testable import DesignSystem

final class DSToastTests: XCTestCase {

    // MARK: - DSToastType Tests

    func testToastTypeIconNames() {
        XCTAssertEqual(DSToastType.success.iconName, "checkmark.circle.fill")
        XCTAssertEqual(DSToastType.error.iconName, "xmark.circle.fill")
        XCTAssertEqual(DSToastType.warning.iconName, "exclamationmark.triangle.fill")
        XCTAssertEqual(DSToastType.info.iconName, "info.circle.fill")
    }

    func testToastTypeCustomIcon() {
        let customType = DSToastType.custom(icon: "star.fill", backgroundColor: .blue, textColor: .white)
        XCTAssertEqual(customType.iconName, "star.fill")
    }

    func testToastTypeCustomNilIcon() {
        let customType = DSToastType.custom(icon: nil, backgroundColor: .blue, textColor: .white)
        XCTAssertNil(customType.iconName)
    }

    func testToastTypeAccessibilityPrefix() {
        XCTAssertEqual(DSToastType.success.accessibilityPrefix, "Success")
        XCTAssertEqual(DSToastType.error.accessibilityPrefix, "Error")
        XCTAssertEqual(DSToastType.warning.accessibilityPrefix, "Warning")
        XCTAssertEqual(DSToastType.info.accessibilityPrefix, "Information")
    }

    // MARK: - DSToastDuration Tests

    func testToastDurationSeconds() {
        XCTAssertEqual(DSToastDuration.short.seconds, 2.0)
        XCTAssertEqual(DSToastDuration.long.seconds, 4.0)
        XCTAssertEqual(DSToastDuration.indefinite.seconds, .infinity)
        XCTAssertEqual(DSToastDuration.custom(seconds: 5.0).seconds, 5.0)
    }

    func testToastDurationEquatable() {
        XCTAssertEqual(DSToastDuration.short, DSToastDuration.custom(seconds: 2.0))
        XCTAssertNotEqual(DSToastDuration.short, DSToastDuration.long)
    }

    // MARK: - DSToastItem Tests

    func testToastItemInitialization() {
        let item = DSToastItem(
            message: "Test message",
            type: .success,
            icon: "star",
            duration: .long,
            actionTitle: "Action",
            action: {}
        )

        XCTAssertEqual(item.message, "Test message")
        XCTAssertEqual(item.icon, "star")
        XCTAssertEqual(item.duration, .long)
        XCTAssertEqual(item.actionTitle, "Action")
    }

    func testToastItemDefaults() {
        let item = DSToastItem(message: "Test")

        XCTAssertEqual(item.message, "Test")
        XCTAssertNil(item.icon)
        XCTAssertEqual(item.duration, .short)
        XCTAssertNil(item.actionTitle)
        XCTAssertNil(item.action)
    }

    func testToastItemEquatable() {
        let id = UUID()
        let item1 = DSToastItem(id: id, message: "Test")
        let item2 = DSToastItem(id: id, message: "Different message")

        XCTAssertEqual(item1, item2) // Equal by ID only
    }

    func testToastItemFactoryMethods() {
        let successItem = DSToastItem.success("Success message")
        XCTAssertEqual(successItem.message, "Success message")

        let errorItem = DSToastItem.error("Error message")
        XCTAssertEqual(errorItem.message, "Error message")
        XCTAssertEqual(errorItem.duration, .long) // Errors default to long duration

        let warningItem = DSToastItem.warning("Warning message")
        XCTAssertEqual(warningItem.message, "Warning message")
        XCTAssertEqual(warningItem.duration, .long)

        let infoItem = DSToastItem.info("Info message")
        XCTAssertEqual(infoItem.message, "Info message")
        XCTAssertEqual(infoItem.duration, .short)
    }

    func testSnackbarFactoryMethod() {
        var actionCalled = false
        let snackbar = DSToastItem.snackbar(
            "Deleted",
            actionTitle: "Undo",
            duration: .long
        ) {
            actionCalled = true
        }

        XCTAssertEqual(snackbar.message, "Deleted")
        XCTAssertEqual(snackbar.actionTitle, "Undo")
        XCTAssertEqual(snackbar.duration, .long)
        XCTAssertNotNil(snackbar.action)

        snackbar.action?()
        XCTAssertTrue(actionCalled)
    }

    // MARK: - DSToastPosition Tests

    func testToastPositionCases() {
        XCTAssertNotNil(DSToastPosition.top)
        XCTAssertNotNil(DSToastPosition.bottom)
    }
}
