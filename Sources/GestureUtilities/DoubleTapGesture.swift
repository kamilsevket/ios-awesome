import SwiftUI

// MARK: - Double Tap Configuration

/// Configuration options for double tap gesture behavior.
public struct DoubleTapConfiguration {
    /// Maximum time interval between taps.
    public var maxInterval: TimeInterval

    /// Maximum distance between tap locations.
    public var maxDistance: CGFloat

    /// Whether to trigger haptic feedback on double tap.
    public var hapticFeedback: Bool

    /// The haptic feedback style to use.
    public var hapticStyle: HapticStyle

    /// Default configuration.
    public static let `default` = DoubleTapConfiguration(
        maxInterval: 0.3,
        maxDistance: 50,
        hapticFeedback: true,
        hapticStyle: .light
    )

    /// Fast configuration requiring quicker taps.
    public static let fast = DoubleTapConfiguration(
        maxInterval: 0.2,
        maxDistance: 30,
        hapticFeedback: true,
        hapticStyle: .light
    )

    /// Relaxed configuration allowing more time.
    public static let relaxed = DoubleTapConfiguration(
        maxInterval: 0.5,
        maxDistance: 80,
        hapticFeedback: true,
        hapticStyle: .medium
    )

    public init(
        maxInterval: TimeInterval = 0.3,
        maxDistance: CGFloat = 50,
        hapticFeedback: Bool = true,
        hapticStyle: HapticStyle = .light
    ) {
        self.maxInterval = maxInterval
        self.maxDistance = maxDistance
        self.hapticFeedback = hapticFeedback
        self.hapticStyle = hapticStyle
    }
}

// MARK: - Multi-Tap Configuration

/// Configuration for multi-tap gestures (triple tap, etc.).
public struct MultiTapConfiguration {
    /// Number of taps required.
    public var requiredTaps: Int

    /// Maximum time interval between taps.
    public var maxInterval: TimeInterval

    /// Maximum distance between tap locations.
    public var maxDistance: CGFloat

    /// Whether to trigger haptic feedback.
    public var hapticFeedback: Bool

    /// The haptic feedback style to use.
    public var hapticStyle: HapticStyle

    /// Creates a configuration for the specified number of taps.
    public static func taps(_ count: Int) -> MultiTapConfiguration {
        MultiTapConfiguration(
            requiredTaps: count,
            maxInterval: 0.3,
            maxDistance: 50,
            hapticFeedback: true,
            hapticStyle: .light
        )
    }

    public init(
        requiredTaps: Int = 2,
        maxInterval: TimeInterval = 0.3,
        maxDistance: CGFloat = 50,
        hapticFeedback: Bool = true,
        hapticStyle: HapticStyle = .light
    ) {
        self.requiredTaps = max(1, requiredTaps)
        self.maxInterval = maxInterval
        self.maxDistance = maxDistance
        self.hapticFeedback = hapticFeedback
        self.hapticStyle = hapticStyle
    }
}

// MARK: - Double Tap Gesture Modifier

/// A view modifier that handles double tap gestures.
public struct DoubleTapGestureModifier: ViewModifier {
    let configuration: DoubleTapConfiguration
    let action: () -> Void

    public init(
        configuration: DoubleTapConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2) {
                if configuration.hapticFeedback {
                    HapticManager.shared.trigger(configuration.hapticStyle)
                }
                action()
            }
            .accessibilityAction(named: "Double tap") {
                action()
            }
    }
}

// MARK: - Double Tap with Location Modifier

/// A view modifier that provides tap location on double tap.
public struct DoubleTapLocationModifier: ViewModifier {
    let configuration: DoubleTapConfiguration
    let action: (CGPoint) -> Void

    @State private var tapCount = 0
    @State private var lastTapLocation: CGPoint?
    @State private var lastTapTime: Date?

    public init(
        configuration: DoubleTapConfiguration = .default,
        action: @escaping (CGPoint) -> Void
    ) {
        self.configuration = configuration
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        handleTap(at: value.startLocation)
                    }
            )
            .accessibilityAction(named: "Double tap") {
                action(.zero)
            }
    }

    private func handleTap(at location: CGPoint) {
        let now = Date()

        if let lastTime = lastTapTime,
           let lastLocation = lastTapLocation,
           now.timeIntervalSince(lastTime) < configuration.maxInterval,
           distance(from: lastLocation, to: location) < configuration.maxDistance {
            // Second tap detected
            tapCount = 0
            lastTapLocation = nil
            lastTapTime = nil

            if configuration.hapticFeedback {
                Task { @MainActor in
                    HapticManager.shared.trigger(configuration.hapticStyle)
                }
            }

            action(location)
        } else {
            // First tap
            tapCount = 1
            lastTapLocation = location
            lastTapTime = now
        }
    }

    private func distance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2))
    }
}

// MARK: - Multi-Tap Gesture Modifier

/// A view modifier that handles multiple tap gestures (triple tap, etc.).
public struct MultiTapGestureModifier: ViewModifier {
    let configuration: MultiTapConfiguration
    let action: () -> Void

    public init(
        configuration: MultiTapConfiguration,
        action: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: configuration.requiredTaps) {
                if configuration.hapticFeedback {
                    HapticManager.shared.trigger(configuration.hapticStyle)
                }
                action()
            }
            .accessibilityAction(named: tapAccessibilityName) {
                action()
            }
    }

    private var tapAccessibilityName: LocalizedStringKey {
        switch configuration.requiredTaps {
        case 2: return "Double tap"
        case 3: return "Triple tap"
        default: return "Tap \(configuration.requiredTaps) times"
        }
    }
}

// MARK: - Double Tap Toggle Modifier

/// A view modifier that toggles a boolean value on double tap.
public struct DoubleTapToggleModifier: ViewModifier {
    @Binding var isOn: Bool
    let configuration: DoubleTapConfiguration

    public init(
        isOn: Binding<Bool>,
        configuration: DoubleTapConfiguration = .default
    ) {
        self._isOn = isOn
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2) {
                if configuration.hapticFeedback {
                    HapticManager.shared.trigger(configuration.hapticStyle)
                }
                isOn.toggle()
            }
            .accessibilityAction(named: "Toggle") {
                isOn.toggle()
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds a double tap gesture handler.
    /// - Parameters:
    ///   - configuration: Configuration options for the double tap gesture.
    ///   - action: The action to perform when double tap is detected.
    /// - Returns: A view with the double tap gesture attached.
    func onDoubleTap(
        configuration: DoubleTapConfiguration = .default,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(DoubleTapGestureModifier(
            configuration: configuration,
            action: action
        ))
    }

    /// Adds a double tap gesture handler that provides the tap location.
    /// - Parameters:
    ///   - configuration: Configuration options for the double tap gesture.
    ///   - action: The action to perform when double tap is detected, with location.
    /// - Returns: A view with the double tap gesture attached.
    func onDoubleTap(
        configuration: DoubleTapConfiguration = .default,
        at action: @escaping (CGPoint) -> Void
    ) -> some View {
        modifier(DoubleTapLocationModifier(
            configuration: configuration,
            action: action
        ))
    }

    /// Adds a multi-tap gesture handler.
    /// - Parameters:
    ///   - count: The number of taps required.
    ///   - action: The action to perform when the taps are detected.
    /// - Returns: A view with the multi-tap gesture attached.
    func onTaps(
        count: Int,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(MultiTapGestureModifier(
            configuration: .taps(count),
            action: action
        ))
    }

    /// Adds a multi-tap gesture handler with full configuration.
    /// - Parameters:
    ///   - configuration: Configuration options for the multi-tap gesture.
    ///   - action: The action to perform when the taps are detected.
    /// - Returns: A view with the multi-tap gesture attached.
    func onTaps(
        configuration: MultiTapConfiguration,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(MultiTapGestureModifier(
            configuration: configuration,
            action: action
        ))
    }

    /// Adds a double tap gesture that toggles a boolean.
    /// - Parameters:
    ///   - isOn: A binding to the boolean to toggle.
    ///   - configuration: Configuration options for the double tap gesture.
    /// - Returns: A view with the double tap toggle gesture attached.
    func doubleTapToggle(
        _ isOn: Binding<Bool>,
        configuration: DoubleTapConfiguration = .default
    ) -> some View {
        modifier(DoubleTapToggleModifier(
            isOn: isOn,
            configuration: configuration
        ))
    }
}
