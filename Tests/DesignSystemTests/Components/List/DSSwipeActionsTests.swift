import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSwipeActionsTests: XCTestCase {

    // MARK: - DSSwipeActionRole Tests

    func testDestructiveRoleButtonRole() {
        let role = DSSwipeActionRole.destructive
        XCTAssertEqual(role.buttonRole, .destructive)
    }

    func testCancelRoleButtonRole() {
        let role = DSSwipeActionRole.cancel
        XCTAssertEqual(role.buttonRole, .cancel)
    }

    func testNoneRoleButtonRole() {
        let role = DSSwipeActionRole.none
        XCTAssertNil(role.buttonRole)
    }

    // MARK: - DSSwipeAction Initialization Tests

    func testSwipeActionInitialization() {
        var actionCalled = false
        let action = DSSwipeAction(
            title: "Test",
            icon: Image(systemName: "star"),
            tint: .blue,
            role: .none
        ) {
            actionCalled = true
        }

        XCTAssertEqual(action.title, "Test")
        XCTAssertNotNil(action.icon)
        XCTAssertEqual(action.tint, .blue)
        XCTAssertEqual(action.role, .none)
        XCTAssertFalse(actionCalled, "Action should not be called during initialization")
    }

    func testSwipeActionDefaultValues() {
        let action = DSSwipeAction(title: "Default") { }

        XCTAssertEqual(action.title, "Default")
        XCTAssertNil(action.icon)
        XCTAssertEqual(action.tint, DSColors.primary)
        XCTAssertEqual(action.role, .none)
    }

    func testSwipeActionUniqueIds() {
        let action1 = DSSwipeAction(title: "Action 1") { }
        let action2 = DSSwipeAction(title: "Action 2") { }

        XCTAssertNotEqual(action1.id, action2.id)
    }

    // MARK: - Factory Method Tests

    func testDeleteActionFactory() {
        var deleteCalled = false
        let action = DSSwipeAction.delete {
            deleteCalled = true
        }

        XCTAssertEqual(action.title, "Delete")
        XCTAssertNotNil(action.icon)
        XCTAssertEqual(action.tint, DSColors.destructive)
        XCTAssertEqual(action.role, .destructive)
        XCTAssertFalse(deleteCalled)
    }

    func testArchiveActionFactory() {
        let action = DSSwipeAction.archive { }

        XCTAssertEqual(action.title, "Archive")
        XCTAssertNotNil(action.icon)
        XCTAssertEqual(action.tint, .orange)
        XCTAssertEqual(action.role, .none)
    }

    func testPinActionFactoryNotPinned() {
        let action = DSSwipeAction.pin(isPinned: false) { }

        XCTAssertEqual(action.title, "Pin")
        XCTAssertNotNil(action.icon)
        XCTAssertEqual(action.tint, .yellow)
    }

    func testPinActionFactoryPinned() {
        let action = DSSwipeAction.pin(isPinned: true) { }

        XCTAssertEqual(action.title, "Unpin")
        XCTAssertNotNil(action.icon)
    }

    func testShareActionFactory() {
        let action = DSSwipeAction.share { }

        XCTAssertEqual(action.title, "Share")
        XCTAssertNotNil(action.icon)
        XCTAssertEqual(action.tint, DSColors.primary)
    }

    func testFlagActionFactoryNotFlagged() {
        let action = DSSwipeAction.flag(isFlagged: false) { }

        XCTAssertEqual(action.title, "Flag")
        XCTAssertNotNil(action.icon)
    }

    func testFlagActionFactoryFlagged() {
        let action = DSSwipeAction.flag(isFlagged: true) { }

        XCTAssertEqual(action.title, "Unflag")
        XCTAssertNotNil(action.icon)
    }

    func testMarkAsReadActionFactoryUnread() {
        let action = DSSwipeAction.markAsRead(isRead: false) { }

        XCTAssertEqual(action.title, "Mark Read")
        XCTAssertNotNil(action.icon)
    }

    func testMarkAsReadActionFactoryRead() {
        let action = DSSwipeAction.markAsRead(isRead: true) { }

        XCTAssertEqual(action.title, "Mark Unread")
        XCTAssertNotNil(action.icon)
    }

    func testEditActionFactory() {
        let action = DSSwipeAction.edit { }

        XCTAssertEqual(action.title, "Edit")
        XCTAssertNotNil(action.icon)
        XCTAssertEqual(action.tint, DSColors.info)
    }

    // MARK: - DSSwipeActionsModifier Tests

    func testSwipeActionsModifierInitialization() {
        let modifier = DSSwipeActionsModifier(
            leading: [.pin(action: { })],
            trailing: [.delete(action: { })],
            allowFullSwipe: true
        )
        XCTAssertNotNil(modifier)
    }

    func testSwipeActionsModifierEmptyActions() {
        let modifier = DSSwipeActionsModifier()
        XCTAssertNotNil(modifier)
    }

    // MARK: - View Extension Tests

    func testDsSwipeActionsExtension() {
        let view = Text("Test")
            .dsSwipeActions(
                leading: [.pin(action: { })],
                trailing: [.delete(action: { })]
            )
        XCTAssertNotNil(view)
    }

    func testDsDeleteActionExtension() {
        var deleteCalled = false
        let view = Text("Test")
            .dsDeleteAction {
                deleteCalled = true
            }

        XCTAssertNotNil(view)
        XCTAssertFalse(deleteCalled)
    }

    func testDsSwipeActionsWithMultipleActions() {
        let leadingActions: [DSSwipeAction] = [
            .pin(action: { }),
            .markAsRead(action: { })
        ]
        let trailingActions: [DSSwipeAction] = [
            .delete(action: { }),
            .archive(action: { }),
            .share(action: { })
        ]

        let view = Text("Test")
            .dsSwipeActions(
                leading: leadingActions,
                trailing: trailingActions,
                allowFullSwipe: false
            )

        XCTAssertNotNil(view)
    }
}
