import XCTest
import SwiftUI
@testable import DesignSystem

final class DSBadgeTests: XCTestCase {

    // MARK: - DSBadge Tests

    func testBadgeDisplaysCorrectCount() {
        let badge = DSBadge(count: 5)
        XCTAssertNotNil(badge)
    }

    func testBadgeDisplays99Plus() {
        let badge = DSBadge(count: 150)
        XCTAssertNotNil(badge)
    }

    func testBadgeCustomMaxCount() {
        let badge = DSBadge(count: 50, maxCount: 49)
        XCTAssertNotNil(badge)
    }

    func testBadgeHiddenWhenZero() {
        let badge = DSBadge(count: 0, showZero: false)
        XCTAssertNotNil(badge)
    }

    func testBadgeShownWhenZeroWithShowZero() {
        let badge = DSBadge(count: 0, showZero: true)
        XCTAssertNotNil(badge)
    }

    func testBadgeSizeVariants() {
        let smallBadge = DSBadge(count: 1, size: .sm)
        let mediumBadge = DSBadge(count: 1, size: .md)
        XCTAssertNotNil(smallBadge)
        XCTAssertNotNil(mediumBadge)
    }

    func testBadgeNegativeCountTreatedAsZero() {
        let badge = DSBadge(count: -5)
        XCTAssertNotNil(badge)
    }

    // MARK: - DSBadgeSize Tests

    func testBadgeSizeSmallValues() {
        let size = DSBadgeSize.sm
        XCTAssertEqual(size.minWidth, 16)
        XCTAssertEqual(size.minHeight, 16)
        XCTAssertEqual(size.horizontalPadding, DSSpacing.xs)
        XCTAssertEqual(size.verticalPadding, DSSpacing.xxs)
    }

    func testBadgeSizeMediumValues() {
        let size = DSBadgeSize.md
        XCTAssertEqual(size.minWidth, 20)
        XCTAssertEqual(size.minHeight, 20)
        XCTAssertEqual(size.horizontalPadding, DSSpacing.sm)
        XCTAssertEqual(size.verticalPadding, DSSpacing.xs)
    }
}
