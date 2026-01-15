import SwiftUI

// MARK: - Navigation Bar Style

/// Defines the visual style of the navigation bar
public enum DSNavigationBarStyle: Equatable {
    /// Standard inline title style
    case inline
    /// Large title style (iOS style)
    case largeTitle
    /// Transparent navigation bar
    case transparent
    /// Custom style with specific configuration
    case custom(DSNavigationBarConfiguration)

    // MARK: - Properties

    /// Height of the navigation bar in standard state
    public var standardHeight: CGFloat {
        switch self {
        case .inline, .transparent:
            return 44
        case .largeTitle:
            return 96
        case .custom(let config):
            return config.standardHeight
        }
    }

    /// Height of the navigation bar in collapsed state
    public var collapsedHeight: CGFloat {
        switch self {
        case .inline, .transparent:
            return 44
        case .largeTitle:
            return 44
        case .custom(let config):
            return config.collapsedHeight
        }
    }

    /// Large title font size
    public var largeTitleSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .custom(let config):
            return config.largeTitleSize
        default:
            return 17
        }
    }

    /// Inline title font size
    public var inlineTitleSize: CGFloat {
        switch self {
        case .custom(let config):
            return config.inlineTitleSize
        default:
            return 17
        }
    }

    /// Whether the navigation bar has a background
    public var hasBackground: Bool {
        switch self {
        case .transparent:
            return false
        default:
            return true
        }
    }

    /// Whether the navigation bar supports collapsing
    public var supportsCollapse: Bool {
        switch self {
        case .largeTitle:
            return true
        case .custom(let config):
            return config.supportsCollapse
        default:
            return false
        }
    }

    // MARK: - Equatable

    public static func == (lhs: DSNavigationBarStyle, rhs: DSNavigationBarStyle) -> Bool {
        switch (lhs, rhs) {
        case (.inline, .inline),
             (.largeTitle, .largeTitle),
             (.transparent, .transparent):
            return true
        case (.custom(let lhsConfig), .custom(let rhsConfig)):
            return lhsConfig == rhsConfig
        default:
            return false
        }
    }
}

// MARK: - Navigation Bar Configuration

/// Custom configuration for navigation bar
public struct DSNavigationBarConfiguration: Equatable {
    public let standardHeight: CGFloat
    public let collapsedHeight: CGFloat
    public let largeTitleSize: CGFloat
    public let inlineTitleSize: CGFloat
    public let supportsCollapse: Bool

    public init(
        standardHeight: CGFloat = 96,
        collapsedHeight: CGFloat = 44,
        largeTitleSize: CGFloat = 34,
        inlineTitleSize: CGFloat = 17,
        supportsCollapse: Bool = true
    ) {
        self.standardHeight = standardHeight
        self.collapsedHeight = collapsedHeight
        self.largeTitleSize = largeTitleSize
        self.inlineTitleSize = inlineTitleSize
        self.supportsCollapse = supportsCollapse
    }
}

// MARK: - Navigation Bar Background Style

/// Defines the background appearance of the navigation bar
public enum DSNavigationBarBackgroundStyle: Equatable {
    /// Solid color background
    case solid(Color)
    /// Blur effect background (iOS style)
    case blur(UIBlurEffect.Style)
    /// Gradient background
    case gradient([Color])
    /// Transparent background
    case transparent

    // MARK: - Default Backgrounds

    public static var defaultLight: DSNavigationBarBackgroundStyle {
        .solid(Color(.systemBackground))
    }

    public static var defaultDark: DSNavigationBarBackgroundStyle {
        .solid(Color(.systemBackground))
    }

    public static var defaultBlur: DSNavigationBarBackgroundStyle {
        .blur(.systemMaterial)
    }
}

// MARK: - Navigation Bar Shadow Style

/// Defines the shadow appearance of the navigation bar
public struct DSNavigationBarShadowStyle: Equatable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    public let opacity: CGFloat

    public init(
        color: Color = .black,
        radius: CGFloat = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 0.5,
        opacity: CGFloat = 0.1
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
        self.opacity = opacity
    }

    // MARK: - Presets

    public static var none: DSNavigationBarShadowStyle {
        DSNavigationBarShadowStyle(opacity: 0)
    }

    public static var subtle: DSNavigationBarShadowStyle {
        DSNavigationBarShadowStyle()
    }

    public static var medium: DSNavigationBarShadowStyle {
        DSNavigationBarShadowStyle(radius: 2, y: 1, opacity: 0.15)
    }

    public static var prominent: DSNavigationBarShadowStyle {
        DSNavigationBarShadowStyle(radius: 4, y: 2, opacity: 0.2)
    }
}

// MARK: - Collapse State

/// Represents the collapse state of the navigation bar
public enum DSNavigationBarCollapseState: Equatable {
    case expanded
    case collapsing(progress: CGFloat)
    case collapsed

    public var progress: CGFloat {
        switch self {
        case .expanded:
            return 0
        case .collapsing(let progress):
            return progress
        case .collapsed:
            return 1
        }
    }

    public var isCollapsed: Bool {
        switch self {
        case .collapsed:
            return true
        case .collapsing(let progress):
            return progress > 0.9
        default:
            return false
        }
    }
}
