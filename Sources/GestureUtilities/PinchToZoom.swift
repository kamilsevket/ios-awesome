import SwiftUI

// MARK: - Pinch Configuration

/// Configuration options for pinch to zoom gesture behavior.
public struct PinchConfiguration {
    /// Minimum scale allowed.
    public var minScale: CGFloat

    /// Maximum scale allowed.
    public var maxScale: CGFloat

    /// Whether to animate scale changes.
    public var animated: Bool

    /// Animation duration for scale changes.
    public var animationDuration: TimeInterval

    /// Whether to trigger haptic feedback at scale limits.
    public var hapticFeedback: Bool

    /// The haptic feedback style for scale limits.
    public var hapticStyle: HapticStyle

    /// Whether to snap to 1.0 when close.
    public var snapToIdentity: Bool

    /// The threshold for snapping to identity scale.
    public var snapThreshold: CGFloat

    /// Default configuration.
    public static let `default` = PinchConfiguration(
        minScale: 0.5,
        maxScale: 4.0,
        animated: true,
        animationDuration: 0.2,
        hapticFeedback: true,
        hapticStyle: .light,
        snapToIdentity: true,
        snapThreshold: 0.1
    )

    /// Photo viewer configuration with wider range.
    public static let photoViewer = PinchConfiguration(
        minScale: 0.25,
        maxScale: 10.0,
        animated: true,
        animationDuration: 0.25,
        hapticFeedback: true,
        hapticStyle: .light,
        snapToIdentity: true,
        snapThreshold: 0.15
    )

    /// Restricted configuration with limited range.
    public static let restricted = PinchConfiguration(
        minScale: 0.8,
        maxScale: 2.0,
        animated: true,
        animationDuration: 0.15,
        hapticFeedback: true,
        hapticStyle: .medium,
        snapToIdentity: false,
        snapThreshold: 0
    )

    public init(
        minScale: CGFloat = 0.5,
        maxScale: CGFloat = 4.0,
        animated: Bool = true,
        animationDuration: TimeInterval = 0.2,
        hapticFeedback: Bool = true,
        hapticStyle: HapticStyle = .light,
        snapToIdentity: Bool = true,
        snapThreshold: CGFloat = 0.1
    ) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.animated = animated
        self.animationDuration = animationDuration
        self.hapticFeedback = hapticFeedback
        self.hapticStyle = hapticStyle
        self.snapToIdentity = snapToIdentity
        self.snapThreshold = snapThreshold
    }
}

// MARK: - Pinch State

/// Represents the current state of a pinch gesture.
public enum PinchState: Equatable {
    case inactive
    case zooming(scale: CGFloat)
    case ended(finalScale: CGFloat)
}

// MARK: - Pinch to Zoom Modifier

/// A view modifier that handles pinch to zoom gestures.
public struct PinchToZoomModifier: ViewModifier {
    @Binding var scale: CGFloat
    let configuration: PinchConfiguration
    let onScaleChange: ((CGFloat) -> Void)?

    @State private var lastScale: CGFloat = 1.0
    @State private var hasTriggeredMinHaptic = false
    @State private var hasTriggeredMaxHaptic = false

    public init(
        scale: Binding<CGFloat>,
        configuration: PinchConfiguration = .default,
        onScaleChange: ((CGFloat) -> Void)? = nil
    ) {
        self._scale = scale
        self.configuration = configuration
        self.onScaleChange = onScaleChange
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = lastScale * value
                        let clampedScale = clampScale(newScale)

                        triggerBoundaryHaptics(for: newScale)

                        if configuration.animated {
                            withAnimation(.easeOut(duration: 0.1)) {
                                scale = clampedScale
                            }
                        } else {
                            scale = clampedScale
                        }

                        onScaleChange?(clampedScale)
                    }
                    .onEnded { _ in
                        lastScale = scale

                        // Snap to identity if enabled and close enough
                        if configuration.snapToIdentity && abs(scale - 1.0) < configuration.snapThreshold {
                            if configuration.animated {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    scale = 1.0
                                }
                            } else {
                                scale = 1.0
                            }
                            lastScale = 1.0

                            if configuration.hapticFeedback {
                                Task { @MainActor in
                                    HapticManager.shared.trigger(.light)
                                }
                            }
                        }

                        hasTriggeredMinHaptic = false
                        hasTriggeredMaxHaptic = false
                        onScaleChange?(scale)
                    }
            )
            .accessibilityAction(named: "Zoom in") {
                adjustScale(by: 0.5)
            }
            .accessibilityAction(named: "Zoom out") {
                adjustScale(by: -0.5)
            }
            .accessibilityAction(named: "Reset zoom") {
                resetScale()
            }
    }

    private func clampScale(_ value: CGFloat) -> CGFloat {
        min(max(value, configuration.minScale), configuration.maxScale)
    }

    private func triggerBoundaryHaptics(for newScale: CGFloat) {
        guard configuration.hapticFeedback else { return }

        if newScale <= configuration.minScale && !hasTriggeredMinHaptic {
            Task { @MainActor in
                HapticManager.shared.trigger(configuration.hapticStyle)
            }
            hasTriggeredMinHaptic = true
        } else if newScale > configuration.minScale {
            hasTriggeredMinHaptic = false
        }

        if newScale >= configuration.maxScale && !hasTriggeredMaxHaptic {
            Task { @MainActor in
                HapticManager.shared.trigger(configuration.hapticStyle)
            }
            hasTriggeredMaxHaptic = true
        } else if newScale < configuration.maxScale {
            hasTriggeredMaxHaptic = false
        }
    }

    private func adjustScale(by delta: CGFloat) {
        let newScale = clampScale(scale + delta)
        if configuration.animated {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = newScale
            }
        } else {
            scale = newScale
        }
        lastScale = newScale
        onScaleChange?(newScale)
    }

    private func resetScale() {
        if configuration.animated {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1.0
            }
        } else {
            scale = 1.0
        }
        lastScale = 1.0
        onScaleChange?(1.0)
    }
}

// MARK: - Pinch to Zoom with State Modifier

/// A view modifier that provides pinch state tracking.
public struct PinchToZoomStateModifier: ViewModifier {
    @Binding var scale: CGFloat
    @Binding var state: PinchState
    let configuration: PinchConfiguration

    @State private var lastScale: CGFloat = 1.0

    public init(
        scale: Binding<CGFloat>,
        state: Binding<PinchState>,
        configuration: PinchConfiguration = .default
    ) {
        self._scale = scale
        self._state = state
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = lastScale * value
                        let clampedScale = clampScale(newScale)
                        scale = clampedScale
                        state = .zooming(scale: clampedScale)
                    }
                    .onEnded { _ in
                        lastScale = scale

                        if configuration.snapToIdentity && abs(scale - 1.0) < configuration.snapThreshold {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                scale = 1.0
                            }
                            lastScale = 1.0
                        }

                        state = .ended(finalScale: scale)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            state = .inactive
                        }
                    }
            )
    }

    private func clampScale(_ value: CGFloat) -> CGFloat {
        min(max(value, configuration.minScale), configuration.maxScale)
    }
}

// MARK: - Zoomable Container

/// A container view that provides pinch-to-zoom functionality with offset support.
public struct ZoomableContainer<Content: View>: View {
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    let configuration: PinchConfiguration
    let content: () -> Content

    @State private var lastScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero

    public init(
        scale: Binding<CGFloat>,
        offset: Binding<CGSize>,
        configuration: PinchConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._scale = scale
        self._offset = offset
        self.configuration = configuration
        self.content = content
    }

    public var body: some View {
        content()
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                SimultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let newScale = lastScale * value
                            scale = clampScale(newScale)
                        }
                        .onEnded { _ in
                            lastScale = scale
                            handleSnapToIdentity()
                        },
                    DragGesture()
                        .onChanged { value in
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
            )
            .accessibilityAction(named: "Zoom in") {
                adjustScale(by: 0.5)
            }
            .accessibilityAction(named: "Zoom out") {
                adjustScale(by: -0.5)
            }
            .accessibilityAction(named: "Reset view") {
                resetView()
            }
    }

    private func clampScale(_ value: CGFloat) -> CGFloat {
        min(max(value, configuration.minScale), configuration.maxScale)
    }

    private func handleSnapToIdentity() {
        if configuration.snapToIdentity && abs(scale - 1.0) < configuration.snapThreshold {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1.0
                offset = .zero
            }
            lastScale = 1.0
            lastOffset = .zero

            if configuration.hapticFeedback {
                Task { @MainActor in
                    HapticManager.shared.trigger(.light)
                }
            }
        }
    }

    private func adjustScale(by delta: CGFloat) {
        let newScale = clampScale(scale + delta)
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            scale = newScale
        }
        lastScale = newScale
    }

    private func resetView() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            scale = 1.0
            offset = .zero
        }
        lastScale = 1.0
        lastOffset = .zero
    }
}

// MARK: - View Extensions

public extension View {
    /// Adds pinch to zoom functionality.
    /// - Parameters:
    ///   - scale: A binding to the current scale.
    ///   - configuration: Configuration options for the pinch gesture.
    ///   - onScaleChange: Optional callback when scale changes.
    /// - Returns: A view with pinch to zoom functionality.
    func pinchToZoom(
        scale: Binding<CGFloat>,
        configuration: PinchConfiguration = .default,
        onScaleChange: ((CGFloat) -> Void)? = nil
    ) -> some View {
        modifier(PinchToZoomModifier(
            scale: scale,
            configuration: configuration,
            onScaleChange: onScaleChange
        ))
    }

    /// Adds pinch to zoom functionality with state tracking.
    /// - Parameters:
    ///   - scale: A binding to the current scale.
    ///   - state: A binding to track the pinch state.
    ///   - configuration: Configuration options for the pinch gesture.
    /// - Returns: A view with pinch to zoom functionality and state tracking.
    func pinchToZoom(
        scale: Binding<CGFloat>,
        state: Binding<PinchState>,
        configuration: PinchConfiguration = .default
    ) -> some View {
        modifier(PinchToZoomStateModifier(
            scale: scale,
            state: state,
            configuration: configuration
        ))
    }
}
