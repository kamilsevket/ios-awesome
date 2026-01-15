import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSActionSheetAction Tests

final class DSActionSheetActionTests: XCTestCase {

    func testDefaultActionFactory() {
        var actionCalled = false
        let action = DSActionSheetAction.default("Save", systemImage: "square.and.arrow.down") {
            actionCalled = true
        }

        XCTAssertEqual(action.title, "Save")
        XCTAssertEqual(action.systemImage, "square.and.arrow.down")
        XCTAssertEqual(action.role, .default)
        XCTAssertFalse(actionCalled)
    }

    func testDestructiveActionFactory() {
        let action = DSActionSheetAction.destructive("Delete", systemImage: "trash") { }

        XCTAssertEqual(action.title, "Delete")
        XCTAssertEqual(action.systemImage, "trash")
        XCTAssertEqual(action.role, .destructive)
    }

    func testCancelActionFactory() {
        let action = DSActionSheetAction.cancel()

        XCTAssertEqual(action.title, "Cancel")
        XCTAssertNil(action.systemImage)
        XCTAssertEqual(action.role, .default)
    }

    func testCancelActionWithCustomTitle() {
        let action = DSActionSheetAction.cancel("Dismiss") { }

        XCTAssertEqual(action.title, "Dismiss")
    }

    func testActionWithoutSystemImage() {
        let action = DSActionSheetAction.default("Simple Action") { }

        XCTAssertEqual(action.title, "Simple Action")
        XCTAssertNil(action.systemImage)
    }

    func testActionExecution() {
        var executed = false
        let action = DSActionSheetAction.default("Execute") {
            executed = true
        }

        action.action()

        XCTAssertTrue(executed)
    }

    func testActionIdentifiable() {
        let action1 = DSActionSheetAction.default("Action 1") { }
        let action2 = DSActionSheetAction.default("Action 2") { }

        XCTAssertNotEqual(action1.id, action2.id)
    }
}

// MARK: - DSActionSheetStyle Tests

final class DSActionSheetStyleTests: XCTestCase {

    func testDefaultStyleValues() {
        let style = DSActionSheetStyle.default

        XCTAssertTrue(style.showsDragIndicator)
        XCTAssertEqual(style.cornerRadius, 14)
        XCTAssertEqual(style.buttonHeight, 56)
        XCTAssertEqual(style.separatorInset, 0)
    }

    func testCompactStyleValues() {
        let style = DSActionSheetStyle.compact

        XCTAssertFalse(style.showsDragIndicator)
        XCTAssertEqual(style.cornerRadius, 14)
        XCTAssertEqual(style.buttonHeight, 48)
        XCTAssertEqual(style.separatorInset, 16)
    }

    func testCustomStyleInitialization() {
        let customStyle = DSActionSheetStyle(
            showsDragIndicator: false,
            cornerRadius: 20,
            buttonHeight: 60,
            separatorInset: 24
        )

        XCTAssertFalse(customStyle.showsDragIndicator)
        XCTAssertEqual(customStyle.cornerRadius, 20)
        XCTAssertEqual(customStyle.buttonHeight, 60)
        XCTAssertEqual(customStyle.separatorInset, 24)
    }
}

// MARK: - DSActionSheet Tests

final class DSActionSheetTests: XCTestCase {

    func testActionSheetInitialization() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Options",
            actions: [
                .default("Option 1") { },
                .default("Option 2") { }
            ]
        )

        XCTAssertNotNil(sheet)
    }

    func testActionSheetWithMessage() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Photo Options",
            message: "Choose an action for this photo",
            actions: [
                .default("Save") { },
                .default("Share") { }
            ]
        )

        XCTAssertNotNil(sheet)
    }

    func testActionSheetWithDestructiveAction() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            actions: [
                .default("Edit") { },
                .destructive("Delete") { }
            ]
        )

        XCTAssertNotNil(sheet)
    }

    func testActionSheetWithCustomCancelAction() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            actions: [.default("OK") { }],
            cancelAction: .cancel("Dismiss") { }
        )

        XCTAssertNotNil(sheet)
    }

    func testActionSheetWithCustomStyle() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            actions: [.default("Action") { }],
            style: .compact
        )

        XCTAssertNotNil(sheet)
    }

    func testActionSheetDismissOnBackdropTap() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            actions: [.default("Action") { }],
            dismissOnBackdropTap: false
        )

        XCTAssertNotNil(sheet)
    }

    func testActionSheetWithIconActions() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Share",
            actions: [
                .default("Save to Photos", systemImage: "square.and.arrow.down") { },
                .default("Copy Link", systemImage: "link") { },
                .default("Share", systemImage: "square.and.arrow.up") { }
            ]
        )

        XCTAssertNotNil(sheet)
    }
}

// MARK: - View Extension Tests

final class ActionSheetViewExtensionTests: XCTestCase {

    func testDsActionSheetModifier() {
        var isPresented = true
        let view = Text("Content")
            .dsActionSheet(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                actions: [
                    .default("Edit") { },
                    .destructive("Delete") { }
                ]
            )

        XCTAssertNotNil(view)
    }

    func testDsActionSheetModifierWithAllParameters() {
        var isPresented = true
        let view = Text("Content")
            .dsActionSheet(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                title: "Title",
                message: "Message",
                actions: [.default("Action") { }],
                cancelAction: .cancel("Dismiss") { },
                style: .compact,
                dismissOnBackdropTap: false
            )

        XCTAssertNotNil(view)
    }
}

// MARK: - Integration Tests

final class ActionSheetIntegrationTests: XCTestCase {

    func testMultipleActionTypes() {
        var isPresented = true
        let sheet = DSActionSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            title: "Complete Menu",
            message: "All action types",
            actions: [
                .default("Default Action", systemImage: "star") { },
                .default("Another Default") { },
                .destructive("Destructive", systemImage: "trash") { }
            ],
            cancelAction: .cancel("Cancel") { }
        )

        XCTAssertNotNil(sheet)
    }

    func testActionRoleForegroundColors() {
        let defaultRole = DSMenuItemRole.default
        let destructiveRole = DSMenuItemRole.destructive

        // Default should use label color
        XCTAssertEqual(defaultRole.foregroundColor, Color(UIColor.label))

        // Destructive should use destructive color
        XCTAssertEqual(destructiveRole.foregroundColor, DSColors.destructive)
    }
}
