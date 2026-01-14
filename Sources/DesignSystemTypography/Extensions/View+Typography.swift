import SwiftUI

// MARK: - View Typography Extensions

extension View {
    /// Apply a typography token to the view
    public func typography(_ token: TypographyToken) -> some View {
        modifier(TypographyModifier(token: token))
    }

    /// Apply a font scale with optional weight
    public func typography(
        _ scale: FontScale,
        weight: DSFontWeight? = nil
    ) -> some View {
        let token = TypographyToken(scale: scale, weight: weight)
        return modifier(TypographyModifier(token: token))
    }

    /// Apply design system text style
    public func textStyle(_ scale: FontScale) -> some View {
        typography(scale)
    }

    /// Apply design system text style with weight
    public func textStyle(_ scale: FontScale, weight: DSFontWeight) -> some View {
        typography(scale, weight: weight)
    }
}

// MARK: - Typography Modifier

/// ViewModifier that applies complete typography styling
public struct TypographyModifier: ViewModifier {
    public let token: TypographyToken
    @Environment(\.sizeCategory) private var sizeCategory

    public init(token: TypographyToken) {
        self.token = token
    }

    public func body(content: Content) -> some View {
        content
            .font(Font.ds.font(from: token))
            .lineSpacing(scaledLineSpacing)
            .tracking(token.letterSpacing)
    }

    private var scaledLineSpacing: CGFloat {
        // Scale line spacing based on Dynamic Type
        let baseSpacing = token.lineSpacing
        let scaleFactor = sizeCategory.scaleFactor
        return baseSpacing * scaleFactor
    }
}

// MARK: - Size Category Scale Factor

extension ContentSizeCategory {
    /// Scale factor for Dynamic Type adjustments
    var scaleFactor: CGFloat {
        switch self {
        case .extraSmall: return 0.82
        case .small: return 0.88
        case .medium: return 0.94
        case .large: return 1.0
        case .extraLarge: return 1.06
        case .extraExtraLarge: return 1.12
        case .extraExtraExtraLarge: return 1.18
        case .accessibilityMedium: return 1.35
        case .accessibilityLarge: return 1.53
        case .accessibilityExtraLarge: return 1.76
        case .accessibilityExtraExtraLarge: return 2.0
        case .accessibilityExtraExtraExtraLarge: return 2.35
        @unknown default: return 1.0
        }
    }

    /// Whether this is an accessibility size category
    var isAccessibilityCategory: Bool {
        switch self {
        case .accessibilityMedium,
             .accessibilityLarge,
             .accessibilityExtraLarge,
             .accessibilityExtraExtraLarge,
             .accessibilityExtraExtraExtraLarge:
            return true
        default:
            return false
        }
    }
}
