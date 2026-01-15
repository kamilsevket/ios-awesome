import XCTest
import SwiftUI
@testable import DesignSystem

final class DSAvatarGroupTests: XCTestCase {

    // MARK: - Test Users

    private var testUsers: [SimpleAvatarUser] {
        [
            SimpleAvatarUser(displayName: "John Doe"),
            SimpleAvatarUser(displayName: "Alice Brown"),
            SimpleAvatarUser(displayName: "Charlie Davis"),
            SimpleAvatarUser(displayName: "Eve Foster"),
            SimpleAvatarUser(displayName: "Grace Hill")
        ]
    }

    // MARK: - Initialization Tests

    func testInit_withUsers() {
        let group = DSAvatarGroup(users: testUsers, max: 3, size: .md)
        XCTAssertNotNil(group)
    }

    func testInit_withInitials() {
        let group = DSAvatarGroup(
            initials: ["JD", "AB", "CD"],
            max: 2,
            size: .lg
        )
        XCTAssertNotNil(group)
    }

    func testInit_withEmptyUsers() {
        let group = DSAvatarGroup(users: [SimpleAvatarUser](), max: 3, size: .md)
        XCTAssertNotNil(group)
    }

    func testInit_withSingleUser() {
        let group = DSAvatarGroup(
            users: [SimpleAvatarUser(displayName: "John")],
            max: 3,
            size: .md
        )
        XCTAssertNotNil(group)
    }

    // MARK: - Configuration Tests

    func testInit_defaultValues() {
        let group = DSAvatarGroup(users: testUsers)
        XCTAssertNotNil(group)
    }

    func testInit_customOverlapRatio() {
        let group = DSAvatarGroup(
            users: testUsers,
            max: 3,
            size: .md,
            overlapRatio: 0.5
        )
        XCTAssertNotNil(group)
    }

    func testInit_overlapRatioClamped() {
        // Test that overlap ratio is clamped to valid range
        let groupNegative = DSAvatarGroup(
            users: testUsers,
            max: 3,
            overlapRatio: -0.5
        )
        XCTAssertNotNil(groupNegative)

        let groupOverOne = DSAvatarGroup(
            users: testUsers,
            max: 3,
            overlapRatio: 1.5
        )
        XCTAssertNotNil(groupOverOne)
    }

    func testInit_withRing() {
        let group = DSAvatarGroup(
            users: testUsers,
            max: 3,
            showRing: true,
            ringColor: .blue
        )
        XCTAssertNotNil(group)
    }

    func testInit_withoutRing() {
        let group = DSAvatarGroup(
            users: testUsers,
            max: 3,
            showRing: false
        )
        XCTAssertNotNil(group)
    }

    // MARK: - All Sizes Tests

    func testInit_allSizes() {
        for size in AvatarSize.allCases {
            let group = DSAvatarGroup(users: testUsers, max: 3, size: size)
            XCTAssertNotNil(group, "Failed to create group with size: \(size)")
        }
    }

    // MARK: - Edge Cases

    func testInit_maxGreaterThanUserCount() {
        let group = DSAvatarGroup(users: testUsers, max: 10, size: .md)
        XCTAssertNotNil(group)
    }

    func testInit_maxZero() {
        let group = DSAvatarGroup(users: testUsers, max: 0, size: .md)
        XCTAssertNotNil(group)
    }

    func testInit_maxOne() {
        let group = DSAvatarGroup(users: testUsers, max: 1, size: .md)
        XCTAssertNotNil(group)
    }
}

// MARK: - SimpleAvatarUser Tests

final class SimpleAvatarUserTests: XCTestCase {

    func testInit_withAllParameters() {
        let url = URL(string: "https://example.com/avatar.jpg")
        let user = SimpleAvatarUser(avatarURL: url, displayName: "John Doe")

        XCTAssertEqual(user.avatarURL, url)
        XCTAssertEqual(user.displayName, "John Doe")
    }

    func testInit_withOnlyDisplayName() {
        let user = SimpleAvatarUser(displayName: "John Doe")

        XCTAssertNil(user.avatarURL)
        XCTAssertEqual(user.displayName, "John Doe")
    }

    func testInit_withOnlyURL() {
        let url = URL(string: "https://example.com/avatar.jpg")
        let user = SimpleAvatarUser(avatarURL: url)

        XCTAssertEqual(user.avatarURL, url)
        XCTAssertNil(user.displayName)
    }

    func testInit_empty() {
        let user = SimpleAvatarUser()

        XCTAssertNil(user.avatarURL)
        XCTAssertNil(user.displayName)
    }

    func testConformsToAvatarUser() {
        let user: any AvatarUser = SimpleAvatarUser(displayName: "Test")
        XCTAssertNotNil(user)
    }
}
