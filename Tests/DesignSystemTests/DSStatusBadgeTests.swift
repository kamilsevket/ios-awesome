import XCTest
import SwiftUI
@testable import DesignSystem

final class DSStatusBadgeTests: XCTestCase {

    // MARK: - DSStatusBadge Tests

    func testStatusBadgeCreation() {
        let badge = DSStatusBadge(.online)
        XCTAssertNotNil(badge)
    }

    func testStatusBadgeWithText() {
        let badge = DSStatusBadge(.online, text: "Active")
        XCTAssertNotNil(badge)
    }

    func testStatusBadgeSizeVariants() {
        let smallBadge = DSStatusBadge(.online, size: .sm)
        let mediumBadge = DSStatusBadge(.online, size: .md)
        XCTAssertNotNil(smallBadge)
        XCTAssertNotNil(mediumBadge)
    }

    func testStatusBadgeWithoutPulse() {
        let badge = DSStatusBadge(.online, showPulse: false)
        XCTAssertNotNil(badge)
    }

    // MARK: - DSStatus Tests

    func testStatusOnlineColor() {
        let status = DSStatus.online
        XCTAssertEqual(status.color, DSColors.statusOnline)
        XCTAssertEqual(status.accessibilityLabel, "Online")
    }

    func testStatusOfflineColor() {
        let status = DSStatus.offline
        XCTAssertEqual(status.color, DSColors.statusOffline)
        XCTAssertEqual(status.accessibilityLabel, "Offline")
    }

    func testStatusBusyColor() {
        let status = DSStatus.busy
        XCTAssertEqual(status.color, DSColors.statusBusy)
        XCTAssertEqual(status.accessibilityLabel, "Busy")
    }

    func testStatusAwayColor() {
        let status = DSStatus.away
        XCTAssertEqual(status.color, DSColors.statusAway)
        XCTAssertEqual(status.accessibilityLabel, "Away")
    }

    func testAllStatusCases() {
        XCTAssertEqual(DSStatus.allCases.count, 4)
        XCTAssertTrue(DSStatus.allCases.contains(.online))
        XCTAssertTrue(DSStatus.allCases.contains(.offline))
        XCTAssertTrue(DSStatus.allCases.contains(.busy))
        XCTAssertTrue(DSStatus.allCases.contains(.away))
    }

    // MARK: - DSStatusBadgeSize Tests

    func testStatusBadgeSizeSmallValues() {
        let size = DSStatusBadgeSize.sm
        XCTAssertEqual(size.dotSize, 8)
    }

    func testStatusBadgeSizeMediumValues() {
        let size = DSStatusBadgeSize.md
        XCTAssertEqual(size.dotSize, 10)
    }
}
