import SwiftUI

// MARK: - Keyframe Animation Helper

/// A helper for creating multi-step keyframe animations
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct DSKeyframeAnimation<Value: Animatable> {
    public let keyframes: [Keyframe<Value>]
    public let duration: Double
    public let repeatCount: Int
    public let autoreverses: Bool

    public init(
        keyframes: [Keyframe<Value>],
        duration: Double = 1.0,
        repeatCount: Int = 1,
        autoreverses: Bool = false
    ) {
        self.keyframes = keyframes
        self.duration = duration
        self.repeatCount = repeatCount
        self.autoreverses = autoreverses
    }

    public struct Keyframe<T> {
        public let value: T
        public let duration: Double
        public let timingFunction: TimingFunction

        public init(value: T, duration: Double = 0.25, timingFunction: TimingFunction = .easeInOut) {
            self.value = value
            self.duration = duration
            self.timingFunction = timingFunction
        }
    }

    public enum TimingFunction {
        case linear
        case easeIn
        case easeOut
        case easeInOut
        case spring(response: Double, dampingFraction: Double)
    }
}

// MARK: - Keyframe Preset Animations

/// Preset keyframe animations for common use cases
public struct DSKeyframePresets {
    private init() {}

    // MARK: - Shake Animation

    /// Shake animation values for horizontal shake
    public static let shakeOffsets: [CGFloat] = [0, -10, 10, -10, 10, -5, 5, -2, 2, 0]

    /// Shake animation duration
    public static let shakeDuration: Double = 0.6

    // MARK: - Bounce Animation

    /// Bounce animation scale values
    public static let bounceScales: [CGFloat] = [1, 1.2, 0.9, 1.1, 0.95, 1.02, 1]

    /// Bounce animation duration
    public static let bounceDuration: Double = 0.6

    // MARK: - Pulse Animation

    /// Pulse animation scale values
    public static let pulseScales: [CGFloat] = [1, 1.1, 1, 1.1, 1]

    /// Pulse animation opacity values
    public static let pulseOpacities: [Double] = [1, 0.7, 1, 0.7, 1]

    /// Pulse animation duration
    public static let pulseDuration: Double = 1.0

    // MARK: - Wiggle Animation

    /// Wiggle rotation angles in degrees
    public static let wiggleAngles: [Double] = [0, -5, 5, -5, 5, -3, 3, -1, 1, 0]

    /// Wiggle animation duration
    public static let wiggleDuration: Double = 0.5

    // MARK: - Heartbeat Animation

    /// Heartbeat scale values
    public static let heartbeatScales: [CGFloat] = [1, 1.3, 1, 1.15, 1]

    /// Heartbeat animation duration
    public static let heartbeatDuration: Double = 0.8

    // MARK: - Jello Animation

    /// Jello skew values for X
    public static let jelloSkewX: [CGFloat] = [0, -0.25, 0.25, -0.125, 0.125, -0.0625, 0.0625, 0]

    /// Jello animation duration
    public static let jelloDuration: Double = 0.9
}

// MARK: - Keyframe Animation Modifier

/// A view modifier that applies keyframe-based shake animation
public struct ShakeModifier: ViewModifier {
    @State private var shakeOffset: CGFloat = 0
    let isShaking: Bool
    let intensity: CGFloat

    public init(isShaking: Bool, intensity: CGFloat = 1.0) {
        self.isShaking = isShaking
        self.intensity = intensity
    }

    public func body(content: Content) -> some View {
        content
            .offset(x: shakeOffset * intensity)
            .onChange(of: isShaking) { _, newValue in
                if newValue {
                    performShake()
                }
            }
    }

    private func performShake() {
        let offsets = DSKeyframePresets.shakeOffsets
        let totalDuration = DSKeyframePresets.shakeDuration
        let stepDuration = totalDuration / Double(offsets.count)

        for (index, offset) in offsets.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(index)) {
                withAnimation(.linear(duration: stepDuration)) {
                    shakeOffset = offset
                }
            }
        }
    }
}

/// A view modifier that applies keyframe-based bounce animation
public struct BounceAnimationModifier: ViewModifier {
    @State private var scale: CGFloat = 1
    let isBouncing: Bool
    let intensity: CGFloat

    public init(isBouncing: Bool, intensity: CGFloat = 1.0) {
        self.isBouncing = isBouncing
        self.intensity = intensity
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onChange(of: isBouncing) { _, newValue in
                if newValue {
                    performBounce()
                }
            }
    }

    private func performBounce() {
        let scales = DSKeyframePresets.bounceScales.map { 1 + ($0 - 1) * intensity }
        let totalDuration = DSKeyframePresets.bounceDuration
        let stepDuration = totalDuration / Double(scales.count)

        for (index, scaleValue) in scales.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(index)) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                    scale = scaleValue
                }
            }
        }
    }
}

/// A view modifier that applies continuous pulse animation
public struct PulseAnimationModifier: ViewModifier {
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    let isPulsing: Bool

    public init(isPulsing: Bool) {
        self.isPulsing = isPulsing
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                if isPulsing {
                    startPulsing()
                }
            }
            .onChange(of: isPulsing) { _, newValue in
                if newValue {
                    startPulsing()
                } else {
                    stopPulsing()
                }
            }
    }

    private func startPulsing() {
        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            scale = 1.1
            opacity = 0.7
        }
    }

    private func stopPulsing() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = 1
            opacity = 1
        }
    }
}

/// A view modifier that applies wiggle animation
public struct WiggleModifier: ViewModifier {
    @State private var rotation: Double = 0
    let isWiggling: Bool

    public init(isWiggling: Bool) {
        self.isWiggling = isWiggling
    }

    public func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation))
            .onChange(of: isWiggling) { _, newValue in
                if newValue {
                    performWiggle()
                }
            }
    }

    private func performWiggle() {
        let angles = DSKeyframePresets.wiggleAngles
        let totalDuration = DSKeyframePresets.wiggleDuration
        let stepDuration = totalDuration / Double(angles.count)

        for (index, angle) in angles.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(index)) {
                withAnimation(.linear(duration: stepDuration)) {
                    rotation = angle
                }
            }
        }
    }
}

/// A view modifier that applies heartbeat animation
public struct HeartbeatModifier: ViewModifier {
    @State private var scale: CGFloat = 1
    let isBeating: Bool
    let continuous: Bool

    public init(isBeating: Bool, continuous: Bool = false) {
        self.isBeating = isBeating
        self.continuous = continuous
    }

    public func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onAppear {
                if isBeating && continuous {
                    startContinuousHeartbeat()
                }
            }
            .onChange(of: isBeating) { _, newValue in
                if newValue {
                    if continuous {
                        startContinuousHeartbeat()
                    } else {
                        performHeartbeat()
                    }
                } else {
                    stopHeartbeat()
                }
            }
    }

    private func performHeartbeat() {
        let scales = DSKeyframePresets.heartbeatScales
        let totalDuration = DSKeyframePresets.heartbeatDuration
        let stepDuration = totalDuration / Double(scales.count)

        for (index, scaleValue) in scales.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(index)) {
                withAnimation(.easeInOut(duration: stepDuration)) {
                    scale = scaleValue
                }
            }
        }
    }

    private func startContinuousHeartbeat() {
        performHeartbeat()
        DispatchQueue.main.asyncAfter(deadline: .now() + DSKeyframePresets.heartbeatDuration) {
            if isBeating && continuous {
                startContinuousHeartbeat()
            }
        }
    }

    private func stopHeartbeat() {
        withAnimation(.easeInOut(duration: 0.2)) {
            scale = 1
        }
    }
}

// MARK: - View Extensions

public extension View {
    /// Apply shake animation
    func dsShake(isActive: Bool, intensity: CGFloat = 1.0) -> some View {
        modifier(ShakeModifier(isShaking: isActive, intensity: intensity))
    }

    /// Apply bounce animation
    func dsBounce(isActive: Bool, intensity: CGFloat = 1.0) -> some View {
        modifier(BounceAnimationModifier(isBouncing: isActive, intensity: intensity))
    }

    /// Apply pulse animation
    func dsPulse(isActive: Bool) -> some View {
        modifier(PulseAnimationModifier(isPulsing: isActive))
    }

    /// Apply wiggle animation
    func dsWiggle(isActive: Bool) -> some View {
        modifier(WiggleModifier(isWiggling: isActive))
    }

    /// Apply heartbeat animation
    func dsHeartbeat(isActive: Bool, continuous: Bool = false) -> some View {
        modifier(HeartbeatModifier(isBeating: isActive, continuous: continuous))
    }
}
