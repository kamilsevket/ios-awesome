import SwiftUI
import Combine

// MARK: - Auto-scroll State

/// Observable state for managing auto-scroll behavior.
@MainActor
public final class DSAutoScrollState: ObservableObject {
    /// Whether auto-scroll is currently active.
    @Published public private(set) var isActive: Bool = false

    /// Whether auto-scroll is paused (e.g., due to user interaction).
    @Published public private(set) var isPaused: Bool = false

    /// The current interval between auto-scroll actions.
    public let interval: TimeInterval

    /// Whether to pause on user interaction.
    public let pauseOnInteraction: Bool

    /// Resume delay after user interaction.
    public let resumeDelay: TimeInterval

    private var timer: Timer?
    private var resumeTask: Task<Void, Never>?
    private let onTick: () -> Void

    /// Creates an auto-scroll state manager.
    /// - Parameters:
    ///   - interval: Time between auto-scroll actions
    ///   - pauseOnInteraction: Whether to pause when user interacts
    ///   - resumeDelay: Delay before resuming after interaction
    ///   - onTick: Callback executed on each auto-scroll tick
    public init(
        interval: TimeInterval = 3.0,
        pauseOnInteraction: Bool = true,
        resumeDelay: TimeInterval = 2.0,
        onTick: @escaping () -> Void
    ) {
        self.interval = interval
        self.pauseOnInteraction = pauseOnInteraction
        self.resumeDelay = resumeDelay
        self.onTick = onTick
    }

    /// Starts the auto-scroll timer.
    public func start() {
        guard !isActive else { return }
        isActive = true
        isPaused = false
        scheduleTimer()
    }

    /// Stops the auto-scroll timer completely.
    public func stop() {
        isActive = false
        isPaused = false
        cancelTimer()
        cancelResumeTask()
    }

    /// Pauses the auto-scroll timer temporarily.
    public func pause() {
        guard isActive && !isPaused else { return }
        isPaused = true
        cancelTimer()
    }

    /// Resumes the auto-scroll timer.
    public func resume() {
        guard isActive && isPaused else { return }
        isPaused = false
        scheduleTimer()
    }

    /// Called when user interaction starts (e.g., drag begins).
    public func onInteractionStart() {
        guard pauseOnInteraction else { return }
        cancelResumeTask()
        pause()
    }

    /// Called when user interaction ends (e.g., drag ends).
    public func onInteractionEnd() {
        guard pauseOnInteraction && isActive else { return }
        scheduleResume()
    }

    private func scheduleTimer() {
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.onTick()
            }
        }
    }

    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func scheduleResume() {
        cancelResumeTask()
        resumeTask = Task { [weak self] in
            guard let self = self else { return }
            try? await Task.sleep(nanoseconds: UInt64(resumeDelay * 1_000_000_000))
            guard !Task.isCancelled else { return }
            resume()
        }
    }

    private func cancelResumeTask() {
        resumeTask?.cancel()
        resumeTask = nil
    }

    deinit {
        timer?.invalidate()
        resumeTask?.cancel()
    }
}

// MARK: - Auto-scroll View Modifier

/// A view modifier that adds auto-scroll behavior to a view.
public struct DSAutoScrollModifier: ViewModifier {
    @StateObject private var autoScrollState: DSAutoScrollState
    private let reduceMotion: Bool

    /// Creates an auto-scroll modifier.
    /// - Parameters:
    ///   - interval: Time between auto-scroll actions
    ///   - pauseOnInteraction: Whether to pause on user interaction
    ///   - resumeDelay: Delay before resuming after interaction
    ///   - reduceMotion: Whether reduce motion is enabled
    ///   - onTick: Callback for each auto-scroll tick
    public init(
        interval: TimeInterval,
        pauseOnInteraction: Bool = true,
        resumeDelay: TimeInterval = 2.0,
        reduceMotion: Bool = false,
        onTick: @escaping () -> Void
    ) {
        self._autoScrollState = StateObject(wrappedValue: DSAutoScrollState(
            interval: interval,
            pauseOnInteraction: pauseOnInteraction,
            resumeDelay: resumeDelay,
            onTick: onTick
        ))
        self.reduceMotion = reduceMotion
    }

    public func body(content: Content) -> some View {
        content
            .environment(\.dsAutoScrollState, autoScrollState)
            .onAppear {
                guard !reduceMotion else { return }
                autoScrollState.start()
            }
            .onDisappear {
                autoScrollState.stop()
            }
    }
}

// MARK: - Environment Key

private struct DSAutoScrollStateKey: EnvironmentKey {
    static let defaultValue: DSAutoScrollState? = nil
}

extension EnvironmentValues {
    /// The current auto-scroll state, if any.
    public var dsAutoScrollState: DSAutoScrollState? {
        get { self[DSAutoScrollStateKey.self] }
        set { self[DSAutoScrollStateKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {
    /// Adds auto-scroll behavior to the view.
    /// - Parameters:
    ///   - interval: Time between auto-scroll actions
    ///   - pauseOnInteraction: Whether to pause on user interaction
    ///   - resumeDelay: Delay before resuming after interaction
    ///   - reduceMotion: Whether reduce motion is enabled
    ///   - onTick: Callback for each auto-scroll tick
    /// - Returns: A view with auto-scroll behavior
    public func dsAutoScroll(
        interval: TimeInterval,
        pauseOnInteraction: Bool = true,
        resumeDelay: TimeInterval = 2.0,
        reduceMotion: Bool = false,
        onTick: @escaping () -> Void
    ) -> some View {
        modifier(DSAutoScrollModifier(
            interval: interval,
            pauseOnInteraction: pauseOnInteraction,
            resumeDelay: resumeDelay,
            reduceMotion: reduceMotion,
            onTick: onTick
        ))
    }
}

// MARK: - Auto-scroll Gesture Modifier

/// A view modifier that handles gesture-based auto-scroll pause/resume.
public struct DSAutoScrollGestureModifier: ViewModifier {
    @Environment(\.dsAutoScrollState) private var autoScrollState

    public init() {}

    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        autoScrollState?.onInteractionStart()
                    }
                    .onEnded { _ in
                        autoScrollState?.onInteractionEnd()
                    }
            )
    }
}

extension View {
    /// Adds gesture handling for auto-scroll pause/resume.
    /// Use this on interactive elements within an auto-scrolling container.
    public func dsAutoScrollGesture() -> some View {
        modifier(DSAutoScrollGestureModifier())
    }
}

// MARK: - Preview

#if DEBUG
struct DSAutoScroll_Previews: PreviewProvider {
    static var previews: some View {
        AutoScrollPreviewContainer()
            .previewDisplayName("Auto-scroll Demo")
    }
}

private struct AutoScrollPreviewContainer: View {
    @State private var currentIndex = 0
    @State private var isAutoScrollEnabled = true

    let items = ["First", "Second", "Third", "Fourth", "Fifth"]

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Text("Auto-scroll Demo")
                .font(.headline)

            Text("Current: \(items[currentIndex])")
                .font(.title2)
                .fontWeight(.semibold)

            DSPageIndicator(
                currentPage: currentIndex,
                totalPages: items.count,
                style: .capsule
            )

            HStack(spacing: Spacing.md) {
                Button(isAutoScrollEnabled ? "Pause" : "Resume") {
                    isAutoScrollEnabled.toggle()
                }
                .buttonStyle(.bordered)

                Button("Reset") {
                    currentIndex = 0
                }
                .buttonStyle(.bordered)
            }

            Text("Tap 'Pause' to stop auto-scroll")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .dsAutoScroll(
            interval: 2.0,
            pauseOnInteraction: true,
            resumeDelay: 3.0
        ) {
            guard isAutoScrollEnabled else { return }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }
}
#endif
