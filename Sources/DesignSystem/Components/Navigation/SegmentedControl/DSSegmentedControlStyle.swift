import SwiftUI

// MARK: - Segmented Control Style

/// Visual style for the segmented control
public enum DSSegmentedControlStyle: Equatable {
    /// Native iOS style with gray background
    case standard
    /// Modern pill/capsule style with rounded selection
    case pill
    /// Underline indicator style
    case underline

    /// Corner radius for segment items
    public var segmentCornerRadius: CGFloat {
        switch self {
        case .standard:
            return 6
        case .pill:
            return 20
        case .underline:
            return 0
        }
    }

    /// Corner radius for the container
    public var containerCornerRadius: CGFloat {
        switch self {
        case .standard:
            return 8
        case .pill:
            return 24
        case .underline:
            return 0
        }
    }

    /// Whether this style has a container background
    public var hasContainerBackground: Bool {
        switch self {
        case .standard, .pill:
            return true
        case .underline:
            return false
        }
    }

    /// Whether this style uses an indicator view
    public var hasIndicator: Bool {
        true
    }
}

// MARK: - Segmented Control Size

/// Size variants for segmented control
public enum DSSegmentedControlSize: Equatable {
    /// Compact size
    case compact
    /// Standard size
    case standard
    /// Large size
    case large

    /// Height of the segmented control
    public var height: CGFloat {
        switch self {
        case .compact:
            return 32
        case .standard:
            return 44
        case .large:
            return 52
        }
    }

    /// Font for segment text
    public var font: Font {
        switch self {
        case .compact:
            return .system(size: 13, weight: .medium)
        case .standard:
            return .system(size: 14, weight: .medium)
        case .large:
            return .system(size: 16, weight: .medium)
        }
    }

    /// Icon size
    public var iconSize: CGFloat {
        switch self {
        case .compact:
            return 14
        case .standard:
            return 16
        case .large:
            return 20
        }
    }

    /// Horizontal padding inside segments
    public var horizontalPadding: CGFloat {
        switch self {
        case .compact:
            return 12
        case .standard:
            return 16
        case .large:
            return 20
        }
    }

    /// Spacing between icon and text
    public var iconTextSpacing: CGFloat {
        switch self {
        case .compact:
            return 4
        case .standard:
            return 6
        case .large:
            return 8
        }
    }
}

// MARK: - Segment Width Mode

/// Width distribution mode for segments
public enum DSSegmentWidthMode: Equatable {
    /// All segments have equal width
    case equal
    /// Segments size to fit their content
    case dynamic
    /// Fixed width for each segment
    case fixed(CGFloat)
}

// MARK: - Segmented Control Constants

/// Layout constants for segmented control components
public enum DSSegmentedControlConstants {
    // MARK: - Animation

    /// Spring response for selection animation
    public static let springResponse: Double = 0.35

    /// Spring damping for selection animation
    public static let springDamping: Double = 0.75

    /// Standard animation duration
    public static let animationDuration: Double = 0.25

    // MARK: - Layout

    /// Container padding
    public static let containerPadding: CGFloat = 2

    /// Minimum segment width
    public static let minSegmentWidth: CGFloat = 44

    /// Underline indicator height
    public static let underlineHeight: CGFloat = 2

    /// Underline indicator horizontal inset
    public static let underlineInset: CGFloat = 8

    // MARK: - Colors

    /// Default selected text color
    public static var defaultSelectedColor: Color {
        .primary
    }

    /// Default unselected text color
    public static var defaultUnselectedColor: Color {
        .secondary
    }
}
