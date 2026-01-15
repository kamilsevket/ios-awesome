import XCTest
import SwiftUI
@testable import IOSComponents

final class AvatarTests: XCTestCase {

    // MARK: - Avatar Size Tests

    func testSmallSize_HasCorrectValue() {
        XCTAssertEqual(Avatar.AvatarSize.small.rawValue, 32)
    }

    func testMediumSize_HasCorrectValue() {
        XCTAssertEqual(Avatar.AvatarSize.medium.rawValue, 48)
    }

    func testLargeSize_HasCorrectValue() {
        XCTAssertEqual(Avatar.AvatarSize.large.rawValue, 64)
    }

    func testExtraLargeSize_HasCorrectValue() {
        XCTAssertEqual(Avatar.AvatarSize.extraLarge.rawValue, 96)
    }

    // MARK: - Avatar Size Font Tests

    func testSmallSize_HasCorrectFontSize() {
        XCTAssertEqual(Avatar.AvatarSize.small.fontSize, 12)
    }

    func testMediumSize_HasCorrectFontSize() {
        XCTAssertEqual(Avatar.AvatarSize.medium.fontSize, 18)
    }

    func testLargeSize_HasCorrectFontSize() {
        XCTAssertEqual(Avatar.AvatarSize.large.fontSize, 24)
    }

    func testExtraLargeSize_HasCorrectFontSize() {
        XCTAssertEqual(Avatar.AvatarSize.extraLarge.fontSize, 36)
    }

    // MARK: - Avatar Shape Tests

    func testCircleShape_HasInfiniteCornerRadius() {
        XCTAssertEqual(Avatar.AvatarShape.circle.cornerRadius, .infinity)
    }

    func testRoundedShape_HasCorrectCornerRadius() {
        XCTAssertEqual(Avatar.AvatarShape.rounded.cornerRadius, 8)
    }

    func testSquareShape_HasZeroCornerRadius() {
        XCTAssertEqual(Avatar.AvatarShape.square.cornerRadius, 0)
    }

    // MARK: - Avatar Initialization Tests

    func testAvatarWithInitials_CreatesView() {
        let avatar = Avatar(source: .initials("JD"))
        XCTAssertNotNil(avatar)
    }

    func testAvatarWithSystemIcon_CreatesView() {
        let avatar = Avatar(source: .systemIcon("person.fill"))
        XCTAssertNotNil(avatar)
    }

    func testAvatarWithURL_CreatesView() {
        let url = URL(string: "https://example.com/avatar.png")!
        let avatar = Avatar(source: .url(url))
        XCTAssertNotNil(avatar)
    }

    func testAvatarWithImage_CreatesView() {
        let avatar = Avatar(source: .image(Image(systemName: "person")))
        XCTAssertNotNil(avatar)
    }

    func testAvatarWithCustomSize_CreatesView() {
        let avatar = Avatar(source: .initials("JD"), size: .large)
        XCTAssertNotNil(avatar)
    }

    func testAvatarWithCustomShape_CreatesView() {
        let avatar = Avatar(source: .initials("JD"), shape: .rounded)
        XCTAssertNotNil(avatar)
    }

    func testAvatarWithAccessibilityText_CreatesView() {
        let avatar = Avatar(source: .initials("JD"), accessibilityText: "John Doe avatar")
        XCTAssertNotNil(avatar)
    }

    // MARK: - Avatar Body Tests

    func testAvatarBody_ReturnsView() {
        let avatar = Avatar(source: .initials("JD"))
        let body = avatar.body
        XCTAssertNotNil(body)
    }
}
