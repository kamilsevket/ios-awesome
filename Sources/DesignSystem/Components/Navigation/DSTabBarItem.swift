import SwiftUI

// MARK: - Tab Bar Item Configuration

/// Configuration model for a tab bar item
public struct DSTabBarItem<Tag: Hashable>: Identifiable {

    // MARK: - Properties

    public let id: Tag
    public let title: String
    public let icon: String
    public let selectedIcon: String?
    public let badge: DSTabBadge?

    // MARK: - Initialization

    /// Creates a tab bar item with title and SF Symbol icon
    /// - Parameters:
    ///   - tag: Unique identifier for the tab
    ///   - title: Display title for the tab
    ///   - icon: SF Symbol name for unselected state
    ///   - selectedIcon: SF Symbol name for selected state (defaults to icon.fill)
    ///   - badge: Optional badge to display on the tab
    public init(
        _ tag: Tag,
        title: String,
        icon: String,
        selectedIcon: String? = nil,
        badge: DSTabBadge? = nil
    ) {
        self.id = tag
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.badge = badge
    }

    /// Creates a tab bar item with only an icon (no title)
    /// - Parameters:
    ///   - tag: Unique identifier for the tab
    ///   - icon: SF Symbol name for unselected state
    ///   - selectedIcon: SF Symbol name for selected state
    ///   - badge: Optional badge to display on the tab
    public static func iconOnly(
        _ tag: Tag,
        icon: String,
        selectedIcon: String? = nil,
        badge: DSTabBadge? = nil
    ) -> DSTabBarItem {
        DSTabBarItem(tag, title: "", icon: icon, selectedIcon: selectedIcon, badge: badge)
    }

    // MARK: - Computed Properties

    /// Whether this tab has a title
    public var hasTitle: Bool {
        !title.isEmpty
    }

    /// Returns the appropriate icon for the given selection state
    public func icon(selected: Bool) -> String {
        if selected, let selectedIcon = selectedIcon {
            return selectedIcon
        }
        if selected {
            // Try to use filled variant if available
            return icon + ".fill"
        }
        return icon
    }
}

// MARK: - Tab Badge

/// Badge configuration for tab bar items
public enum DSTabBadge: Equatable {
    /// Numeric badge with count
    case count(Int)
    /// Simple dot indicator
    case dot
    /// Custom text badge
    case text(String)

    /// Display string for the badge
    public var displayValue: String? {
        switch self {
        case .count(let value):
            if value > 99 {
                return "99+"
            }
            return value > 0 ? "\(value)" : nil
        case .dot:
            return nil
        case .text(let value):
            return value.isEmpty ? nil : value
        }
    }

    /// Whether this badge should be visible
    public var isVisible: Bool {
        switch self {
        case .count(let value):
            return value > 0
        case .dot:
            return true
        case .text(let value):
            return !value.isEmpty
        }
    }

    /// Whether this is a dot-style badge
    public var isDot: Bool {
        if case .dot = self {
            return true
        }
        return false
    }
}

// MARK: - Tab Bar Style

/// Visual style for the tab bar
public enum DSTabBarStyle {
    /// Standard iOS tab bar appearance
    case standard
    /// Pill-shaped selection indicator
    case pill
    /// Underline selection indicator
    case underline
    /// Floating tab bar with rounded corners and shadow
    case floating

    /// Corner radius for the tab bar container
    public var cornerRadius: CGFloat {
        switch self {
        case .standard:
            return 0
        case .pill:
            return 0
        case .underline:
            return 0
        case .floating:
            return 24
        }
    }

    /// Whether this style has a background
    public var hasBackground: Bool {
        switch self {
        case .standard, .floating:
            return true
        case .pill, .underline:
            return false
        }
    }
}

// MARK: - Tab Bar Size

/// Size variants for tab bar
public enum DSTabBarSize {
    /// Compact size (icon only recommended)
    case compact
    /// Standard iOS tab bar size
    case standard
    /// Large size with bigger icons and text
    case large

    /// Height of the tab bar (excluding safe area)
    public var height: CGFloat {
        switch self {
        case .compact:
            return 44
        case .standard:
            return 49
        case .large:
            return 64
        }
    }

    /// Icon size for the tab bar
    public var iconSize: CGFloat {
        switch self {
        case .compact:
            return 22
        case .standard:
            return 24
        case .large:
            return 28
        }
    }

    /// Font size for tab titles
    public var fontSize: CGFloat {
        switch self {
        case .compact:
            return 9
        case .standard:
            return 10
        case .large:
            return 12
        }
    }

    /// Spacing between icon and title
    public var iconTitleSpacing: CGFloat {
        switch self {
        case .compact:
            return 2
        case .standard:
            return 3
        case .large:
            return 4
        }
    }
}

// MARK: - Tab Display Mode

/// Display mode for tab items
public enum DSTabDisplayMode {
    /// Show both icon and title
    case iconAndTitle
    /// Show only icon
    case iconOnly
    /// Show only title
    case titleOnly
    /// Adaptive based on available space
    case adaptive
}
