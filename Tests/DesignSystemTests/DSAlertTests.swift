import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSAlertAction Tests

final class DSAlertActionTests: XCTestCase {

    // MARK: - Alert Action Style Tests

    func testDefaultStyleColors() {
        let style = DSAlertActionStyle.default
        XCTAssertEqual(style.foregroundColor, .accentColor)
        XCTAssertEqual(style.fontWeight, .regular)
    }

    func testCancelStyleColors() {
        let style = DSAlertActionStyle.cancel
        XCTAssertEqual(style.fontWeight, .semibold)
    }

    func testDestructiveStyleColors() {
        let style = DSAlertActionStyle.destructive
        XCTAssertEqual(style.foregroundColor, DSColors.destructive)
        XCTAssertEqual(style.fontWeight, .regular)
    }

    // MARK: - Alert Action Initialization Tests

    func testActionInitializationWithDefaults() {
        var actionCalled = false
        let action = DSAlertAction("Test") {
            actionCalled = true
        }

        XCTAssertEqual(action.title, "Test")
        XCTAssertEqual(action.style, .default)
        XCTAssertFalse(actionCalled, "Action should not be called on initialization")
    }

    func testActionInitializationWithStyle() {
        let action = DSAlertAction("Delete", style: .destructive) { }

        XCTAssertEqual(action.title, "Delete")
        XCTAssertEqual(action.style, .destructive)
    }

    // MARK: - Factory Method Tests

    func testCancelFactory() {
        let action = DSAlertAction.cancel()

        XCTAssertEqual(action.title, "Cancel")
        XCTAssertEqual(action.style, .cancel)
    }

    func testCancelFactoryWithCustomTitle() {
        let action = DSAlertAction.cancel("Dismiss")

        XCTAssertEqual(action.title, "Dismiss")
        XCTAssertEqual(action.style, .cancel)
    }

    func testDestructiveFactory() {
        let action = DSAlertAction.destructive("Delete") { }

        XCTAssertEqual(action.title, "Delete")
        XCTAssertEqual(action.style, .destructive)
    }

    func testDefaultFactory() {
        let action = DSAlertAction.default("OK") { }

        XCTAssertEqual(action.title, "OK")
        XCTAssertEqual(action.style, .default)
    }

    // MARK: - Action Execution Tests

    func testActionExecutes() {
        var executed = false
        let action = DSAlertAction("Test") {
            executed = true
        }

        action.action()

        XCTAssertTrue(executed, "Action should execute when called")
    }
}

// MARK: - DSAlertIcon Tests

final class DSAlertIconTests: XCTestCase {

    func testSuccessIcon() {
        let icon = DSAlertIcon.success

        XCTAssertEqual(icon.color, DSColors.success)
        XCTAssertNotNil(icon.image)
    }

    func testWarningIcon() {
        let icon = DSAlertIcon.warning

        XCTAssertEqual(icon.color, DSColors.warning)
        XCTAssertNotNil(icon.image)
    }

    func testErrorIcon() {
        let icon = DSAlertIcon.error

        XCTAssertEqual(icon.color, DSColors.error)
        XCTAssertNotNil(icon.image)
    }

    func testInfoIcon() {
        let icon = DSAlertIcon.info

        XCTAssertEqual(icon.color, DSColors.info)
        XCTAssertNotNil(icon.image)
    }

    func testSystemIcon() {
        let icon = DSAlertIcon.system("star")

        XCTAssertEqual(icon.color, .accentColor)
        XCTAssertNotNil(icon.image)
    }

    func testCustomIcon() {
        let customImage = Image(systemName: "heart.fill")
        let icon = DSAlertIcon.custom(customImage)

        XCTAssertEqual(icon.color, .accentColor)
        XCTAssertNotNil(icon.image)
    }
}

// MARK: - DSAlert Tests

final class DSAlertTests: XCTestCase {

    func testAlertInitialization() {
        var isPresented = true
        let alert = DSAlert(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Test Title",
            message: "Test message",
            primaryAction: .default("OK") { }
        )

        XCTAssertNotNil(alert)
    }

    func testAlertWithIcon() {
        var isPresented = true
        let alert = DSAlert(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Success",
            message: "Operation completed",
            icon: .success,
            primaryAction: .default("Done") { }
        )

        XCTAssertNotNil(alert)
    }

    func testAlertWithTwoActions() {
        var isPresented = true
        let alert = DSAlert(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Delete?",
            message: "This cannot be undone",
            primaryAction: .destructive("Delete") { },
            secondaryAction: .cancel()
        )

        XCTAssertNotNil(alert)
    }

    func testAlertConfiguration() {
        let config = DSAlert.Configuration(
            title: "Test",
            message: "Message",
            icon: .info,
            primaryAction: .default("OK") { },
            secondaryAction: .cancel(),
            dismissOnBackdropTap: false
        )

        XCTAssertEqual(config.title, "Test")
        XCTAssertEqual(config.message, "Message")
        XCTAssertFalse(config.dismissOnBackdropTap)
    }
}

// MARK: - DSConfirmationDialog Tests

final class DSConfirmationDialogTests: XCTestCase {

    func testDialogInitialization() {
        var isPresented = true
        let dialog = DSConfirmationDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Options",
            actions: [
                .default("Option 1") { },
                .default("Option 2") { }
            ]
        )

        XCTAssertNotNil(dialog)
    }

    func testDialogWithMessage() {
        var isPresented = true
        let dialog = DSConfirmationDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Share",
            message: "Choose how to share",
            actions: [
                .default("Copy Link") { },
                .default("Share via Email") { }
            ]
        )

        XCTAssertNotNil(dialog)
    }

    func testDialogWithDestructiveAction() {
        var isPresented = true
        let dialog = DSConfirmationDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Photo Options",
            actions: [
                .default("Edit") { },
                .destructive("Delete") { }
            ]
        )

        XCTAssertNotNil(dialog)
    }

    func testDialogWithCustomCancel() {
        var isPresented = true
        let dialog = DSConfirmationDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            actions: [.default("OK") { }],
            cancelAction: .cancel("Dismiss")
        )

        XCTAssertNotNil(dialog)
    }
}

// MARK: - DSCustomDialog Tests

final class DSCustomDialogTests: XCTestCase {

    func testCustomDialogInitialization() {
        var isPresented = true
        let dialog = DSCustomDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Custom"
        ) {
            Text("Custom content")
        }

        XCTAssertNotNil(dialog)
    }

    func testCustomDialogWithActions() {
        var isPresented = true
        let dialog = DSCustomDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Settings"
        ) {
            Text("Toggle options")
        } actions: [
            .cancel(),
            .default("Save") { }
        ]

        XCTAssertNotNil(dialog)
    }

    func testCustomDialogMaxWidth() {
        var isPresented = true
        let dialog = DSCustomDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            maxWidth: 400
        ) {
            Text("Wide content")
        }

        XCTAssertNotNil(dialog)
    }

    func testCustomDialogDismissOnBackdropTap() {
        var isPresented = true
        let dialog = DSCustomDialog(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            dismissOnBackdropTap: false
        ) {
            Text("Non-dismissable")
        }

        XCTAssertNotNil(dialog)
    }
}

// MARK: - DSColors Tests

final class DSColorsTests: XCTestCase {

    func testSemanticColorsExist() {
        XCTAssertNotNil(DSColors.primary)
        XCTAssertNotNil(DSColors.success)
        XCTAssertNotNil(DSColors.warning)
        XCTAssertNotNil(DSColors.error)
        XCTAssertNotNil(DSColors.info)
    }

    func testDestructiveColorsExist() {
        XCTAssertNotNil(DSColors.destructive)
        XCTAssertNotNil(DSColors.destructiveDark)
    }

    func testBackgroundColorsExist() {
        XCTAssertNotNil(DSColors.backdrop)
        XCTAssertNotNil(DSColors.alertBackground)
        XCTAssertNotNil(DSColors.alertBackgroundSecondary)
    }

    func testDestructiveColorMatchesError() {
        XCTAssertEqual(DSColors.destructive, DSColors.error)
    }
}

// MARK: - Integration Tests

final class AlertIntegrationTests: XCTestCase {

    func testAllAlertTypesCanBeInstantiated() {
        var isPresented = true
        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })

        // DSAlert
        let alert = DSAlert(
            isPresented: binding,
            title: "Test",
            primaryAction: .default("OK") { }
        )
        XCTAssertNotNil(alert)

        // DSConfirmationDialog
        let confirmDialog = DSConfirmationDialog(
            isPresented: binding,
            actions: [.default("Action") { }]
        )
        XCTAssertNotNil(confirmDialog)

        // DSCustomDialog
        let customDialog = DSCustomDialog(
            isPresented: binding
        ) {
            Text("Content")
        }
        XCTAssertNotNil(customDialog)
    }

    func testAllActionStylesAreDistinct() {
        let defaultColor = DSAlertActionStyle.default.foregroundColor
        let cancelColor = DSAlertActionStyle.cancel.foregroundColor
        let destructiveColor = DSAlertActionStyle.destructive.foregroundColor

        // Destructive should be red (different from default and cancel)
        XCTAssertEqual(destructiveColor, DSColors.destructive)

        // Cancel should have different font weight
        XCTAssertEqual(DSAlertActionStyle.cancel.fontWeight, .semibold)
        XCTAssertEqual(DSAlertActionStyle.default.fontWeight, .regular)
        XCTAssertEqual(DSAlertActionStyle.destructive.fontWeight, .regular)
    }

    func testAllIconTypesHaveCorrectColors() {
        XCTAssertEqual(DSAlertIcon.success.color, DSColors.success)
        XCTAssertEqual(DSAlertIcon.warning.color, DSColors.warning)
        XCTAssertEqual(DSAlertIcon.error.color, DSColors.error)
        XCTAssertEqual(DSAlertIcon.info.color, DSColors.info)
    }
}
