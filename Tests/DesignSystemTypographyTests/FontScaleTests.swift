import XCTest
@testable import DesignSystemTypography

final class FontScaleTests: XCTestCase {
    // MARK: - Default Size Tests

    func testDefaultSizes() {
        XCTAssertEqual(FontScale.largeTitle.defaultSize, 34)
        XCTAssertEqual(FontScale.title1.defaultSize, 28)
        XCTAssertEqual(FontScale.title2.defaultSize, 22)
        XCTAssertEqual(FontScale.title3.defaultSize, 20)
        XCTAssertEqual(FontScale.headline.defaultSize, 17)
        XCTAssertEqual(FontScale.body.defaultSize, 17)
        XCTAssertEqual(FontScale.callout.defaultSize, 16)
        XCTAssertEqual(FontScale.subheadline.defaultSize, 15)
        XCTAssertEqual(FontScale.footnote.defaultSize, 13)
        XCTAssertEqual(FontScale.caption1.defaultSize, 12)
        XCTAssertEqual(FontScale.caption2.defaultSize, 11)
    }

    // MARK: - Default Weight Tests

    func testDefaultWeights() {
        // Headline should be semibold by default
        XCTAssertEqual(FontScale.headline.defaultWeight, .semibold)

        // Other text styles should be regular
        XCTAssertEqual(FontScale.body.defaultWeight, .regular)
        XCTAssertEqual(FontScale.largeTitle.defaultWeight, .regular)
        XCTAssertEqual(FontScale.caption1.defaultWeight, .regular)
    }

    // MARK: - Line Height Tests

    func testLineHeightMultipliers() {
        // All multipliers should be greater than 1.0
        for scale in FontScale.allCases {
            XCTAssertGreaterThan(scale.lineHeightMultiplier, 1.0,
                                 "\(scale.rawValue) should have line height multiplier > 1.0")
        }

        // Smaller text should have larger relative line height
        XCTAssertGreaterThan(FontScale.footnote.lineHeightMultiplier,
                             FontScale.largeTitle.lineHeightMultiplier)
    }

    // MARK: - Letter Spacing Tests

    func testLetterSpacing() {
        // Large titles should have positive tracking
        XCTAssertGreaterThan(FontScale.largeTitle.letterSpacing, 0)

        // Body text typically has negative tracking for readability
        XCTAssertLessThan(FontScale.body.letterSpacing, 0)
    }

    // MARK: - All Cases Tests

    func testAllCasesCount() {
        XCTAssertEqual(FontScale.allCases.count, 11)
    }

    func testAllCasesHaveUniqueRawValues() {
        let rawValues = FontScale.allCases.map { $0.rawValue }
        let uniqueRawValues = Set(rawValues)
        XCTAssertEqual(rawValues.count, uniqueRawValues.count,
                       "All font scales should have unique raw values")
    }

    // MARK: - Accessibility Description Tests

    func testAccessibilityDescriptions() {
        for scale in FontScale.allCases {
            XCTAssertFalse(scale.accessibilityDescription.isEmpty,
                          "\(scale.rawValue) should have an accessibility description")
        }
    }
}
