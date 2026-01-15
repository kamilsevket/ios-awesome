import SwiftUI

/// Size variants for avatar components
public enum AvatarSize: CaseIterable {
    case xs
    case sm
    case md
    case lg
    case xl

    /// The diameter of the avatar in points
    public var diameter: CGFloat {
        switch self {
        case .xs: return 24
        case .sm: return 32
        case .md: return 40
        case .lg: return 56
        case .xl: return 80
        }
    }

    /// Font size for initials text
    public var fontSize: CGFloat {
        switch self {
        case .xs: return 10
        case .sm: return 12
        case .md: return 16
        case .lg: return 22
        case .xl: return 32
        }
    }

    /// Size of the status indicator
    public var statusIndicatorSize: CGFloat {
        switch self {
        case .xs: return 8
        case .sm: return 10
        case .md: return 12
        case .lg: return 16
        case .xl: return 20
        }
    }

    /// Border width for the status indicator
    public var statusBorderWidth: CGFloat {
        switch self {
        case .xs: return 1.5
        case .sm: return 2
        case .md: return 2
        case .lg: return 2.5
        case .xl: return 3
        }
    }

    /// Border width for avatar ring
    public var ringWidth: CGFloat {
        switch self {
        case .xs: return 1.5
        case .sm: return 2
        case .md: return 2
        case .lg: return 3
        case .xl: return 4
        }
    }

    /// Placeholder icon size
    public var iconSize: CGFloat {
        switch self {
        case .xs: return 12
        case .sm: return 16
        case .md: return 20
        case .lg: return 28
        case .xl: return 40
        }
    }
}
