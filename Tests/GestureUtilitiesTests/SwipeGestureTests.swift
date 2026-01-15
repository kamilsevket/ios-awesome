import XCTest
@testable import GestureUtilities

final class SwipeGestureTests: XCTestCase {

    // MARK: - SwipeDirection Tests

    func testSwipeDirectionOpposite() {
        XCTAssertEqual(SwipeDirection.left.opposite, .right)
        XCTAssertEqual(SwipeDirection.right.opposite, .left)
        XCTAssertEqual(SwipeDirection.up.opposite, .down)
        XCTAssertEqual(SwipeDirection.down.opposite, .up)
    }

    func testSwipeDirectionAllCases() {
        let allCases = SwipeDirection.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.left))
        XCTAssertTrue(allCases.contains(.right))
        XCTAssertTrue(allCases.contains(.up))
        XCTAssertTrue(allCases.contains(.down))
    }

    // MARK: - SwipeConfiguration Tests

    func testSwipeConfigurationDefault() {
        let config = SwipeConfiguration.default
        XCTAssertEqual(config.minimumDistance, 50)
        XCTAssertEqual(config.maximumAngle, 30)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .light)
    }

    func testSwipeConfigurationSensitive() {
        let config = SwipeConfiguration.sensitive
        XCTAssertEqual(config.minimumDistance, 25)
        XCTAssertEqual(config.maximumAngle, 45)
        XCTAssertTrue(config.hapticFeedback)
    }

    func testSwipeConfigurationStrict() {
        let config = SwipeConfiguration.strict
        XCTAssertEqual(config.minimumDistance, 80)
        XCTAssertEqual(config.maximumAngle, 20)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .medium)
    }

    func testSwipeConfigurationCustomInit() {
        let config = SwipeConfiguration(
            minimumDistance: 100,
            maximumAngle: 15,
            hapticFeedback: false,
            hapticStyle: .heavy
        )
        XCTAssertEqual(config.minimumDistance, 100)
        XCTAssertEqual(config.maximumAngle, 15)
        XCTAssertFalse(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .heavy)
    }
}
