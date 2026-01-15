import XCTest
import SwiftUI
@testable import DesignSystem

final class AnimationTests: XCTestCase {

    // MARK: - Animation Duration Tests

    func testDurationPresetsValues() {
        XCTAssertEqual(Animation.ds.duration.instant, 0.1, accuracy: 0.001)
        XCTAssertEqual(Animation.ds.duration.quick, 0.2, accuracy: 0.001)
        XCTAssertEqual(Animation.ds.duration.standard, 0.3, accuracy: 0.001)
        XCTAssertEqual(Animation.ds.duration.moderate, 0.4, accuracy: 0.001)
        XCTAssertEqual(Animation.ds.duration.slow, 0.5, accuracy: 0.001)
        XCTAssertEqual(Animation.ds.duration.verySlow, 0.7, accuracy: 0.001)
    }

    // MARK: - Animation Preset Tests

    func testAnimationPresetDefaultDurations() {
        XCTAssertEqual(DSAnimationPreset.fadeIn.defaultDuration, 0.3, accuracy: 0.001)
        XCTAssertEqual(DSAnimationPreset.fadeOut.defaultDuration, 0.3, accuracy: 0.001)
        XCTAssertEqual(DSAnimationPreset.slideUp.defaultDuration, 0.35, accuracy: 0.001)
        XCTAssertEqual(DSAnimationPreset.scale.defaultDuration, 0.25, accuracy: 0.001)
        XCTAssertEqual(DSAnimationPreset.bounce.defaultDuration, 0.4, accuracy: 0.001)
        XCTAssertEqual(DSAnimationPreset.shake.defaultDuration, 0.6, accuracy: 0.001)
        XCTAssertEqual(DSAnimationPreset.pulse.defaultDuration, 1.0, accuracy: 0.001)
    }

    func testAnimationPresetReduceMotionFlags() {
        // Fade animations should not be reduced
        XCTAssertFalse(DSAnimationPreset.fadeIn.shouldReduceMotion)
        XCTAssertFalse(DSAnimationPreset.fadeOut.shouldReduceMotion)
        XCTAssertFalse(DSAnimationPreset.fadeInOut.shouldReduceMotion)

        // Emphasis animations should be reduced
        XCTAssertTrue(DSAnimationPreset.pulse.shouldReduceMotion)
        XCTAssertTrue(DSAnimationPreset.shake.shouldReduceMotion)
        XCTAssertTrue(DSAnimationPreset.wiggle.shouldReduceMotion)
        XCTAssertTrue(DSAnimationPreset.heartbeat.shouldReduceMotion)

        // Movement animations should be reduced
        XCTAssertTrue(DSAnimationPreset.slideUp.shouldReduceMotion)
        XCTAssertTrue(DSAnimationPreset.slideDown.shouldReduceMotion)
        XCTAssertTrue(DSAnimationPreset.scale.shouldReduceMotion)
        XCTAssertTrue(DSAnimationPreset.bounce.shouldReduceMotion)
    }

    func testAllAnimationPresetsHaveAnimations() {
        for preset in DSAnimationPreset.allCases {
            // Just verify the animation property doesn't crash
            _ = preset.animation
        }
    }

    func testAllAnimationPresetsHaveTransitions() {
        for preset in DSAnimationPreset.allCases {
            // Just verify the transition property doesn't crash
            _ = preset.transition
        }
    }

    // MARK: - Spring Preset Tests

    func testSpringPresetValues() {
        XCTAssertEqual(DSSpringPreset.gentle.response, 0.5, accuracy: 0.001)
        XCTAssertEqual(DSSpringPreset.gentle.dampingFraction, 0.8, accuracy: 0.001)

        XCTAssertEqual(DSSpringPreset.snappy.response, 0.3, accuracy: 0.001)
        XCTAssertEqual(DSSpringPreset.snappy.dampingFraction, 0.7, accuracy: 0.001)

        XCTAssertEqual(DSSpringPreset.bouncy.response, 0.4, accuracy: 0.001)
        XCTAssertEqual(DSSpringPreset.bouncy.dampingFraction, 0.5, accuracy: 0.001)

        XCTAssertEqual(DSSpringPreset.stiff.response, 0.2, accuracy: 0.001)
        XCTAssertEqual(DSSpringPreset.stiff.dampingFraction, 0.9, accuracy: 0.001)

        XCTAssertEqual(DSSpringPreset.interactive.response, 0.15, accuracy: 0.001)
        XCTAssertEqual(DSSpringPreset.interactive.dampingFraction, 0.86, accuracy: 0.001)

        XCTAssertEqual(DSSpringPreset.smooth.response, 0.4, accuracy: 0.001)
        XCTAssertEqual(DSSpringPreset.smooth.dampingFraction, 1.0, accuracy: 0.001)
    }

    func testAllSpringPresetsHaveAnimations() {
        for preset in DSSpringPreset.allCases {
            // Just verify the animation property doesn't crash
            _ = preset.animation
        }
    }

    // MARK: - Easing Preset Tests

    func testEasingPresetDurations() {
        XCTAssertEqual(DSEasingPreset.instant.duration, 0.1, accuracy: 0.001)
        XCTAssertEqual(DSEasingPreset.quick.duration, 0.2, accuracy: 0.001)
        XCTAssertEqual(DSEasingPreset.standard.duration, 0.3, accuracy: 0.001)
        XCTAssertEqual(DSEasingPreset.moderate.duration, 0.4, accuracy: 0.001)
        XCTAssertEqual(DSEasingPreset.slow.duration, 0.5, accuracy: 0.001)
    }

    func testAllEasingPresetsHaveAnimations() {
        for preset in DSEasingPreset.allCases {
            _ = preset.animation
            _ = preset.easeIn
            _ = preset.easeOut
        }
    }

    // MARK: - Keyframe Preset Tests

    func testShakePresetValues() {
        XCTAssertEqual(DSKeyframePresets.shakeOffsets.count, 10)
        XCTAssertEqual(DSKeyframePresets.shakeOffsets.first, 0)
        XCTAssertEqual(DSKeyframePresets.shakeOffsets.last, 0)
        XCTAssertEqual(DSKeyframePresets.shakeDuration, 0.6, accuracy: 0.001)
    }

    func testBouncePresetValues() {
        XCTAssertEqual(DSKeyframePresets.bounceScales.count, 7)
        XCTAssertEqual(DSKeyframePresets.bounceScales.first, 1)
        XCTAssertEqual(DSKeyframePresets.bounceScales.last, 1)
        XCTAssertEqual(DSKeyframePresets.bounceDuration, 0.6, accuracy: 0.001)
    }

    func testPulsePresetValues() {
        XCTAssertEqual(DSKeyframePresets.pulseScales.count, 5)
        XCTAssertEqual(DSKeyframePresets.pulseOpacities.count, 5)
        XCTAssertEqual(DSKeyframePresets.pulseDuration, 1.0, accuracy: 0.001)
    }

    func testWigglePresetValues() {
        XCTAssertEqual(DSKeyframePresets.wiggleAngles.count, 10)
        XCTAssertEqual(DSKeyframePresets.wiggleAngles.first, 0)
        XCTAssertEqual(DSKeyframePresets.wiggleAngles.last, 0)
        XCTAssertEqual(DSKeyframePresets.wiggleDuration, 0.5, accuracy: 0.001)
    }

    func testHeartbeatPresetValues() {
        XCTAssertEqual(DSKeyframePresets.heartbeatScales.count, 5)
        XCTAssertEqual(DSKeyframePresets.heartbeatScales.first, 1)
        XCTAssertEqual(DSKeyframePresets.heartbeatScales.last, 1)
        XCTAssertEqual(DSKeyframePresets.heartbeatDuration, 0.8, accuracy: 0.001)
    }

    // MARK: - Lottie Configuration Tests

    func testLottieLoopModeEquality() {
        XCTAssertEqual(DSLottieLoopMode.playOnce, DSLottieLoopMode.playOnce)
        XCTAssertEqual(DSLottieLoopMode.loop, DSLottieLoopMode.loop)
        XCTAssertEqual(DSLottieLoopMode.autoReverse, DSLottieLoopMode.autoReverse)
        XCTAssertNotEqual(DSLottieLoopMode.playOnce, DSLottieLoopMode.loop)
    }

    func testLottieContentModeMapping() {
        XCTAssertEqual(DSLottieContentMode.scaleAspectFit.swiftUIContentMode, .fit)
        XCTAssertEqual(DSLottieContentMode.scaleAspectFill.swiftUIContentMode, .fill)
        XCTAssertEqual(DSLottieContentMode.scaleToFill.swiftUIContentMode, .fill)
    }

    func testLottieConfigurationDefaults() {
        let config = DSLottieConfiguration(source: .name("test"))

        XCTAssertEqual(config.loopMode, .playOnce)
        XCTAssertEqual(config.speed, 1.0, accuracy: 0.001)
        XCTAssertEqual(config.contentMode, .scaleAspectFit)
        XCTAssertTrue(config.autoPlay)
        XCTAssertTrue(config.respectReduceMotion)
    }

    func testLottieAnimationStateEquality() {
        XCTAssertEqual(DSLottieAnimationState.loading, DSLottieAnimationState.loading)
        XCTAssertEqual(DSLottieAnimationState.playing, DSLottieAnimationState.playing)
        XCTAssertEqual(DSLottieAnimationState.paused, DSLottieAnimationState.paused)
        XCTAssertEqual(DSLottieAnimationState.stopped, DSLottieAnimationState.stopped)
        XCTAssertEqual(DSLottieAnimationState.completed, DSLottieAnimationState.completed)
        XCTAssertNotEqual(DSLottieAnimationState.loading, DSLottieAnimationState.playing)
    }

    // MARK: - Animation Preset Configuration Tests

    func testAnimationPresetConfigurationDefaults() {
        let config = DSAnimationPresetConfiguration(preset: .fadeIn)

        XCTAssertEqual(config.preset, .fadeIn)
        XCTAssertNil(config.duration)
        XCTAssertEqual(config.delay, 0, accuracy: 0.001)
        XCTAssertTrue(config.respectReduceMotion)
    }

    func testAnimationPresetConfigurationEffectiveDuration() {
        let defaultConfig = DSAnimationPresetConfiguration(preset: .fadeIn)
        XCTAssertEqual(defaultConfig.effectiveDuration, 0.3, accuracy: 0.001)

        let customConfig = DSAnimationPresetConfiguration(preset: .fadeIn, duration: 0.5)
        XCTAssertEqual(customConfig.effectiveDuration, 0.5, accuracy: 0.001)
    }

    // MARK: - Animation State Manager Tests

    @MainActor
    func testAnimationStateManagerInitialState() {
        let manager = DSAnimationStateManager()
        XCTAssertFalse(manager.isAnimating)
    }

    @MainActor
    func testAnimationStateManagerTriggerOnce() {
        let manager = DSAnimationStateManager()

        manager.triggerOnce()

        XCTAssertTrue(manager.isAnimating)
    }

    @MainActor
    func testAnimationStateManagerReset() {
        let manager = DSAnimationStateManager()
        manager.triggerOnce()

        manager.reset(animated: false)

        XCTAssertFalse(manager.isAnimating)
    }
}

// MARK: - View Modifier Tests

final class AnimationViewModifierTests: XCTestCase {

    func testShakeModifierCreation() {
        let modifier = ShakeModifier(isShaking: false, intensity: 1.0)
        XCTAssertNotNil(modifier)
    }

    func testBounceAnimationModifierCreation() {
        let modifier = BounceAnimationModifier(isBouncing: false, intensity: 1.0)
        XCTAssertNotNil(modifier)
    }

    func testPulseAnimationModifierCreation() {
        let modifier = PulseAnimationModifier(isPulsing: false)
        XCTAssertNotNil(modifier)
    }

    func testWiggleModifierCreation() {
        let modifier = WiggleModifier(isWiggling: false)
        XCTAssertNotNil(modifier)
    }

    func testHeartbeatModifierCreation() {
        let modifier = HeartbeatModifier(isBeating: false, continuous: false)
        XCTAssertNotNil(modifier)

        let continuousModifier = HeartbeatModifier(isBeating: true, continuous: true)
        XCTAssertNotNil(continuousModifier)
    }
}
