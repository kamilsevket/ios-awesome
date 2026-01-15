import SwiftUI

// MARK: - Alert Action Style

/// Defines the visual style of an alert action button
public enum DSAlertActionStyle {
    case `default`
    case cancel
    case destructive

    var foregroundColor: Color {
        switch self {
        case .default:
            return .accentColor
        case .cancel:
            return Color(.label)
        case .destructive:
            return DSColors.destructive
        }
    }

    var fontWeight: Font.Weight {
        switch self {
        case .cancel:
            return .semibold
        case .default, .destructive:
            return .regular
        }
    }
}

// MARK: - Alert Action

/// Represents an action button in an alert or dialog
public struct DSAlertAction: Identifiable {
    public let id = UUID()
    public let title: String
    public let style: DSAlertActionStyle
    public let action: () -> Void

    // MARK: - Initialization

    /// Creates a new alert action
    /// - Parameters:
    ///   - title: The title displayed on the action button
    ///   - style: The visual style of the action (default: .default)
    ///   - action: The closure executed when the action is triggered
    public init(
        _ title: String,
        style: DSAlertActionStyle = .default,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.style = style
        self.action = action
    }

    // MARK: - Convenience Factory Methods

    /// Creates a cancel action
    /// - Parameters:
    ///   - title: The title for the cancel button (default: "Cancel")
    ///   - action: Optional closure to execute on cancel
    /// - Returns: A configured cancel action
    public static func cancel(
        _ title: String = "Cancel",
        action: @escaping () -> Void = {}
    ) -> DSAlertAction {
        DSAlertAction(title, style: .cancel, action: action)
    }

    /// Creates a destructive action
    /// - Parameters:
    ///   - title: The title for the destructive button
    ///   - action: The closure to execute
    /// - Returns: A configured destructive action
    public static func destructive(
        _ title: String,
        action: @escaping () -> Void
    ) -> DSAlertAction {
        DSAlertAction(title, style: .destructive, action: action)
    }

    /// Creates a default action
    /// - Parameters:
    ///   - title: The title for the button
    ///   - action: The closure to execute
    /// - Returns: A configured default action
    public static func `default`(
        _ title: String,
        action: @escaping () -> Void
    ) -> DSAlertAction {
        DSAlertAction(title, style: .default, action: action)
    }
}

// MARK: - Alert Icon

/// Defines the icon type for alerts
public enum DSAlertIcon {
    case system(String)
    case custom(Image)
    case success
    case warning
    case error
    case info

    var image: Image {
        switch self {
        case .system(let name):
            return Image(systemName: name)
        case .custom(let image):
            return image
        case .success:
            return Image(systemName: "checkmark.circle.fill")
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .error:
            return Image(systemName: "xmark.circle.fill")
        case .info:
            return Image(systemName: "info.circle.fill")
        }
    }

    var color: Color {
        switch self {
        case .system, .custom:
            return .accentColor
        case .success:
            return DSColors.success
        case .warning:
            return DSColors.warning
        case .error:
            return DSColors.error
        case .info:
            return DSColors.info
        }
    }
}
