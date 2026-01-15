import XCTest
@testable import GestureUtilities

final class GestureStateTests: XCTestCase {

    // MARK: - ActiveGesture Tests

    func testActiveGestureEquality() {
        XCTAssertEqual(ActiveGesture.none, ActiveGesture.none)
        XCTAssertEqual(ActiveGesture.tap, ActiveGesture.tap)
        XCTAssertEqual(ActiveGesture.doubleTap, ActiveGesture.doubleTap)
        XCTAssertEqual(ActiveGesture.longPress, ActiveGesture.longPress)
        XCTAssertEqual(ActiveGesture.swipe(.left), ActiveGesture.swipe(.left))
        XCTAssertEqual(ActiveGesture.drag, ActiveGesture.drag)
        XCTAssertEqual(ActiveGesture.pinch, ActiveGesture.pinch)
        XCTAssertEqual(ActiveGesture.rotation, ActiveGesture.rotation)
        XCTAssertEqual(ActiveGesture.custom("test"), ActiveGesture.custom("test"))

        XCTAssertNotEqual(ActiveGesture.none, ActiveGesture.tap)
        XCTAssertNotEqual(ActiveGesture.swipe(.left), ActiveGesture.swipe(.right))
        XCTAssertNotEqual(ActiveGesture.custom("test1"), ActiveGesture.custom("test2"))
    }

    // MARK: - GestureCoordinator Tests

    func testGestureCoordinatorAllowsWhenNoActive() {
        XCTAssertTrue(GestureCoordinator.shouldAllowGesture(.tap, currentActive: .none))
        XCTAssertTrue(GestureCoordinator.shouldAllowGesture(.swipe(.left), currentActive: .none))
        XCTAssertTrue(GestureCoordinator.shouldAllowGesture(.pinch, currentActive: .none))
    }

    func testGestureCoordinatorExclusivePriority() {
        XCTAssertTrue(GestureCoordinator.shouldAllowGesture(.tap, currentActive: .longPress, priority: .exclusive))
        XCTAssertTrue(GestureCoordinator.shouldAllowGesture(.swipe(.left), currentActive: .drag, priority: .exclusive))
    }

    func testGestureCoordinatorConflictingGestures() {
        // Swipe and drag conflict
        XCTAssertFalse(GestureCoordinator.shouldAllowGesture(.swipe(.left), currentActive: .drag, priority: .normal))
        XCTAssertFalse(GestureCoordinator.shouldAllowGesture(.drag, currentActive: .swipe(.up), priority: .normal))

        // Pinch and long press conflict
        XCTAssertFalse(GestureCoordinator.shouldAllowGesture(.pinch, currentActive: .longPress, priority: .normal))
        XCTAssertFalse(GestureCoordinator.shouldAllowGesture(.longPress, currentActive: .pinch, priority: .normal))
    }

    func testGestureCoordinatorDoubleTapOverridesTap() {
        XCTAssertTrue(GestureCoordinator.shouldAllowGesture(.doubleTap, currentActive: .tap, priority: .normal))
    }

    func testGestureCoordinatorPriorityComparison() {
        XCTAssertLessThan(GestureCoordinator.Priority.low, GestureCoordinator.Priority.normal)
        XCTAssertLessThan(GestureCoordinator.Priority.normal, GestureCoordinator.Priority.high)
        XCTAssertLessThan(GestureCoordinator.Priority.high, GestureCoordinator.Priority.exclusive)
    }

    // MARK: - GestureVelocity Tests

    func testGestureVelocityMagnitude() {
        let velocity = GestureVelocity(x: 3, y: 4)
        XCTAssertEqual(velocity.magnitude, 5, accuracy: 0.001)
    }

    func testGestureVelocityAngle() {
        let velocityRight = GestureVelocity(x: 1, y: 0)
        XCTAssertEqual(velocityRight.angle, 0, accuracy: 0.001)

        let velocityUp = GestureVelocity(x: 0, y: -1)
        XCTAssertEqual(velocityUp.angle, -.pi / 2, accuracy: 0.001)
    }

    func testGestureVelocityFromTranslation() {
        let velocity = GestureVelocity.from(
            translation: CGSize(width: 100, height: 200),
            duration: 0.5
        )
        XCTAssertEqual(velocity.x, 200, accuracy: 0.001)
        XCTAssertEqual(velocity.y, 400, accuracy: 0.001)
    }

    func testGestureVelocityFromZeroDuration() {
        let velocity = GestureVelocity.from(
            translation: CGSize(width: 100, height: 200),
            duration: 0
        )
        XCTAssertEqual(velocity.x, 0)
        XCTAssertEqual(velocity.y, 0)
    }

    func testGestureVelocityZero() {
        let zero = GestureVelocity.zero
        XCTAssertEqual(zero.x, 0)
        XCTAssertEqual(zero.y, 0)
        XCTAssertEqual(zero.magnitude, 0)
    }

    // MARK: - GestureTracker Tests

    func testGestureTrackerBasicUsage() {
        var tracker = GestureTracker()

        tracker.start(at: CGPoint(x: 0, y: 0))
        tracker.update(at: CGPoint(x: 100, y: 100))

        let distance = tracker.totalDistance()
        XCTAssertGreaterThan(distance, 0)

        let duration = tracker.currentDuration()
        XCTAssertGreaterThanOrEqual(duration, 0)
    }

    func testGestureTrackerReset() {
        var tracker = GestureTracker()

        tracker.start(at: CGPoint(x: 0, y: 0))
        tracker.update(at: CGPoint(x: 100, y: 100))
        tracker.reset()

        XCTAssertEqual(tracker.totalDistance(), 0)
        XCTAssertEqual(tracker.currentDuration(), 0)
    }

    func testGestureTrackerEndReturnsVelocity() {
        var tracker = GestureTracker()

        tracker.start(at: CGPoint(x: 0, y: 0))
        tracker.update(at: CGPoint(x: 100, y: 0))

        let velocity = tracker.end()
        XCTAssertGreaterThanOrEqual(velocity.x, 0)
    }

    // MARK: - CombinedGestureState Tests

    func testCombinedGestureStateIdentity() {
        let identity = CombinedGestureState.identity
        XCTAssertEqual(identity.scale, 1.0)
        XCTAssertEqual(identity.rotation, .zero)
        XCTAssertEqual(identity.offset, .zero)
        XCTAssertFalse(identity.isActive)
    }

    func testCombinedGestureStateReset() {
        var state = CombinedGestureState(
            scale: 2.0,
            rotation: .degrees(45),
            offset: CGSize(width: 100, height: 100),
            isActive: true
        )

        state.reset()

        XCTAssertEqual(state.scale, 1.0)
        XCTAssertEqual(state.rotation, .zero)
        XCTAssertEqual(state.offset, .zero)
        XCTAssertFalse(state.isActive)
    }

    func testCombinedGestureStateEquality() {
        let state1 = CombinedGestureState(scale: 1.5, rotation: .degrees(30), offset: .zero, isActive: true)
        let state2 = CombinedGestureState(scale: 1.5, rotation: .degrees(30), offset: .zero, isActive: true)
        let state3 = CombinedGestureState(scale: 2.0, rotation: .degrees(30), offset: .zero, isActive: true)

        XCTAssertEqual(state1, state2)
        XCTAssertNotEqual(state1, state3)
    }
}
