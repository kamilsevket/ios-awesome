import XCTest
import SwiftUI
@testable import DesignSystem

final class DSDynamicTypeTests: XCTestCase {

    // MARK: - ContentSizeCategory Extension Tests

    func testScaleFactorExtraSmall() {
        let category = ContentSizeCategory.extraSmall
        XCTAssertEqual(category.scaleFactor, 0.82, accuracy: 0.01)
    }

    func testScaleFactorSmall() {
        let category = ContentSizeCategory.small
        XCTAssertEqual(category.scaleFactor, 0.88, accuracy: 0.01)
    }

    func testScaleFactorMedium() {
        let category = ContentSizeCategory.medium
        XCTAssertEqual(category.scaleFactor, 0.94, accuracy: 0.01)
    }

    func testScaleFactorLarge() {
        let category = ContentSizeCategory.large
        XCTAssertEqual(category.scaleFactor, 1.0, accuracy: 0.01)
    }

    func testScaleFactorExtraLarge() {
        let category = ContentSizeCategory.extraLarge
        XCTAssertEqual(category.scaleFactor, 1.12, accuracy: 0.01)
    }

    func testScaleFactorExtraExtraLarge() {
        let category = ContentSizeCategory.extraExtraLarge
        XCTAssertEqual(category.scaleFactor, 1.24, accuracy: 0.01)
    }

    func testScaleFactorExtraExtraExtraLarge() {
        let category = ContentSizeCategory.extraExtraExtraLarge
        XCTAssertEqual(category.scaleFactor, 1.35, accuracy: 0.01)
    }

    func testScaleFactorAccessibilityMedium() {
        let category = ContentSizeCategory.accessibilityMedium
        XCTAssertEqual(category.scaleFactor, 1.64, accuracy: 0.01)
    }

    func testScaleFactorAccessibilityLarge() {
        let category = ContentSizeCategory.accessibilityLarge
        XCTAssertEqual(category.scaleFactor, 1.95, accuracy: 0.01)
    }

    func testScaleFactorAccessibilityExtraLarge() {
        let category = ContentSizeCategory.accessibilityExtraLarge
        XCTAssertEqual(category.scaleFactor, 2.35, accuracy: 0.01)
    }

    func testScaleFactorAccessibilityExtraExtraLarge() {
        let category = ContentSizeCategory.accessibilityExtraExtraLarge
        XCTAssertEqual(category.scaleFactor, 2.76, accuracy: 0.01)
    }

    func testScaleFactorAccessibilityExtraExtraExtraLarge() {
        let category = ContentSizeCategory.accessibilityExtraExtraExtraLarge
        XCTAssertEqual(category.scaleFactor, 3.12, accuracy: 0.01)
    }

    // MARK: - Accessibility Category Tests

    func testIsAccessibilityCategoryForStandardSizes() {
        XCTAssertFalse(ContentSizeCategory.extraSmall.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.small.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.medium.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.large.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.extraLarge.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.extraExtraLarge.isAccessibilityCategory)
        XCTAssertFalse(ContentSizeCategory.extraExtraExtraLarge.isAccessibilityCategory)
    }

    func testIsAccessibilityCategoryForAccessibilitySizes() {
        XCTAssertTrue(ContentSizeCategory.accessibilityMedium.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityLarge.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityExtraLarge.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityExtraExtraLarge.isAccessibilityCategory)
        XCTAssertTrue(ContentSizeCategory.accessibilityExtraExtraExtraLarge.isAccessibilityCategory)
    }

    // MARK: - Dynamic Type Modifier Tests

    func testDsDynamicTypeSizeModifier() {
        let modifier = DSDynamicTypeSizeModifier(
            minSize: .xSmall,
            maxSize: .accessibility3
        )

        XCTAssertNotNil(modifier)
    }

    func testDsDynamicTypeSizeView() {
        let view = Text("Test")
            .dsDynamicTypeSize(.small, .xxxLarge)

        XCTAssertNotNil(view)
    }

    func testDsDynamicTypeStandard() {
        let view = Text("Test")
            .dsDynamicTypeStandard()

        XCTAssertNotNil(view)
    }

    func testDsDynamicTypeCompact() {
        let view = Text("Test")
            .dsDynamicTypeCompact()

        XCTAssertNotNil(view)
    }

    // MARK: - Dynamic Type Observer Tests

    func testDynamicTypeObserverSharedInstance() {
        let observer = DSDynamicTypeObserver.shared

        XCTAssertNotNil(observer)
    }

    func testDynamicTypeObserverIsSingleton() {
        let instance1 = DSDynamicTypeObserver.shared
        let instance2 = DSDynamicTypeObserver.shared

        XCTAssertTrue(instance1 === instance2)
    }

    func testDynamicTypeObserverHasCurrentSize() {
        let observer = DSDynamicTypeObserver.shared

        XCTAssertNotNil(observer.currentSize)
    }

    func testDynamicTypeObserverHasAccessibilitySizeFlag() {
        let observer = DSDynamicTypeObserver.shared

        XCTAssertNotNil(observer.isAccessibilitySize)
    }

    // MARK: - DSDynamicTypeContainer Tests

    func testDynamicTypeContainerCreation() {
        let container = DSDynamicTypeContainer { isAccessibilitySize in
            if isAccessibilitySize {
                Text("Large")
            } else {
                Text("Normal")
            }
        }

        XCTAssertNotNil(container)
    }
}
