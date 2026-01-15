import SwiftUI

// MARK: - Long Press Configuration

/// Configuration options for long press gesture behavior.
public struct LongPressConfiguration {
    /// Minimum duration required to trigger the long press.
    public var minimumDuration: TimeInterval

    /// Maximum distance the touch can move before the gesture fails.
    public var maximumDistance: CGFloat

    /// Whether to trigger haptic feedback on long press.
    public var hapticFeedback: Bool

    /// The haptic feedback style to use.
    public var hapticStyle: HapticStyle

    /// Whether to trigger haptic feedback when pressing starts.
    public var hapticOnStart: Bool

    /// Default configuration.
    public static let `default` = LongPressConfiguration(
        minimumDuration: 0.5,
        maximumDistance: 10,
        hapticFeedback: true,
        hapticStyle: .medium,
        hapticOnStart: false
    )

    /// Quick configuration with shorter duration.
    public static let quick = LongPressConfiguration(
        minimumDuration: 0.3,
        maximumDistance: 10,
        hapticFeedback: true,
        hapticStyle: .light,
        hapticOnStart: true
    )

    /// Slow configuration requiring longer press.
    public static let slow = LongPressConfiguration(
        minimumDuration: 1.0,
        maximumDistance: 5,
        hapticFeedback: true,
        hapticStyle: .heavy,
        hapticOnStart: false
    )

    public init(
        minimumDuration: TimeInterval = 0.5,
        maximumDistance: CGFloat = 10,
        hapticFeedback: Bool = true,
        hapticStyle: HapticStyle = .medium,
        hapticOnStart: Bool = false
    ) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
        self.hapticFeedback = hapticFeedback
        self.hapticStyle = hapticStyle
        self.hapticOnStart = hapticOnStart
    }
}

// MARK: - Long Press State

/// Represents the current state of a long press gesture.
public enum LongPressState: Equatable {
    case inactive
    case pressing
    case completed
}

// MARK: - Long Press Gesture Modifier

/// A view modifier that handles long press gestures with customizable behavior.
public struct LongPressGestureModifier: ViewModifier {
    let configuration: LongPressConfiguration
    let onStart: (() -> Void)?
    let onEnd: (() -> Void)?
    let action: () -> Void

    @GestureState private var isPressed = false

    public init(
        configuration: LongPressConfiguration = .default,
        onStart: (() -> Void)? = nil,
        onEnd: (() -> Void)? = nil,
        action: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.onStart = onStart
        self.onEnd = onEnd
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .gesture(
                LongPressGesture(minimumDuration: configuration.minimumDuration)
                    .updating($isPressed) { currentState, gestureState, _ in
                        gestureState = currentState
                    }
                    .onEnded { _ in
                        if configuration.hapticFeedback {
                            HapticManager.shared.trigger(configuration.hapticStyle)
                        }
                        action()
                    }
            )
            .onChange(of: isPressed) { _, newValue in
                if newValue {
                    if configuration.hapticOnStart {
                        HapticManager.shared.trigger(.light)
                    }
                    onStart?()
                } else {
                    onEnd?()
                }
            }
            .accessibilityAction(named: "Long press") {
                action()
            }
    }
}

// MARK: - Long Press Progress Modifier

/// A view modifier that provides progress feedback during a long press.
public struct LongPressProgressModifier: ViewModifier {
    let configuration: LongPressConfiguration
    let action: () -> Void

    @State private var isPressed = false
    @State private var progress: CGFloat = 0
    @State private var timer: Timer?

    public init(
        configuration: LongPressConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let distance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))

                        if distance > configuration.maximumDistance {
                            cancelPress()
                            return
                        }

                        if !isPressed {
                            startPress()
                        }
                    }
                    .onEnded { _ in
                        cancelPress()
                    }
            )
            .accessibilityAction(named: "Long press") {
                action()
            }
    }

    private func startPress() {
        isPressed = true
        progress = 0

        if configuration.hapticOnStart {
            HapticManager.shared.trigger(.light)
        }

        let updateInterval: TimeInterval = 0.02
        let progressIncrement = CGFloat(updateInterval / configuration.minimumDuration)

        timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            progress += progressIncrement

            if progress >= 1.0 {
                timer.invalidate()
                self.timer = nil

                if configuration.hapticFeedback {
                    HapticManager.shared.trigger(configuration.hapticStyle)
                }

                action()
                isPressed = false
                progress = 0
            }
        }
    }

    private func cancelPress() {
        timer?.invalidate()
        timer = nil
        isPressed = false
        progress = 0
    }
}

// MARK: - Long Press with State Modifier

/// A view modifier that exposes the long press state for custom handling.
public struct LongPressStateModifier: ViewModifier {
    @Binding var state: LongPressState
    let configuration: LongPressConfiguration
    let action: () -> Void

    @GestureState private var isDetecting = false

    public init(
        state: Binding<LongPressState>,
        configuration: LongPressConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self._state = state
        self.configuration = configuration
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .gesture(
                LongPressGesture(minimumDuration: configuration.minimumDuration)
                    .updating($isDetecting) { currentState, gestureState, _ in
                        gestureState = currentState
                    }
                    .onEnded { _ in
                        state = .completed

                        if configuration.hapticFeedback {
                            HapticManager.shared.trigger(configuration.hapticStyle)
                        }

                        action()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            state = .inactive
                        }
                    }
            )
            .onChange(of: isDetecting) { _, newValue in
                state = newValue ? .pressing : .inactive
            }
            .accessibilityAction(named: "Long press") {
                action()
            }
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds a long press gesture handler.
    /// - Parameters:
    ///   - minimumDuration: The minimum duration for the long press.
    ///   - action: The action to perform when the long press is completed.
    /// - Returns: A view with the long press gesture attached.
    func onLongPress(
        minimumDuration: TimeInterval = 0.5,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(LongPressGestureModifier(
            configuration: LongPressConfiguration(minimumDuration: minimumDuration),
            action: action
        ))
    }

    /// Adds a long press gesture handler with full configuration.
    /// - Parameters:
    ///   - configuration: Configuration options for the long press gesture.
    ///   - onStart: Optional callback when pressing starts.
    ///   - onEnd: Optional callback when pressing ends (without completing).
    ///   - action: The action to perform when the long press is completed.
    /// - Returns: A view with the long press gesture attached.
    func onLongPress(
        configuration: LongPressConfiguration,
        onStart: (() -> Void)? = nil,
        onEnd: (() -> Void)? = nil,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(LongPressGestureModifier(
            configuration: configuration,
            onStart: onStart,
            onEnd: onEnd,
            action: action
        ))
    }

    /// Adds a long press gesture with state tracking.
    /// - Parameters:
    ///   - state: A binding to track the long press state.
    ///   - configuration: Configuration options for the long press gesture.
    ///   - action: The action to perform when the long press is completed.
    /// - Returns: A view with the long press gesture attached.
    func onLongPress(
        state: Binding<LongPressState>,
        configuration: LongPressConfiguration = .default,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(LongPressStateModifier(
            state: state,
            configuration: configuration,
            action: action
        ))
    }
}
