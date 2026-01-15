#if canImport(UIKit)
import UIKit

// MARK: - UIFont Design System Extension

extension UIFont {
    /// Design system typography namespace for UIKit
    public struct DS {
        // MARK: Display Styles

        /// Large title style (34pt default)
        public static var largeTitle: UIFont {
            font(for: .largeTitle)
        }

        /// Title 1 style (28pt default)
        public static var title1: UIFont {
            font(for: .title1)
        }

        /// Title 2 style (22pt default)
        public static var title2: UIFont {
            font(for: .title2)
        }

        /// Title 3 style (20pt default)
        public static var title3: UIFont {
            font(for: .title3)
        }

        // MARK: Content Styles

        /// Headline style (17pt semibold default)
        public static var headline: UIFont {
            font(for: .headline)
        }

        /// Body style (17pt default)
        public static var body: UIFont {
            font(for: .body)
        }

        /// Callout style (16pt default)
        public static var callout: UIFont {
            font(for: .callout)
        }

        /// Subheadline style (15pt default)
        public static var subheadline: UIFont {
            font(for: .subheadline)
        }

        // MARK: Supporting Styles

        /// Footnote style (13pt default)
        public static var footnote: UIFont {
            font(for: .footnote)
        }

        /// Caption 1 style (12pt default)
        public static var caption1: UIFont {
            font(for: .caption1)
        }

        /// Caption 2 style (11pt default)
        public static var caption2: UIFont {
            font(for: .caption2)
        }

        // MARK: Factory Methods

        /// Create a font for a specific scale with optional weight override
        public static func font(
            for scale: FontScale,
            weight: DSFontWeight? = nil
        ) -> UIFont {
            let effectiveWeight = weight ?? scale.defaultWeight
            let baseFont = UIFont.systemFont(ofSize: scale.defaultSize, weight: effectiveWeight.uiKitWeight)
            return UIFontMetrics(forTextStyle: scale.uiTextStyle).scaledFont(for: baseFont)
        }

        /// Create a font from a typography token
        public static func font(from token: TypographyToken) -> UIFont {
            if token.fontFamily.isSystem || token.fontFamily.name == nil {
                let baseFont = UIFont.systemFont(ofSize: token.size, weight: token.weight.uiKitWeight)
                return UIFontMetrics(forTextStyle: token.scale.uiTextStyle).scaledFont(for: baseFont)
            }

            // Custom font with Dynamic Type scaling
            let fontName = FontFamilyRegistry.shared.fontName(
                for: token.fontFamily,
                weight: token.weight
            ) ?? token.fontFamily.name ?? ""

            if let customFont = UIFont(name: fontName, size: token.size) {
                return UIFontMetrics(forTextStyle: token.scale.uiTextStyle).scaledFont(for: customFont)
            }

            // Fallback to system font
            let fallbackFont = UIFont.systemFont(ofSize: token.size, weight: token.weight.uiKitWeight)
            return UIFontMetrics(forTextStyle: token.scale.uiTextStyle).scaledFont(for: fallbackFont)
        }

        /// Create a custom font with Dynamic Type support
        public static func custom(
            _ name: String,
            scale: FontScale,
            weight: DSFontWeight = .regular
        ) -> UIFont {
            let fontFamily = FontFamily.custom(name)
            let fontName = FontFamilyRegistry.shared.fontName(for: fontFamily, weight: weight) ?? name

            if let customFont = UIFont(name: fontName, size: scale.defaultSize) {
                return UIFontMetrics(forTextStyle: scale.uiTextStyle).scaledFont(for: customFont)
            }

            // Fallback
            let fallbackFont = UIFont.systemFont(ofSize: scale.defaultSize, weight: weight.uiKitWeight)
            return UIFontMetrics(forTextStyle: scale.uiTextStyle).scaledFont(for: fallbackFont)
        }
    }

    /// Access design system typography
    public static var ds: DS.Type { DS.self }
}

// MARK: - FontScale UIKit Extension

extension FontScale {
    /// Corresponding UIKit UIFont.TextStyle for Dynamic Type
    public var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .body: return .body
        case .callout: return .callout
        case .subheadline: return .subheadline
        case .footnote: return .footnote
        case .caption1: return .caption1
        case .caption2: return .caption2
        }
    }
}

// MARK: - UIFont Convenience Extensions

extension UIFont {
    /// Create font from FontScale with optional weight
    public static func designSystem(
        _ scale: FontScale,
        weight: DSFontWeight? = nil
    ) -> UIFont {
        DS.font(for: scale, weight: weight)
    }

    /// Create font from TypographyToken
    public static func designSystem(_ token: TypographyToken) -> UIFont {
        DS.font(from: token)
    }

    /// Create a scaled font that respects Dynamic Type
    public func scaled(for textStyle: UIFont.TextStyle) -> UIFont {
        UIFontMetrics(forTextStyle: textStyle).scaledFont(for: self)
    }

    /// Create a scaled font for a FontScale
    public func scaled(for scale: FontScale) -> UIFont {
        UIFontMetrics(forTextStyle: scale.uiTextStyle).scaledFont(for: self)
    }
}
#endif
