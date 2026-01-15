import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSegmentedControlTests: XCTestCase {

    // MARK: - DSSegmentedControlStyle Tests

    func testStandardStyleValues() {
        let style = DSSegmentedControlStyle.standard
        XCTAssertEqual(style.segmentCornerRadius, 6)
        XCTAssertEqual(style.containerCornerRadius, 8)
        XCTAssertTrue(style.hasContainerBackground)
        XCTAssertTrue(style.hasIndicator)
    }

    func testPillStyleValues() {
        let style = DSSegmentedControlStyle.pill
        XCTAssertEqual(style.segmentCornerRadius, 20)
        XCTAssertEqual(style.containerCornerRadius, 24)
        XCTAssertTrue(style.hasContainerBackground)
        XCTAssertTrue(style.hasIndicator)
    }

    func testUnderlineStyleValues() {
        let style = DSSegmentedControlStyle.underline
        XCTAssertEqual(style.segmentCornerRadius, 0)
        XCTAssertEqual(style.containerCornerRadius, 0)
        XCTAssertFalse(style.hasContainerBackground)
        XCTAssertTrue(style.hasIndicator)
    }

    // MARK: - DSSegmentedControlSize Tests

    func testCompactSizeValues() {
        let size = DSSegmentedControlSize.compact
        XCTAssertEqual(size.height, 32)
        XCTAssertEqual(size.iconSize, 14)
        XCTAssertEqual(size.horizontalPadding, 12)
        XCTAssertEqual(size.iconTextSpacing, 4)
    }

    func testStandardSizeValues() {
        let size = DSSegmentedControlSize.standard
        XCTAssertEqual(size.height, 44)
        XCTAssertEqual(size.iconSize, 16)
        XCTAssertEqual(size.horizontalPadding, 16)
        XCTAssertEqual(size.iconTextSpacing, 6)
    }

    func testLargeSizeValues() {
        let size = DSSegmentedControlSize.large
        XCTAssertEqual(size.height, 52)
        XCTAssertEqual(size.iconSize, 20)
        XCTAssertEqual(size.horizontalPadding, 20)
        XCTAssertEqual(size.iconTextSpacing, 8)
    }

    func testStandardSizeMeetsMinTouchTarget() {
        let size = DSSegmentedControlSize.standard
        XCTAssertGreaterThanOrEqual(size.height, 44, "Standard size should meet 44pt minimum touch target")
    }

    func testLargeSizeMeetsMinTouchTarget() {
        let size = DSSegmentedControlSize.large
        XCTAssertGreaterThanOrEqual(size.height, 44, "Large size should meet 44pt minimum touch target")
    }

    // MARK: - DSSegmentWidthMode Tests

    func testWidthModeEquality() {
        XCTAssertEqual(DSSegmentWidthMode.equal, DSSegmentWidthMode.equal)
        XCTAssertEqual(DSSegmentWidthMode.dynamic, DSSegmentWidthMode.dynamic)
        XCTAssertEqual(DSSegmentWidthMode.fixed(100), DSSegmentWidthMode.fixed(100))
        XCTAssertNotEqual(DSSegmentWidthMode.fixed(100), DSSegmentWidthMode.fixed(200))
    }

    // MARK: - DSSegmentedControlConstants Tests

    func testConstantsValues() {
        XCTAssertEqual(DSSegmentedControlConstants.springResponse, 0.35)
        XCTAssertEqual(DSSegmentedControlConstants.springDamping, 0.75)
        XCTAssertEqual(DSSegmentedControlConstants.animationDuration, 0.25)
        XCTAssertEqual(DSSegmentedControlConstants.containerPadding, 2)
        XCTAssertEqual(DSSegmentedControlConstants.minSegmentWidth, 44)
        XCTAssertEqual(DSSegmentedControlConstants.underlineHeight, 2)
        XCTAssertEqual(DSSegmentedControlConstants.underlineInset, 8)
    }
}

// MARK: - DSSegment Tests

final class DSSegmentTests: XCTestCase {

    enum TestTag: String {
        case first
        case second
        case third
    }

    // MARK: - Initialization Tests

    func testSegmentWithTitleOnly() {
        let segment = DSSegment(.first, "First")

        XCTAssertEqual(segment.id, TestTag.first)
        XCTAssertEqual(segment.title, "First")
        XCTAssertNil(segment.icon)
        XCTAssertFalse(segment.isDisabled)
        XCTAssertTrue(segment.hasTitle)
        XCTAssertFalse(segment.hasIcon)
        XCTAssertFalse(segment.isIconOnly)
    }

    func testSegmentWithTitleAndIcon() {
        let segment = DSSegment(.second, "Second", icon: "star")

        XCTAssertEqual(segment.id, TestTag.second)
        XCTAssertEqual(segment.title, "Second")
        XCTAssertEqual(segment.icon, "star")
        XCTAssertFalse(segment.isDisabled)
        XCTAssertTrue(segment.hasTitle)
        XCTAssertTrue(segment.hasIcon)
        XCTAssertFalse(segment.isIconOnly)
    }

    func testSegmentIconOnly() {
        let segment = DSSegment<TestTag>.iconOnly(
            .third,
            icon: "checkmark",
            accessibilityLabel: "Complete"
        )

        XCTAssertEqual(segment.id, TestTag.third)
        XCTAssertEqual(segment.title, "")
        XCTAssertEqual(segment.icon, "checkmark")
        XCTAssertFalse(segment.hasTitle)
        XCTAssertTrue(segment.hasIcon)
        XCTAssertTrue(segment.isIconOnly)
        XCTAssertEqual(segment.accessibilityLabel, "Complete")
    }

    func testDisabledSegment() {
        let segment = DSSegment(.first, "Disabled", isDisabled: true)

        XCTAssertTrue(segment.isDisabled)
    }

    func testAccessibilityLabelFallsBackToTitle() {
        let segment = DSSegment(.first, "First Item")

        XCTAssertEqual(segment.accessibilityLabel, "First Item")
    }
}

// MARK: - DSSegmentedControlAccessibility Tests

final class DSSegmentedControlAccessibilityTests: XCTestCase {

    func testPositionValue() {
        XCTAssertEqual(
            DSSegmentedControlAccessibility.positionValue(index: 0, total: 3),
            "1 of 3"
        )
        XCTAssertEqual(
            DSSegmentedControlAccessibility.positionValue(index: 2, total: 5),
            "3 of 5"
        )
    }
}

// MARK: - DSSegmentedControl Integration Tests

final class DSSegmentedControlIntegrationTests: XCTestCase {

    enum Filter: String, CaseIterable {
        case all
        case active
        case completed
    }

    func testSegmentedControlInitialization() {
        // Test array-based initialization
        let segments = [
            DSSegment(.all, "All"),
            DSSegment(.active, "Active"),
            DSSegment(.completed, "Completed")
        ]

        var selection: Filter = .all
        let binding = Binding(
            get: { selection },
            set: { selection = $0 }
        )

        let _ = DSSegmentedControl(selection: binding, segments: segments)
        XCTAssertEqual(selection, .all)
    }

    func testSegmentedControlResultBuilder() {
        var selection: Filter = .all
        let binding = Binding(
            get: { selection },
            set: { selection = $0 }
        )

        let _ = DSSegmentedControl(selection: binding) {
            DSSegment(.all, "All")
            DSSegment(.active, "Active")
            DSSegment(.completed, "Completed")
        }

        XCTAssertEqual(selection, .all)
    }

    func testSegmentedControlModifiers() {
        var selection: Filter = .all
        let binding = Binding(
            get: { selection },
            set: { selection = $0 }
        )

        // Test that all modifiers compile and return Self
        let control = DSSegmentedControl(selection: binding) {
            DSSegment(.all, "All")
            DSSegment(.active, "Active")
        }
        .style(.pill)
        .controlSize(.large)
        .widthMode(.dynamic)
        .tintColor(.blue)
        .selectedTextColor(.white)
        .unselectedTextColor(.gray)
        .backgroundColor(.clear)

        // If this compiles and doesn't crash, the test passes
        _ = control
    }
}
