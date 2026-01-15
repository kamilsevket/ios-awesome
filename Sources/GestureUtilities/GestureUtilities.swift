/// GestureUtilities
///
/// A comprehensive SwiftUI gesture handling library providing easy-to-use modifiers
/// for common gesture interactions including swipe, long press, pinch to zoom, and double tap.
///
/// ## Features
///
/// - **Swipe Gestures**: 4-direction swipe detection with configurable sensitivity
/// - **Long Press**: Customizable duration with progress tracking
/// - **Pinch to Zoom**: Scale controls with snap-to-identity and boundary haptics
/// - **Double Tap**: Single and multi-tap gesture support
/// - **Gesture State**: Coordinated state management for multiple gestures
/// - **Haptic Feedback**: Integrated haptic feedback with customizable styles
/// - **Accessibility**: VoiceOver alternatives and reduced motion support
///
/// ## Quick Start
///
/// ### Swipe Gesture
/// ```swift
/// Rectangle()
///     .onSwipe(.left) { print("swiped left") }
///     .onSwipe(.right) { print("swiped right") }
///
/// // Or handle multiple directions
/// Rectangle()
///     .onSwipe(handlers: [
///         .left: { handleLeft() },
///         .right: { handleRight() },
///         .up: { handleUp() },
///         .down: { handleDown() }
///     ])
/// ```
///
/// ### Long Press
/// ```swift
/// Circle()
///     .onLongPress(minimumDuration: 0.5) {
///         showContextMenu()
///     }
///
/// // With state tracking
/// @State var pressState: LongPressState = .inactive
///
/// Circle()
///     .onLongPress(state: $pressState, configuration: .quick) {
///         handleLongPress()
///     }
/// ```
///
/// ### Pinch to Zoom
/// ```swift
/// @State var scale: CGFloat = 1.0
///
/// Image("photo")
///     .pinchToZoom(scale: $scale)
///
/// // With offset for panning
/// @State var offset: CGSize = .zero
///
/// ZoomableContainer(scale: $scale, offset: $offset) {
///     Image("photo")
/// }
/// ```
///
/// ### Double Tap
/// ```swift
/// Rectangle()
///     .onDoubleTap {
///         toggleFavorite()
///     }
///
/// // Toggle a boolean
/// @State var isFavorite = false
///
/// Rectangle()
///     .doubleTapToggle($isFavorite)
/// ```
///
/// ## Configuration
///
/// All gestures support customizable configurations:
///
/// ```swift
/// // Swipe configuration
/// let swipeConfig = SwipeConfiguration(
///     minimumDistance: 50,
///     maximumAngle: 30,
///     hapticFeedback: true,
///     hapticStyle: .light
/// )
///
/// // Long press configuration
/// let longPressConfig = LongPressConfiguration(
///     minimumDuration: 0.5,
///     maximumDistance: 10,
///     hapticFeedback: true,
///     hapticStyle: .medium,
///     hapticOnStart: false
/// )
///
/// // Pinch configuration
/// let pinchConfig = PinchConfiguration(
///     minScale: 0.5,
///     maxScale: 4.0,
///     animated: true,
///     snapToIdentity: true,
///     snapThreshold: 0.1
/// )
/// ```
///
/// ## Haptic Feedback
///
/// Control haptic feedback globally or per-gesture:
///
/// ```swift
/// // Disable globally
/// HapticManager.shared.isEnabled = false
///
/// // Per-gesture configuration
/// .onSwipe(.left, configuration: SwipeConfiguration(hapticFeedback: false)) {
///     handleSwipe()
/// }
///
/// // Environment-based preferences
/// ContentView()
///     .hapticPreferences(.minimal)
/// ```
///
/// ## Accessibility
///
/// All gestures automatically provide VoiceOver alternatives. Additional support:
///
/// ```swift
/// // Custom accessibility actions
/// Rectangle()
///     .accessibilityGestureAction("Delete item") {
///         deleteItem()
///     }
///
/// // Reduced motion support
/// Rectangle()
///     .reducedMotionFriendly()
/// ```
///
/// ## Gesture Coordination
///
/// Manage multiple gestures with the gesture state manager:
///
/// ```swift
/// @StateObject var gestureManager = GestureStateManager()
///
/// ContentView()
///     .gestureStateManager(gestureManager)
/// ```

// Re-export all public types
@_exported import SwiftUI

// MARK: - Module Version

/// The version of the GestureUtilities library.
public let gestureUtilitiesVersion = "1.0.0"

// MARK: - Convenience Type Aliases

/// A handler closure for gesture actions.
public typealias GestureHandler = () -> Void

/// A handler closure for gesture actions with a location.
public typealias GestureLocationHandler = (CGPoint) -> Void

/// A handler closure for scale changes.
public typealias ScaleChangeHandler = (CGFloat) -> Void
