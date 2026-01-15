import XCTest
import SwiftUI
@testable import DesignSystem

final class DSTagTests: XCTestCase {

    // MARK: - DSTag Tests

    func testTagCreation() {
        let tag = DSTag("Swift")
        XCTAssertNotNil(tag)
    }

    func testTagWithIcon() {
        let tag = DSTag("Apple", icon: Image(systemName: "apple.logo"))
        XCTAssertNotNil(tag)
    }

    func testTagSizeVariants() {
        let smallTag = DSTag("Small", size: .sm)
        let mediumTag = DSTag("Medium", size: .md)
        XCTAssertNotNil(smallTag)
        XCTAssertNotNil(mediumTag)
    }

    func testTagWithDismiss() {
        var dismissed = false
        let tag = DSTag("Dismissible") { dismissed = true }
        XCTAssertNotNil(tag)
        XCTAssertFalse(dismissed)
    }

    // MARK: - DSTagVariant Tests

    func testTagVariantDefault() {
        let variant = DSTagVariant.default
        XCTAssertEqual(variant.backgroundColor, DSColors.chipBackground)
        XCTAssertEqual(variant.foregroundColor, DSColors.chipText)
        XCTAssertEqual(variant.borderColor, Color.clear)
    }

    func testTagVariantPrimary() {
        let variant = DSTagVariant.primary
        XCTAssertNotNil(variant.backgroundColor)
        XCTAssertEqual(variant.foregroundColor, DSColors.primary)
    }

    func testTagVariantSuccess() {
        let variant = DSTagVariant.success
        XCTAssertEqual(variant.foregroundColor, DSColors.success)
    }

    func testTagVariantWarning() {
        let variant = DSTagVariant.warning
        XCTAssertNotNil(variant.backgroundColor)
    }

    func testTagVariantError() {
        let variant = DSTagVariant.error
        XCTAssertEqual(variant.foregroundColor, DSColors.error)
    }

    func testTagVariantInfo() {
        let variant = DSTagVariant.info
        XCTAssertNotNil(variant.backgroundColor)
    }

    // MARK: - DSTagSize Tests

    func testTagSizeSmallValues() {
        let size = DSTagSize.sm
        XCTAssertEqual(size.horizontalPadding, DSSpacing.sm)
        XCTAssertEqual(size.verticalPadding, DSSpacing.xs)
        XCTAssertEqual(size.minHeight, 24)
    }

    func testTagSizeMediumValues() {
        let size = DSTagSize.md
        XCTAssertEqual(size.horizontalPadding, DSSpacing.md)
        XCTAssertEqual(size.verticalPadding, DSSpacing.sm)
        XCTAssertEqual(size.minHeight, 28)
    }
}
