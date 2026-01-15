import XCTest
import SwiftUI
@testable import DesignSystem

@MainActor
final class DSToastManagerTests: XCTestCase {

    var sut: DSToastManager!

    override func setUp() async throws {
        sut = DSToastManager.shared
        sut.dismissAll()
        // Wait for any pending operations
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
    }

    override func tearDown() async throws {
        sut.dismissAll()
        try await Task.sleep(nanoseconds: 100_000_000)
    }

    // MARK: - Singleton Tests

    func testSharedInstance() {
        let instance1 = DSToastManager.shared
        let instance2 = DSToastManager.shared
        XCTAssertTrue(instance1 === instance2)
    }

    // MARK: - Show Tests

    func testShowToast() async throws {
        sut.show("Test message", type: .success)

        // Wait for animation
        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Test message")
    }

    func testShowToastWithAllParameters() async throws {
        sut.show(
            "Full test",
            type: .warning,
            icon: "star.fill",
            duration: .long
        )

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Full test")
        XCTAssertEqual(sut.currentToast?.icon, "star.fill")
        XCTAssertEqual(sut.currentToast?.duration, .long)
    }

    func testShowSnackbar() async throws {
        var actionCalled = false

        sut.showSnackbar(
            "Item deleted",
            type: .info,
            actionTitle: "Undo",
            duration: .long
        ) {
            actionCalled = true
        }

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Item deleted")
        XCTAssertEqual(sut.currentToast?.actionTitle, "Undo")

        sut.currentToast?.action?()
        XCTAssertTrue(actionCalled)
    }

    func testShowToastItem() async throws {
        let item = DSToastItem(message: "Custom item", type: .error)
        sut.show(item)

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.id, item.id)
    }

    // MARK: - Queue Tests

    func testQueueManagement() async throws {
        sut.show("First")
        sut.show("Second")
        sut.show("Third")

        try await Task.sleep(nanoseconds: 100_000_000)

        // First toast should be current
        XCTAssertEqual(sut.currentToast?.message, "First")
        // Others should be in queue
        XCTAssertEqual(sut.queue.count, 2)
        XCTAssertEqual(sut.queue[0].message, "Second")
        XCTAssertEqual(sut.queue[1].message, "Third")
    }

    func testClearQueue() async throws {
        sut.show("First")
        sut.show("Second")
        sut.show("Third")

        try await Task.sleep(nanoseconds: 100_000_000)

        sut.clearQueue()

        XCTAssertTrue(sut.queue.isEmpty)
        XCTAssertNotNil(sut.currentToast) // Current toast still shown
    }

    func testDismissAll() async throws {
        sut.show("First")
        sut.show("Second")

        try await Task.sleep(nanoseconds: 100_000_000)

        sut.dismissAll()

        try await Task.sleep(nanoseconds: 400_000_000)

        XCTAssertNil(sut.currentToast)
        XCTAssertTrue(sut.queue.isEmpty)
    }

    // MARK: - Dismiss Tests

    func testDismiss() async throws {
        sut.show("Test", duration: .indefinite)

        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotNil(sut.currentToast)

        sut.dismiss()

        try await Task.sleep(nanoseconds: 400_000_000)
        XCTAssertNil(sut.currentToast)
    }

    func testDismissShowsNextInQueue() async throws {
        sut.show("First", duration: .indefinite)
        sut.show("Second", duration: .indefinite)

        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(sut.currentToast?.message, "First")

        sut.dismiss()

        try await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(sut.currentToast?.message, "Second")
    }

    // MARK: - Position Tests

    func testDefaultPosition() {
        XCTAssertEqual(sut.position, .bottom)
    }

    func testSetPosition() {
        sut.position = .top
        XCTAssertEqual(sut.position, .top)

        sut.position = .bottom
        XCTAssertEqual(sut.position, .bottom)
    }

    // MARK: - Static Convenience Methods

    func testStaticSuccess() async throws {
        DSToastManager.success("Success message")

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Success message")
    }

    func testStaticError() async throws {
        DSToastManager.error("Error message")

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Error message")
    }

    func testStaticWarning() async throws {
        DSToastManager.warning("Warning message")

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Warning message")
    }

    func testStaticInfo() async throws {
        DSToastManager.info("Info message")

        try await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertNotNil(sut.currentToast)
        XCTAssertEqual(sut.currentToast?.message, "Info message")
    }
}
