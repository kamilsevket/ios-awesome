import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Reduce Motion Support

/// A view modifier that respects the user's reduce motion preference
public struct DSReduceMotionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let animation: Animation
    let reducedAnimation: Animation?
    let value: AnyHashable

    public func body(content: Content) -> some View {
        content
            .animation(reduceMotion ? (reducedAnimation ?? .none) : animation, value: value)
    }
}

extension View {
    /// Applies animation that respects reduce motion preference
    /// - Parameters:
    ///   - animation: The animation to use when reduce motion is off
    ///   - reducedAnimation: Optional animation for reduce motion (defaults to none)
    ///   - value: The value to animate
    /// - Returns: A view with accessible animation
    public func dsReduceMotionAnimation<V: Equatable>(
        _ animation: Animation = .default,
        reduced reducedAnimation: Animation? = nil,
        value: V
    ) -> some View {
        modifier(DSReduceMotionModifier(
            animation: animation,
            reducedAnimation: reducedAnimation,
            value: AnyHashable(value)
        ))
    }

    /// Applies spring animation that respects reduce motion
    /// - Parameters:
    ///   - response: The spring response time
    ///   - dampingFraction: The spring damping
    ///   - value: The value to animate
    public func dsReduceMotionSpring<V: Equatable>(
        response: Double = 0.3,
        dampingFraction: Double = 0.7,
        value: V
    ) -> some View {
        dsReduceMotionAnimation(
            .spring(response: response, dampingFraction: dampingFraction),
            reduced: .easeInOut(duration: 0.01),
            value: value
        )
    }
}

// MARK: - Reduce Motion Observer

/// An observable object that tracks the user's reduce motion preference
public final class DSReduceMotionObserver: ObservableObject {
    @Published public private(set) var isReduceMotionEnabled: Bool = false

    public static let shared = DSReduceMotionObserver()

    private init() {
        updatePreference()

        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reduceMotionDidChange),
            name: UIAccessibility.reduceMotionStatusDidChangeNotification,
            object: nil
        )
        #endif
    }

    deinit {
        #if os(iOS)
        NotificationCenter.default.removeObserver(self)
        #endif
    }

    #if os(iOS)
    @objc private func reduceMotionDidChange() {
        updatePreference()
    }
    #endif

    private func updatePreference() {
        #if os(iOS)
        DispatchQueue.main.async {
            self.isReduceMotionEnabled = UIAccessibility.isReduceMotionEnabled
        }
        #elseif os(macOS)
        DispatchQueue.main.async {
            self.isReduceMotionEnabled = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
        }
        #endif
    }
}

// MARK: - Conditional Animation View

/// A view that conditionally applies animation based on reduce motion preference
public struct DSMotionSafeView<Content: View, ReducedContent: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let content: Content
    let reducedContent: ReducedContent

    /// Creates a motion-safe view with alternative content for reduce motion
    /// - Parameters:
    ///   - content: The default animated content
    ///   - reducedContent: Content to show when reduce motion is enabled
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder reducedContent: () -> ReducedContent
    ) {
        self.content = content()
        self.reducedContent = reducedContent()
    }

    public var body: some View {
        if reduceMotion {
            reducedContent
        } else {
            content
        }
    }
}

// MARK: - Simple Motion Safe View

extension DSMotionSafeView where ReducedContent == Content {
    /// Creates a motion-safe view with the same content but without animation
    /// - Parameter content: The view content
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.reducedContent = content()
    }
}

// MARK: - Transition Modifier

/// A modifier that provides accessible transitions
public struct DSAccessibleTransitionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let transition: AnyTransition
    let reducedTransition: AnyTransition

    public func body(content: Content) -> some View {
        content
            .transition(reduceMotion ? reducedTransition : transition)
    }
}

extension View {
    /// Applies a transition that respects reduce motion
    /// - Parameters:
    ///   - transition: The transition when reduce motion is off
    ///   - reduced: The transition when reduce motion is on (defaults to opacity)
    public func dsAccessibleTransition(
        _ transition: AnyTransition,
        reduced: AnyTransition = .opacity
    ) -> some View {
        modifier(DSAccessibleTransitionModifier(
            transition: transition,
            reducedTransition: reduced
        ))
    }
}

// MARK: - Predefined Accessible Animations

/// A collection of pre-configured accessible animations
public enum DSAccessibleAnimation {
    /// A gentle fade animation
    public static let fade: Animation = .easeInOut(duration: 0.2)

    /// A quick snap animation (instant when reduce motion is on)
    public static let snap: Animation = .spring(response: 0.2, dampingFraction: 0.8)

    /// A smooth slide animation
    public static let slide: Animation = .easeInOut(duration: 0.3)

    /// A bouncy spring animation
    public static let bounce: Animation = .spring(response: 0.4, dampingFraction: 0.6)

    /// No animation
    public static let none: Animation = .linear(duration: 0)

    /// Returns the appropriate animation based on reduce motion preference
    /// - Parameters:
    ///   - preferred: The preferred animation
    ///   - reduceMotion: Whether reduce motion is enabled
    /// - Returns: The appropriate animation
    public static func accessible(
        _ preferred: Animation,
        reduceMotion: Bool
    ) -> Animation {
        reduceMotion ? none : preferred
    }
}

// MARK: - Reduce Motion Property Wrapper

/// A property wrapper that provides a value based on reduce motion preference
@propertyWrapper
public struct DSMotionSafe<Value>: DynamicProperty {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let standard: Value
    private let reduced: Value

    public var wrappedValue: Value {
        reduceMotion ? reduced : standard
    }

    /// Creates a motion-safe value
    /// - Parameters:
    ///   - standard: The value when reduce motion is off
    ///   - reduced: The value when reduce motion is on
    public init(standard: Value, reduced: Value) {
        self.standard = standard
        self.reduced = reduced
    }
}
