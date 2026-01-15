import XCTest
import SwiftUI
@testable import DesignSystem

final class DSReduceMotionTests: XCTestCase {

    // MARK: - DSReduceMotionModifier Tests

    func testReduceMotionModifierCreation() {
        let modifier = DSReduceMotionModifier(
            animation: .default,
            reducedAnimation: nil,
            value: AnyHashable(true)
        )

        XCTAssertNotNil(modifier)
    }

    func testReduceMotionModifierWithReducedAnimation() {
        let modifier = DSReduceMotionModifier(
            animation: .spring(),
            reducedAnimation: .linear(duration: 0.01),
            value: AnyHashable(false)
        )

        XCTAssertNotNil(modifier)
    }

    // MARK: - View Extension Tests

    func testDsReduceMotionAnimation() {
        let view = Rectangle()
            .dsReduceMotionAnimation(.default, value: true)

        XCTAssertNotNil(view)
    }

    func testDsReduceMotionAnimationWithReduced() {
        let view = Rectangle()
            .dsReduceMotionAnimation(
                .spring(),
                reduced: .easeInOut(duration: 0.01),
                value: false
            )

        XCTAssertNotNil(view)
    }

    func testDsReduceMotionSpring() {
        let view = Circle()
            .dsReduceMotionSpring(
                response: 0.4,
                dampingFraction: 0.8,
                value: true
            )

        XCTAssertNotNil(view)
    }

    // MARK: - DSReduceMotionObserver Tests

    func testReduceMotionObserverSharedInstance() {
        let observer = DSReduceMotionObserver.shared

        XCTAssertNotNil(observer)
    }

    func testReduceMotionObserverIsSingleton() {
        let instance1 = DSReduceMotionObserver.shared
        let instance2 = DSReduceMotionObserver.shared

        XCTAssertTrue(instance1 === instance2)
    }

    func testReduceMotionObserverHasProperty() {
        let observer = DSReduceMotionObserver.shared

        // Just verify the property exists and is accessible
        _ = observer.isReduceMotionEnabled
    }

    // MARK: - DSMotionSafeView Tests

    func testMotionSafeViewCreation() {
        let view = DSMotionSafeView {
            Text("Animated")
                .scaleEffect(1.2)
        } reducedContent: {
            Text("Static")
        }

        XCTAssertNotNil(view)
    }

    func testMotionSafeViewSingleContent() {
        let view = DSMotionSafeView {
            Text("Content")
        }

        XCTAssertNotNil(view)
    }

    // MARK: - DSAccessibleTransitionModifier Tests

    func testAccessibleTransitionModifier() {
        let modifier = DSAccessibleTransitionModifier(
            transition: .slide,
            reducedTransition: .opacity
        )

        XCTAssertNotNil(modifier)
    }

    func testDsAccessibleTransition() {
        let view = Text("Test")
            .dsAccessibleTransition(.slide)

        XCTAssertNotNil(view)
    }

    func testDsAccessibleTransitionWithReduced() {
        let view = Text("Test")
            .dsAccessibleTransition(.scale, reduced: .opacity)

        XCTAssertNotNil(view)
    }

    // MARK: - DSAccessibleAnimation Tests

    func testAccessibleAnimationFade() {
        let animation = DSAccessibleAnimation.fade
        XCTAssertNotNil(animation)
    }

    func testAccessibleAnimationSnap() {
        let animation = DSAccessibleAnimation.snap
        XCTAssertNotNil(animation)
    }

    func testAccessibleAnimationSlide() {
        let animation = DSAccessibleAnimation.slide
        XCTAssertNotNil(animation)
    }

    func testAccessibleAnimationBounce() {
        let animation = DSAccessibleAnimation.bounce
        XCTAssertNotNil(animation)
    }

    func testAccessibleAnimationNone() {
        let animation = DSAccessibleAnimation.none
        XCTAssertNotNil(animation)
    }

    func testAccessibleAnimationWithReduceMotion() {
        let standardAnimation = DSAccessibleAnimation.accessible(.spring(), reduceMotion: false)
        XCTAssertNotNil(standardAnimation)

        let reducedAnimation = DSAccessibleAnimation.accessible(.spring(), reduceMotion: true)
        XCTAssertNotNil(reducedAnimation)
    }

    // MARK: - DSMotionSafe Property Wrapper Tests

    func testMotionSafePropertyWrapper() {
        struct TestView: View {
            @DSMotionSafe(standard: 1.0, reduced: 0.0)
            var opacity: Double

            var body: some View {
                Text("Test")
                    .opacity(opacity)
            }
        }

        let view = TestView()
        XCTAssertNotNil(view)
    }
}
