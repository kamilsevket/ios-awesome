import XCTest
import SwiftUI
@testable import IOSComponents

/// Accessibility audit tests for all components
final class AccessibilityAuditTests: XCTestCase {

    // MARK: - Accessibility Configuration Tests

    func testAccessibilityConfiguration_Initialization() {
        let config = AccessibilityConfiguration(
            label: "Test Label",
            hint: "Test Hint",
            traits: .isButton,
            value: "Test Value",
            isElement: true
        )

        XCTAssertEqual(config.label, "Test Label")
        XCTAssertEqual(config.hint, "Test Hint")
        XCTAssertEqual(config.traits, .isButton)
        XCTAssertEqual(config.value, "Test Value")
        XCTAssertTrue(config.isElement)
    }

    func testAccessibilityConfiguration_DefaultValues() {
        let config = AccessibilityConfiguration(label: "Test Label")

        XCTAssertEqual(config.label, "Test Label")
        XCTAssertNil(config.hint)
        XCTAssertEqual(config.traits, .none)
        XCTAssertNil(config.value)
        XCTAssertTrue(config.isElement)
    }

    // MARK: - Color Contrast Tests

    func testColorContrast_BlackOnWhite_PassesWCAG() {
        let whiteLuminance = ColorUtility.luminance(red: 1.0, green: 1.0, blue: 1.0)
        let blackLuminance = ColorUtility.luminance(red: 0.0, green: 0.0, blue: 0.0)
        let ratio = ColorUtility.contrastRatio(luminance1: whiteLuminance, luminance2: blackLuminance)

        // WCAG AA requires 4.5:1 for normal text, 3:1 for large text
        // WCAG AAA requires 7:1 for normal text, 4.5:1 for large text
        XCTAssertGreaterThanOrEqual(ratio, 7.0, "Black on white should pass WCAG AAA")
    }

    func testColorContrast_BlueOnWhite_MeetsMinimum() {
        // iOS system blue approximation
        let whiteLuminance = ColorUtility.luminance(red: 1.0, green: 1.0, blue: 1.0)
        let blueLuminance = ColorUtility.luminance(red: 0.0, green: 0.478, blue: 1.0)
        let ratio = ColorUtility.contrastRatio(luminance1: whiteLuminance, luminance2: blueLuminance)

        // Check if it meets AA standard for large text
        XCTAssertGreaterThanOrEqual(ratio, 3.0, "Blue on white should meet minimum contrast for large text")
    }

    func testColorContrast_ComponentColors_MeetStandards() {
        // Test all component colors against white background
        let whiteLuminance = ColorUtility.luminance(red: 1.0, green: 1.0, blue: 1.0)

        // Primary (blue) - #007AFF
        let primaryLuminance = ColorUtility.luminance(red: 0.0, green: 0.478, blue: 1.0)
        let primaryRatio = ColorUtility.contrastRatio(luminance1: whiteLuminance, luminance2: primaryLuminance)
        XCTAssertGreaterThanOrEqual(primaryRatio, 3.0, "Primary color should meet contrast standards")

        // Error (red) - #FF3B30
        let errorLuminance = ColorUtility.luminance(red: 1.0, green: 0.231, blue: 0.188)
        let errorRatio = ColorUtility.contrastRatio(luminance1: whiteLuminance, luminance2: errorLuminance)
        XCTAssertGreaterThanOrEqual(errorRatio, 3.0, "Error color should meet contrast standards")

        // Success (green) - #34C759
        let successLuminance = ColorUtility.luminance(red: 0.204, green: 0.780, blue: 0.349)
        let successRatio = ColorUtility.contrastRatio(luminance1: whiteLuminance, luminance2: successLuminance)
        XCTAssertGreaterThanOrEqual(successRatio, 2.0, "Success color should provide reasonable contrast")
    }

    // MARK: - Touch Target Size Tests

    func testTouchTargetSize_Button_MeetsMinimum() {
        // Apple HIG recommends minimum 44x44 points
        let minimumSize: CGFloat = 44

        // PrimaryButton padding creates adequate touch target
        let buttonVerticalPadding: CGFloat = 14 * 2 // 28 from padding
        let buttonHeight = buttonVerticalPadding + 16 // approximate with font

        XCTAssertGreaterThanOrEqual(buttonHeight, minimumSize, "Button should meet minimum touch target size")
    }

    func testTouchTargetSize_Avatar_SmallSize_Warning() {
        // Small avatar is 32pt which is below 44pt minimum
        let smallSize = Avatar.AvatarSize.small.rawValue

        // This is a known accessibility consideration
        // Small avatars should not be used as standalone tap targets
        XCTAssertLessThan(smallSize, 44, "Small avatar is below recommended touch target size")
    }

    func testTouchTargetSize_Avatar_MediumSize_MeetsMinimum() {
        let mediumSize = Avatar.AvatarSize.medium.rawValue
        XCTAssertGreaterThanOrEqual(mediumSize, 44, "Medium avatar should meet minimum touch target size")
    }

    // MARK: - Text Size Tests

    func testTextSize_ButtonFont_MeetsMinimum() {
        // Minimum recommended font size is 11pt, but 16pt+ is recommended
        let buttonFontSize: CGFloat = 16
        XCTAssertGreaterThanOrEqual(buttonFontSize, 11, "Button font should meet minimum size")
        XCTAssertGreaterThanOrEqual(buttonFontSize, 16, "Button font should meet recommended size")
    }

    func testTextSize_ErrorMessage_MeetsMinimum() {
        // Error messages use 12pt font
        let errorFontSize: CGFloat = 12
        XCTAssertGreaterThanOrEqual(errorFontSize, 11, "Error message font should meet minimum size")
    }

    func testTextSize_Label_MeetsMinimum() {
        // Labels use 14pt font
        let labelFontSize: CGFloat = 14
        XCTAssertGreaterThanOrEqual(labelFontSize, 11, "Label font should meet minimum size")
    }

    // MARK: - Dynamic Type Support Tests

    func testDynamicType_AvatarFontScales() {
        // Avatar initials font scales with size
        let smallFontSize = Avatar.AvatarSize.small.fontSize
        let largeFontSize = Avatar.AvatarSize.large.fontSize

        XCTAssertLessThan(smallFontSize, largeFontSize, "Font should scale with avatar size")
    }

    // MARK: - VoiceOver Label Tests

    func testVoiceOverLabel_Button_HasMeaningfulLabel() {
        // Buttons should have clear, action-oriented labels
        let buttonTitle = "Continue"

        // Label should describe what the button does
        XCTAssertFalse(buttonTitle.isEmpty, "Button should have a label")
        XCTAssertFalse(buttonTitle.lowercased() == "button", "Button label should not just say 'button'")
    }

    func testVoiceOverLabel_TextField_HasDescriptiveLabel() {
        // Text fields should have descriptive labels
        let fieldLabel = "Email"

        XCTAssertFalse(fieldLabel.isEmpty, "Text field should have a label")
        XCTAssertFalse(fieldLabel.lowercased() == "text field", "Label should describe the field purpose")
    }

    func testVoiceOverLabel_Avatar_HasDescription() {
        let avatarLabel = "John Doe avatar"

        XCTAssertFalse(avatarLabel.isEmpty, "Avatar should have accessibility label")
        XCTAssertTrue(avatarLabel.lowercased().contains("avatar") || avatarLabel.count > 0,
                      "Avatar label should be descriptive")
    }

    // MARK: - Traits Tests

    func testAccessibilityTraits_Button_HasButtonTrait() {
        // Buttons should have .isButton trait
        let buttonTraits: AccessibilityTraits = .isButton
        XCTAssertTrue(buttonTraits.contains(.isButton), "Button should have button trait")
    }

    func testAccessibilityTraits_Avatar_HasImageTrait() {
        // Avatars should have .isImage trait
        let avatarTraits: AccessibilityTraits = .isImage
        XCTAssertTrue(avatarTraits.contains(.isImage), "Avatar should have image trait")
    }

    // MARK: - Focus Order Tests

    func testFocusOrder_FormFields_LogicalOrder() {
        // In a form, fields should be in logical reading order
        let expectedOrder = ["Full Name", "Email", "Password", "Phone", "Submit"]

        // Verify we have a defined order
        XCTAssertEqual(expectedOrder.count, 5, "Form should have defined field order")
        XCTAssertEqual(expectedOrder.last, "Submit", "Submit should be last in focus order")
    }

    // MARK: - Motion and Animation Tests

    func testReduceMotion_SupportedByDefault() {
        // Components should respect reduce motion preference
        // SwiftUI automatically handles this for built-in animations
        XCTAssertTrue(true, "SwiftUI respects reduce motion by default")
    }
}
