import XCTest
import SwiftUI
@testable import DesignSystem

final class DSEmptyStateTests: XCTestCase {

    // MARK: - DSEmptyStateType Tests

    func testEmptyStateTypeDefaultIcons() {
        XCTAssertEqual(DSEmptyStateType.empty.defaultIcon, "tray")
        XCTAssertEqual(DSEmptyStateType.error.defaultIcon, "exclamationmark.triangle")
        XCTAssertEqual(DSEmptyStateType.noResults.defaultIcon, "magnifyingglass")
        XCTAssertEqual(DSEmptyStateType.offline.defaultIcon, "wifi.slash")
    }

    func testEmptyStateTypeCustomIcon() {
        let customType = DSEmptyStateType.custom(icon: "star.fill", iconColor: .blue)
        XCTAssertEqual(customType.defaultIcon, "star.fill")
    }

    func testEmptyStateTypeAccessibilityPrefix() {
        XCTAssertEqual(DSEmptyStateType.empty.accessibilityPrefix, "Empty")
        XCTAssertEqual(DSEmptyStateType.error.accessibilityPrefix, "Error")
        XCTAssertEqual(DSEmptyStateType.noResults.accessibilityPrefix, "No results")
        XCTAssertEqual(DSEmptyStateType.offline.accessibilityPrefix, "Offline")
        XCTAssertEqual(DSEmptyStateType.custom(icon: "star", iconColor: .blue).accessibilityPrefix, "Status")
    }

    func testEmptyStateTypeEquatable() {
        XCTAssertEqual(DSEmptyStateType.empty, DSEmptyStateType.empty)
        XCTAssertEqual(DSEmptyStateType.error, DSEmptyStateType.error)
        XCTAssertNotEqual(DSEmptyStateType.empty, DSEmptyStateType.error)

        let custom1 = DSEmptyStateType.custom(icon: "star", iconColor: .blue)
        let custom2 = DSEmptyStateType.custom(icon: "star", iconColor: .blue)
        XCTAssertEqual(custom1, custom2)
    }

    func testEmptyStateTypeIconColorLight() {
        let lightScheme = ColorScheme.light

        let emptyColor = DSEmptyStateType.empty.iconColor(colorScheme: lightScheme)
        XCTAssertEqual(emptyColor, DSColors.emptyStateIcon)

        let noResultsColor = DSEmptyStateType.noResults.iconColor(colorScheme: lightScheme)
        XCTAssertEqual(noResultsColor, DSColors.emptyStateIcon)

        let errorColor = DSEmptyStateType.error.iconColor(colorScheme: lightScheme)
        XCTAssertEqual(errorColor, DSColors.error)

        let offlineColor = DSEmptyStateType.offline.iconColor(colorScheme: lightScheme)
        XCTAssertEqual(offlineColor, DSColors.warning)
    }

    func testEmptyStateTypeIconColorDark() {
        let darkScheme = ColorScheme.dark

        let emptyColor = DSEmptyStateType.empty.iconColor(colorScheme: darkScheme)
        XCTAssertEqual(emptyColor, DSColors.emptyStateIconDark)

        let noResultsColor = DSEmptyStateType.noResults.iconColor(colorScheme: darkScheme)
        XCTAssertEqual(noResultsColor, DSColors.emptyStateIconDark)
    }

    func testCustomTypeIconColor() {
        let customColor = Color.purple
        let customType = DSEmptyStateType.custom(icon: "heart.fill", iconColor: customColor)
        XCTAssertEqual(customType.iconColor(colorScheme: .light), customColor)
        XCTAssertEqual(customType.iconColor(colorScheme: .dark), customColor)
    }

    // MARK: - DSEmptyStateSize Tests

    func testEmptyStateSizeIconSizes() {
        XCTAssertEqual(DSEmptyStateSize.small.iconSize, 40)
        XCTAssertEqual(DSEmptyStateSize.medium.iconSize, 56)
        XCTAssertEqual(DSEmptyStateSize.large.iconSize, 72)
    }

    func testEmptyStateSizeIconContainerSizes() {
        XCTAssertEqual(DSEmptyStateSize.small.iconContainerSize, 64)
        XCTAssertEqual(DSEmptyStateSize.medium.iconContainerSize, 88)
        XCTAssertEqual(DSEmptyStateSize.large.iconContainerSize, 112)
    }

    func testEmptyStateSizeSpacing() {
        XCTAssertEqual(DSEmptyStateSize.small.spacing, DSSpacing.sm)
        XCTAssertEqual(DSEmptyStateSize.medium.spacing, DSSpacing.md)
        XCTAssertEqual(DSEmptyStateSize.large.spacing, DSSpacing.lg)
    }

    // MARK: - DSEmptyStateAction Tests

    func testEmptyStateActionInitialization() {
        var actionCalled = false
        let action = DSEmptyStateAction(
            title: "Test Action",
            style: .primary
        ) {
            actionCalled = true
        }

        XCTAssertEqual(action.title, "Test Action")
        XCTAssertEqual(action.style.backgroundColor, DSColors.primary)
        XCTAssertEqual(action.style.foregroundColor, .white)

        action.action()
        XCTAssertTrue(actionCalled)
    }

    func testEmptyStateActionFactoryMethods() {
        var primaryCalled = false
        let primaryAction = DSEmptyStateAction.primary("Primary") {
            primaryCalled = true
        }
        XCTAssertEqual(primaryAction.title, "Primary")
        XCTAssertEqual(primaryAction.style.backgroundColor, DSColors.primary)

        primaryAction.action()
        XCTAssertTrue(primaryCalled)

        var secondaryCalled = false
        let secondaryAction = DSEmptyStateAction.secondary("Secondary") {
            secondaryCalled = true
        }
        XCTAssertEqual(secondaryAction.title, "Secondary")
        XCTAssertEqual(secondaryAction.style.backgroundColor, Color(.systemGray5))

        secondaryAction.action()
        XCTAssertTrue(secondaryCalled)
    }

    // MARK: - DSEmptyStateActionStyle Tests

    func testEmptyStateActionStyleColors() {
        XCTAssertEqual(DSEmptyStateActionStyle.primary.backgroundColor, DSColors.primary)
        XCTAssertEqual(DSEmptyStateActionStyle.primary.foregroundColor, .white)

        XCTAssertEqual(DSEmptyStateActionStyle.secondary.backgroundColor, Color(.systemGray5))
        XCTAssertEqual(DSEmptyStateActionStyle.secondary.foregroundColor, .primary)
    }

    // MARK: - DSEmptyState Factory Methods Tests

    func testErrorFactoryMethod() {
        let errorState = DSEmptyState<EmptyView>.error(
            title: "Custom Error",
            description: "Custom description",
            retryAction: { }
        )
        XCTAssertNotNil(errorState)
    }

    func testErrorFactoryMethodWithoutAction() {
        let errorState = DSEmptyState<EmptyView>.error(
            title: "Error Title",
            description: "Error description"
        )
        XCTAssertNotNil(errorState)
    }

    func testNoResultsFactoryMethod() {
        let noResultsState = DSEmptyState<EmptyView>.noResults(
            title: "Custom No Results",
            description: "Custom description",
            clearAction: { }
        )
        XCTAssertNotNil(noResultsState)
    }

    func testNoResultsFactoryMethodWithDefaults() {
        let noResultsState = DSEmptyState<EmptyView>.noResults()
        XCTAssertNotNil(noResultsState)
    }

    func testOfflineFactoryMethod() {
        let offlineState = DSEmptyState<EmptyView>.offline(
            title: "Custom Offline",
            description: "Custom description",
            retryAction: { }
        )
        XCTAssertNotNil(offlineState)
    }

    func testOfflineFactoryMethodWithDefaults() {
        let offlineState = DSEmptyState<EmptyView>.offline()
        XCTAssertNotNil(offlineState)
    }

    // MARK: - DSEmptyState Initialization Tests

    func testBasicInitialization() {
        let emptyState = DSEmptyState<EmptyView>(
            type: .empty,
            title: "Test Title"
        )
        XCTAssertNotNil(emptyState)
    }

    func testInitializationWithAllParameters() {
        let emptyState = DSEmptyState<EmptyView>(
            type: .error,
            icon: "custom.icon",
            title: "Test Title",
            description: "Test Description",
            size: .large,
            action: .primary("Action") { },
            showIconBackground: false
        )
        XCTAssertNotNil(emptyState)
    }

    func testTupleStyleInitialization() {
        let emptyState = DSEmptyState<EmptyView>(
            icon: "tray",
            title: "No items",
            description: "Add your first item",
            action: ("Add Item", { })
        )
        XCTAssertNotNil(emptyState)
    }

    func testTupleStyleInitializationWithoutAction() {
        let emptyState = DSEmptyState<EmptyView>(
            icon: "tray",
            title: "No items",
            description: "Add your first item"
        )
        XCTAssertNotNil(emptyState)
    }

    func testInitializationWithCustomContent() {
        let emptyState = DSEmptyState(
            type: .empty,
            title: "Test"
        ) {
            Text("Custom content")
        }
        XCTAssertNotNil(emptyState)
    }

    // MARK: - DSColors Empty State Tests

    func testEmptyStateColorTokens() {
        XCTAssertNotNil(DSColors.emptyStateIcon)
        XCTAssertNotNil(DSColors.emptyStateIconDark)
    }

    // MARK: - Edge Cases

    func testEmptyDescriptionHandling() {
        let emptyState = DSEmptyState<EmptyView>(
            type: .empty,
            title: "Title Only",
            description: nil
        )
        XCTAssertNotNil(emptyState)
    }

    func testAllSizeVariants() {
        let sizes: [DSEmptyStateSize] = [.small, .medium, .large]

        for size in sizes {
            let emptyState = DSEmptyState<EmptyView>(
                type: .empty,
                title: "Test",
                size: size
            )
            XCTAssertNotNil(emptyState)
        }
    }

    func testAllTypeVariants() {
        let types: [DSEmptyStateType] = [
            .empty,
            .error,
            .noResults,
            .offline,
            .custom(icon: "star", iconColor: .blue)
        ]

        for type in types {
            let emptyState = DSEmptyState<EmptyView>(
                type: type,
                title: "Test"
            )
            XCTAssertNotNil(emptyState)
        }
    }
}
