import SwiftUI
import Combine

// MARK: - Gesture State Manager

/// A class that manages and coordinates multiple gesture states.
@MainActor
public final class GestureStateManager: ObservableObject {
    /// Current active gesture type.
    @Published public private(set) var activeGesture: ActiveGesture = .none

    /// Whether any gesture is currently active.
    @Published public private(set) var isGestureActive: Bool = false

    /// The current drag translation if dragging.
    @Published public private(set) var dragTranslation: CGSize = .zero

    /// The current scale if zooming.
    @Published public private(set) var zoomScale: CGFloat = 1.0

    /// The current rotation if rotating.
    @Published public private(set) var rotationAngle: Angle = .zero

    /// Shared instance for app-wide gesture coordination.
    public static let shared = GestureStateManager()

    public init() {}

    /// Updates the active gesture state.
    public func setActiveGesture(_ gesture: ActiveGesture) {
        activeGesture = gesture
        isGestureActive = gesture != .none
    }

    /// Updates drag translation.
    public func updateDrag(_ translation: CGSize) {
        dragTranslation = translation
    }

    /// Updates zoom scale.
    public func updateZoom(_ scale: CGFloat) {
        zoomScale = scale
    }

    /// Updates rotation angle.
    public func updateRotation(_ angle: Angle) {
        rotationAngle = angle
    }

    /// Resets all gesture states.
    public func reset() {
        activeGesture = .none
        isGestureActive = false
        dragTranslation = .zero
        zoomScale = 1.0
        rotationAngle = .zero
    }
}

// MARK: - Active Gesture Type

/// Represents the type of gesture currently active.
public enum ActiveGesture: Equatable {
    case none
    case tap
    case doubleTap
    case longPress
    case swipe(SwipeDirection)
    case drag
    case pinch
    case rotation
    case custom(String)
}

// MARK: - Gesture Coordinator

/// Coordinates gestures to prevent conflicts and manage priority.
public struct GestureCoordinator {
    /// Priority levels for gestures.
    public enum Priority: Int, Comparable {
        case low = 0
        case normal = 1
        case high = 2
        case exclusive = 3

        public static func < (lhs: Priority, rhs: Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    /// Determines if a gesture should be allowed based on current state.
    public static func shouldAllowGesture(
        _ gesture: ActiveGesture,
        currentActive: ActiveGesture,
        priority: Priority = .normal
    ) -> Bool {
        if currentActive == .none {
            return true
        }

        // Allow gestures with exclusive priority
        if priority == .exclusive {
            return true
        }

        // Prevent conflicting gestures
        switch (currentActive, gesture) {
        case (.swipe, .drag), (.drag, .swipe):
            return false
        case (.pinch, .longPress), (.longPress, .pinch):
            return false
        case (.tap, .doubleTap):
            return true // Allow double tap to override single tap
        default:
            return priority > .normal
        }
    }
}

// MARK: - Gesture Velocity

/// Represents the velocity of a gesture.
public struct GestureVelocity: Equatable {
    /// Horizontal velocity.
    public let x: CGFloat

    /// Vertical velocity.
    public let y: CGFloat

    /// Combined magnitude.
    public var magnitude: CGFloat {
        sqrt(x * x + y * y)
    }

    /// Direction angle in radians.
    public var angle: CGFloat {
        atan2(y, x)
    }

    /// Creates a velocity from translation and time.
    public static func from(
        translation: CGSize,
        duration: TimeInterval
    ) -> GestureVelocity {
        guard duration > 0 else {
            return GestureVelocity(x: 0, y: 0)
        }

        return GestureVelocity(
            x: translation.width / CGFloat(duration),
            y: translation.height / CGFloat(duration)
        )
    }

    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    /// Zero velocity.
    public static let zero = GestureVelocity(x: 0, y: 0)
}

// MARK: - Gesture Tracker

/// Tracks gesture timing and velocity.
public struct GestureTracker {
    private var startTime: Date?
    private var startLocation: CGPoint?
    private var lastLocation: CGPoint?
    private var lastTime: Date?

    public init() {}

    /// Starts tracking a gesture.
    public mutating func start(at location: CGPoint) {
        let now = Date()
        startTime = now
        startLocation = location
        lastLocation = location
        lastTime = now
    }

    /// Updates tracking with new location.
    public mutating func update(at location: CGPoint) {
        lastLocation = location
        lastTime = Date()
    }

    /// Ends tracking and returns the velocity.
    public mutating func end() -> GestureVelocity {
        guard let start = startLocation,
              let end = lastLocation,
              let startT = startTime,
              let endT = lastTime else {
            return .zero
        }

        let translation = CGSize(
            width: end.x - start.x,
            height: end.y - start.y
        )

        let duration = endT.timeIntervalSince(startT)

        reset()

        return GestureVelocity.from(translation: translation, duration: duration)
    }

    /// Resets the tracker.
    public mutating func reset() {
        startTime = nil
        startLocation = nil
        lastLocation = nil
        lastTime = nil
    }

    /// Returns the current duration.
    public func currentDuration() -> TimeInterval {
        guard let startT = startTime else { return 0 }
        return Date().timeIntervalSince(startT)
    }

    /// Returns the total distance traveled.
    public func totalDistance() -> CGFloat {
        guard let start = startLocation, let end = lastLocation else { return 0 }
        return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2))
    }
}

// MARK: - Combined Gesture State

/// A combined state for views that support multiple gestures.
public struct CombinedGestureState: Equatable {
    public var scale: CGFloat
    public var rotation: Angle
    public var offset: CGSize
    public var isActive: Bool

    public static let identity = CombinedGestureState(
        scale: 1.0,
        rotation: .zero,
        offset: .zero,
        isActive: false
    )

    public init(
        scale: CGFloat = 1.0,
        rotation: Angle = .zero,
        offset: CGSize = .zero,
        isActive: Bool = false
    ) {
        self.scale = scale
        self.rotation = rotation
        self.offset = offset
        self.isActive = isActive
    }

    /// Resets to identity state.
    public mutating func reset() {
        scale = 1.0
        rotation = .zero
        offset = .zero
        isActive = false
    }
}

// MARK: - Gesture State Binding Helper

/// A property wrapper that provides gesture state with reset capability.
@propertyWrapper
public struct GestureStateBinding<Value: Equatable>: DynamicProperty {
    @State private var value: Value
    private let resetValue: Value

    public var wrappedValue: Value {
        get { value }
        nonmutating set { value = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { value },
            set: { value = $0 }
        )
    }

    public init(wrappedValue: Value, resetValue: Value) {
        self._value = State(initialValue: wrappedValue)
        self.resetValue = resetValue
    }

    public init(wrappedValue: Value) where Value: ExpressibleByNilLiteral {
        self._value = State(initialValue: wrappedValue)
        self.resetValue = nil
    }

    /// Resets to the initial value.
    public func reset() {
        value = resetValue
    }
}

// MARK: - Environment Key for Gesture State

private struct GestureStateManagerKey: EnvironmentKey {
    @MainActor static let defaultValue = GestureStateManager()
}

public extension EnvironmentValues {
    /// The gesture state manager for the current environment.
    var gestureStateManager: GestureStateManager {
        get { self[GestureStateManagerKey.self] }
        set { self[GestureStateManagerKey.self] = newValue }
    }
}

// MARK: - View Extension for Gesture State

public extension View {
    /// Injects a gesture state manager into the environment.
    func gestureStateManager(_ manager: GestureStateManager) -> some View {
        environment(\.gestureStateManager, manager)
    }
}
