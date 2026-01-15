import XCTest
@testable import GestureUtilities

final class DoubleTapGestureTests: XCTestCase {

    // MARK: - DoubleTapConfiguration Tests

    func testDoubleTapConfigurationDefault() {
        let config = DoubleTapConfiguration.default
        XCTAssertEqual(config.maxInterval, 0.3)
        XCTAssertEqual(config.maxDistance, 50)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .light)
    }

    func testDoubleTapConfigurationFast() {
        let config = DoubleTapConfiguration.fast
        XCTAssertEqual(config.maxInterval, 0.2)
        XCTAssertEqual(config.maxDistance, 30)
        XCTAssertTrue(config.hapticFeedback)
    }

    func testDoubleTapConfigurationRelaxed() {
        let config = DoubleTapConfiguration.relaxed
        XCTAssertEqual(config.maxInterval, 0.5)
        XCTAssertEqual(config.maxDistance, 80)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .medium)
    }

    func testDoubleTapConfigurationCustomInit() {
        let config = DoubleTapConfiguration(
            maxInterval: 0.4,
            maxDistance: 100,
            hapticFeedback: false,
            hapticStyle: .heavy
        )
        XCTAssertEqual(config.maxInterval, 0.4)
        XCTAssertEqual(config.maxDistance, 100)
        XCTAssertFalse(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .heavy)
    }

    // MARK: - MultiTapConfiguration Tests

    func testMultiTapConfigurationTaps() {
        let config = MultiTapConfiguration.taps(3)
        XCTAssertEqual(config.requiredTaps, 3)
        XCTAssertEqual(config.maxInterval, 0.3)
        XCTAssertEqual(config.maxDistance, 50)
        XCTAssertTrue(config.hapticFeedback)
    }

    func testMultiTapConfigurationMinimumTaps() {
        // Should clamp to minimum of 1
        let config = MultiTapConfiguration(requiredTaps: 0)
        XCTAssertEqual(config.requiredTaps, 1)

        let configNegative = MultiTapConfiguration(requiredTaps: -5)
        XCTAssertEqual(configNegative.requiredTaps, 1)
    }

    func testMultiTapConfigurationCustomInit() {
        let config = MultiTapConfiguration(
            requiredTaps: 5,
            maxInterval: 0.5,
            maxDistance: 100,
            hapticFeedback: false,
            hapticStyle: .rigid
        )
        XCTAssertEqual(config.requiredTaps, 5)
        XCTAssertEqual(config.maxInterval, 0.5)
        XCTAssertEqual(config.maxDistance, 100)
        XCTAssertFalse(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .rigid)
    }
}
