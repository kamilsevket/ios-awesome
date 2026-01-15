import XCTest
import SwiftUI
@testable import DesignSystemTypography

final class ContentSizeCategoryTests: XCTestCase {
    // MARK: - Scale Factor Tests

    func testScaleFactorForDefaultSize() {
        let defaultCategory = ContentSizeCategory.large
        XCTAssertEqual(defaultCategory.scaleFactor, 1.0)
    }

    func testScaleFactorForSmallerSizes() {
        XCTAssertLessThan(ContentSizeCategory.extraSmall.scaleFactor, 1.0)
        XCTAssertLessThan(ContentSizeCategory.small.scaleFactor, 1.0)
        XCTAssertLessThan(ContentSizeCategory.medium.scaleFactor, 1.0)
    }

    func testScaleFactorForLargerSizes() {
        XCTAssertGreaterThan(ContentSizeCategory.extraLarge.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.extraExtraLarge.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.extraExtraExtraLarge.scaleFactor, 1.0)
    }

    func testScaleFactorForAccessibilitySizes() {
        XCTAssertGreaterThan(ContentSizeCategory.accessibilityMedium.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.accessibilityLarge.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.accessibilityExtraLarge.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.accessibilityExtraExtraLarge.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.accessibilityExtraExtraExtraLarge.scaleFactor, 1.0)
    }

    func testScaleFactorsAreIncreasing() {
        let categories: [ContentSizeCategory] = [
            .extraSmall,
            .small,
            .medium,
            .large,
            .extraLarge,
            .extraExtraLarge,
            .extraExtraExtraLarge
        ]

        for i in 0..<(categories.count - 1) {
            XCTAssertLessThan(categories[i].scaleFactor, categories[i + 1].scaleFactor,
                             "\(categories[i]) should have smaller scale factor than \(categories[i + 1])")
        }
    }

    // MARK: - Accessibility Category Tests

    func testIsAccessibilityCategory() {
        // Non-accessibility categories
        XCTAssertFalse(ContentSizeCategory.extraSmall.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.large.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.extraExtraExtraLarge.isAccessibilityCategory)

        // Accessibility categories
        XCTAssertTrue(ContentSizeCategory.accessibilityMedium.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityLarge.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityExtraLarge.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityExtraExtraLarge.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityExtraExtraExtraLarge.isAccessibilityCategory)
    }

    // MARK: - Scale Factor Range Tests

    func testScaleFactorRange() {
        let allCategories: [ContentSizeCategory] = [
            .extraSmall,
            .small,
            .medium,
            .large,
            .extraLarge,
            .extraExtraLarge,
            .extraExtraExtraLarge,
            .accessibilityMedium,
            .accessibilityLarge,
            .accessibilityExtraLarge,
            .accessibilityExtraExtraLarge,
            .accessibilityExtraExtraExtraLarge
        ]

        for category in allCategories {
            // Scale factors should be positive
            XCTAssertGreaterThan(category.scaleFactor, 0,
                                "\(category) should have positive scale factor")

            // Scale factors should not exceed reasonable bounds
            XCTAssertLessThanOrEqual(category.scaleFactor, 3.0,
                                    "\(category) scale factor should not exceed 3.0")
        }
    }
}
