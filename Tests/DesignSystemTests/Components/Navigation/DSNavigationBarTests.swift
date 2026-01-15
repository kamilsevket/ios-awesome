import XCTest
import SwiftUI
@testable import DesignSystem

final class DSNavigationBarTests: XCTestCase {

    // MARK: - Navigation Bar Style Tests

    func testNavigationBarStyleProperties() {
        // Inline style
        let inlineStyle = DSNavigationBarStyle.inline
        XCTAssertEqual(inlineStyle.standardHeight, 44)
        XCTAssertEqual(inlineStyle.collapsedHeight, 44)
        XCTAssertTrue(inlineStyle.hasBackground)
        XCTAssertFalse(inlineStyle.supportsCollapse)

        // Large title style
        let largeTitleStyle = DSNavigationBarStyle.largeTitle
        XCTAssertEqual(largeTitleStyle.standardHeight, 96)
        XCTAssertEqual(largeTitleStyle.collapsedHeight, 44)
        XCTAssertTrue(largeTitleStyle.hasBackground)
        XCTAssertTrue(largeTitleStyle.supportsCollapse)
        XCTAssertEqual(largeTitleStyle.largeTitleSize, 34)

        // Transparent style
        let transparentStyle = DSNavigationBarStyle.transparent
        XCTAssertFalse(transparentStyle.hasBackground)
        XCTAssertFalse(transparentStyle.supportsCollapse)
    }

    func testNavigationBarStyleEquality() {
        XCTAssertEqual(DSNavigationBarStyle.inline, DSNavigationBarStyle.inline)
        XCTAssertEqual(DSNavigationBarStyle.largeTitle, DSNavigationBarStyle.largeTitle)
        XCTAssertNotEqual(DSNavigationBarStyle.inline, DSNavigationBarStyle.largeTitle)

        let config1 = DSNavigationBarConfiguration(standardHeight: 100)
        let config2 = DSNavigationBarConfiguration(standardHeight: 100)
        let config3 = DSNavigationBarConfiguration(standardHeight: 120)

        XCTAssertEqual(DSNavigationBarStyle.custom(config1), DSNavigationBarStyle.custom(config2))
        XCTAssertNotEqual(DSNavigationBarStyle.custom(config1), DSNavigationBarStyle.custom(config3))
    }

    func testCustomNavigationBarConfiguration() {
        let config = DSNavigationBarConfiguration(
            standardHeight: 120,
            collapsedHeight: 50,
            largeTitleSize: 40,
            inlineTitleSize: 18,
            supportsCollapse: true
        )

        XCTAssertEqual(config.standardHeight, 120)
        XCTAssertEqual(config.collapsedHeight, 50)
        XCTAssertEqual(config.largeTitleSize, 40)
        XCTAssertEqual(config.inlineTitleSize, 18)
        XCTAssertTrue(config.supportsCollapse)

        let customStyle = DSNavigationBarStyle.custom(config)
        XCTAssertEqual(customStyle.standardHeight, 120)
        XCTAssertTrue(customStyle.supportsCollapse)
    }

    // MARK: - Collapse State Tests

    func testCollapseStateProgress() {
        XCTAssertEqual(DSNavigationBarCollapseState.expanded.progress, 0)
        XCTAssertEqual(DSNavigationBarCollapseState.collapsed.progress, 1)
        XCTAssertEqual(DSNavigationBarCollapseState.collapsing(progress: 0.5).progress, 0.5)
    }

    func testCollapseStateIsCollapsed() {
        XCTAssertFalse(DSNavigationBarCollapseState.expanded.isCollapsed)
        XCTAssertTrue(DSNavigationBarCollapseState.collapsed.isCollapsed)
        XCTAssertFalse(DSNavigationBarCollapseState.collapsing(progress: 0.5).isCollapsed)
        XCTAssertTrue(DSNavigationBarCollapseState.collapsing(progress: 0.95).isCollapsed)
    }

    // MARK: - Shadow Style Tests

    func testShadowStylePresets() {
        let none = DSNavigationBarShadowStyle.none
        XCTAssertEqual(none.opacity, 0)

        let subtle = DSNavigationBarShadowStyle.subtle
        XCTAssertEqual(subtle.opacity, 0.1)
        XCTAssertEqual(subtle.radius, 0.5)

        let medium = DSNavigationBarShadowStyle.medium
        XCTAssertEqual(medium.opacity, 0.15)
        XCTAssertEqual(medium.radius, 2)

        let prominent = DSNavigationBarShadowStyle.prominent
        XCTAssertEqual(prominent.opacity, 0.2)
        XCTAssertEqual(prominent.radius, 4)
    }

    // MARK: - Scroll Collapse Calculator Tests

    func testScrollCollapseCalculatorProgress() {
        let calculator = DSScrollCollapseCalculator(
            collapseStartOffset: 0,
            collapseEndOffset: 100
        )

        XCTAssertEqual(calculator.progress(for: -10), 0)
        XCTAssertEqual(calculator.progress(for: 0), 0)
        XCTAssertEqual(calculator.progress(for: 50), 0.5)
        XCTAssertEqual(calculator.progress(for: 100), 1)
        XCTAssertEqual(calculator.progress(for: 150), 1)
    }

    func testScrollCollapseCalculatorState() {
        let calculator = DSScrollCollapseCalculator(
            collapseStartOffset: 0,
            collapseEndOffset: 100
        )

        XCTAssertEqual(calculator.state(for: 0), .expanded)
        XCTAssertEqual(calculator.state(for: 100), .collapsed)

        if case .collapsing(let progress) = calculator.state(for: 50) {
            XCTAssertEqual(progress, 0.5)
        } else {
            XCTFail("Expected collapsing state")
        }
    }

    func testScrollCollapseCalculatorHeight() {
        let calculator = DSScrollCollapseCalculator()

        let expandedHeight: CGFloat = 100
        let collapsedHeight: CGFloat = 44

        XCTAssertEqual(calculator.height(expandedHeight: expandedHeight, collapsedHeight: collapsedHeight, progress: 0), 100)
        XCTAssertEqual(calculator.height(expandedHeight: expandedHeight, collapsedHeight: collapsedHeight, progress: 1), 44)
        XCTAssertEqual(calculator.height(expandedHeight: expandedHeight, collapsedHeight: collapsedHeight, progress: 0.5), 72)
    }

    func testScrollCollapseCalculatorLargeTitleOpacity() {
        let calculator = DSScrollCollapseCalculator()

        XCTAssertEqual(calculator.largeTitleOpacity(for: 0), 1)
        XCTAssertEqual(calculator.largeTitleOpacity(for: 0.5), 0)
        XCTAssertEqual(calculator.largeTitleOpacity(for: 1), 0)
    }

    func testScrollCollapseCalculatorLargeTitleScale() {
        let calculator = DSScrollCollapseCalculator()

        XCTAssertEqual(calculator.largeTitleScale(for: 0), 1)
        XCTAssertEqual(calculator.largeTitleScale(for: 1), 0.7)
    }

    // MARK: - Back Button Style Tests

    func testBackButtonStyleIconNames() {
        XCTAssertEqual(DSBackButtonStyle.chevron.iconName, "chevron.left")
        XCTAssertEqual(DSBackButtonStyle.arrow.iconName, "arrow.left")
        XCTAssertEqual(DSBackButtonStyle.close.iconName, "xmark")
        XCTAssertEqual(DSBackButtonStyle.custom("custom.icon").iconName, "custom.icon")
    }

    // MARK: - Search Field Style Tests

    func testSearchFieldStyleProperties() {
        let rounded = DSSearchFieldStyle.rounded
        XCTAssertEqual(rounded.cornerRadius, 10)
        XCTAssertEqual(rounded.height, 36)

        let pill = DSSearchFieldStyle.pill
        XCTAssertEqual(pill.cornerRadius, 20)
        XCTAssertEqual(pill.height, 36)

        let minimal = DSSearchFieldStyle.minimal
        XCTAssertEqual(minimal.cornerRadius, 0)
        XCTAssertEqual(minimal.height, 32)
    }

    // MARK: - Large Title Display Mode Tests

    func testLargeTitleDisplayModePreferences() {
        XCTAssertTrue(DSLargeTitleDisplayMode.always.prefersLargeTitles)
        XCTAssertTrue(DSLargeTitleDisplayMode.automatic.prefersLargeTitles)
        XCTAssertFalse(DSLargeTitleDisplayMode.never.prefersLargeTitles)
    }

    // MARK: - Accessibility Identifier Tests

    func testAccessibilityIdentifiers() {
        XCTAssertEqual(DSNavigationBarAccessibilityIdentifier.navigationBar, "ds.navigationBar")
        XCTAssertEqual(DSNavigationBarAccessibilityIdentifier.backButton, "ds.navigationBar.backButton")
        XCTAssertEqual(DSNavigationBarAccessibilityIdentifier.title, "ds.navigationBar.title")
        XCTAssertEqual(DSNavigationBarAccessibilityIdentifier.searchField, "ds.navigationBar.searchField")
    }

    // MARK: - Dynamic Type Scale Factor Tests

    func testContentSizeCategoryScaleFactor() {
        XCTAssertEqual(ContentSizeCategory.medium.scaleFactor, 1.0)
        XCTAssertEqual(ContentSizeCategory.large.scaleFactor, 1.0)
        XCTAssertLessThan(ContentSizeCategory.small.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.extraLarge.scaleFactor, 1.0)
        XCTAssertGreaterThan(ContentSizeCategory.accessibilityExtraExtraExtraLarge.scaleFactor, 1.5)
    }

    func testNavigationBarStyleAdjustedHeights() {
        let style = DSNavigationBarStyle.largeTitle
        let (standard, collapsed) = style.adjustedHeights(for: .extraLarge)

        XCTAssertGreaterThan(standard, style.standardHeight)
        XCTAssertGreaterThan(collapsed, style.collapsedHeight)
    }
}

// MARK: - Scroll Offset Preference Key Tests

final class ScrollOffsetPreferenceKeyTests: XCTestCase {

    func testDefaultValue() {
        XCTAssertEqual(ScrollOffsetPreferenceKey.defaultValue, 0)
    }

    func testReduce() {
        var value: CGFloat = 0
        ScrollOffsetPreferenceKey.reduce(value: &value) { 50 }
        XCTAssertEqual(value, 50)
    }
}
