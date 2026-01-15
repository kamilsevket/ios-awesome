import SwiftUI

// MARK: - Animation Presets

/// A collection of predefined animation presets for the Design System
public enum DSAnimationPreset: String, CaseIterable {
    // MARK: - Fade Presets
    case fadeIn
    case fadeOut
    case fadeInOut

    // MARK: - Slide Presets
    case slideUp
    case slideDown
    case slideLeft
    case slideRight

    // MARK: - Scale Presets
    case scale
    case scaleUp
    case scaleDown
    case bounce

    // MARK: - Combined Presets
    case slideUpFade
    case slideDownFade
    case scaleUpFade
    case popIn
    case popOut

    // MARK: - Emphasis Presets
    case pulse
    case shake
    case wiggle
    case heartbeat

    // MARK: - Properties

    /// The default duration for this preset
    public var defaultDuration: Double {
        switch self {
        case .fadeIn, .fadeOut, .fadeInOut:
            return 0.3
        case .slideUp, .slideDown, .slideLeft, .slideRight:
            return 0.35
        case .scale, .scaleUp, .scaleDown:
            return 0.25
        case .bounce, .popIn, .popOut:
            return 0.4
        case .slideUpFade, .slideDownFade, .scaleUpFade:
            return 0.35
        case .pulse:
            return 1.0
        case .shake:
            return 0.6
        case .wiggle:
            return 0.5
        case .heartbeat:
            return 0.8
        }
    }

    /// The recommended animation curve for this preset
    public var animation: Animation {
        switch self {
        case .fadeIn:
            return .easeIn(duration: defaultDuration)
        case .fadeOut:
            return .easeOut(duration: defaultDuration)
        case .fadeInOut:
            return .easeInOut(duration: defaultDuration)
        case .slideUp, .slideDown, .slideLeft, .slideRight:
            return .spring(response: 0.35, dampingFraction: 0.8)
        case .scale, .scaleUp, .scaleDown:
            return .easeInOut(duration: defaultDuration)
        case .bounce:
            return .spring(response: 0.4, dampingFraction: 0.5)
        case .popIn:
            return .spring(response: 0.3, dampingFraction: 0.6)
        case .popOut:
            return .easeOut(duration: 0.2)
        case .slideUpFade, .slideDownFade, .scaleUpFade:
            return .spring(response: 0.35, dampingFraction: 0.75)
        case .pulse:
            return .easeInOut(duration: 0.5).repeatForever(autoreverses: true)
        case .shake, .wiggle:
            return .spring(response: 0.2, dampingFraction: 0.3)
        case .heartbeat:
            return .easeInOut(duration: 0.4)
        }
    }

    /// The transition for this preset
    public var transition: AnyTransition {
        switch self {
        case .fadeIn, .fadeOut, .fadeInOut:
            return .opacity
        case .slideUp:
            return .move(edge: .bottom).combined(with: .opacity)
        case .slideDown:
            return .move(edge: .top).combined(with: .opacity)
        case .slideLeft:
            return .move(edge: .trailing).combined(with: .opacity)
        case .slideRight:
            return .move(edge: .leading).combined(with: .opacity)
        case .scale, .scaleUp:
            return .scale(scale: 0.8).combined(with: .opacity)
        case .scaleDown:
            return .scale(scale: 1.2).combined(with: .opacity)
        case .bounce:
            return .scale(scale: 0.5).combined(with: .opacity)
        case .popIn:
            return .scale(scale: 0.5).combined(with: .opacity)
        case .popOut:
            return .scale(scale: 0.8).combined(with: .opacity)
        case .slideUpFade:
            return AnyTransition.ds.slideUpScale
        case .slideDownFade:
            return .move(edge: .top).combined(with: .opacity)
        case .scaleUpFade:
            return .scale(scale: 0.9).combined(with: .opacity)
        case .pulse, .shake, .wiggle, .heartbeat:
            return .opacity
        }
    }

    /// Whether this preset should be skipped when reduce motion is enabled
    public var shouldReduceMotion: Bool {
        switch self {
        case .fadeIn, .fadeOut, .fadeInOut:
            return false
        case .pulse, .shake, .wiggle, .heartbeat:
            return true
        default:
            return true
        }
    }
}

// MARK: - Preset Configuration

/// Configuration for applying animation presets
public struct DSAnimationPresetConfiguration {
    public let preset: DSAnimationPreset
    public var duration: Double?
    public var delay: Double
    public var respectReduceMotion: Bool

    public init(
        preset: DSAnimationPreset,
        duration: Double? = nil,
        delay: Double = 0,
        respectReduceMotion: Bool = true
    ) {
        self.preset = preset
        self.duration = duration
        self.delay = delay
        self.respectReduceMotion = respectReduceMotion
    }

    public var effectiveDuration: Double {
        duration ?? preset.defaultDuration
    }

    public var effectiveAnimation: Animation {
        var animation = preset.animation
        if delay > 0 {
            animation = animation.delay(delay)
        }
        return animation
    }
}

// MARK: - View Extension for Presets

public extension View {
    /// Apply an animation preset with optional configuration
    func dsAnimate(
        _ preset: DSAnimationPreset,
        duration: Double? = nil,
        delay: Double = 0,
        respectReduceMotion: Bool = true
    ) -> some View {
        let config = DSAnimationPresetConfiguration(
            preset: preset,
            duration: duration,
            delay: delay,
            respectReduceMotion: respectReduceMotion
        )
        return self.modifier(AnimationPresetModifier(configuration: config))
    }

    /// Apply a transition preset
    func dsTransition(_ preset: DSAnimationPreset, respectReduceMotion: Bool = true) -> some View {
        let transition: AnyTransition
        if respectReduceMotion && UIAccessibility.isReduceMotionEnabled && preset.shouldReduceMotion {
            transition = .opacity
        } else {
            transition = preset.transition
        }
        return self.transition(transition)
    }
}

// MARK: - Animation Preset Modifier

private struct AnimationPresetModifier: ViewModifier {
    let configuration: DSAnimationPresetConfiguration

    func body(content: Content) -> some View {
        if configuration.respectReduceMotion &&
           UIAccessibility.isReduceMotionEnabled &&
           configuration.preset.shouldReduceMotion {
            content.animation(.easeInOut(duration: 0.1), value: UUID())
        } else {
            content.animation(configuration.effectiveAnimation, value: UUID())
        }
    }
}

// MARK: - Spring Presets Enum

/// Spring animation presets with natural feeling values
public enum DSSpringPreset: String, CaseIterable {
    /// Gentle spring - soft and slow (response: 0.5, damping: 0.8)
    case gentle

    /// Snappy spring - quick and responsive (response: 0.3, damping: 0.7)
    case snappy

    /// Bouncy spring - playful with overshoot (response: 0.4, damping: 0.5)
    case bouncy

    /// Stiff spring - very quick, minimal bounce (response: 0.2, damping: 0.9)
    case stiff

    /// Interactive spring - for gesture-driven animations (response: 0.15, damping: 0.86)
    case interactive

    /// Smooth spring - medium speed, no bounce (response: 0.4, damping: 1.0)
    case smooth

    public var animation: Animation {
        switch self {
        case .gentle:
            return .spring(response: 0.5, dampingFraction: 0.8)
        case .snappy:
            return .spring(response: 0.3, dampingFraction: 0.7)
        case .bouncy:
            return .spring(response: 0.4, dampingFraction: 0.5)
        case .stiff:
            return .spring(response: 0.2, dampingFraction: 0.9)
        case .interactive:
            return .spring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25)
        case .smooth:
            return .spring(response: 0.4, dampingFraction: 1.0)
        }
    }

    public var response: Double {
        switch self {
        case .gentle: return 0.5
        case .snappy: return 0.3
        case .bouncy: return 0.4
        case .stiff: return 0.2
        case .interactive: return 0.15
        case .smooth: return 0.4
        }
    }

    public var dampingFraction: Double {
        switch self {
        case .gentle: return 0.8
        case .snappy: return 0.7
        case .bouncy: return 0.5
        case .stiff: return 0.9
        case .interactive: return 0.86
        case .smooth: return 1.0
        }
    }
}

// MARK: - Easing Presets Enum

/// Easing animation presets
public enum DSEasingPreset: String, CaseIterable {
    /// Instant - 100ms
    case instant

    /// Quick - 200ms
    case quick

    /// Standard - 300ms
    case standard

    /// Moderate - 400ms
    case moderate

    /// Slow - 500ms
    case slow

    public var duration: Double {
        switch self {
        case .instant: return 0.1
        case .quick: return 0.2
        case .standard: return 0.3
        case .moderate: return 0.4
        case .slow: return 0.5
        }
    }

    public var animation: Animation {
        .easeInOut(duration: duration)
    }

    public var easeIn: Animation {
        .easeIn(duration: duration)
    }

    public var easeOut: Animation {
        .easeOut(duration: duration)
    }
}
