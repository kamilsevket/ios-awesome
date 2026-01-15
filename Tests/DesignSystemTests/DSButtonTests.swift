import XCTest
import SwiftUI
@testable import DesignSystem

final class DSButtonTests: XCTestCase {

    // MARK: - DSButtonStyle Tests

    func testPrimaryStyleColors() {
        let style = DSButtonStyle.primary
        XCTAssertEqual(style.foregroundColor, Color.white)
        XCTAssertNotEqual(style.backgroundColor, Color.clear)
    }

    func testSecondaryStyleColors() {
        let style = DSButtonStyle.secondary
        XCTAssertEqual(style.foregroundColor, Color.primary)
    }

    func testTertiaryStyleHasClearBackground() {
        let style = DSButtonStyle.tertiary
        XCTAssertEqual(style.backgroundColor, Color.clear)
    }

    // MARK: - DSButtonSize Tests

    func testSmallSizeValues() {
        let size = DSButtonSize.small
        XCTAssertEqual(size.verticalPadding, 8)
        XCTAssertEqual(size.horizontalPadding, 16)
        XCTAssertEqual(size.minHeight, 36)
        XCTAssertEqual(size.cornerRadius, 8)
        XCTAssertEqual(size.iconSize, 16)
    }

    func testMediumSizeValues() {
        let size = DSButtonSize.medium
        XCTAssertEqual(size.verticalPadding, 12)
        XCTAssertEqual(size.horizontalPadding, 24)
        XCTAssertEqual(size.minHeight, 44)
        XCTAssertEqual(size.cornerRadius, 10)
        XCTAssertEqual(size.iconSize, 20)
    }

    func testLargeSizeValues() {
        let size = DSButtonSize.large
        XCTAssertEqual(size.verticalPadding, 16)
        XCTAssertEqual(size.horizontalPadding, 32)
        XCTAssertEqual(size.minHeight, 52)
        XCTAssertEqual(size.cornerRadius, 12)
        XCTAssertEqual(size.iconSize, 24)
    }

    func testMediumSizeMinHeightMeetsTouchTarget() {
        let size = DSButtonSize.medium
        XCTAssertGreaterThanOrEqual(size.minHeight, 44, "Medium button should meet 44pt minimum touch target")
    }

    func testLargeSizeMinHeightMeetsTouchTarget() {
        let size = DSButtonSize.large
        XCTAssertGreaterThanOrEqual(size.minHeight, 44, "Large button should meet 44pt minimum touch target")
    }

    // MARK: - DSButton Initialization Tests

    func testButtonInitializationWithDefaults() {
        var actionCalled = false
        let _ = DSButton("Test") {
            actionCalled = true
        }
        XCTAssertFalse(actionCalled, "Action should not be called on initialization")
    }

    func testButtonInitializationWithAllParameters() {
        let _ = DSButton(
            "Test Button",
            style: .secondary,
            size: .large,
            icon: Image(systemName: "star"),
            iconPosition: .trailing,
            isFullWidth: true,
            isLoading: false,
            isEnabled: true,
            hapticFeedback: false
        ) { }
        // If this compiles and doesn't crash, the test passes
    }
}

// MARK: - DSIconButton Tests

final class DSIconButtonTests: XCTestCase {

    // MARK: - Icon Button Style Tests

    func testFilledStyleHasOpaqueForeground() {
        let style = DSIconButtonStyle.filled
        let foregroundColor = style.foregroundColor(for: .blue)
        XCTAssertEqual(foregroundColor, Color.white)
    }

    func testTintedStyleMatchesTintColor() {
        let style = DSIconButtonStyle.tinted
        let tintColor = Color.red
        let foregroundColor = style.foregroundColor(for: tintColor)
        XCTAssertEqual(foregroundColor, tintColor)
    }

    func testPlainStyleHasClearBackground() {
        let style = DSIconButtonStyle.plain
        let backgroundColor = style.backgroundColor(for: .blue)
        XCTAssertEqual(backgroundColor, Color.clear)
    }

    // MARK: - Icon Button Size Tests

    func testSmallIconButtonSize() {
        let size = DSIconButtonSize.small
        XCTAssertEqual(size.buttonSize, 36)
        XCTAssertEqual(size.iconSize, 16)
    }

    func testMediumIconButtonSize() {
        let size = DSIconButtonSize.medium
        XCTAssertEqual(size.buttonSize, 44)
        XCTAssertEqual(size.iconSize, 20)
    }

    func testLargeIconButtonSize() {
        let size = DSIconButtonSize.large
        XCTAssertEqual(size.buttonSize, 52)
        XCTAssertEqual(size.iconSize, 24)
    }

    func testMediumIconButtonMeetsTouchTarget() {
        let size = DSIconButtonSize.medium
        XCTAssertGreaterThanOrEqual(size.buttonSize, 44, "Medium icon button should meet 44pt minimum touch target")
    }

    // MARK: - Convenience Initializers Tests

    func testCloseButtonFactory() {
        let button = DSIconButton.close { }
        // If this compiles and doesn't crash, the test passes
        XCTAssertNotNil(button)
    }

    func testAddButtonFactory() {
        let button = DSIconButton.add { }
        XCTAssertNotNil(button)
    }

    func testSettingsButtonFactory() {
        let button = DSIconButton.settings { }
        XCTAssertNotNil(button)
    }

    func testShareButtonFactory() {
        let button = DSIconButton.share { }
        XCTAssertNotNil(button)
    }

    func testEditButtonFactory() {
        let button = DSIconButton.edit { }
        XCTAssertNotNil(button)
    }

    func testDeleteButtonFactory() {
        let button = DSIconButton.delete { }
        XCTAssertNotNil(button)
    }
}

// MARK: - DSFloatingActionButton Tests

final class DSFloatingActionButtonTests: XCTestCase {

    // MARK: - FAB Size Tests

    func testSmallFABSize() {
        let size = DSFABSize.small
        XCTAssertEqual(size.diameter, 40)
        XCTAssertEqual(size.iconSize, 20)
        XCTAssertEqual(size.shadowRadius, 4)
    }

    func testRegularFABSize() {
        let size = DSFABSize.regular
        XCTAssertEqual(size.diameter, 56)
        XCTAssertEqual(size.iconSize, 24)
        XCTAssertEqual(size.shadowRadius, 8)
    }

    func testExtendedFABSize() {
        let size = DSFABSize.extended
        XCTAssertEqual(size.diameter, 56)
        XCTAssertEqual(size.iconSize, 24)
        XCTAssertEqual(size.shadowRadius, 8)
    }

    func testRegularFABMeetsTouchTarget() {
        let size = DSFABSize.regular
        XCTAssertGreaterThanOrEqual(size.diameter, 44, "Regular FAB should meet 44pt minimum touch target")
    }

    // MARK: - FAB Initialization Tests

    func testFABInitializationWithSystemName() {
        let fab = DSFloatingActionButton(
            systemName: "plus",
            accessibilityLabel: "Add"
        ) { }
        XCTAssertNotNil(fab)
    }

    func testFABInitializationWithCustomIcon() {
        let fab = DSFloatingActionButton(
            icon: Image(systemName: "star.fill"),
            accessibilityLabel: "Favorite"
        ) { }
        XCTAssertNotNil(fab)
    }

    func testExtendedFABFactory() {
        let fab = DSFloatingActionButton.extended(
            systemName: "plus",
            title: "Create"
        ) { }
        XCTAssertNotNil(fab)
    }

    func testExtendedFABWithCustomIcon() {
        let fab = DSFloatingActionButton.extended(
            icon: Image(systemName: "star.fill"),
            title: "Favorite"
        ) { }
        XCTAssertNotNil(fab)
    }

    func testFABWithAllParameters() {
        let fab = DSFloatingActionButton(
            systemName: "plus",
            size: .small,
            backgroundColor: .red,
            foregroundColor: .white,
            isEnabled: false,
            hapticFeedback: false,
            accessibilityLabel: "Add item"
        ) { }
        XCTAssertNotNil(fab)
    }
}

// MARK: - Integration Tests

final class ButtonIntegrationTests: XCTestCase {

    func testAllButtonTypesCanBeInstantiated() {
        // DSButton
        let button = DSButton("Test", style: .primary) { }
        XCTAssertNotNil(button)

        // DSIconButton
        let iconButton = DSIconButton(systemName: "star", accessibilityLabel: "Star") { }
        XCTAssertNotNil(iconButton)

        // DSFloatingActionButton
        let fab = DSFloatingActionButton(systemName: "plus", accessibilityLabel: "Add") { }
        XCTAssertNotNil(fab)
    }

    func testButtonStylesAreDistinct() {
        let primaryBg = DSButtonStyle.primary.backgroundColor
        let secondaryBg = DSButtonStyle.secondary.backgroundColor
        let tertiaryBg = DSButtonStyle.tertiary.backgroundColor

        XCTAssertNotEqual(primaryBg, secondaryBg)
        XCTAssertNotEqual(secondaryBg, tertiaryBg)
        XCTAssertNotEqual(primaryBg, tertiaryBg)
    }

    func testAllSizesHaveMinimumTouchTarget() {
        // All medium and large buttons should meet 44pt touch target
        XCTAssertGreaterThanOrEqual(DSButtonSize.medium.minHeight, 44)
        XCTAssertGreaterThanOrEqual(DSButtonSize.large.minHeight, 44)
        XCTAssertGreaterThanOrEqual(DSIconButtonSize.medium.buttonSize, 44)
        XCTAssertGreaterThanOrEqual(DSIconButtonSize.large.buttonSize, 44)
        XCTAssertGreaterThanOrEqual(DSFABSize.regular.diameter, 44)
    }
}
