import XCTest
@testable import GestureUtilities

final class PinchToZoomTests: XCTestCase {

    // MARK: - PinchConfiguration Tests

    func testPinchConfigurationDefault() {
        let config = PinchConfiguration.default
        XCTAssertEqual(config.minScale, 0.5)
        XCTAssertEqual(config.maxScale, 4.0)
        XCTAssertTrue(config.animated)
        XCTAssertEqual(config.animationDuration, 0.2)
        XCTAssertTrue(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .light)
        XCTAssertTrue(config.snapToIdentity)
        XCTAssertEqual(config.snapThreshold, 0.1)
    }

    func testPinchConfigurationPhotoViewer() {
        let config = PinchConfiguration.photoViewer
        XCTAssertEqual(config.minScale, 0.25)
        XCTAssertEqual(config.maxScale, 10.0)
        XCTAssertTrue(config.animated)
        XCTAssertEqual(config.animationDuration, 0.25)
        XCTAssertTrue(config.snapToIdentity)
        XCTAssertEqual(config.snapThreshold, 0.15)
    }

    func testPinchConfigurationRestricted() {
        let config = PinchConfiguration.restricted
        XCTAssertEqual(config.minScale, 0.8)
        XCTAssertEqual(config.maxScale, 2.0)
        XCTAssertTrue(config.animated)
        XCTAssertEqual(config.animationDuration, 0.15)
        XCTAssertFalse(config.snapToIdentity)
        XCTAssertEqual(config.snapThreshold, 0)
    }

    func testPinchConfigurationCustomInit() {
        let config = PinchConfiguration(
            minScale: 0.1,
            maxScale: 20.0,
            animated: false,
            animationDuration: 0.5,
            hapticFeedback: false,
            hapticStyle: .heavy,
            snapToIdentity: false,
            snapThreshold: 0.05
        )
        XCTAssertEqual(config.minScale, 0.1)
        XCTAssertEqual(config.maxScale, 20.0)
        XCTAssertFalse(config.animated)
        XCTAssertEqual(config.animationDuration, 0.5)
        XCTAssertFalse(config.hapticFeedback)
        XCTAssertEqual(config.hapticStyle, .heavy)
        XCTAssertFalse(config.snapToIdentity)
        XCTAssertEqual(config.snapThreshold, 0.05)
    }

    // MARK: - PinchState Tests

    func testPinchStateEquality() {
        XCTAssertEqual(PinchState.inactive, PinchState.inactive)
        XCTAssertEqual(PinchState.zooming(scale: 1.5), PinchState.zooming(scale: 1.5))
        XCTAssertEqual(PinchState.ended(finalScale: 2.0), PinchState.ended(finalScale: 2.0))
        XCTAssertNotEqual(PinchState.inactive, PinchState.zooming(scale: 1.0))
        XCTAssertNotEqual(PinchState.zooming(scale: 1.5), PinchState.zooming(scale: 2.0))
    }
}
