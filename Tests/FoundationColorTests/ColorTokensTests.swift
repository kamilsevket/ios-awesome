import XCTest
import SwiftUI
@testable import FoundationColor

final class ColorTokensTests: XCTestCase {

    // MARK: - Primary Colors

    func testPrimaryColorsExist() {
        XCTAssertNotNil(ColorTokens.Primary.shade50)
        XCTAssertNotNil(ColorTokens.Primary.shade100)
        XCTAssertNotNil(ColorTokens.Primary.shade200)
        XCTAssertNotNil(ColorTokens.Primary.shade300)
        XCTAssertNotNil(ColorTokens.Primary.shade400)
        XCTAssertNotNil(ColorTokens.Primary.shade500)
        XCTAssertNotNil(ColorTokens.Primary.shade600)
        XCTAssertNotNil(ColorTokens.Primary.shade700)
        XCTAssertNotNil(ColorTokens.Primary.shade800)
        XCTAssertNotNil(ColorTokens.Primary.shade900)
    }

    // MARK: - Secondary Colors

    func testSecondaryColorsExist() {
        XCTAssertNotNil(ColorTokens.Secondary.shade50)
        XCTAssertNotNil(ColorTokens.Secondary.shade100)
        XCTAssertNotNil(ColorTokens.Secondary.shade200)
        XCTAssertNotNil(ColorTokens.Secondary.shade300)
        XCTAssertNotNil(ColorTokens.Secondary.shade400)
        XCTAssertNotNil(ColorTokens.Secondary.shade500)
        XCTAssertNotNil(ColorTokens.Secondary.shade600)
        XCTAssertNotNil(ColorTokens.Secondary.shade700)
        XCTAssertNotNil(ColorTokens.Secondary.shade800)
        XCTAssertNotNil(ColorTokens.Secondary.shade900)
    }

    // MARK: - Tertiary Colors

    func testTertiaryColorsExist() {
        XCTAssertNotNil(ColorTokens.Tertiary.shade50)
        XCTAssertNotNil(ColorTokens.Tertiary.shade100)
        XCTAssertNotNil(ColorTokens.Tertiary.shade200)
        XCTAssertNotNil(ColorTokens.Tertiary.shade300)
        XCTAssertNotNil(ColorTokens.Tertiary.shade400)
        XCTAssertNotNil(ColorTokens.Tertiary.shade500)
        XCTAssertNotNil(ColorTokens.Tertiary.shade600)
        XCTAssertNotNil(ColorTokens.Tertiary.shade700)
        XCTAssertNotNil(ColorTokens.Tertiary.shade800)
        XCTAssertNotNil(ColorTokens.Tertiary.shade900)
    }

    // MARK: - Semantic Colors

    func testSemanticColorsExist() {
        XCTAssertNotNil(ColorTokens.Semantic.success)
        XCTAssertNotNil(ColorTokens.Semantic.successLight)
        XCTAssertNotNil(ColorTokens.Semantic.warning)
        XCTAssertNotNil(ColorTokens.Semantic.warningLight)
        XCTAssertNotNil(ColorTokens.Semantic.error)
        XCTAssertNotNil(ColorTokens.Semantic.errorLight)
        XCTAssertNotNil(ColorTokens.Semantic.info)
        XCTAssertNotNil(ColorTokens.Semantic.infoLight)
    }

    // MARK: - UI Colors

    func testUIColorsExist() {
        XCTAssertNotNil(ColorTokens.UI.background)
        XCTAssertNotNil(ColorTokens.UI.backgroundSecondary)
        XCTAssertNotNil(ColorTokens.UI.surface)
        XCTAssertNotNil(ColorTokens.UI.surfaceElevated)
        XCTAssertNotNil(ColorTokens.UI.textPrimary)
        XCTAssertNotNil(ColorTokens.UI.textSecondary)
        XCTAssertNotNil(ColorTokens.UI.textTertiary)
        XCTAssertNotNil(ColorTokens.UI.textInverse)
        XCTAssertNotNil(ColorTokens.UI.border)
        XCTAssertNotNil(ColorTokens.UI.divider)
    }

    // MARK: - Color Extensions

    func testColorExtensionsExist() {
        XCTAssertNotNil(Color.primary500)
        XCTAssertNotNil(Color.secondary500)
        XCTAssertNotNil(Color.tertiary500)
        XCTAssertNotNil(Color.semantic.success)
        XCTAssertNotNil(Color.ui.background)
    }
}
