import SwiftUI

// MARK: - Design System withAnimation Helpers

/// Namespace for Design System animation helpers
public enum DSAnimations {
    // MARK: - Standard Animations

    /// Execute an action with a standard animation (300ms ease-in-out)
    public static func standard<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.easeInOut(duration: 0.3), action)
    }

    /// Execute an action with a quick animation (200ms)
    public static func quick<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.easeInOut(duration: 0.2), action)
    }

    /// Execute an action with a slow animation (500ms)
    public static func slow<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.easeInOut(duration: 0.5), action)
    }

    // MARK: - Spring Animations

    /// Execute an action with a gentle spring animation
    public static func springGentle<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.5, dampingFraction: 0.8), action)
    }

    /// Execute an action with a snappy spring animation
    public static func springSnappy<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.3, dampingFraction: 0.7), action)
    }

    /// Execute an action with a bouncy spring animation
    public static func springBouncy<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.4, dampingFraction: 0.5), action)
    }

    /// Execute an action with a stiff spring animation
    public static func springStiff<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.2, dampingFraction: 0.9), action)
    }

    /// Execute an action with an interactive spring animation
    public static func springInteractive<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.15, dampingFraction: 0.86, blendDuration: 0.25), action)
    }

    // MARK: - Custom Spring

    /// Execute an action with a custom spring animation
    public static func spring<Result>(
        response: Double = 0.3,
        dampingFraction: Double = 0.7,
        blendDuration: Double = 0,
        _ action: () throws -> Result
    ) rethrows -> Result {
        try withAnimation(
            .spring(response: response, dampingFraction: dampingFraction, blendDuration: blendDuration),
            action
        )
    }

    // MARK: - Preset Animations

    /// Execute an action with a spring preset
    public static func spring<Result>(
        preset: DSSpringPreset,
        _ action: () throws -> Result
    ) rethrows -> Result {
        try withAnimation(preset.animation, action)
    }

    /// Execute an action with an easing preset
    public static func easing<Result>(
        preset: DSEasingPreset,
        _ action: () throws -> Result
    ) rethrows -> Result {
        try withAnimation(preset.animation, action)
    }

    // MARK: - Contextual Animations

    /// Animation for button press feedback
    public static func buttonPress<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.3, dampingFraction: 0.7), action)
    }

    /// Animation for toggle switch
    public static func toggle<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.3, dampingFraction: 0.7), action)
    }

    /// Animation for modal presentation
    public static func modalPresent<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.5, dampingFraction: 0.8), action)
    }

    /// Animation for modal dismissal
    public static func modalDismiss<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.easeIn(duration: 0.25), action)
    }

    /// Animation for list item appearance
    public static func listItem<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.5, dampingFraction: 0.8), action)
    }

    /// Animation for tab switch
    public static func tabSwitch<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.3, dampingFraction: 0.7), action)
    }

    /// Animation for page transition
    public static func pageTransition<Result>(_ action: () throws -> Result) rethrows -> Result {
        try withAnimation(.spring(response: 0.5, dampingFraction: 0.8), action)
    }

    // MARK: - Reduce Motion Support

    /// Execute with animation respecting reduce motion settings
    public static func respectingReduceMotion<Result>(
        _ animation: Animation,
        fallback: Animation = .easeInOut(duration: 0.1),
        _ action: () throws -> Result
    ) rethrows -> Result {
        if UIAccessibility.isReduceMotionEnabled {
            return try withAnimation(fallback, action)
        }
        return try withAnimation(animation, action)
    }

    /// Execute an action without animation
    public static func none<Result>(_ action: () throws -> Result) rethrows -> Result {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        return try withTransaction(transaction, action)
    }
}

// MARK: - Delayed Animation Helpers

public extension DSAnimations {
    /// Execute an action with animation after a delay
    static func delayed<Result>(
        _ animation: Animation,
        delay: Double,
        _ action: @escaping () -> Result
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(animation) {
                _ = action()
            }
        }
    }

    /// Execute a standard animation after a delay
    static func standardDelayed(
        delay: Double,
        _ action: @escaping () -> Void
    ) {
        delayed(.easeInOut(duration: 0.3), delay: delay, action)
    }

    /// Execute a spring animation after a delay
    static func springDelayed(
        preset: DSSpringPreset = .snappy,
        delay: Double,
        _ action: @escaping () -> Void
    ) {
        delayed(preset.animation, delay: delay, action)
    }
}

// MARK: - Sequential Animation Helpers

public extension DSAnimations {
    /// Execute multiple actions in sequence with animations
    static func sequence(
        animation: Animation = .easeInOut(duration: 0.3),
        interval: Double = 0.1,
        actions: [() -> Void]
    ) {
        for (index, action) in actions.enumerated() {
            let delay = Double(index) * interval
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(animation) {
                    action()
                }
            }
        }
    }

    /// Animate items appearing one after another
    static func staggered<T>(
        items: [T],
        animation: Animation = .spring(response: 0.4, dampingFraction: 0.8),
        interval: Double = 0.05,
        action: @escaping (T) -> Void
    ) {
        for (index, item) in items.enumerated() {
            let delay = Double(index) * interval
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(animation) {
                    action(item)
                }
            }
        }
    }
}

// MARK: - Transaction Helpers

public extension DSAnimations {
    /// Execute with a custom transaction
    static func withCustomTransaction<Result>(
        animation: Animation? = nil,
        disablesAnimations: Bool = false,
        _ action: () throws -> Result
    ) rethrows -> Result {
        var transaction = Transaction()
        transaction.animation = animation
        transaction.disablesAnimations = disablesAnimations
        return try withTransaction(transaction, action)
    }

    /// Execute with completion handler (approximation using delay)
    static func withCompletion(
        animation: Animation,
        estimatedDuration: Double,
        action: @escaping () -> Void,
        completion: @escaping () -> Void
    ) {
        withAnimation(animation) {
            action()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + estimatedDuration) {
            completion()
        }
    }
}

// MARK: - Animation State Manager

/// A helper class to manage animation states
@MainActor
public class DSAnimationStateManager: ObservableObject {
    @Published public var isAnimating = false

    public init() {}

    /// Trigger an animation with automatic reset
    public func trigger(
        duration: Double = 0.3,
        animation: Animation = .easeInOut(duration: 0.3)
    ) {
        withAnimation(animation) {
            isAnimating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(animation) {
                self.isAnimating = false
            }
        }
    }

    /// Trigger a one-shot animation
    public func triggerOnce(animation: Animation = .easeInOut(duration: 0.3)) {
        withAnimation(animation) {
            isAnimating = true
        }
    }

    /// Reset animation state
    public func reset(animated: Bool = true) {
        if animated {
            withAnimation {
                isAnimating = false
            }
        } else {
            isAnimating = false
        }
    }
}

// MARK: - View Modifiers for Animation Helpers

public extension View {
    /// Apply a staggered appearance animation
    func dsStaggeredAppearance(
        index: Int,
        interval: Double = 0.05,
        animation: Animation = .spring(response: 0.4, dampingFraction: 0.8)
    ) -> some View {
        self.modifier(StaggeredAppearanceModifier(
            index: index,
            interval: interval,
            animation: animation
        ))
    }
}

private struct StaggeredAppearanceModifier: ViewModifier {
    let index: Int
    let interval: Double
    let animation: Animation

    @State private var isVisible = false

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                let delay = Double(index) * interval
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(animation) {
                        isVisible = true
                    }
                }
            }
    }
}
