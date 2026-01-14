import SwiftUI

// MARK: - Design System Font Extension

extension Font {
    /// Design system typography namespace
    public struct DS {
        // MARK: Display Styles

        /// Large title style (34pt default)
        public static var largeTitle: Font {
            font(for: .largeTitle)
        }

        /// Title 1 style (28pt default)
        public static var title1: Font {
            font(for: .title1)
        }

        /// Title 2 style (22pt default)
        public static var title2: Font {
            font(for: .title2)
        }

        /// Title 3 style (20pt default)
        public static var title3: Font {
            font(for: .title3)
        }

        // MARK: Content Styles

        /// Headline style (17pt semibold default)
        public static var headline: Font {
            font(for: .headline)
        }

        /// Body style (17pt default)
        public static var body: Font {
            font(for: .body)
        }

        /// Callout style (16pt default)
        public static var callout: Font {
            font(for: .callout)
        }

        /// Subheadline style (15pt default)
        public static var subheadline: Font {
            font(for: .subheadline)
        }

        // MARK: Supporting Styles

        /// Footnote style (13pt default)
        public static var footnote: Font {
            font(for: .footnote)
        }

        /// Caption 1 style (12pt default)
        public static var caption1: Font {
            font(for: .caption1)
        }

        /// Caption 2 style (11pt default)
        public static var caption2: Font {
            font(for: .caption2)
        }

        // MARK: Factory Methods

        /// Create a font for a specific scale with optional weight override
        public static func font(
            for scale: FontScale,
            weight: DSFontWeight? = nil
        ) -> Font {
            let effectiveWeight = weight ?? scale.defaultWeight
            return .system(scale.textStyle, design: .default, weight: effectiveWeight.swiftUIWeight)
        }

        /// Create a font from a typography token
        public static func font(from token: TypographyToken) -> Font {
            if token.fontFamily.isSystem || token.fontFamily.name == nil {
                return .system(
                    token.scale.textStyle,
                    design: .default,
                    weight: token.weight.swiftUIWeight
                )
            }

            // Custom font with Dynamic Type scaling
            return .custom(
                fontName(for: token),
                size: token.size,
                relativeTo: token.scale.textStyle
            )
        }

        /// Create a custom font with Dynamic Type support
        public static func custom(
            _ name: String,
            scale: FontScale,
            weight: DSFontWeight = .regular
        ) -> Font {
            let fontFamily = FontFamily.custom(name)
            if let fontName = FontFamilyRegistry.shared.fontName(for: fontFamily, weight: weight) {
                return .custom(fontName, size: scale.defaultSize, relativeTo: scale.textStyle)
            }
            return .custom(name, size: scale.defaultSize, relativeTo: scale.textStyle)
        }

        /// Get font name for a token
        private static func fontName(for token: TypographyToken) -> String {
            FontFamilyRegistry.shared.fontName(
                for: token.fontFamily,
                weight: token.weight
            ) ?? token.fontFamily.name ?? ""
        }
    }

    /// Access design system typography
    public static var ds: DS.Type { DS.self }
}

// MARK: - Font Scale Convenience

extension Font {
    /// Create font from FontScale with optional weight
    public static func designSystem(
        _ scale: FontScale,
        weight: DSFontWeight? = nil
    ) -> Font {
        DS.font(for: scale, weight: weight)
    }

    /// Create font from TypographyToken
    public static func designSystem(_ token: TypographyToken) -> Font {
        DS.font(from: token)
    }
}

// MARK: - Dynamic Type Scaled Font

extension Font {
    /// Create a scaled system font with Dynamic Type support
    public static func scaledSystem(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        relativeTo textStyle: Font.TextStyle = .body
    ) -> Font {
        .system(size: size, weight: weight, design: design)
    }

    /// Create a scaled custom font with Dynamic Type support
    public static func scaledCustom(
        _ name: String,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body
    ) -> Font {
        .custom(name, size: size, relativeTo: textStyle)
    }
}
