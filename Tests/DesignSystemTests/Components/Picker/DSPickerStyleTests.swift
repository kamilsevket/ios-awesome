import XCTest
import SwiftUI
@testable import DesignSystem

final class DSPickerStyleTests: XCTestCase {

    // MARK: - DSPickerSize Tests

    func testSmallSizeValues() {
        let size = DSPickerSize.small
        XCTAssertEqual(size.verticalPadding, 8)
        XCTAssertEqual(size.horizontalPadding, 12)
        XCTAssertEqual(size.cornerRadius, 8)
        XCTAssertEqual(size.rowHeight, 32)
    }

    func testMediumSizeValues() {
        let size = DSPickerSize.medium
        XCTAssertEqual(size.verticalPadding, 12)
        XCTAssertEqual(size.horizontalPadding, 16)
        XCTAssertEqual(size.cornerRadius, 10)
        XCTAssertEqual(size.rowHeight, 40)
    }

    func testLargeSizeValues() {
        let size = DSPickerSize.large
        XCTAssertEqual(size.verticalPadding, 16)
        XCTAssertEqual(size.horizontalPadding, 20)
        XCTAssertEqual(size.cornerRadius, 12)
        XCTAssertEqual(size.rowHeight, 48)
    }

    func testSizeFontsAreDifferent() {
        let small = DSPickerSize.small
        let medium = DSPickerSize.medium
        let large = DSPickerSize.large

        // Verify fonts are assigned (not nil)
        XCTAssertNotNil(small.font)
        XCTAssertNotNil(medium.font)
        XCTAssertNotNil(large.font)
        XCTAssertNotNil(small.labelFont)
        XCTAssertNotNil(medium.labelFont)
        XCTAssertNotNil(large.labelFont)
    }

    // MARK: - DSPickerVariant Tests

    func testDefaultVariantHasNoBorder() {
        let variant = DSPickerVariant.default
        XCTAssertEqual(variant.borderWidth, 0)
    }

    func testOutlinedVariantHasBorder() {
        let variant = DSPickerVariant.outlined
        XCTAssertEqual(variant.borderWidth, 1)
    }

    func testFilledVariantHasNoBorder() {
        let variant = DSPickerVariant.filled
        XCTAssertEqual(variant.borderWidth, 0)
    }

    func testVariantBackgroundColorsAreDifferent() {
        let defaultVariant = DSPickerVariant.default
        let outlinedVariant = DSPickerVariant.outlined
        let filledVariant = DSPickerVariant.filled

        let defaultBg = defaultVariant.backgroundColor(for: .light)
        let outlinedBg = outlinedVariant.backgroundColor(for: .light)
        let filledBg = filledVariant.backgroundColor(for: .light)

        // Default and outlined should be clear
        XCTAssertEqual(defaultBg, Color.clear)
        XCTAssertEqual(outlinedBg, Color.clear)
        // Filled should not be clear
        XCTAssertNotEqual(filledBg, Color.clear)
    }

    func testVariantBorderColors() {
        let defaultVariant = DSPickerVariant.default
        let outlinedVariant = DSPickerVariant.outlined
        let filledVariant = DSPickerVariant.filled

        // Default and filled should have clear border
        XCTAssertEqual(defaultVariant.borderColor(for: .light), Color.clear)
        XCTAssertEqual(filledVariant.borderColor(for: .light), Color.clear)

        // Outlined should have a visible border
        XCTAssertNotEqual(outlinedVariant.borderColor(for: .light), Color.clear)
    }

    func testVariantDarkModeSupport() {
        let filledVariant = DSPickerVariant.filled

        let lightBg = filledVariant.backgroundColor(for: .light)
        let darkBg = filledVariant.backgroundColor(for: .dark)

        // Both should have backgrounds (not clear)
        XCTAssertNotEqual(lightBg, Color.clear)
        XCTAssertNotEqual(darkBg, Color.clear)
    }

    // MARK: - DSPickerDisplayMode Tests

    func testAllDisplayModesExist() {
        let compact = DSPickerDisplayMode.compact
        let inline = DSPickerDisplayMode.inline
        let wheel = DSPickerDisplayMode.wheel
        let graphical = DSPickerDisplayMode.graphical

        XCTAssertNotNil(compact)
        XCTAssertNotNil(inline)
        XCTAssertNotNil(wheel)
        XCTAssertNotNil(graphical)
    }
}
