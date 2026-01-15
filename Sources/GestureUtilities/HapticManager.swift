import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Haptic Style

/// Defines the intensity and type of haptic feedback.
public enum HapticStyle: Equatable, CaseIterable {
    case light
    case medium
    case heavy
    case soft
    case rigid
    case success
    case warning
    case error
    case selection

    #if canImport(UIKit)
    /// Converts to UIKit impact style.
    var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle? {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        case .soft: return .soft
        case .rigid: return .rigid
        case .success, .warning, .error, .selection: return nil
        }
    }

    /// Converts to UIKit notification type.
    var notificationType: UINotificationFeedbackGenerator.FeedbackType? {
        switch self {
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        default: return nil
        }
    }
    #endif
}

// MARK: - Haptic Manager

/// Manages haptic feedback for gesture interactions.
@MainActor
public final class HapticManager {
    /// Shared instance for app-wide haptic feedback.
    public static let shared = HapticManager()

    /// Whether haptic feedback is globally enabled.
    public var isEnabled: Bool = true

    #if canImport(UIKit)
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    private var notificationGenerator: UINotificationFeedbackGenerator?
    private var selectionGenerator: UISelectionFeedbackGenerator?
    #endif

    public init() {
        prepareGenerators()
    }

    /// Prepares haptic generators for quick response.
    public func prepareGenerators() {
        #if canImport(UIKit)
        // Prepare impact generators
        let styles: [UIImpactFeedbackGenerator.FeedbackStyle] = [.light, .medium, .heavy, .soft, .rigid]
        for style in styles {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            impactGenerators[style] = generator
        }

        // Prepare notification generator
        notificationGenerator = UINotificationFeedbackGenerator()
        notificationGenerator?.prepare()

        // Prepare selection generator
        selectionGenerator = UISelectionFeedbackGenerator()
        selectionGenerator?.prepare()
        #endif
    }

    /// Triggers haptic feedback with the specified style.
    public func trigger(_ style: HapticStyle) {
        guard isEnabled else { return }

        #if canImport(UIKit)
        switch style {
        case .selection:
            selectionGenerator?.selectionChanged()
            selectionGenerator?.prepare()

        case .success, .warning, .error:
            if let type = style.notificationType {
                notificationGenerator?.notificationOccurred(type)
                notificationGenerator?.prepare()
            }

        default:
            if let impactStyle = style.impactStyle,
               let generator = impactGenerators[impactStyle] {
                generator.impactOccurred()
                generator.prepare()
            }
        }
        #endif
    }

    /// Triggers haptic feedback with custom intensity.
    public func trigger(_ style: HapticStyle, intensity: CGFloat) {
        guard isEnabled else { return }

        #if canImport(UIKit)
        if let impactStyle = style.impactStyle,
           let generator = impactGenerators[impactStyle] {
            generator.impactOccurred(intensity: min(max(intensity, 0), 1))
            generator.prepare()
        } else {
            trigger(style)
        }
        #endif
    }

    /// Triggers a sequence of haptic feedback.
    public func triggerSequence(_ styles: [HapticStyle], interval: TimeInterval = 0.1) {
        guard isEnabled else { return }

        for (index, style) in styles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * interval) { [weak self] in
                self?.trigger(style)
            }
        }
    }

    /// Triggers haptic feedback for a gesture action.
    public func triggerForGesture(_ gesture: ActiveGesture) {
        guard isEnabled else { return }

        switch gesture {
        case .none:
            break
        case .tap:
            trigger(.light)
        case .doubleTap:
            trigger(.medium)
        case .longPress:
            trigger(.heavy)
        case .swipe:
            trigger(.light)
        case .drag:
            trigger(.selection)
        case .pinch:
            trigger(.light)
        case .rotation:
            trigger(.light)
        case .custom:
            trigger(.medium)
        }
    }
}

// MARK: - Haptic Feedback Modifier

/// A view modifier that triggers haptic feedback on value changes.
public struct HapticFeedbackModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let style: HapticStyle

    @State private var previousValue: Value?

    public init(value: Value, style: HapticStyle) {
        self.value = value
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .onChange(of: value) { _, newValue in
                if previousValue != nil {
                    HapticManager.shared.trigger(style)
                }
                previousValue = newValue
            }
            .onAppear {
                previousValue = value
            }
    }
}

// MARK: - Haptic Button Style

/// A button style that provides haptic feedback on press.
public struct HapticButtonStyle: ButtonStyle {
    let pressedStyle: HapticStyle
    let releasedStyle: HapticStyle?

    public init(
        pressedStyle: HapticStyle = .light,
        releasedStyle: HapticStyle? = nil
    ) {
        self.pressedStyle = pressedStyle
        self.releasedStyle = releasedStyle
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    HapticManager.shared.trigger(pressedStyle)
                } else if let style = releasedStyle {
                    HapticManager.shared.trigger(style)
                }
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Triggers haptic feedback when a value changes.
    func hapticFeedback<Value: Equatable>(
        on value: Value,
        style: HapticStyle = .light
    ) -> some View {
        modifier(HapticFeedbackModifier(value: value, style: style))
    }

    /// Triggers haptic feedback when condition becomes true.
    func hapticFeedback(
        when condition: Bool,
        style: HapticStyle = .light
    ) -> some View {
        modifier(HapticFeedbackModifier(value: condition, style: style))
    }

    /// Triggers haptic feedback immediately.
    func triggerHaptic(_ style: HapticStyle) -> some View {
        self.onAppear {
            HapticManager.shared.trigger(style)
        }
    }
}

// MARK: - Haptic Preferences

/// User preferences for haptic feedback.
public struct HapticPreferences {
    /// Whether haptic feedback is enabled.
    public var isEnabled: Bool

    /// The intensity multiplier (0.0 to 1.0).
    public var intensity: CGFloat

    /// Whether to use haptic feedback for gestures.
    public var useForGestures: Bool

    /// Whether to use haptic feedback for buttons.
    public var useForButtons: Bool

    /// Default preferences.
    public static let `default` = HapticPreferences(
        isEnabled: true,
        intensity: 1.0,
        useForGestures: true,
        useForButtons: true
    )

    /// Minimal haptic feedback.
    public static let minimal = HapticPreferences(
        isEnabled: true,
        intensity: 0.5,
        useForGestures: false,
        useForButtons: true
    )

    /// No haptic feedback.
    public static let disabled = HapticPreferences(
        isEnabled: false,
        intensity: 0,
        useForGestures: false,
        useForButtons: false
    )

    public init(
        isEnabled: Bool = true,
        intensity: CGFloat = 1.0,
        useForGestures: Bool = true,
        useForButtons: Bool = true
    ) {
        self.isEnabled = isEnabled
        self.intensity = intensity
        self.useForGestures = useForGestures
        self.useForButtons = useForButtons
    }
}

// MARK: - Environment Key for Haptic Preferences

private struct HapticPreferencesKey: EnvironmentKey {
    static let defaultValue = HapticPreferences.default
}

public extension EnvironmentValues {
    /// The haptic preferences for the current environment.
    var hapticPreferences: HapticPreferences {
        get { self[HapticPreferencesKey.self] }
        set { self[HapticPreferencesKey.self] = newValue }
    }
}

// MARK: - View Extension for Haptic Preferences

public extension View {
    /// Sets the haptic preferences for this view hierarchy.
    func hapticPreferences(_ preferences: HapticPreferences) -> some View {
        environment(\.hapticPreferences, preferences)
    }
}
