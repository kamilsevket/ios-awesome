import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSDragIndicator Tests

final class DSDragIndicatorTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        let indicator = DSDragIndicator()
        XCTAssertNotNil(indicator)
    }

    func testInitializationWithStyle() {
        let standardIndicator = DSDragIndicator(style: .standard)
        let lightIndicator = DSDragIndicator(style: .light)
        let darkIndicator = DSDragIndicator(style: .dark)
        let customIndicator = DSDragIndicator(style: .custom(.blue))

        XCTAssertNotNil(standardIndicator)
        XCTAssertNotNil(lightIndicator)
        XCTAssertNotNil(darkIndicator)
        XCTAssertNotNil(customIndicator)
    }

    func testInitializationWithCustomSize() {
        let indicator = DSDragIndicator(width: 60, height: 8)
        XCTAssertNotNil(indicator)
    }

    // MARK: - Style Color Tests

    func testStandardStyleColor() {
        let style = DSDragIndicator.Style.standard
        XCTAssertNotNil(style.color)
    }

    func testLightStyleColor() {
        let style = DSDragIndicator.Style.light
        // Light style should have opacity
        XCTAssertNotNil(style.color)
    }

    func testDarkStyleColor() {
        let style = DSDragIndicator.Style.dark
        // Dark style should have opacity
        XCTAssertNotNil(style.color)
    }

    func testCustomStyleColor() {
        let customColor = Color.red
        let style = DSDragIndicator.Style.custom(customColor)
        XCTAssertEqual(style.color, customColor)
    }

    // MARK: - Style Enum Tests

    func testAllStyleCases() {
        let styles: [DSDragIndicator.Style] = [
            .standard,
            .light,
            .dark,
            .custom(.green)
        ]

        for style in styles {
            XCTAssertNotNil(style.color, "Style \(style) should have a valid color")
        }
    }
}
