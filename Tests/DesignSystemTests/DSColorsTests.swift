import XCTest
import SwiftUI
@testable import DesignSystem

final class DSColorsTests: XCTestCase {

    // MARK: - Badge Colors Tests

    func testBadgeRedExists() {
        XCTAssertNotNil(DSColors.badgeRed)
    }

    func testBadgeRedDarkExists() {
        XCTAssertNotNil(DSColors.badgeRedDark)
    }

    // MARK: - Status Colors Tests

    func testStatusOnlineColor() {
        XCTAssertNotNil(DSColors.statusOnline)
    }

    func testStatusOfflineColor() {
        XCTAssertNotNil(DSColors.statusOffline)
    }

    func testStatusBusyColor() {
        XCTAssertNotNil(DSColors.statusBusy)
    }

    func testStatusAwayColor() {
        XCTAssertNotNil(DSColors.statusAway)
    }

    // MARK: - Chip Colors Tests

    func testChipBackgroundColor() {
        XCTAssertNotNil(DSColors.chipBackground)
    }

    func testChipBackgroundDarkColor() {
        XCTAssertNotNil(DSColors.chipBackgroundDark)
    }

    func testChipSelectedBackgroundColor() {
        XCTAssertNotNil(DSColors.chipSelectedBackground)
    }

    func testChipTextColor() {
        XCTAssertNotNil(DSColors.chipText)
    }

    func testChipTextDarkColor() {
        XCTAssertNotNil(DSColors.chipTextDark)
    }

    // MARK: - Semantic Colors Tests

    func testPrimaryColor() {
        XCTAssertNotNil(DSColors.primary)
    }

    func testSuccessColor() {
        XCTAssertNotNil(DSColors.success)
    }

    func testWarningColor() {
        XCTAssertNotNil(DSColors.warning)
    }

    func testErrorColor() {
        XCTAssertNotNil(DSColors.error)
    }

    func testInfoColor() {
        XCTAssertNotNil(DSColors.info)
    }

    // MARK: - Loading Colors Tests

    func testLoadingTrackColor() {
        XCTAssertNotNil(DSColors.loadingTrack)
    }

    func testLoadingTrackDarkColor() {
        XCTAssertNotNil(DSColors.loadingTrackDark)
    }

    func testShimmerBaseColor() {
        XCTAssertNotNil(DSColors.shimmerBase)
    }

    func testShimmerHighlightColor() {
        XCTAssertNotNil(DSColors.shimmerHighlight)
    }
}
