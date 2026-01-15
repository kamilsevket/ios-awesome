import XCTest
@testable import DesignSystem

final class DSSkeletonTests: XCTestCase {

    // MARK: - Shape Tests

    func testAllShapeCases() {
        let allCases = DSSkeletonShape.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.rectangle))
        XCTAssertTrue(allCases.contains(.roundedRectangle))
        XCTAssertTrue(allCases.contains(.circle))
        XCTAssertTrue(allCases.contains(.capsule))
    }

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        let skeleton = DSSkeleton()
        XCTAssertNotNil(skeleton)
    }

    func testRectangleShapeInitialization() {
        let skeleton = DSSkeleton(shape: .rectangle)
        XCTAssertNotNil(skeleton)
    }

    func testRoundedRectangleInitialization() {
        let skeleton = DSSkeleton(shape: .roundedRectangle, cornerRadius: 12)
        XCTAssertNotNil(skeleton)
    }

    func testCircleShapeInitialization() {
        let skeleton = DSSkeleton(shape: .circle)
        XCTAssertNotNil(skeleton)
    }

    func testCapsuleShapeInitialization() {
        let skeleton = DSSkeleton(shape: .capsule)
        XCTAssertNotNil(skeleton)
    }

    func testCustomColorInitialization() {
        let skeleton = DSSkeleton(shape: .rectangle, color: DSColors.secondary)
        XCTAssertNotNil(skeleton)
    }

    // MARK: - Skeleton Group Tests

    func testTextLinesPreset() {
        let group = DSSkeletonGroup(preset: .textLines(count: 3))
        XCTAssertNotNil(group)
    }

    func testAvatarWithTextPreset() {
        let group = DSSkeletonGroup(preset: .avatarWithText)
        XCTAssertNotNil(group)
    }

    func testCardPreset() {
        let group = DSSkeletonGroup(preset: .card)
        XCTAssertNotNil(group)
    }

    func testListItemPreset() {
        let group = DSSkeletonGroup(preset: .listItem)
        XCTAssertNotNil(group)
    }
}
