import CoreGraphics
import SwiftUI

// MARK: - Layout Constants

/// Centralized layout constants for consistent UI dimensions across the app.
///
/// These constants define standard sizes for common UI elements,
/// ensuring consistency and maintainability.
///
/// ## Usage
/// ```swift
/// .frame(height: LayoutConstants.buttonHeight)
/// .frame(minHeight: LayoutConstants.listRowMinHeight)
/// ```
public enum LayoutConstants {

    // MARK: - Touch Targets

    /// Minimum touch target size (44pt) - Apple HIG recommendation
    public static let minTouchTarget: CGFloat = 44

    /// Standard touch target size for interactive elements
    public static let touchTarget: CGFloat = 44

    /// Large touch target for primary actions
    public static let largeTouchTarget: CGFloat = 56

    // MARK: - Button Heights

    /// Small button height
    public static let buttonHeightSmall: CGFloat = 32

    /// Standard button height
    public static let buttonHeight: CGFloat = 44

    /// Large button height
    public static let buttonHeightLarge: CGFloat = 56

    // MARK: - Input Fields

    /// Standard text field height
    public static let textFieldHeight: CGFloat = 44

    /// Text area minimum height
    public static let textAreaMinHeight: CGFloat = 88

    /// Search bar height
    public static let searchBarHeight: CGFloat = 36

    // MARK: - Navigation

    /// Standard navigation bar height
    public static let navigationBarHeight: CGFloat = 44

    /// Large navigation bar height (with large title)
    public static let navigationBarLargeHeight: CGFloat = 96

    /// Tab bar height
    public static let tabBarHeight: CGFloat = 49

    /// Toolbar height
    public static let toolbarHeight: CGFloat = 44

    // MARK: - List & Table

    /// Minimum list row height
    public static let listRowMinHeight: CGFloat = 44

    /// Standard list row height
    public static let listRowHeight: CGFloat = 56

    /// Large list row height (with subtitle)
    public static let listRowHeightLarge: CGFloat = 72

    /// Section header height
    public static let sectionHeaderHeight: CGFloat = 32

    // MARK: - Cards & Containers

    /// Standard card corner radius
    public static let cardCornerRadius: CGFloat = 12

    /// Small corner radius
    public static let cornerRadiusSmall: CGFloat = 4

    /// Medium corner radius
    public static let cornerRadiusMedium: CGFloat = 8

    /// Large corner radius
    public static let cornerRadiusLarge: CGFloat = 16

    /// Extra large corner radius
    public static let cornerRadiusXLarge: CGFloat = 24

    // MARK: - Icons

    /// Small icon size
    public static let iconSizeSmall: CGFloat = 16

    /// Standard icon size
    public static let iconSize: CGFloat = 24

    /// Large icon size
    public static let iconSizeLarge: CGFloat = 32

    /// Extra large icon size
    public static let iconSizeXLarge: CGFloat = 48

    // MARK: - Avatars

    /// Small avatar size
    public static let avatarSizeSmall: CGFloat = 32

    /// Standard avatar size
    public static let avatarSize: CGFloat = 40

    /// Large avatar size
    public static let avatarSizeLarge: CGFloat = 56

    /// Extra large avatar size
    public static let avatarSizeXLarge: CGFloat = 80

    // MARK: - Dividers & Borders

    /// Hairline divider thickness
    public static let hairline: CGFloat = 0.5

    /// Standard divider thickness
    public static let dividerThickness: CGFloat = 1

    /// Standard border width
    public static let borderWidth: CGFloat = 1

    /// Thick border width
    public static let borderWidthThick: CGFloat = 2

    // MARK: - Shadows

    /// Small shadow radius
    public static let shadowRadiusSmall: CGFloat = 2

    /// Standard shadow radius
    public static let shadowRadius: CGFloat = 4

    /// Large shadow radius
    public static let shadowRadiusLarge: CGFloat = 8

    /// Extra large shadow radius
    public static let shadowRadiusXLarge: CGFloat = 16

    // MARK: - Animation

    /// Standard animation duration (seconds)
    public static let animationDuration: Double = 0.3

    /// Fast animation duration (seconds)
    public static let animationDurationFast: Double = 0.15

    /// Slow animation duration (seconds)
    public static let animationDurationSlow: Double = 0.5

    // MARK: - Content Width

    /// Maximum content width for readability (iPad)
    public static let maxContentWidth: CGFloat = 672

    /// Maximum readable line width
    public static let maxReadableWidth: CGFloat = 560

    /// Compact content width
    public static let compactContentWidth: CGFloat = 320
}

// MARK: - Layout Insets

/// Pre-defined edge insets for common layout scenarios
public enum LayoutInsets {

    /// Standard content insets
    public static let content = EdgeInsets(
        top: Spacing.md,
        leading: Spacing.md,
        bottom: Spacing.md,
        trailing: Spacing.md
    )

    /// Card content insets
    public static let card = EdgeInsets(
        top: Spacing.md,
        leading: Spacing.md,
        bottom: Spacing.md,
        trailing: Spacing.md
    )

    /// List row insets
    public static let listRow = EdgeInsets(
        top: Spacing.sm,
        leading: Spacing.md,
        bottom: Spacing.sm,
        trailing: Spacing.md
    )

    /// Section header insets
    public static let sectionHeader = EdgeInsets(
        top: Spacing.lg,
        leading: Spacing.md,
        bottom: Spacing.sm,
        trailing: Spacing.md
    )

    /// Button content insets
    public static let button = EdgeInsets(
        top: Spacing.sm,
        leading: Spacing.md,
        bottom: Spacing.sm,
        trailing: Spacing.md
    )

    /// Compact button content insets
    public static let buttonCompact = EdgeInsets(
        top: Spacing.xs,
        leading: Spacing.sm,
        bottom: Spacing.xs,
        trailing: Spacing.sm
    )

    /// Text field insets
    public static let textField = EdgeInsets(
        top: Spacing.sm,
        leading: Spacing.sm,
        bottom: Spacing.sm,
        trailing: Spacing.sm
    )

    /// Modal/Sheet content insets
    public static let modal = EdgeInsets(
        top: Spacing.lg,
        leading: Spacing.md,
        bottom: Spacing.lg,
        trailing: Spacing.md
    )

    /// Zero insets
    public static let zero = EdgeInsets(
        top: 0,
        leading: 0,
        bottom: 0,
        trailing: 0
    )
}

// MARK: - Layout Dimensions Helper

/// Helper for calculating dimensions based on spacing
public enum LayoutDimensions {

    /// Calculates a dimension based on spacing tokens
    /// - Parameters:
    ///   - baseSize: The base size
    ///   - spacing: Additional spacing to add
    /// - Returns: The calculated dimension
    public static func dimension(_ baseSize: CGFloat, plus spacing: SpacingToken) -> CGFloat {
        baseSize + spacing.value
    }

    /// Calculates a square dimension
    /// - Parameter size: The size for both width and height
    /// - Returns: A CGSize with equal width and height
    public static func square(_ size: CGFloat) -> CGSize {
        CGSize(width: size, height: size)
    }

    /// Calculates a size with spacing-based dimensions
    /// - Parameters:
    ///   - widthToken: Width spacing token
    ///   - heightToken: Height spacing token
    ///   - multiplier: Multiplier for both dimensions
    /// - Returns: The calculated CGSize
    public static func size(
        width widthToken: SpacingToken,
        height heightToken: SpacingToken,
        multiplier: CGFloat = 1
    ) -> CGSize {
        CGSize(
            width: widthToken.value * multiplier,
            height: heightToken.value * multiplier
        )
    }
}
