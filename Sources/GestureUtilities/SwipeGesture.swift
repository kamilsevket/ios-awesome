import SwiftUI

// MARK: - Swipe Direction

/// Represents the direction of a swipe gesture.
public enum SwipeDirection: CaseIterable {
    case left
    case right
    case up
    case down

    /// Returns the opposite direction.
    public var opposite: SwipeDirection {
        switch self {
        case .left: return .right
        case .right: return .left
        case .up: return .down
        case .down: return .up
        }
    }
}

// MARK: - Swipe Configuration

/// Configuration options for swipe gesture behavior.
public struct SwipeConfiguration {
    /// Minimum distance required to trigger the swipe.
    public var minimumDistance: CGFloat

    /// Maximum angle deviation from the primary direction (in degrees).
    public var maximumAngle: CGFloat

    /// Whether to trigger haptic feedback on swipe.
    public var hapticFeedback: Bool

    /// The haptic feedback style to use.
    public var hapticStyle: HapticStyle

    /// Default configuration.
    public static let `default` = SwipeConfiguration(
        minimumDistance: 50,
        maximumAngle: 30,
        hapticFeedback: true,
        hapticStyle: .light
    )

    /// Sensitive configuration with shorter distance requirement.
    public static let sensitive = SwipeConfiguration(
        minimumDistance: 25,
        maximumAngle: 45,
        hapticFeedback: true,
        hapticStyle: .light
    )

    /// Strict configuration requiring longer, more precise swipes.
    public static let strict = SwipeConfiguration(
        minimumDistance: 80,
        maximumAngle: 20,
        hapticFeedback: true,
        hapticStyle: .medium
    )

    public init(
        minimumDistance: CGFloat = 50,
        maximumAngle: CGFloat = 30,
        hapticFeedback: Bool = true,
        hapticStyle: HapticStyle = .light
    ) {
        self.minimumDistance = minimumDistance
        self.maximumAngle = maximumAngle
        self.hapticFeedback = hapticFeedback
        self.hapticStyle = hapticStyle
    }
}

// MARK: - Swipe Gesture Modifier

/// A view modifier that handles swipe gestures in a specific direction.
public struct SwipeGestureModifier: ViewModifier {
    let direction: SwipeDirection
    let configuration: SwipeConfiguration
    let action: () -> Void

    @State private var startLocation: CGPoint?

    public init(
        direction: SwipeDirection,
        configuration: SwipeConfiguration = .default,
        action: @escaping () -> Void
    ) {
        self.direction = direction
        self.configuration = configuration
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: configuration.minimumDistance)
                    .onChanged { value in
                        if startLocation == nil {
                            startLocation = value.startLocation
                        }
                    }
                    .onEnded { value in
                        defer { startLocation = nil }

                        let translation = value.translation
                        let detectedDirection = detectDirection(from: translation)

                        if detectedDirection == direction && isWithinAngle(translation: translation) {
                            if configuration.hapticFeedback {
                                HapticManager.shared.trigger(configuration.hapticStyle)
                            }
                            action()
                        }
                    }
            )
            .accessibilityAction(named: accessibilityActionName) {
                action()
            }
    }

    private func detectDirection(from translation: CGSize) -> SwipeDirection {
        let horizontal = abs(translation.width)
        let vertical = abs(translation.height)

        if horizontal > vertical {
            return translation.width > 0 ? .right : .left
        } else {
            return translation.height > 0 ? .down : .up
        }
    }

    private func isWithinAngle(translation: CGSize) -> Bool {
        let angle: CGFloat

        switch direction {
        case .left, .right:
            angle = abs(atan2(translation.height, abs(translation.width))) * 180 / .pi
        case .up, .down:
            angle = abs(atan2(abs(translation.width), translation.height)) * 180 / .pi
        }

        return angle <= configuration.maximumAngle
    }

    private var accessibilityActionName: LocalizedStringKey {
        switch direction {
        case .left: return "Swipe left"
        case .right: return "Swipe right"
        case .up: return "Swipe up"
        case .down: return "Swipe down"
        }
    }
}

// MARK: - Multi-Direction Swipe Modifier

/// A view modifier that handles swipe gestures in multiple directions.
public struct MultiSwipeGestureModifier: ViewModifier {
    let handlers: [SwipeDirection: () -> Void]
    let configuration: SwipeConfiguration

    @State private var startLocation: CGPoint?

    public init(
        handlers: [SwipeDirection: () -> Void],
        configuration: SwipeConfiguration = .default
    ) {
        self.handlers = handlers
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: configuration.minimumDistance)
                    .onChanged { value in
                        if startLocation == nil {
                            startLocation = value.startLocation
                        }
                    }
                    .onEnded { value in
                        defer { startLocation = nil }

                        let translation = value.translation
                        let detectedDirection = detectDirection(from: translation)

                        if let handler = handlers[detectedDirection], isWithinAngle(translation: translation, direction: detectedDirection) {
                            if configuration.hapticFeedback {
                                HapticManager.shared.trigger(configuration.hapticStyle)
                            }
                            handler()
                        }
                    }
            )
            .accessibilityElement(children: .contain)
            .accessibilityActions(handlers: handlers)
    }

    private func detectDirection(from translation: CGSize) -> SwipeDirection {
        let horizontal = abs(translation.width)
        let vertical = abs(translation.height)

        if horizontal > vertical {
            return translation.width > 0 ? .right : .left
        } else {
            return translation.height > 0 ? .down : .up
        }
    }

    private func isWithinAngle(translation: CGSize, direction: SwipeDirection) -> Bool {
        let angle: CGFloat

        switch direction {
        case .left, .right:
            angle = abs(atan2(translation.height, abs(translation.width))) * 180 / .pi
        case .up, .down:
            angle = abs(atan2(abs(translation.width), translation.height)) * 180 / .pi
        }

        return angle <= configuration.maximumAngle
    }
}

// MARK: - View Extension for Accessibility

private extension View {
    func accessibilityActions(handlers: [SwipeDirection: () -> Void]) -> some View {
        var view = AnyView(self)

        for direction in SwipeDirection.allCases {
            if let handler = handlers[direction] {
                view = AnyView(view.accessibilityAction(named: direction.accessibilityName) {
                    handler()
                })
            }
        }

        return view
    }
}

private extension SwipeDirection {
    var accessibilityName: LocalizedStringKey {
        switch self {
        case .left: return "Swipe left"
        case .right: return "Swipe right"
        case .up: return "Swipe up"
        case .down: return "Swipe down"
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds a swipe gesture handler for a specific direction.
    /// - Parameters:
    ///   - direction: The direction of the swipe to detect.
    ///   - configuration: Configuration options for the swipe gesture.
    ///   - action: The action to perform when the swipe is detected.
    /// - Returns: A view with the swipe gesture attached.
    func onSwipe(
        _ direction: SwipeDirection,
        configuration: SwipeConfiguration = .default,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(SwipeGestureModifier(
            direction: direction,
            configuration: configuration,
            action: action
        ))
    }

    /// Adds swipe gesture handlers for multiple directions.
    /// - Parameters:
    ///   - configuration: Configuration options for the swipe gestures.
    ///   - handlers: A dictionary mapping directions to their handlers.
    /// - Returns: A view with the swipe gestures attached.
    func onSwipe(
        configuration: SwipeConfiguration = .default,
        handlers: [SwipeDirection: () -> Void]
    ) -> some View {
        modifier(MultiSwipeGestureModifier(
            handlers: handlers,
            configuration: configuration
        ))
    }
}
