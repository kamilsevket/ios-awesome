import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Accessibility Gesture Alternative

/// Provides alternative actions for users who cannot perform standard gestures.
public struct AccessibilityGestureAlternative {
    /// The action name displayed to VoiceOver users.
    public let name: LocalizedStringKey

    /// The hint describing what the action does.
    public let hint: LocalizedStringKey?

    /// The action to perform.
    public let action: () -> Void

    public init(
        name: LocalizedStringKey,
        hint: LocalizedStringKey? = nil,
        action: @escaping () -> Void
    ) {
        self.name = name
        self.hint = hint
        self.action = action
    }
}

// MARK: - Accessibility Gesture Configuration

/// Configuration for accessibility alternatives to gestures.
public struct AccessibilityGestureConfiguration {
    /// Alternative for swipe left gesture.
    public var swipeLeftAlternative: AccessibilityGestureAlternative?

    /// Alternative for swipe right gesture.
    public var swipeRightAlternative: AccessibilityGestureAlternative?

    /// Alternative for swipe up gesture.
    public var swipeUpAlternative: AccessibilityGestureAlternative?

    /// Alternative for swipe down gesture.
    public var swipeDownAlternative: AccessibilityGestureAlternative?

    /// Alternative for long press gesture.
    public var longPressAlternative: AccessibilityGestureAlternative?

    /// Alternative for double tap gesture.
    public var doubleTapAlternative: AccessibilityGestureAlternative?

    /// Alternative for pinch zoom in gesture.
    public var zoomInAlternative: AccessibilityGestureAlternative?

    /// Alternative for pinch zoom out gesture.
    public var zoomOutAlternative: AccessibilityGestureAlternative?

    /// Alternative for reset zoom gesture.
    public var resetZoomAlternative: AccessibilityGestureAlternative?

    public init(
        swipeLeftAlternative: AccessibilityGestureAlternative? = nil,
        swipeRightAlternative: AccessibilityGestureAlternative? = nil,
        swipeUpAlternative: AccessibilityGestureAlternative? = nil,
        swipeDownAlternative: AccessibilityGestureAlternative? = nil,
        longPressAlternative: AccessibilityGestureAlternative? = nil,
        doubleTapAlternative: AccessibilityGestureAlternative? = nil,
        zoomInAlternative: AccessibilityGestureAlternative? = nil,
        zoomOutAlternative: AccessibilityGestureAlternative? = nil,
        resetZoomAlternative: AccessibilityGestureAlternative? = nil
    ) {
        self.swipeLeftAlternative = swipeLeftAlternative
        self.swipeRightAlternative = swipeRightAlternative
        self.swipeUpAlternative = swipeUpAlternative
        self.swipeDownAlternative = swipeDownAlternative
        self.longPressAlternative = longPressAlternative
        self.doubleTapAlternative = doubleTapAlternative
        self.zoomInAlternative = zoomInAlternative
        self.zoomOutAlternative = zoomOutAlternative
        self.resetZoomAlternative = resetZoomAlternative
    }
}

// MARK: - Accessibility Gesture Modifier

/// A view modifier that adds accessibility alternatives for gestures.
public struct AccessibilityGestureModifier: ViewModifier {
    let configuration: AccessibilityGestureConfiguration

    public init(configuration: AccessibilityGestureConfiguration) {
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .contain)
            .modifier(ConditionalAccessibilityActions(configuration: configuration))
    }
}

private struct ConditionalAccessibilityActions: ViewModifier {
    let configuration: AccessibilityGestureConfiguration

    func body(content: Content) -> some View {
        var view = AnyView(content)

        if let alt = configuration.swipeLeftAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.swipeRightAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.swipeUpAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.swipeDownAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.longPressAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.doubleTapAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.zoomInAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.zoomOutAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }
        if let alt = configuration.resetZoomAlternative {
            view = AnyView(view.accessibilityAction(named: alt.name, alt.action))
        }

        return view
    }
}

// MARK: - Accessibility Helpers

/// Helpers for detecting and responding to accessibility settings.
public struct AccessibilityHelpers {
    /// Checks if reduce motion is enabled.
    public static var isReduceMotionEnabled: Bool {
        #if canImport(UIKit)
        return UIAccessibility.isReduceMotionEnabled
        #else
        return false
        #endif
    }

    /// Checks if VoiceOver is running.
    public static var isVoiceOverRunning: Bool {
        #if canImport(UIKit)
        return UIAccessibility.isVoiceOverRunning
        #else
        return false
        #endif
    }

    /// Checks if Switch Control is running.
    public static var isSwitchControlRunning: Bool {
        #if canImport(UIKit)
        return UIAccessibility.isSwitchControlRunning
        #else
        return false
        #endif
    }

    /// Checks if any assistive technology is running.
    public static var isAssistiveTechnologyRunning: Bool {
        isVoiceOverRunning || isSwitchControlRunning
    }

    /// Posts an accessibility announcement.
    public static func announce(_ message: String) {
        #if canImport(UIKit)
        UIAccessibility.post(notification: .announcement, argument: message)
        #endif
    }

    /// Posts a screen changed notification.
    public static func screenChanged(focus: Any? = nil) {
        #if canImport(UIKit)
        UIAccessibility.post(notification: .screenChanged, argument: focus)
        #endif
    }

    /// Posts a layout changed notification.
    public static func layoutChanged(focus: Any? = nil) {
        #if canImport(UIKit)
        UIAccessibility.post(notification: .layoutChanged, argument: focus)
        #endif
    }
}

// MARK: - Accessible Gesture Container

/// A container that provides accessible alternatives for gesture-based interactions.
public struct AccessibleGestureContainer<Content: View>: View {
    let content: Content
    let configuration: AccessibilityGestureConfiguration
    let announceOnAction: Bool

    public init(
        configuration: AccessibilityGestureConfiguration,
        announceOnAction: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.configuration = configuration
        self.announceOnAction = announceOnAction
    }

    public var body: some View {
        content
            .modifier(AccessibilityGestureModifier(configuration: configuration))
    }
}

// MARK: - Accessibility Action Builder

/// A builder for creating accessibility actions from gesture handlers.
@resultBuilder
public struct AccessibilityActionBuilder {
    public static func buildBlock(_ components: AccessibilityGestureAlternative...) -> [AccessibilityGestureAlternative] {
        components
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds accessibility alternatives for gestures.
    func gestureAccessibility(
        _ configuration: AccessibilityGestureConfiguration
    ) -> some View {
        modifier(AccessibilityGestureModifier(configuration: configuration))
    }

    /// Adds a custom accessibility action for a gesture.
    func accessibilityGestureAction(
        _ name: LocalizedStringKey,
        hint: LocalizedStringKey? = nil,
        action: @escaping () -> Void
    ) -> some View {
        self.accessibilityAction(named: name, action)
    }

    /// Announces a message to VoiceOver users when a gesture is performed.
    func announceGestureResult(_ message: String, when condition: Bool) -> some View {
        self.onChange(of: condition) { newValue in
            if newValue {
                AccessibilityHelpers.announce(message)
            }
        }
    }

    /// Provides alternative button actions for assistive technologies.
    func accessibilityButtonAlternative(
        label: LocalizedStringKey,
        action: @escaping () -> Void
    ) -> some View {
        self.overlay(
            Group {
                if AccessibilityHelpers.isAssistiveTechnologyRunning {
                    Button(action: action) {
                        Color.clear
                    }
                    .accessibilityLabel(label)
                }
            }
        )
    }
}

// MARK: - Reduced Motion Gesture Alternative

/// A view modifier that provides simplified gestures when reduce motion is enabled.
public struct ReducedMotionGestureModifier: ViewModifier {
    let standardAnimation: Animation
    let reducedAnimation: Animation

    public init(
        standardAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        reducedAnimation: Animation = .linear(duration: 0.1)
    ) {
        self.standardAnimation = standardAnimation
        self.reducedAnimation = reducedAnimation
    }

    public func body(content: Content) -> some View {
        content
            .animation(
                AccessibilityHelpers.isReduceMotionEnabled ? reducedAnimation : standardAnimation,
                value: UUID()
            )
    }
}

public extension View {
    /// Applies reduced motion friendly animations.
    func reducedMotionFriendly(
        standardAnimation: Animation = .spring(response: 0.3, dampingFraction: 0.7),
        reducedAnimation: Animation = .linear(duration: 0.1)
    ) -> some View {
        modifier(ReducedMotionGestureModifier(
            standardAnimation: standardAnimation,
            reducedAnimation: reducedAnimation
        ))
    }
}

// MARK: - Environment Key for Accessibility Configuration

private struct GestureAccessibilityConfigurationKey: EnvironmentKey {
    static let defaultValue = AccessibilityGestureConfiguration()
}

public extension EnvironmentValues {
    /// The gesture accessibility configuration for the current environment.
    var gestureAccessibilityConfiguration: AccessibilityGestureConfiguration {
        get { self[GestureAccessibilityConfigurationKey.self] }
        set { self[GestureAccessibilityConfigurationKey.self] = newValue }
    }
}
