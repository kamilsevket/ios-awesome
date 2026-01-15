import SwiftUI

// MARK: - Design System Animation Namespace

public extension Animation {
    /// Design System animation presets
    struct ds {
        private init() {}
    }
}

// MARK: - Spring Presets

public extension Animation.ds {
    /// Spring presets for natural feeling animations
    struct spring {
        private init() {}

        /// Gentle spring - soft and slow, good for subtle movements
        /// Response: 0.5, Damping: 0.8
        public static var gentle: Animation {
            .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)
        }

        /// Snappy spring - quick and responsive, good for UI feedback
        /// Response: 0.3, Damping: 0.7
        public static var snappy: Animation {
            .spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
        }

        /// Bouncy spring - playful with overshoot, good for emphasis
        /// Response: 0.4, Damping: 0.5
        public static var bouncy: Animation {
            .spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)
        }

        /// Stiff spring - very quick, minimal bounce
        /// Response: 0.2, Damping: 0.9
        public static var stiff: Animation {
            .spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0)
        }

        /// Interactive spring - optimized for gesture-driven animations
        /// Response: 0.15, Damping: 0.86
        public static var interactive: Animation {
            .spring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25)
        }

        /// Custom spring animation
        public static func custom(response: Double, dampingFraction: Double, blendDuration: Double = 0) -> Animation {
            .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration)
        }
    }
}

// MARK: - Easing Presets

public extension Animation.ds {
    /// Standard easing animations
    struct easing {
        private init() {}

        /// Quick easing (200ms) - for micro-interactions
        public static var quick: Animation {
            .easeInOut(duration: 0.2)
        }

        /// Standard easing (300ms) - default for most animations
        public static var standard: Animation {
            .easeInOut(duration: 0.3)
        }

        /// Slow easing (500ms) - for emphasis or large movements
        public static var slow: Animation {
            .easeInOut(duration: 0.5)
        }

        /// Entrance animation - ease out for appearing elements
        public static var enter: Animation {
            .easeOut(duration: 0.3)
        }

        /// Exit animation - ease in for disappearing elements
        public static var exit: Animation {
            .easeIn(duration: 0.25)
        }

        /// Linear animation - constant speed
        public static func linear(duration: Double = 0.3) -> Animation {
            .linear(duration: duration)
        }
    }
}

// MARK: - Duration Presets

public extension Animation.ds {
    /// Duration constants for consistent timing
    struct duration {
        private init() {}

        /// Instant duration (100ms)
        public static let instant: Double = 0.1

        /// Quick duration (200ms)
        public static let quick: Double = 0.2

        /// Standard duration (300ms)
        public static let standard: Double = 0.3

        /// Moderate duration (400ms)
        public static let moderate: Double = 0.4

        /// Slow duration (500ms)
        public static let slow: Double = 0.5

        /// Very slow duration (700ms)
        public static let verySlow: Double = 0.7
    }
}

// MARK: - Contextual Animations

public extension Animation.ds {
    /// Button press animation
    static var buttonPress: Animation {
        spring.snappy
    }

    /// Toggle switch animation
    static var toggle: Animation {
        spring.snappy
    }

    /// Modal presentation animation
    static var modalPresent: Animation {
        spring.gentle
    }

    /// Modal dismissal animation
    static var modalDismiss: Animation {
        easing.exit
    }

    /// List item appearance animation
    static var listItem: Animation {
        spring.gentle
    }

    /// Card flip animation
    static var cardFlip: Animation {
        easing.standard
    }

    /// Refresh indicator animation
    static var refresh: Animation {
        .linear(duration: 1).repeatForever(autoreverses: false)
    }

    /// Pulse animation
    static var pulse: Animation {
        easing.slow.repeatForever(autoreverses: true)
    }

    /// Shake animation
    static var shake: Animation {
        spring.stiff
    }

    /// Tab switch animation
    static var tabSwitch: Animation {
        spring.snappy
    }

    /// Page transition animation
    static var pageTransition: Animation {
        spring.gentle
    }

    /// Keyboard appearance animation
    static var keyboard: Animation {
        spring.interactive
    }
}

// MARK: - Animation Modifiers

public extension Animation {
    /// Add delay to animation
    func dsDelay(_ delay: Double) -> Animation {
        self.delay(delay)
    }

    /// Repeat animation forever
    func dsRepeatForever(autoreverses: Bool = true) -> Animation {
        self.repeatForever(autoreverses: autoreverses)
    }

    /// Repeat animation a specific number of times
    func dsRepeat(count: Int, autoreverses: Bool = true) -> Animation {
        self.repeatCount(count, autoreverses: autoreverses)
    }

    /// Apply speed multiplier to animation
    func dsSpeed(_ speed: Double) -> Animation {
        self.speed(speed)
    }
}

// MARK: - Reduce Motion Support

public extension Animation.ds {
    /// Returns an animation that respects reduce motion setting
    /// Falls back to instant animation when reduce motion is enabled
    static func respectingReduceMotion(_ animation: Animation) -> Animation {
        if UIAccessibility.isReduceMotionEnabled {
            return .easeInOut(duration: duration.instant)
        }
        return animation
    }

    /// No animation - for when animation should be skipped
    static var none: Animation? {
        nil
    }
}

// MARK: - View Extension

public extension View {
    /// Apply a Design System animation with reduce motion support
    func dsAnimation(_ animation: Animation?, respectReduceMotion: Bool = true) -> some View {
        let finalAnimation: Animation?
        if respectReduceMotion && UIAccessibility.isReduceMotionEnabled {
            finalAnimation = .easeInOut(duration: Animation.ds.duration.instant)
        } else {
            finalAnimation = animation
        }
        return self.animation(finalAnimation, value: UUID())
    }

    /// Animate changes with a Design System animation
    @ViewBuilder
    func dsAnimated<V: Equatable>(_ animation: Animation?, value: V, respectReduceMotion: Bool = true) -> some View {
        let finalAnimation: Animation?
        if respectReduceMotion && UIAccessibility.isReduceMotionEnabled {
            finalAnimation = .easeInOut(duration: Animation.ds.duration.instant)
        } else {
            finalAnimation = animation
        }
        self.animation(finalAnimation, value: value)
    }
}
