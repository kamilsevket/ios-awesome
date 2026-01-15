import SwiftUI

// MARK: - Lottie Loop Mode

/// Loop mode options for Lottie animations
public enum DSLottieLoopMode: Equatable {
    /// Play the animation once and stop
    case playOnce

    /// Loop the animation indefinitely
    case loop

    /// Loop the animation indefinitely, reversing at each end
    case autoReverse

    /// Play the animation a specific number of times
    case `repeat`(count: Float)

    /// Play from a specific progress to another progress once
    case playRange(from: CGFloat, to: CGFloat)
}

// MARK: - Lottie Content Mode

/// Content mode for Lottie animation scaling
public enum DSLottieContentMode {
    case scaleToFill
    case scaleAspectFit
    case scaleAspectFill

    var swiftUIContentMode: ContentMode {
        switch self {
        case .scaleToFill, .scaleAspectFill:
            return .fill
        case .scaleAspectFit:
            return .fit
        }
    }
}

// MARK: - Lottie Animation Source

/// Source for Lottie animation
public enum DSLottieAnimationSource: Equatable {
    /// Animation from a local file name (without extension)
    case name(String)

    /// Animation from a file path
    case filepath(String)

    /// Animation from a URL
    case url(URL)

    /// Animation from a bundle resource
    case bundle(name: String, bundle: Bundle)
}

// MARK: - Lottie View State

/// State of the Lottie animation
public enum DSLottieAnimationState: Equatable {
    case loading
    case playing
    case paused
    case stopped
    case completed
    case failed(Error)

    public static func == (lhs: DSLottieAnimationState, rhs: DSLottieAnimationState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading),
             (.playing, .playing),
             (.paused, .paused),
             (.stopped, .stopped),
             (.completed, .completed):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

// MARK: - Lottie View Configuration

/// Configuration for DSLottieView
public struct DSLottieConfiguration {
    public let source: DSLottieAnimationSource
    public var loopMode: DSLottieLoopMode
    public var speed: CGFloat
    public var contentMode: DSLottieContentMode
    public var autoPlay: Bool
    public var respectReduceMotion: Bool

    public init(
        source: DSLottieAnimationSource,
        loopMode: DSLottieLoopMode = .playOnce,
        speed: CGFloat = 1.0,
        contentMode: DSLottieContentMode = .scaleAspectFit,
        autoPlay: Bool = true,
        respectReduceMotion: Bool = true
    ) {
        self.source = source
        self.loopMode = loopMode
        self.speed = speed
        self.contentMode = contentMode
        self.autoPlay = autoPlay
        self.respectReduceMotion = respectReduceMotion
    }
}

// MARK: - Lottie View Protocol

/// Protocol for Lottie animation control
public protocol DSLottieAnimatable: AnyObject {
    func play()
    func play(fromProgress: CGFloat, toProgress: CGFloat)
    func pause()
    func stop()
    func setProgress(_ progress: CGFloat)
    var currentProgress: CGFloat { get }
    var isPlaying: Bool { get }
}

// MARK: - DSLottieView

/// A SwiftUI wrapper for Lottie animations
/// This is a placeholder implementation that can be connected to the actual Lottie library
public struct DSLottieView: View {
    private let configuration: DSLottieConfiguration
    @Binding private var animationState: DSLottieAnimationState
    @State private var isAnimating = false
    private var onStateChange: ((DSLottieAnimationState) -> Void)?
    private var onComplete: (() -> Void)?

    // MARK: - Initialization

    /// Initialize with animation name
    public init(
        animation name: String,
        bundle: Bundle = .main,
        loopMode: DSLottieLoopMode = .playOnce,
        speed: CGFloat = 1.0,
        contentMode: DSLottieContentMode = .scaleAspectFit,
        autoPlay: Bool = true,
        respectReduceMotion: Bool = true
    ) {
        self.configuration = DSLottieConfiguration(
            source: .bundle(name: name, bundle: bundle),
            loopMode: loopMode,
            speed: speed,
            contentMode: contentMode,
            autoPlay: autoPlay,
            respectReduceMotion: respectReduceMotion
        )
        self._animationState = .constant(.stopped)
    }

    /// Initialize with configuration
    public init(
        configuration: DSLottieConfiguration,
        animationState: Binding<DSLottieAnimationState> = .constant(.stopped)
    ) {
        self.configuration = configuration
        self._animationState = animationState
    }

    /// Initialize with URL
    public init(
        url: URL,
        loopMode: DSLottieLoopMode = .playOnce,
        speed: CGFloat = 1.0,
        autoPlay: Bool = true
    ) {
        self.configuration = DSLottieConfiguration(
            source: .url(url),
            loopMode: loopMode,
            speed: speed,
            autoPlay: autoPlay
        )
        self._animationState = .constant(.stopped)
    }

    public var body: some View {
        LottieViewRepresentable(
            configuration: configuration,
            isAnimating: $isAnimating,
            onStateChange: { state in
                animationState = state
                onStateChange?(state)
                if state == .completed {
                    onComplete?()
                }
            }
        )
        .onAppear {
            if configuration.autoPlay && shouldAnimate {
                isAnimating = true
            }
        }
    }

    private var shouldAnimate: Bool {
        if configuration.respectReduceMotion && UIAccessibility.isReduceMotionEnabled {
            return false
        }
        return true
    }

    // MARK: - Modifiers

    /// Set the loop mode
    public func loopMode(_ mode: DSLottieLoopMode) -> DSLottieView {
        var newConfig = configuration
        newConfig.loopMode = mode
        return DSLottieView(configuration: newConfig, animationState: $animationState)
    }

    /// Set the animation speed
    public func speed(_ speed: CGFloat) -> DSLottieView {
        var newConfig = configuration
        newConfig.speed = speed
        return DSLottieView(configuration: newConfig, animationState: $animationState)
    }

    /// Set callback for state changes
    public func onStateChange(_ handler: @escaping (DSLottieAnimationState) -> Void) -> DSLottieView {
        var view = self
        view.onStateChange = handler
        return view
    }

    /// Set callback for animation completion
    public func onComplete(_ handler: @escaping () -> Void) -> DSLottieView {
        var view = self
        view.onComplete = handler
        return view
    }

    /// Whether to respect reduce motion setting
    public func respectReduceMotion(_ respect: Bool) -> DSLottieView {
        var newConfig = configuration
        newConfig.respectReduceMotion = respect
        return DSLottieView(configuration: newConfig, animationState: $animationState)
    }
}

// MARK: - Lottie View Representable (Placeholder)

/// A UIViewRepresentable wrapper for Lottie
/// Note: This is a placeholder implementation. Connect to actual Lottie library for full functionality.
private struct LottieViewRepresentable: UIViewRepresentable {
    let configuration: DSLottieConfiguration
    @Binding var isAnimating: Bool
    var onStateChange: ((DSLottieAnimationState) -> Void)?

    func makeUIView(context: Context) -> LottiePlaceholderView {
        let view = LottiePlaceholderView()
        view.configuration = configuration
        view.onStateChange = onStateChange
        return view
    }

    func updateUIView(_ uiView: LottiePlaceholderView, context: Context) {
        if isAnimating {
            uiView.play()
        } else {
            uiView.pause()
        }
    }
}

/// Placeholder view for Lottie integration
/// Replace this with actual Lottie.AnimationView when integrating the library
private class LottiePlaceholderView: UIView {
    var configuration: DSLottieConfiguration?
    var onStateChange: ((DSLottieAnimationState) -> Void)?

    private var isPlaying = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        // Note: In actual implementation, create Lottie.AnimationView here
        // and configure it with the animation source
    }

    func play() {
        guard !isPlaying else { return }
        isPlaying = true
        onStateChange?(.playing)
        // Note: In actual implementation, call animationView.play()
    }

    func pause() {
        guard isPlaying else { return }
        isPlaying = false
        onStateChange?(.paused)
        // Note: In actual implementation, call animationView.pause()
    }

    func stop() {
        isPlaying = false
        onStateChange?(.stopped)
        // Note: In actual implementation, call animationView.stop()
    }
}

// MARK: - Convenience Extensions

public extension DSLottieView {
    /// Create a loading animation
    static func loading(
        name: String = "loading",
        bundle: Bundle = .main,
        size: CGFloat = 48
    ) -> some View {
        DSLottieView(animation: name, bundle: bundle, loopMode: .loop)
            .frame(width: size, height: size)
    }

    /// Create a success animation
    static func success(
        name: String = "success",
        bundle: Bundle = .main,
        size: CGFloat = 64
    ) -> some View {
        DSLottieView(animation: name, bundle: bundle, loopMode: .playOnce)
            .frame(width: size, height: size)
    }

    /// Create an error animation
    static func error(
        name: String = "error",
        bundle: Bundle = .main,
        size: CGFloat = 64
    ) -> some View {
        DSLottieView(animation: name, bundle: bundle, loopMode: .playOnce)
            .frame(width: size, height: size)
    }

    /// Create an empty state animation
    static func emptyState(
        name: String = "empty",
        bundle: Bundle = .main
    ) -> some View {
        DSLottieView(animation: name, bundle: bundle, loopMode: .loop, speed: 0.5)
            .frame(maxWidth: 200, maxHeight: 200)
    }
}

// MARK: - Preview Helpers

#if DEBUG
public extension DSLottieView {
    /// Create a preview placeholder
    static func preview(
        loopMode: DSLottieLoopMode = .loop,
        color: Color = .blue
    ) -> some View {
        AnimationPlaceholderView(loopMode: loopMode, color: color)
    }
}

private struct AnimationPlaceholderView: View {
    let loopMode: DSLottieLoopMode
    let color: Color
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .fill(color.opacity(0.3))
            .overlay(
                Circle()
                    .stroke(color, lineWidth: 3)
                    .scaleEffect(isAnimating ? 1.2 : 1)
                    .opacity(isAnimating ? 0 : 1)
            )
            .onAppear {
                if case .loop = loopMode {
                    withAnimation(.easeOut(duration: 1).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                } else if case .playOnce = loopMode {
                    withAnimation(.easeOut(duration: 1)) {
                        isAnimating = true
                    }
                }
            }
    }
}
#endif
