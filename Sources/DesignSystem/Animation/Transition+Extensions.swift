import SwiftUI

// MARK: - Design System Transition Namespace

public extension AnyTransition {
    /// Design System transition presets
    struct ds {
        private init() {}
    }
}

// MARK: - Fade Transitions

public extension AnyTransition.ds {
    /// Fade in transition with configurable duration
    static var fadeIn: AnyTransition {
        .opacity.animation(.easeIn(duration: 0.3))
    }

    /// Fade out transition with configurable duration
    static var fadeOut: AnyTransition {
        .opacity.animation(.easeOut(duration: 0.3))
    }

    /// Quick fade transition (150ms)
    static var fadeQuick: AnyTransition {
        .opacity.animation(.easeInOut(duration: 0.15))
    }

    /// Slow fade transition (500ms)
    static var fadeSlow: AnyTransition {
        .opacity.animation(.easeInOut(duration: 0.5))
    }
}

// MARK: - Slide Transitions

public extension AnyTransition.ds {
    /// Slide up from bottom with fade
    static var slideUp: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }

    /// Slide down from top with fade
    static var slideDown: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }

    /// Slide in from left with fade
    static var slideLeft: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .move(edge: .trailing).combined(with: .opacity)
        )
    }

    /// Slide in from right with fade
    static var slideRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }

    /// Slide up with custom offset
    static func slideUp(offset: CGFloat = 50) -> AnyTransition {
        .modifier(
            active: SlideModifier(offset: CGSize(width: 0, height: offset), opacity: 0),
            identity: SlideModifier(offset: .zero, opacity: 1)
        )
    }

    /// Slide down with custom offset
    static func slideDown(offset: CGFloat = 50) -> AnyTransition {
        .modifier(
            active: SlideModifier(offset: CGSize(width: 0, height: -offset), opacity: 0),
            identity: SlideModifier(offset: .zero, opacity: 1)
        )
    }
}

// MARK: - Scale Transitions

public extension AnyTransition.ds {
    /// Scale transition with fade
    static var scale: AnyTransition {
        .scale(scale: 0.8).combined(with: .opacity)
    }

    /// Scale from zero with fade
    static var scaleFromZero: AnyTransition {
        .scale(scale: 0).combined(with: .opacity)
    }

    /// Scale with custom scale factor
    static func scale(factor: CGFloat) -> AnyTransition {
        .scale(scale: factor).combined(with: .opacity)
    }

    /// Bounce scale transition
    static var bounce: AnyTransition {
        .modifier(
            active: BounceModifier(scale: 0.5, opacity: 0),
            identity: BounceModifier(scale: 1, opacity: 1)
        )
    }

    /// Pop in transition (scale from small with spring)
    static var popIn: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.5).combined(with: .opacity).animation(.spring(response: 0.3, dampingFraction: 0.6)),
            removal: .scale(scale: 0.8).combined(with: .opacity).animation(.easeOut(duration: 0.2))
        )
    }
}

// MARK: - Combined Transitions

public extension AnyTransition.ds {
    /// Slide up with scale effect
    static var slideUpScale: AnyTransition {
        .modifier(
            active: SlideScaleModifier(offset: CGSize(width: 0, height: 30), scale: 0.9, opacity: 0),
            identity: SlideScaleModifier(offset: .zero, scale: 1, opacity: 1)
        )
    }

    /// Card presentation transition
    static var card: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }

    /// Modal presentation transition
    static var modal: AnyTransition {
        .modifier(
            active: ModalTransitionModifier(offset: 100, opacity: 0, scale: 0.95),
            identity: ModalTransitionModifier(offset: 0, opacity: 1, scale: 1)
        )
    }

    /// Toast transition (slide from top)
    static var toast: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        )
    }

    /// Snackbar transition (slide from bottom)
    static var snackbar: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .bottom).combined(with: .opacity)
        )
    }
}

// MARK: - Transition Modifiers

private struct SlideModifier: ViewModifier {
    let offset: CGSize
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .offset(offset)
            .opacity(opacity)
    }
}

private struct BounceModifier: ViewModifier {
    let scale: CGFloat
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
    }
}

private struct SlideScaleModifier: ViewModifier {
    let offset: CGSize
    let scale: CGFloat
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .offset(offset)
            .scaleEffect(scale)
            .opacity(opacity)
    }
}

private struct ModalTransitionModifier: ViewModifier {
    let offset: CGFloat
    let opacity: Double
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .opacity(opacity)
            .scaleEffect(scale)
    }
}

// MARK: - Reduce Motion Support

public extension AnyTransition.ds {
    /// Returns a transition that respects reduce motion accessibility setting
    static func respectingReduceMotion(_ transition: AnyTransition, fallback: AnyTransition = .opacity) -> AnyTransition {
        if UIAccessibility.isReduceMotionEnabled {
            return fallback
        }
        return transition
    }
}

// MARK: - View Extension for Transitions

public extension View {
    /// Apply a Design System transition with reduce motion support
    func dsTransition(_ transition: AnyTransition, respectReduceMotion: Bool = true) -> some View {
        let finalTransition: AnyTransition
        if respectReduceMotion && UIAccessibility.isReduceMotionEnabled {
            finalTransition = .opacity
        } else {
            finalTransition = transition
        }
        return self.transition(finalTransition)
    }
}
