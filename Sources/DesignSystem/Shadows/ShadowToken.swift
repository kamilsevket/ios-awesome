import SwiftUI

// MARK: - Shadow Token

/// Design system shadow tokens providing consistent elevation effects.
///
/// Usage:
/// ```swift
/// .shadow(.ds.md)
/// .shadow(.ds.lg)
/// ```
public enum ShadowToken: String, CaseIterable, Sendable {
    case none
    case sm
    case md
    case lg
    case xl

    // MARK: - Shadow Properties

    /// The blur radius for this shadow token.
    public var blur: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return 4
        case .md: return 8
        case .lg: return 16
        case .xl: return 24
        }
    }

    /// The vertical offset for this shadow token.
    public var y: CGFloat {
        switch self {
        case .none: return 0
        case .sm: return 2
        case .md: return 4
        case .lg: return 8
        case .xl: return 12
        }
    }

    /// The horizontal offset for this shadow token (default is 0).
    public var x: CGFloat {
        0
    }

    /// The base opacity for light mode.
    public var opacity: Double {
        switch self {
        case .none: return 0
        case .sm: return 0.1
        case .md: return 0.15
        case .lg: return 0.2
        case .xl: return 0.25
        }
    }

    /// The opacity for dark mode (reduced for better appearance).
    public var darkModeOpacity: Double {
        switch self {
        case .none: return 0
        case .sm: return 0.3
        case .md: return 0.4
        case .lg: return 0.5
        case .xl: return 0.6
        }
    }

    /// The shadow color for light mode.
    public var color: Color {
        Color.black.opacity(opacity)
    }

    /// The shadow color for dark mode.
    public var darkModeColor: Color {
        Color.black.opacity(darkModeOpacity)
    }
}

// MARK: - Shadow Token Namespace

/// Namespace for accessing design system shadow tokens.
public struct DSShadowTokens {
    public let none = ShadowToken.none
    public let sm = ShadowToken.sm
    public let md = ShadowToken.md
    public let lg = ShadowToken.lg
    public let xl = ShadowToken.xl
}

// MARK: - Shadow Namespace Extension

public extension ShadowToken {
    /// Access design system shadow tokens via `.ds` namespace.
    static let ds = DSShadowTokens()
}
