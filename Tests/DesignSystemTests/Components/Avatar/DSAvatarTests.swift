import XCTest
import SwiftUI
@testable import DesignSystem

final class DSAvatarTests: XCTestCase {

    // MARK: - Initials Generation Tests

    func testGenerateInitials_fullName() {
        XCTAssertEqual(DSAvatar.generateInitials(from: "John Doe"), "JD")
        XCTAssertEqual(DSAvatar.generateInitials(from: "Alice Brown"), "AB")
    }

    func testGenerateInitials_multipleParts() {
        XCTAssertEqual(DSAvatar.generateInitials(from: "John Michael Doe"), "JD")
        XCTAssertEqual(DSAvatar.generateInitials(from: "Mary Jane Watson Parker"), "MP")
    }

    func testGenerateInitials_singleName() {
        XCTAssertEqual(DSAvatar.generateInitials(from: "John"), "J")
        XCTAssertEqual(DSAvatar.generateInitials(from: "alice"), "A")
    }

    func testGenerateInitials_emptyString() {
        XCTAssertNil(DSAvatar.generateInitials(from: ""))
    }

    func testGenerateInitials_nil() {
        XCTAssertNil(DSAvatar.generateInitials(from: nil))
    }

    func testGenerateInitials_lowercaseConverted() {
        XCTAssertEqual(DSAvatar.generateInitials(from: "john doe"), "JD")
    }

    // MARK: - Color Generation Tests

    func testColorForName_consistentResults() {
        let color1 = DSAvatar.colorForName("John Doe")
        let color2 = DSAvatar.colorForName("John Doe")
        XCTAssertEqual(color1, color2)
    }

    func testColorForName_differentNamesProduceDifferentColors() {
        let color1 = DSAvatar.colorForName("John")
        let color2 = DSAvatar.colorForName("Alice")
        let color3 = DSAvatar.colorForName("Bob")

        // At least some colors should be different
        // (not guaranteed all will be different due to hashing)
        let uniqueColors = Set([color1.description, color2.description, color3.description])
        XCTAssertGreaterThan(uniqueColors.count, 1)
    }

    func testColorForName_emptyString() {
        let color = DSAvatar.colorForName("")
        XCTAssertEqual(color, .gray)
    }

    func testColorForName_nil() {
        let color = DSAvatar.colorForName(nil)
        XCTAssertEqual(color, .gray)
    }

    // MARK: - Initialization Tests

    func testInit_withInitials() {
        let avatar = DSAvatar(initials: "JD", size: .lg, backgroundColor: .blue)
        XCTAssertNotNil(avatar)
    }

    func testInit_withImageURL() {
        let url = URL(string: "https://example.com/avatar.jpg")
        let avatar = DSAvatar(imageURL: url, size: .md)
        XCTAssertNotNil(avatar)
    }

    func testInit_withUser() {
        let user = SimpleAvatarUser(displayName: "John Doe")
        let avatar = DSAvatar(user: user, size: .lg)
        XCTAssertNotNil(avatar)
    }

    func testInit_defaultSize() {
        let avatar = DSAvatar(initials: "JD")
        XCTAssertNotNil(avatar)
    }

    // MARK: - Status Indicator Modifier Tests

    func testStatusIndicator_modifier() {
        let avatar = DSAvatar(initials: "JD", size: .lg)
            .statusIndicator(.online)
        XCTAssertNotNil(avatar)
    }

    func testStatusIndicator_withPosition() {
        let avatar = DSAvatar(initials: "JD", size: .lg)
            .statusIndicator(.busy, position: .topRight)
        XCTAssertNotNil(avatar)
    }
}

// MARK: - AvatarStatus Tests

final class AvatarStatusTests: XCTestCase {

    func testStatusColors() {
        XCTAssertEqual(AvatarStatus.online.color, .green)
        XCTAssertEqual(AvatarStatus.offline.color, .gray)
        XCTAssertEqual(AvatarStatus.busy.color, .red)
        XCTAssertEqual(AvatarStatus.away.color, .orange)
    }

    func testStatusAccessibilityLabels() {
        XCTAssertEqual(AvatarStatus.online.accessibilityLabel, "online")
        XCTAssertEqual(AvatarStatus.offline.accessibilityLabel, "offline")
        XCTAssertEqual(AvatarStatus.busy.accessibilityLabel, "busy")
        XCTAssertEqual(AvatarStatus.away.accessibilityLabel, "away")
    }
}

// MARK: - StatusIndicatorPosition Tests

final class StatusIndicatorPositionTests: XCTestCase {

    func testPositionAlignments() {
        XCTAssertEqual(StatusIndicatorPosition.topLeft.alignment, .topLeading)
        XCTAssertEqual(StatusIndicatorPosition.topRight.alignment, .topTrailing)
        XCTAssertEqual(StatusIndicatorPosition.bottomLeft.alignment, .bottomLeading)
        XCTAssertEqual(StatusIndicatorPosition.bottomRight.alignment, .bottomTrailing)
    }
}
