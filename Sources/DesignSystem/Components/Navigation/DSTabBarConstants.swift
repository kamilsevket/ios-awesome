import SwiftUI

// MARK: - Tab Bar Constants

/// Layout constants for tab bar components
public enum DSTabBarConstants {

    // MARK: - Heights

    /// Standard tab bar height (49pt - Apple HIG)
    public static let standardHeight: CGFloat = 49

    /// Compact tab bar height
    public static let compactHeight: CGFloat = 44

    /// Large tab bar height
    public static let largeHeight: CGFloat = 64

    /// Scrollable tab bar height
    public static let scrollableHeight: CGFloat = 44

    // MARK: - Icon Sizes

    /// Standard icon size for tabs
    public static let standardIconSize: CGFloat = 24

    /// Compact icon size
    public static let compactIconSize: CGFloat = 22

    /// Large icon size
    public static let largeIconSize: CGFloat = 28

    // MARK: - Font Sizes

    /// Standard tab label font size
    public static let standardFontSize: CGFloat = 10

    /// Compact tab label font size
    public static let compactFontSize: CGFloat = 9

    /// Large tab label font size
    public static let largeFontSize: CGFloat = 12

    // MARK: - Spacing

    /// Spacing between icon and title
    public static let iconTitleSpacing: CGFloat = 3

    /// Horizontal padding for tab items
    public static let horizontalPadding: CGFloat = 8

    /// Floating tab bar corner radius
    public static let floatingCornerRadius: CGFloat = 24

    // MARK: - Badge

    /// Badge minimum width
    public static let badgeMinWidth: CGFloat = 16

    /// Badge font size
    public static let badgeFontSize: CGFloat = 10

    /// Dot badge size
    public static let dotBadgeSize: CGFloat = 8

    // MARK: - Animation

    /// Standard animation duration
    public static let animationDuration: Double = 0.3

    /// Spring response for selection animation
    public static let springResponse: Double = 0.3

    /// Spring damping for selection animation
    public static let springDamping: Double = 0.7

    // MARK: - Touch

    /// Minimum touch target size (Apple HIG)
    public static let minTouchTarget: CGFloat = 44

    /// Scale effect when pressed
    public static let pressedScale: CGFloat = 0.95
}

// MARK: - Tab Bar Metrics

/// Computed metrics for tab bar layout
public struct DSTabBarMetrics {
    /// Number of tabs
    public let tabCount: Int
    /// Available width
    public let availableWidth: CGFloat
    /// Tab bar size
    public let size: DSTabBarSize

    /// Width per tab
    public var tabWidth: CGFloat {
        availableWidth / CGFloat(max(tabCount, 1))
    }

    /// Whether tabs should scroll (too many to fit)
    public var shouldScroll: Bool {
        tabWidth < DSTabBarConstants.minTouchTarget
    }

    /// Recommended display mode based on available space
    public var recommendedDisplayMode: DSTabDisplayMode {
        if tabWidth < 60 {
            return .iconOnly
        } else if tabWidth < 80 {
            return .adaptive
        }
        return .iconAndTitle
    }

    public init(tabCount: Int, availableWidth: CGFloat, size: DSTabBarSize = .standard) {
        self.tabCount = tabCount
        self.availableWidth = availableWidth
        self.size = size
    }
}
