import SwiftUI

// MARK: - DSToastType

/// Toast type determines the visual style and icon of the toast
public enum DSToastType {
    case success
    case error
    case warning
    case info
    case custom(icon: String?, backgroundColor: Color, textColor: Color)

    // MARK: - Properties

    /// System icon name for the toast type
    public var iconName: String? {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .info:
            return "info.circle.fill"
        case .custom(let icon, _, _):
            return icon
        }
    }

    /// Background color for light mode
    public var backgroundColor: Color {
        switch self {
        case .success:
            return DSColors.success
        case .error:
            return DSColors.error
        case .warning:
            return DSColors.warning
        case .info:
            return DSColors.info
        case .custom(_, let backgroundColor, _):
            return backgroundColor
        }
    }

    /// Text and icon color
    public var foregroundColor: Color {
        switch self {
        case .success, .error, .info:
            return DSColors.textInverse
        case .warning:
            return DSColors.textPrimary
        case .custom(_, _, let textColor):
            return textColor
        }
    }

    /// Accessibility label prefix
    public var accessibilityPrefix: String {
        switch self {
        case .success:
            return "Success"
        case .error:
            return "Error"
        case .warning:
            return "Warning"
        case .info:
            return "Information"
        case .custom:
            return "Notification"
        }
    }
}

// MARK: - DSToastDuration

/// Duration configuration for toast display
public enum DSToastDuration: Equatable {
    /// Short duration - 2 seconds
    case short

    /// Long duration - 4 seconds
    case long

    /// Toast remains until manually dismissed
    case indefinite

    /// Custom duration in seconds
    case custom(seconds: TimeInterval)

    /// Duration in seconds
    public var seconds: TimeInterval {
        switch self {
        case .short:
            return 2.0
        case .long:
            return 4.0
        case .indefinite:
            return .infinity
        case .custom(let seconds):
            return seconds
        }
    }

    public static func == (lhs: DSToastDuration, rhs: DSToastDuration) -> Bool {
        lhs.seconds == rhs.seconds
    }
}

// MARK: - DSToastPosition

/// Position of the toast on screen
public enum DSToastPosition {
    /// Display at the top of the screen
    case top

    /// Display at the bottom of the screen
    case bottom
}
