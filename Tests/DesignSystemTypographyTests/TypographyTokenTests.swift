import XCTest
@testable import DesignSystemTypography

final class TypographyTokenTests: XCTestCase {
    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        let token = TypographyToken(scale: .body)

        XCTAssertEqual(token.scale, .body)
        XCTAssertEqual(token.weight, .regular)
        XCTAssertEqual(token.size, 17)
        XCTAssertEqual(token.fontFamily, .system)
    }

    func testCustomWeightInitialization() {
        let token = TypographyToken(scale: .body, weight: .bold)

        XCTAssertEqual(token.scale, .body)
        XCTAssertEqual(token.weight, .bold)
    }

    func testCustomSizeInitialization() {
        let token = TypographyToken(scale: .body, size: 20)

        XCTAssertEqual(token.size, 20)
    }

    func testCustomFontFamilyInitialization() {
        let token = TypographyToken(scale: .body, fontFamily: .inter)

        XCTAssertEqual(token.fontFamily, .inter)
    }

    // MARK: - Line Spacing Tests

    func testLineSpacing() {
        let token = TypographyToken(scale: .body)

        // Line spacing = line height - font size
        let expectedLineSpacing = token.lineHeight - token.size
        XCTAssertEqual(token.lineSpacing, expectedLineSpacing)
    }

    func testLineSpacingIsPositive() {
        for scale in FontScale.allCases {
            let token = TypographyToken(scale: scale)
            XCTAssertGreaterThanOrEqual(token.lineSpacing, 0,
                                        "\(scale.rawValue) should have non-negative line spacing")
        }
    }

    // MARK: - Predefined Token Tests

    func testPredefinedTokens() {
        // Display styles
        XCTAssertEqual(TypographyToken.largeTitle.scale, .largeTitle)
        XCTAssertEqual(TypographyToken.title1.scale, .title1)
        XCTAssertEqual(TypographyToken.title2.scale, .title2)
        XCTAssertEqual(TypographyToken.title3.scale, .title3)

        // Content styles
        XCTAssertEqual(TypographyToken.headline.scale, .headline)
        XCTAssertEqual(TypographyToken.body.scale, .body)
        XCTAssertEqual(TypographyToken.callout.scale, .callout)
        XCTAssertEqual(TypographyToken.subheadline.scale, .subheadline)

        // Supporting styles
        XCTAssertEqual(TypographyToken.footnote.scale, .footnote)
        XCTAssertEqual(TypographyToken.caption1.scale, .caption1)
        XCTAssertEqual(TypographyToken.caption2.scale, .caption2)
    }

    func testEmphasizedVariants() {
        XCTAssertEqual(TypographyToken.headlineBold.weight, .bold)
        XCTAssertEqual(TypographyToken.bodyBold.weight, .bold)
        XCTAssertEqual(TypographyToken.calloutBold.weight, .semibold)
        XCTAssertEqual(TypographyToken.subheadlineBold.weight, .semibold)
        XCTAssertEqual(TypographyToken.footnoteBold.weight, .semibold)
    }

    // MARK: - Equality Tests

    func testEquality() {
        let token1 = TypographyToken(scale: .body)
        let token2 = TypographyToken(scale: .body)

        XCTAssertEqual(token1, token2)
    }

    func testInequality() {
        let token1 = TypographyToken(scale: .body)
        let token2 = TypographyToken(scale: .body, weight: .bold)

        XCTAssertNotEqual(token1, token2)
    }

    // MARK: - Custom Factory Tests

    func testCustomFactory() {
        let token = TypographyToken.custom(scale: .body, weight: .medium, fontFamily: .inter)

        XCTAssertEqual(token.scale, .body)
        XCTAssertEqual(token.weight, .medium)
        XCTAssertEqual(token.fontFamily, .inter)
    }
}
