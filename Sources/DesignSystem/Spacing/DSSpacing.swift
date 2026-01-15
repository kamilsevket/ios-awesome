import SwiftUI

/// Design System spacing tokens based on a 4pt grid system.
/// Use these values consistently throughout the app for visual harmony.
public enum DSSpacing {
    /// 2pt - Micro adjustments
    public static let xxs: CGFloat = 2

    /// 4pt - Tight spacing (1x base unit)
    public static let xs: CGFloat = 4

    /// 8pt - Within components (2x base units)
    public static let sm: CGFloat = 8

    /// 12pt - Compact spacing (3x base units)
    public static let md: CGFloat = 12

    /// 16pt - Default spacing (4x base units)
    public static let lg: CGFloat = 16

    /// 24pt - Section breaks (6x base units)
    public static let xl: CGFloat = 24

    /// 32pt - Major breaks (8x base units)
    public static let xxl: CGFloat = 32

    /// 48pt - Page-level spacing (12x base units)
    public static let xxxl: CGFloat = 48
}

// MARK: - Touch Target

public enum DSTouchTarget {
    /// Minimum touch target size (44pt) per Apple HIG
    public static let minimum: CGFloat = 44
}
