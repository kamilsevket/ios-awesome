import XCTest
import SwiftUI
@testable import DesignSystem

final class CardStyleTests: XCTestCase {

    // MARK: - CardStyle Tests

    func testCardStyleBackgroundColors() {
        // Flat style should be clear
        XCTAssertEqual(CardStyle.flat.backgroundColor, .clear)

        // Other styles should have backgrounds
        XCTAssertNotEqual(CardStyle.outlined.backgroundColor, .clear)
        XCTAssertNotEqual(CardStyle.elevated.backgroundColor, .clear)
        XCTAssertNotEqual(CardStyle.filled.backgroundColor, .clear)
    }

    func testCardStyleBorderWidth() {
        // Only outlined style should have border
        XCTAssertEqual(CardStyle.outlined.borderWidth, 1)
        XCTAssertEqual(CardStyle.flat.borderWidth, 0)
        XCTAssertEqual(CardStyle.elevated.borderWidth, 0)
        XCTAssertEqual(CardStyle.filled.borderWidth, 0)
    }

    func testCardStyleCasesCount() {
        XCTAssertEqual(CardStyle.allCases.count, 4)
    }

    // MARK: - CardShadowLevel Tests

    func testCardShadowLevelValues() {
        // None should have zero values
        XCTAssertEqual(CardShadowLevel.none.radius, 0)
        XCTAssertEqual(CardShadowLevel.none.opacity, 0)
        XCTAssertEqual(CardShadowLevel.none.yOffset, 0)

        // Values should increase with level
        XCTAssertLessThan(CardShadowLevel.small.radius, CardShadowLevel.medium.radius)
        XCTAssertLessThan(CardShadowLevel.medium.radius, CardShadowLevel.large.radius)
    }

    func testCardShadowLevelShadowTokenMapping() {
        XCTAssertEqual(CardShadowLevel.none.shadowToken, .none)
        XCTAssertEqual(CardShadowLevel.small.shadowToken, .sm)
        XCTAssertEqual(CardShadowLevel.medium.shadowToken, .md)
        XCTAssertEqual(CardShadowLevel.large.shadowToken, .lg)
    }

    // MARK: - CardPadding Tests

    func testCardPaddingValues() {
        XCTAssertEqual(CardPadding.none.value, 0)
        XCTAssertEqual(CardPadding.compact.value, Spacing.sm)
        XCTAssertEqual(CardPadding.standard.value, Spacing.md)
        XCTAssertEqual(CardPadding.spacious.value, Spacing.lg)
    }

    func testCardPaddingIncreasingOrder() {
        XCTAssertLessThan(CardPadding.none.value, CardPadding.compact.value)
        XCTAssertLessThan(CardPadding.compact.value, CardPadding.standard.value)
        XCTAssertLessThan(CardPadding.standard.value, CardPadding.spacious.value)
    }

    // MARK: - CardCornerRadius Tests

    func testCardCornerRadiusValues() {
        XCTAssertEqual(CardCornerRadius.none.value, 0)
        XCTAssertGreaterThan(CardCornerRadius.small.value, 0)
        XCTAssertGreaterThan(CardCornerRadius.medium.value, CardCornerRadius.small.value)
        XCTAssertGreaterThan(CardCornerRadius.large.value, CardCornerRadius.medium.value)
        XCTAssertGreaterThan(CardCornerRadius.extraLarge.value, CardCornerRadius.large.value)
    }

    func testCardCornerRadiusCasesCount() {
        XCTAssertEqual(CardCornerRadius.allCases.count, 5)
    }

    // MARK: - ImageCardAspectRatio Tests

    func testImageCardAspectRatioValues() {
        XCTAssertEqual(ImageCardAspectRatio.square.value, 1.0)
        XCTAssertEqual(ImageCardAspectRatio.landscape.value, 16.0 / 9.0, accuracy: 0.01)
        XCTAssertEqual(ImageCardAspectRatio.portrait.value, 3.0 / 4.0, accuracy: 0.01)
        XCTAssertEqual(ImageCardAspectRatio.wide.value, 2.0 / 1.0, accuracy: 0.01)
    }

    func testImageCardAspectRatioCasesCount() {
        XCTAssertEqual(ImageCardAspectRatio.allCases.count, 5)
    }

    // MARK: - ImageCardLayout Tests

    func testImageCardLayoutCasesCount() {
        XCTAssertEqual(ImageCardLayout.allCases.count, 4)
    }
}

final class DSCardTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDSCardInitialization() {
        // Test that DSCard can be initialized with content
        let _ = DSCard {
            Text("Test Content")
        }
        // If this compiles and runs without crash, initialization works
    }

    func testDSCardModifierChaining() {
        // Test that all modifiers can be chained
        let _ = DSCard {
            Text("Test Content")
        }
        .style(.elevated)
        .cardPadding(.standard)
        .cornerRadius(.medium)
        .shadowLevel(.small)
        // If this compiles, modifier chaining works
    }

    func testDSCardAllStyles() {
        // Verify all styles can be applied
        for style in CardStyle.allCases {
            let _ = DSCard {
                Text("Test")
            }
            .style(style)
        }
    }

    func testDSCardAllPaddingVariants() {
        for padding in CardPadding.allCases {
            let _ = DSCard {
                Text("Test")
            }
            .cardPadding(padding)
        }
    }

    func testDSCardAllCornerRadiusVariants() {
        for radius in CardCornerRadius.allCases {
            let _ = DSCard {
                Text("Test")
            }
            .cornerRadius(radius)
        }
    }

    func testDSCardAllShadowLevelVariants() {
        for shadow in CardShadowLevel.allCases {
            let _ = DSCard {
                Text("Test")
            }
            .shadowLevel(shadow)
        }
    }
}

final class DSInteractiveCardTests: XCTestCase {

    func testDSInteractiveCardInitialization() {
        var tapped = false
        let _ = DSInteractiveCard {
            Text("Test Content")
        } onTap: {
            tapped = true
        }
        XCTAssertFalse(tapped) // Tap hasn't occurred yet
    }

    func testDSInteractiveCardModifierChaining() {
        let _ = DSInteractiveCard {
            Text("Test Content")
        } onTap: {}
        .style(.elevated)
        .cardPadding(.standard)
        .cornerRadius(.medium)
        .shadowLevel(.small)
        .selectable(true)
        .hapticFeedback(false)
        .pressScale(0.95)
    }

    func testDSInteractiveCardWithoutTapAction() {
        // Should work without tap action
        let _ = DSInteractiveCard {
            Text("Test Content")
        }
    }
}

final class DSImageCardTests: XCTestCase {

    func testDSImageCardWithImage() {
        let _ = DSImageCard(
            image: Image(systemName: "photo"),
            title: "Test Title",
            subtitle: "Test Subtitle"
        )
    }

    func testDSImageCardWithURL() {
        let url = URL(string: "https://example.com/image.jpg")!
        let _ = DSImageCard(
            imageURL: url,
            title: "Test Title",
            subtitle: "Test Subtitle"
        )
    }

    func testDSImageCardWithoutSubtitle() {
        let _ = DSImageCard(
            image: Image(systemName: "photo"),
            title: "Test Title"
        )
    }

    func testDSImageCardModifierChaining() {
        let _ = DSImageCard(
            image: Image(systemName: "photo"),
            title: "Test",
            subtitle: "Subtitle"
        )
        .style(.elevated)
        .cornerRadius(.large)
        .shadowLevel(.medium)
        .aspectRatio(.landscape)
        .layout(.top)
        .imageContentMode(.fill)
        .onTap {}
    }

    func testDSImageCardAllAspectRatios() {
        for ratio in ImageCardAspectRatio.allCases {
            let _ = DSImageCard(
                image: Image(systemName: "photo"),
                title: "Test"
            )
            .aspectRatio(ratio)
        }
    }

    func testDSImageCardAllLayouts() {
        for layout in ImageCardLayout.allCases {
            let _ = DSImageCard(
                image: Image(systemName: "photo"),
                title: "Test"
            )
            .layout(layout)
        }
    }

    func testDSImageCardCustomAspectRatio() {
        let _ = DSImageCard(
            image: Image(systemName: "photo"),
            title: "Test"
        )
        .customAspectRatio(1.5)
    }
}

final class DSListCardTests: XCTestCase {

    func testDSListCardBasicInitialization() {
        let _ = DSListCard(title: "Test Title")
    }

    func testDSListCardFullInitialization() {
        let _ = DSListCard(
            title: "Test Title",
            subtitle: "Test Subtitle",
            icon: Image(systemName: "star")
        )
    }

    func testDSListCardModifierChaining() {
        let _ = DSListCard(
            title: "Test",
            subtitle: "Subtitle",
            icon: Image(systemName: "star")
        )
        .style(.flat)
        .cardPadding(.standard)
        .cornerRadius(.medium)
        .accessory(.chevron)
        .showDivider(true)
        .iconBackground(.blue)
        .iconColor(.white)
        .hapticFeedback(true)
        .onTap {}
    }

    func testDSListCardAccessoryTypes() {
        // Test all built-in accessory types
        let _ = DSListCard(title: "Test").accessory(.none)
        let _ = DSListCard(title: "Test").accessory(.chevron)
        let _ = DSListCard(title: "Test").accessory(.checkmark)
        let _ = DSListCard(title: "Test").accessory(.disclosure)
    }

    func testDSListCardCustomAccessory() {
        let customView = Image(systemName: "circle.fill")
        let _ = DSListCard(title: "Test").accessory(.custom(customView))
    }
}

final class DSExpandableCardTests: XCTestCase {

    func testDSExpandableCardWithTitleInitialization() {
        var isExpanded = false
        let binding = Binding(
            get: { isExpanded },
            set: { isExpanded = $0 }
        )

        let _ = DSExpandableCard(
            title: "Test Title",
            subtitle: "Test Subtitle",
            isExpanded: binding
        ) {
            Text("Content")
        }
    }

    func testDSExpandableCardWithCustomHeader() {
        var isExpanded = false
        let binding = Binding(
            get: { isExpanded },
            set: { isExpanded = $0 }
        )

        let _ = DSExpandableCard(isExpanded: binding) {
            HStack {
                Image(systemName: "star")
                Text("Custom Header")
            }
        } content: {
            Text("Content")
        }
    }

    func testDSExpandableCardModifierChaining() {
        var isExpanded = false
        let binding = Binding(
            get: { isExpanded },
            set: { isExpanded = $0 }
        )

        let _ = DSExpandableCard(
            title: "Test",
            isExpanded: binding
        ) {
            Text("Content")
        }
        .style(.elevated)
        .cardPadding(.standard)
        .cornerRadius(.medium)
        .shadowLevel(.small)
        .animationDuration(0.5)
        .hapticFeedback(false)
    }

    func testDSExpandableCardExpandedState() {
        var isExpanded = true
        let binding = Binding(
            get: { isExpanded },
            set: { isExpanded = $0 }
        )

        let _ = DSExpandableCard(
            title: "Test",
            isExpanded: binding
        ) {
            Text("Content")
        }

        XCTAssertTrue(isExpanded)
    }

    func testDSExpandableCardCollapsedState() {
        var isExpanded = false
        let binding = Binding(
            get: { isExpanded },
            set: { isExpanded = $0 }
        )

        let _ = DSExpandableCard(
            title: "Test",
            isExpanded: binding
        ) {
            Text("Content")
        }

        XCTAssertFalse(isExpanded)
    }
}

// MARK: - Shadow Token Tests

final class ShadowTokenTests: XCTestCase {

    func testShadowTokenNoneValues() {
        let token = ShadowToken.none
        XCTAssertEqual(token.blur, 0)
        XCTAssertEqual(token.y, 0)
        XCTAssertEqual(token.x, 0)
        XCTAssertEqual(token.opacity, 0)
    }

    func testShadowTokenIncreasingBlur() {
        XCTAssertLessThan(ShadowToken.sm.blur, ShadowToken.md.blur)
        XCTAssertLessThan(ShadowToken.md.blur, ShadowToken.lg.blur)
        XCTAssertLessThan(ShadowToken.lg.blur, ShadowToken.xl.blur)
    }

    func testShadowTokenIncreasingOpacity() {
        XCTAssertLessThan(ShadowToken.sm.opacity, ShadowToken.md.opacity)
        XCTAssertLessThan(ShadowToken.md.opacity, ShadowToken.lg.opacity)
        XCTAssertLessThan(ShadowToken.lg.opacity, ShadowToken.xl.opacity)
    }

    func testShadowTokenDarkModeOpacityHigher() {
        for token in ShadowToken.allCases where token != .none {
            XCTAssertGreaterThan(
                token.darkModeOpacity,
                token.opacity,
                "\(token) dark mode opacity should be higher than light mode"
            )
        }
    }

    func testShadowTokenCasesCount() {
        XCTAssertEqual(ShadowToken.allCases.count, 5)
    }
}

// MARK: - Elevation Level Tests

final class ElevationLevelTests: XCTestCase {

    func testElevationLevelSemanticAliases() {
        XCTAssertEqual(ElevationLevel.flat, .level0)
        XCTAssertEqual(ElevationLevel.card, .level1)
        XCTAssertEqual(ElevationLevel.raised, .level2)
        XCTAssertEqual(ElevationLevel.floating, .level3)
        XCTAssertEqual(ElevationLevel.dialog, .level4)
        XCTAssertEqual(ElevationLevel.modal, .level5)
    }

    func testElevationLevelShadowTokenMapping() {
        XCTAssertEqual(ElevationLevel.level0.shadowToken, .none)
        XCTAssertEqual(ElevationLevel.level1.shadowToken, .sm)
        XCTAssertEqual(ElevationLevel.level2.shadowToken, .md)
        XCTAssertEqual(ElevationLevel.level5.shadowToken, .xl)
    }

    func testElevationLevelZIndex() {
        for level in ElevationLevel.allCases {
            XCTAssertEqual(level.zIndex, Double(level.rawValue))
        }
    }

    func testElevationLevelCasesCount() {
        XCTAssertEqual(ElevationLevel.allCases.count, 6)
    }
}

// MARK: - Spacing Tests

final class SpacingTests: XCTestCase {

    func testSpacingBaseUnit() {
        XCTAssertEqual(Spacing.baseUnit, 4)
    }

    func testSpacingScaleValues() {
        XCTAssertEqual(Spacing.xxs, 2)
        XCTAssertEqual(Spacing.xs, 4)
        XCTAssertEqual(Spacing.sm, 8)
        XCTAssertEqual(Spacing.md, 16)
        XCTAssertEqual(Spacing.lg, 24)
        XCTAssertEqual(Spacing.xl, 32)
        XCTAssertEqual(Spacing.xxl, 48)
    }

    func testSpacingSemanticAliases() {
        XCTAssertEqual(Spacing.none, 0)
        XCTAssertEqual(Spacing.inline, Spacing.xs)
        XCTAssertEqual(Spacing.stack, Spacing.sm)
        XCTAssertEqual(Spacing.inset, Spacing.md)
        XCTAssertEqual(Spacing.section, Spacing.lg)
        XCTAssertEqual(Spacing.pageMargin, Spacing.md)
    }

    func testSpacingTokenValues() {
        XCTAssertEqual(SpacingToken.none.value, 0)
        XCTAssertEqual(SpacingToken.xxs.value, 2)
        XCTAssertEqual(SpacingToken.xs.value, 4)
        XCTAssertEqual(SpacingToken.sm.value, 8)
        XCTAssertEqual(SpacingToken.md.value, 16)
        XCTAssertEqual(SpacingToken.lg.value, 24)
        XCTAssertEqual(SpacingToken.xl.value, 32)
        XCTAssertEqual(SpacingToken.xxl.value, 48)
    }
}
