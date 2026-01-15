import SwiftUI

// MARK: - Card Style

/// Defines the visual style of the card
public enum CardStyle: String, CaseIterable, Sendable {
    /// Flat card with no background or border
    case flat
    /// Card with a border outline
    case outlined
    /// Card with elevation shadow
    case elevated
    /// Card with filled background color
    case filled

    /// Background color for the card in light mode
    public var backgroundColor: Color {
        switch self {
        case .flat:
            return .clear
        case .outlined:
            return Color(.systemBackground)
        case .elevated:
            return Color(.systemBackground)
        case .filled:
            return Color(.secondarySystemBackground)
        }
    }

    /// Background color for the card in dark mode
    public var darkModeBackgroundColor: Color {
        switch self {
        case .flat:
            return .clear
        case .outlined:
            return Color(.systemBackground)
        case .elevated:
            return Color(.secondarySystemBackground)
        case .filled:
            return Color(.tertiarySystemBackground)
        }
    }

    /// Returns appropriate background color based on color scheme
    public func resolvedBackgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkModeBackgroundColor : backgroundColor
    }

    /// Border color for outlined style
    public var borderColor: Color {
        Color(.separator)
    }

    /// Border width for outlined style
    public var borderWidth: CGFloat {
        self == .outlined ? 1 : 0
    }
}

// MARK: - Card Shadow Level

/// Defines the shadow intensity for elevated cards
public enum CardShadowLevel: String, CaseIterable, Sendable {
    case none
    case small
    case medium
    case large

    /// Shadow blur radius
    public var radius: CGFloat {
        switch self {
        case .none: return 0
        case .small: return 4
        case .medium: return 8
        case .large: return 16
        }
    }

    /// Shadow opacity in light mode
    public var opacity: Double {
        switch self {
        case .none: return 0
        case .small: return 0.08
        case .medium: return 0.12
        case .large: return 0.16
        }
    }

    /// Shadow Y offset
    public var yOffset: CGFloat {
        switch self {
        case .none: return 0
        case .small: return 2
        case .medium: return 4
        case .large: return 8
        }
    }

    /// Maps to ShadowToken
    public var shadowToken: ShadowToken {
        switch self {
        case .none: return .none
        case .small: return .sm
        case .medium: return .md
        case .large: return .lg
        }
    }
}

// MARK: - Card Padding

/// Defines the internal padding of the card
public enum CardPadding: String, CaseIterable, Sendable {
    case none
    case compact
    case standard
    case spacious

    /// Padding value in points
    public var value: CGFloat {
        switch self {
        case .none: return 0
        case .compact: return Spacing.sm      // 8pt
        case .standard: return Spacing.md     // 16pt
        case .spacious: return Spacing.lg     // 24pt
        }
    }
}

// MARK: - Card Corner Radius

/// Defines the corner radius of the card
public enum CardCornerRadius: String, CaseIterable, Sendable {
    case none
    case small
    case medium
    case large
    case extraLarge

    /// Corner radius value in points
    public var value: CGFloat {
        switch self {
        case .none: return 0
        case .small: return 4
        case .medium: return 8
        case .large: return 12
        case .extraLarge: return 16
        }
    }
}
