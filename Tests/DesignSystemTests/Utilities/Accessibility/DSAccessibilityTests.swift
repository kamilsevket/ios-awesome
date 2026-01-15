import XCTest
import SwiftUI
@testable import DesignSystem

final class DSAccessibilityTests: XCTestCase {

    // MARK: - DSAccessibilityModifier Tests

    func testAccessibilityModifierCreation() {
        let modifier = DSAccessibilityModifier(
            label: "Test Label",
            hint: "Test Hint",
            value: "Test Value",
            traits: .isButton,
            identifier: "test-id",
            isHidden: false,
            sortPriority: 100
        )

        XCTAssertNotNil(modifier)
    }

    func testAccessibilityModifierWithDefaults() {
        let modifier = DSAccessibilityModifier()

        XCTAssertNotNil(modifier)
    }

    func testAccessibilityModifierWithPartialValues() {
        let modifier = DSAccessibilityModifier(
            label: "Button",
            traits: .isButton
        )

        XCTAssertNotNil(modifier)
    }

    // MARK: - View Extension Tests

    func testDsAccessibilityModifier() {
        let view = Text("Test")
            .dsAccessibility(
                label: "Test Label",
                hint: "Test Hint"
            )

        XCTAssertNotNil(view)
    }

    func testDsButtonAccessibility() {
        let view = Text("Button")
            .dsButtonAccessibility(label: "Action Button", hint: "Performs action")

        XCTAssertNotNil(view)
    }

    func testDsHeaderAccessibility() {
        let view = Text("Header")
            .dsHeaderAccessibility(label: "Section Header")

        XCTAssertNotNil(view)
    }

    func testDsLinkAccessibility() {
        let view = Text("Link")
            .dsLinkAccessibility(label: "External Link", hint: "Opens in browser")

        XCTAssertNotNil(view)
    }

    func testDsImageAccessibility() {
        let view = Image(systemName: "star")
            .dsImageAccessibility(label: "Star icon")

        XCTAssertNotNil(view)
    }

    func testDsAccessibilityContainer() {
        let view = VStack {
            Text("Item 1")
            Text("Item 2")
        }
        .dsAccessibilityContainer()

        XCTAssertNotNil(view)
    }

    func testDsAccessibilityGroup() {
        let view = HStack {
            Image(systemName: "person")
            Text("Name")
        }
        .dsAccessibilityGroup()

        XCTAssertNotNil(view)
    }

    func testDsAccessibilityHidden() {
        let view = Image(systemName: "decorative")
            .dsAccessibilityHidden()

        XCTAssertNotNil(view)
    }

    // MARK: - Accessibility Action Tests

    func testDsAccessibilityAction() {
        var actionCalled = false

        let view = Text("Test")
            .dsAccessibilityAction(named: "Custom Action") {
                actionCalled = true
            }

        XCTAssertNotNil(view)
    }

    func testDsAccessibilityAdjustable() {
        var incrementCalled = false
        var decrementCalled = false

        let view = Text("Slider")
            .dsAccessibilityAdjustable(
                onIncrement: { incrementCalled = true },
                onDecrement: { decrementCalled = true }
            )

        XCTAssertNotNil(view)
    }
}

// MARK: - DSAnnouncer Tests

final class DSAnnouncerTests: XCTestCase {

    func testAnnouncerSharedInstance() {
        let announcer = DSAnnouncer.shared

        XCTAssertNotNil(announcer)
    }

    func testAnnouncerIsSingleton() {
        let instance1 = DSAnnouncer.shared
        let instance2 = DSAnnouncer.shared

        XCTAssertTrue(instance1 === instance2)
    }

    func testAnnounce() {
        // This test verifies the method exists and doesn't crash
        DSAnnouncer.shared.announce("Test message")
    }

    func testAnnounceWithPriority() {
        DSAnnouncer.shared.announce("Test", priority: .immediate)
        DSAnnouncer.shared.announce("Test", priority: .normal)
    }

    func testAnnounceWithDelay() {
        DSAnnouncer.shared.announce("Test", delay: 0.5)
    }

    func testAnnounceScreenChange() {
        DSAnnouncer.shared.announceScreenChange("Home Screen")
    }

    func testAnnounceLayoutChange() {
        DSAnnouncer.shared.announceLayoutChange()
        DSAnnouncer.shared.announceLayoutChange(focusElement: nil)
    }

    func testAnnouncePageScroll() {
        DSAnnouncer.shared.announcePageScroll("Page 2 of 5")
    }

    func testAnnounceActionCompleted() {
        DSAnnouncer.shared.announceActionCompleted("Save")
    }

    func testAnnounceError() {
        DSAnnouncer.shared.announceError("Connection failed")
    }

    func testAnnounceLoading() {
        DSAnnouncer.shared.announceLoading(true)
        DSAnnouncer.shared.announceLoading(false)
    }

    func testAnnounceItemCount() {
        DSAnnouncer.shared.announceItemCount(1, itemType: "result")
        DSAnnouncer.shared.announceItemCount(5, itemType: "message")
    }

    func testGlobalAnnounceFunction() {
        dsAnnounce("Test message")
        dsAnnounce("Urgent", priority: .immediate)
    }
}

// MARK: - Announcement Priority Tests

final class AnnouncementPriorityTests: XCTestCase {

    func testPriorityValues() {
        XCTAssertNotNil(AnnouncementPriority.normal)
        XCTAssertNotNil(AnnouncementPriority.immediate)
    }
}
