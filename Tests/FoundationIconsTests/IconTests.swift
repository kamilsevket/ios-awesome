import XCTest
import SwiftUI
@testable import FoundationIcons

final class IconTests: XCTestCase {

    // MARK: - IconSize Tests

    func testIconSizeValues() {
        XCTAssertEqual(IconSize.xs.pointSize, 12)
        XCTAssertEqual(IconSize.sm.pointSize, 16)
        XCTAssertEqual(IconSize.md.pointSize, 20)
        XCTAssertEqual(IconSize.lg.pointSize, 24)
        XCTAssertEqual(IconSize.xl.pointSize, 32)
        XCTAssertEqual(IconSize.xxl.pointSize, 48)
    }

    func testIconSizeAllCases() {
        XCTAssertEqual(IconSize.allCases.count, 6)
        XCTAssertTrue(IconSize.allCases.contains(.xs))
        XCTAssertTrue(IconSize.allCases.contains(.sm))
        XCTAssertTrue(IconSize.allCases.contains(.md))
        XCTAssertTrue(IconSize.allCases.contains(.lg))
        XCTAssertTrue(IconSize.allCases.contains(.xl))
        XCTAssertTrue(IconSize.allCases.contains(.xxl))
    }

    func testIconSizeRawValueEqualsPointSize() {
        for size in IconSize.allCases {
            XCTAssertEqual(size.rawValue, size.pointSize)
        }
    }

    // MARK: - IconWeight Tests

    func testIconWeightFontWeightMapping() {
        XCTAssertEqual(IconWeight.ultraLight.fontWeight, Font.Weight.ultraLight)
        XCTAssertEqual(IconWeight.thin.fontWeight, Font.Weight.thin)
        XCTAssertEqual(IconWeight.light.fontWeight, Font.Weight.light)
        XCTAssertEqual(IconWeight.regular.fontWeight, Font.Weight.regular)
        XCTAssertEqual(IconWeight.medium.fontWeight, Font.Weight.medium)
        XCTAssertEqual(IconWeight.semibold.fontWeight, Font.Weight.semibold)
        XCTAssertEqual(IconWeight.bold.fontWeight, Font.Weight.bold)
        XCTAssertEqual(IconWeight.heavy.fontWeight, Font.Weight.heavy)
        XCTAssertEqual(IconWeight.black.fontWeight, Font.Weight.black)
    }

    // MARK: - Icon Creation Tests

    func testSystemIconCreation() {
        let icon = Icon.system(.heart)
        XCTAssertNotNil(icon)
    }

    func testSystemIconWithSize() {
        let icon = Icon.system(.heart, size: .lg)
        XCTAssertNotNil(icon)
    }

    func testSystemIconWithWeight() {
        let icon = Icon.system(.heart, weight: .bold)
        XCTAssertNotNil(icon)
    }

    func testSystemIconWithSizeAndWeight() {
        let icon = Icon.system(.heart, size: .xl, weight: .semibold)
        XCTAssertNotNil(icon)
    }

    func testCustomIconCreation() {
        let icon = Icon.custom(.logo)
        XCTAssertNotNil(icon)
    }

    func testCustomIconWithSize() {
        let icon = Icon.custom(.logo, size: .lg)
        XCTAssertNotNil(icon)
    }

    // MARK: - Icon Modifier Tests

    func testSizeModifier() {
        let icon = Icon.system(.heart)
        let resizedIcon = icon.size(.xl)
        XCTAssertNotNil(resizedIcon)
    }

    func testWeightModifier() {
        let icon = Icon.system(.heart)
        let weightedIcon = icon.weight(.bold)
        XCTAssertNotNil(weightedIcon)
    }

    // MARK: - IconButton Tests

    func testIconButtonWithSFSymbol() {
        var actionCalled = false
        let button = IconButton(.heart) {
            actionCalled = true
        }
        XCTAssertNotNil(button)
    }

    func testIconButtonWithCustomIcon() {
        let button = IconButton(.logo) {
            // Action
        }
        XCTAssertNotNil(button)
    }

    func testIconButtonWithSize() {
        let button = IconButton(.heart, size: .lg) {
            // Action
        }
        XCTAssertNotNil(button)
    }
}
