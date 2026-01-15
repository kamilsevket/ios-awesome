import XCTest
import SwiftUI
@testable import DesignSystem

@MainActor
final class DSAutoScrollTests: XCTestCase {

    // MARK: - DSAutoScrollState Tests

    func testAutoScrollStateInitialization() {
        var tickCount = 0
        let state = DSAutoScrollState(
            interval: 2.0,
            pauseOnInteraction: true,
            resumeDelay: 1.5,
            onTick: { tickCount += 1 }
        )

        XCTAssertEqual(state.interval, 2.0)
        XCTAssertTrue(state.pauseOnInteraction)
        XCTAssertEqual(state.resumeDelay, 1.5)
        XCTAssertFalse(state.isActive)
        XCTAssertFalse(state.isPaused)
        XCTAssertEqual(tickCount, 0)
    }

    func testAutoScrollStateStart() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.start()

        XCTAssertTrue(state.isActive)
        XCTAssertFalse(state.isPaused)

        state.stop()
    }

    func testAutoScrollStateStop() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.start()
        state.stop()

        XCTAssertFalse(state.isActive)
        XCTAssertFalse(state.isPaused)
    }

    func testAutoScrollStatePause() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.start()
        state.pause()

        XCTAssertTrue(state.isActive)
        XCTAssertTrue(state.isPaused)

        state.stop()
    }

    func testAutoScrollStateResume() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.start()
        state.pause()
        state.resume()

        XCTAssertTrue(state.isActive)
        XCTAssertFalse(state.isPaused)

        state.stop()
    }

    func testAutoScrollStateInteractionHandling() {
        let state = DSAutoScrollState(
            interval: 1.0,
            pauseOnInteraction: true,
            resumeDelay: 0.5,
            onTick: { }
        )

        state.start()
        state.onInteractionStart()

        XCTAssertTrue(state.isActive)
        XCTAssertTrue(state.isPaused)

        state.stop()
    }

    func testAutoScrollStateInteractionEndSchedulesResume() {
        let state = DSAutoScrollState(
            interval: 1.0,
            pauseOnInteraction: true,
            resumeDelay: 0.1,
            onTick: { }
        )

        state.start()
        state.onInteractionStart()
        state.onInteractionEnd()

        XCTAssertTrue(state.isPaused)

        state.stop()
    }

    func testAutoScrollStateNoPauseWhenDisabled() {
        let state = DSAutoScrollState(
            interval: 1.0,
            pauseOnInteraction: false,
            onTick: { }
        )

        state.start()
        state.onInteractionStart()

        XCTAssertTrue(state.isActive)
        XCTAssertFalse(state.isPaused)

        state.stop()
    }

    func testAutoScrollStateMultipleStartCalls() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.start()
        state.start()
        state.start()

        XCTAssertTrue(state.isActive)

        state.stop()
    }

    func testAutoScrollStateStopWithoutStart() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.stop()

        XCTAssertFalse(state.isActive)
        XCTAssertFalse(state.isPaused)
    }

    func testAutoScrollStatePauseWithoutStart() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.pause()

        XCTAssertFalse(state.isActive)
        XCTAssertFalse(state.isPaused)
    }

    func testAutoScrollStateResumeWithoutPause() {
        let state = DSAutoScrollState(
            interval: 1.0,
            onTick: { }
        )

        state.start()
        state.resume()

        XCTAssertTrue(state.isActive)
        XCTAssertFalse(state.isPaused)

        state.stop()
    }

    // MARK: - View Modifier Tests

    func testDsAutoScrollModifier() {
        var tickCount = 0

        let view = Text("Test")
            .dsAutoScroll(
                interval: 1.0,
                pauseOnInteraction: true,
                resumeDelay: 2.0,
                reduceMotion: false
            ) {
                tickCount += 1
            }

        XCTAssertNotNil(view)
    }

    func testDsAutoScrollModifierWithReduceMotion() {
        let view = Text("Test")
            .dsAutoScroll(
                interval: 1.0,
                reduceMotion: true
            ) { }

        XCTAssertNotNil(view)
    }

    func testDsAutoScrollGestureModifier() {
        let view = Text("Test")
            .dsAutoScrollGesture()

        XCTAssertNotNil(view)
    }
}
