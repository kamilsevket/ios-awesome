import XCTest
@testable import GestureUtilities

final class LongPressGestureTests: XCTestCase {

    // MARK: - LongPressConfiguration Tests

    func testLongPressConfigurationDefault() {
        let config = LongPressConfiguration.default
        XCTAssertEqual(config.minimumDuration, 0.5)
        XCTAssertEqual(config.maximumDistance, 10)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .medium)
        XCTAssertFalse(config.hapticOnStart)
    }

    func testLongPressConfigurationQuick() {
        let config = LongPressConfiguration.quick
        XCTAssertEqual(config.minimumDuration, 0.3)
        XCTAssertEqual(config.maximumDistance, 10)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .light)
        XCTAssertTrue(config.hapticOnStart)
    }

    func testLongPressConfigurationSlow() {
        let config = LongPressConfiguration.slow
        XCTAssertEqual(config.minimumDuration, 1.0)
        XCTAssertEqual(config.maximumDistance, 5)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .heavy)
        XCTAssertFalse(config.hapticOnStart)
    }

    func testLongPressConfigurationCustomInit() {
        let config = LongPressConfiguration(
            minimumDuration: 2.0,
            maximumDistance: 20,
            hapticFeedback: false,
            hapticStyle: .soft,
            hapticOnStart: true
        )
        XCTAssertEqual(config.minimumDuration, 2.0)
        XCTAssertEqual(config.maximumDistance, 20)
        XCTAssertFalse(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .soft)
        XCTAssertTrue(config.hapticOnStart)
    }

    // MARK: - LongPressState Tests

    func testLongPressStateEquality() {
        XCTAssertEqual(LongPressState.inactive, LongPressState.inactive)
        XCTAssertEqual(LongPressState.pressing, LongPressState.pressing)
        XCTAssertEqual(LongPressState.completed, LongPressState.completed)
        XCTAssertNotEqual(LongPressState.inactive, LongPressState.pressing)
        XCTAssertNotEqual(LongPressState.pressing, LongPressState.completed)
    }
}
