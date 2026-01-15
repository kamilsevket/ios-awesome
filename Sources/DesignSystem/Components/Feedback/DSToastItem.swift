import SwiftUI

// MARK: - DSToastItem

/// Represents a single toast/snackbar item in the queue
public struct DSToastItem: Identifiable, Equatable {

    // MARK: - Properties

    public let id: UUID
    public let message: String
    public let type: DSToastType
    public let icon: String?
    public let duration: DSToastDuration
    public let actionTitle: String?
    public let action: (() -> Void)?

    // MARK: - Initialization

    /// Creates a toast item
    /// - Parameters:
    ///   - id: Unique identifier (auto-generated if not provided)
    ///   - message: The message to display
    ///   - type: Toast type (default: .info)
    ///   - icon: Optional custom icon
    ///   - duration: Display duration (default: .short)
    ///   - actionTitle: Optional action button title
    ///   - action: Optional action callback
    public init(
        id: UUID = UUID(),
        message: String,
        type: DSToastType = .info,
        icon: String? = nil,
        duration: DSToastDuration = .short,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.id = id
        self.message = message
        self.type = type
        self.icon = icon
        self.duration = duration
        self.actionTitle = actionTitle
        self.action = action
    }

    // MARK: - Equatable

    public static func == (lhs: DSToastItem, rhs: DSToastItem) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Convenience Factory Methods

    /// Creates a success toast
    public static func success(
        _ message: String,
        icon: String? = nil,
        duration: DSToastDuration = .short
    ) -> DSToastItem {
        DSToastItem(message: message, type: .success, icon: icon, duration: duration)
    }

    /// Creates an error toast
    public static func error(
        _ message: String,
        icon: String? = nil,
        duration: DSToastDuration = .long
    ) -> DSToastItem {
        DSToastItem(message: message, type: .error, icon: icon, duration: duration)
    }

    /// Creates a warning toast
    public static func warning(
        _ message: String,
        icon: String? = nil,
        duration: DSToastDuration = .long
    ) -> DSToastItem {
        DSToastItem(message: message, type: .warning, icon: icon, duration: duration)
    }

    /// Creates an info toast
    public static func info(
        _ message: String,
        icon: String? = nil,
        duration: DSToastDuration = .short
    ) -> DSToastItem {
        DSToastItem(message: message, type: .info, icon: icon, duration: duration)
    }

    /// Creates a snackbar with action
    public static func snackbar(
        _ message: String,
        type: DSToastType = .info,
        actionTitle: String,
        duration: DSToastDuration = .long,
        action: @escaping () -> Void
    ) -> DSToastItem {
        DSToastItem(
            message: message,
            type: type,
            duration: duration,
            actionTitle: actionTitle,
            action: action
        )
    }
}
