import SwiftUI
import Combine

// MARK: - DSToastManager

/// Singleton manager for toast and snackbar queue management
///
/// DSToastManager handles displaying toasts in a FIFO queue, auto-dismiss timing,
/// and provides a simple API for showing feedback messages.
///
/// Example usage:
/// ```swift
/// // Simple toast
/// DSToastManager.shared.show("Saved successfully", type: .success)
///
/// // Snackbar with action
/// DSToastManager.shared.showSnackbar(
///     "Item deleted",
///     actionTitle: "Undo"
/// ) {
///     restoreItem()
/// }
/// ```
@MainActor
public final class DSToastManager: ObservableObject {

    // MARK: - Singleton

    public static let shared = DSToastManager()

    // MARK: - Published Properties

    /// Current toast being displayed
    @Published public private(set) var currentToast: DSToastItem?

    /// Queue of pending toasts (FIFO)
    @Published public private(set) var queue: [DSToastItem] = []

    /// Position of toasts on screen
    @Published public var position: DSToastPosition = .bottom

    // MARK: - Private Properties

    private var dismissTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Constants

    private enum Constants {
        static let animationDuration: Double = 0.3
        static let delayBetweenToasts: Double = 0.2
    }

    // MARK: - Initialization

    private init() {}

    // MARK: - Public API

    /// Shows a toast message
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: Toast type (default: .info)
    ///   - icon: Optional custom icon
    ///   - duration: Display duration (default: .short)
    public func show(
        _ message: String,
        type: DSToastType = .info,
        icon: String? = nil,
        duration: DSToastDuration = .short
    ) {
        let item = DSToastItem(
            message: message,
            type: type,
            icon: icon,
            duration: duration
        )
        enqueue(item)
    }

    /// Shows a snackbar with an action button
    /// - Parameters:
    ///   - message: The message to display
    ///   - type: Toast type (default: .info)
    ///   - icon: Optional custom icon
    ///   - actionTitle: Title for the action button
    ///   - duration: Display duration (default: .long)
    ///   - action: Action to perform when button is tapped
    public func showSnackbar(
        _ message: String,
        type: DSToastType = .info,
        icon: String? = nil,
        actionTitle: String,
        duration: DSToastDuration = .long,
        action: @escaping () -> Void
    ) {
        let item = DSToastItem(
            message: message,
            type: type,
            icon: icon,
            duration: duration,
            actionTitle: actionTitle,
            action: action
        )
        enqueue(item)
    }

    /// Shows a pre-configured toast item
    /// - Parameter item: The toast item to display
    public func show(_ item: DSToastItem) {
        enqueue(item)
    }

    /// Dismisses the current toast
    /// - Parameter animated: Whether to animate the dismissal (default: true)
    public func dismiss(animated: Bool = true) {
        dismissTask?.cancel()
        dismissTask = nil

        if animated {
            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                currentToast = nil
            }
        } else {
            currentToast = nil
        }

        // Show next toast in queue after delay
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(Constants.delayBetweenToasts * 1_000_000_000))
            showNextInQueue()
        }
    }

    /// Clears all queued toasts
    public func clearQueue() {
        queue.removeAll()
    }

    /// Dismisses current toast and clears the queue
    public func dismissAll() {
        clearQueue()
        dismiss(animated: true)
    }

    // MARK: - Queue Management

    private func enqueue(_ item: DSToastItem) {
        queue.append(item)

        if currentToast == nil {
            showNextInQueue()
        }
    }

    private func showNextInQueue() {
        guard currentToast == nil, !queue.isEmpty else { return }

        let nextItem = queue.removeFirst()

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            currentToast = nextItem
        }

        startAutoDismissTimer(for: nextItem)
    }

    // MARK: - Auto-Dismiss Timer

    private func startAutoDismissTimer(for item: DSToastItem) {
        dismissTask?.cancel()

        guard item.duration != .indefinite else { return }

        dismissTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: UInt64(item.duration.seconds * 1_000_000_000))
                if currentToast?.id == item.id {
                    dismiss()
                }
            } catch {
                // Task was cancelled
            }
        }
    }
}

// MARK: - Convenience Static Methods

public extension DSToastManager {

    /// Shows a success toast
    static func success(_ message: String, icon: String? = nil) {
        shared.show(message, type: .success, icon: icon)
    }

    /// Shows an error toast
    static func error(_ message: String, icon: String? = nil) {
        shared.show(message, type: .error, icon: icon, duration: .long)
    }

    /// Shows a warning toast
    static func warning(_ message: String, icon: String? = nil) {
        shared.show(message, type: .warning, icon: icon, duration: .long)
    }

    /// Shows an info toast
    static func info(_ message: String, icon: String? = nil) {
        shared.show(message, type: .info, icon: icon)
    }
}
