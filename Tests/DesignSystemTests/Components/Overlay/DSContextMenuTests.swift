import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSMenuItemRole Tests

final class DSMenuItemRoleTests: XCTestCase {

    func testDefaultRoleForegroundColor() {
        let role = DSMenuItemRole.default
        XCTAssertEqual(role.foregroundColor, Color(UIColor.label))
    }

    func testDestructiveRoleForegroundColor() {
        let role = DSMenuItemRole.destructive
        XCTAssertEqual(role.foregroundColor, DSColors.destructive)
    }

    func testRolesAreDistinct() {
        let defaultRole = DSMenuItemRole.default
        let destructiveRole = DSMenuItemRole.destructive

        XCTAssertNotEqual(defaultRole.foregroundColor, destructiveRole.foregroundColor)
    }
}

// MARK: - DSMenuItem Tests

final class DSMenuItemTests: XCTestCase {

    func testMenuItemInitialization() {
        var actionCalled = false
        let menuItem = DSMenuItem("Edit") {
            actionCalled = true
        }

        XCTAssertNotNil(menuItem)
        XCTAssertFalse(actionCalled)
    }

    func testMenuItemWithSystemImage() {
        let menuItem = DSMenuItem("Edit", systemImage: "pencil") { }

        XCTAssertNotNil(menuItem)
    }

    func testMenuItemWithDestructiveRole() {
        let menuItem = DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }

        XCTAssertNotNil(menuItem)
    }

    func testMenuItemDefaultRole() {
        let menuItem = DSMenuItem("Default Action") { }

        XCTAssertNotNil(menuItem)
    }
}

// MARK: - DSMenuSection Tests

final class DSMenuSectionTests: XCTestCase {

    func testMenuSectionWithHeader() {
        let section = DSMenuSection(header: "Actions") {
            DSMenuItem("Edit") { }
            DSMenuItem("Delete") { }
        }

        XCTAssertNotNil(section)
    }

    func testMenuSectionWithoutHeader() {
        let section = DSMenuSection {
            DSMenuItem("Option 1") { }
            DSMenuItem("Option 2") { }
        }

        XCTAssertNotNil(section)
    }
}

// MARK: - DSContextMenuButton Tests

final class DSContextMenuButtonTests: XCTestCase {

    func testContextMenuButtonInitialization() {
        let button = DSContextMenuButton {
            DSMenuItem("Edit") { }
            DSMenuItem("Delete") { }
        } label: {
            Image(systemName: "ellipsis.circle")
        }

        XCTAssertNotNil(button)
    }

    func testContextMenuButtonWithTextLabel() {
        let button = DSContextMenuButton {
            DSMenuItem("Sort by Name") { }
            DSMenuItem("Sort by Date") { }
        } label: {
            Text("Sort")
        }

        XCTAssertNotNil(button)
    }
}

// MARK: - View Extension Tests

final class ContextMenuViewExtensionTests: XCTestCase {

    func testDsContextMenuModifier() {
        let view = Text("Content")
            .dsContextMenu {
                DSMenuItem("Edit", systemImage: "pencil") { }
                DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
            }

        XCTAssertNotNil(view)
    }

    func testDsContextMenuModifierWithPreview() {
        let view = Text("Content")
            .dsContextMenu {
                DSMenuItem("Edit") { }
            } preview: {
                Text("Preview Content")
            }

        XCTAssertNotNil(view)
    }

    func testDsContextMenuWithSections() {
        let view = Text("Content")
            .dsContextMenu {
                DSMenuSection(header: "Edit") {
                    DSMenuItem("Copy") { }
                    DSMenuItem("Cut") { }
                }
                DSMenuSection(header: "Share") {
                    DSMenuItem("Share") { }
                }
            }

        XCTAssertNotNil(view)
    }

    func testDsContextMenuWithDivider() {
        let view = Text("Content")
            .dsContextMenu {
                DSMenuItem("Edit") { }
                Divider()
                DSMenuItem("Delete", role: .destructive) { }
            }

        XCTAssertNotNil(view)
    }
}
