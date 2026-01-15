import SwiftUI

/// Complete typography token combining all typographic properties
public struct TypographyToken: Sendable, Equatable {
    public let scale: FontScale
    public let weight: DSFontWeight
    public let size: CGFloat
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat
    public let fontFamily: FontFamily

    /// Initialize with all properties
    public init(
        scale: FontScale,
        weight: DSFontWeight? = nil,
        size: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil,
        fontFamily: FontFamily = .system
    ) {
        self.scale = scale
        self.weight = weight ?? scale.defaultWeight
        self.size = size ?? scale.defaultSize
        self.lineHeight = lineHeight ?? (scale.defaultSize * scale.lineHeightMultiplier)
        self.letterSpacing = letterSpacing ?? scale.letterSpacing
        self.fontFamily = fontFamily
    }

    /// Line spacing (leading) calculated from line height
    public var lineSpacing: CGFloat {
        lineHeight - size
    }
}

// MARK: - Predefined Tokens

extension TypographyToken {
    // MARK: Display Styles
    public static let largeTitle = TypographyToken(scale: .largeTitle)
    public static let title1 = TypographyToken(scale: .title1)
    public static let title2 = TypographyToken(scale: .title2)
    public static let title3 = TypographyToken(scale: .title3)

    // MARK: Content Styles
    public static let headline = TypographyToken(scale: .headline)
    public static let body = TypographyToken(scale: .body)
    public static let callout = TypographyToken(scale: .callout)
    public static let subheadline = TypographyToken(scale: .subheadline)

    // MARK: Supporting Styles
    public static let footnote = TypographyToken(scale: .footnote)
    public static let caption1 = TypographyToken(scale: .caption1)
    public static let caption2 = TypographyToken(scale: .caption2)

    // MARK: Emphasized Variants
    public static let headlineBold = TypographyToken(scale: .headline, weight: .bold)
    public static let bodyBold = TypographyToken(scale: .body, weight: .bold)
    public static let calloutBold = TypographyToken(scale: .callout, weight: .semibold)
    public static let subheadlineBold = TypographyToken(scale: .subheadline, weight: .semibold)
    public static let footnoteBold = TypographyToken(scale: .footnote, weight: .semibold)

    // MARK: Custom Weight Variants
    public static func custom(
        scale: FontScale,
        weight: DSFontWeight,
        fontFamily: FontFamily = .system
    ) -> TypographyToken {
        TypographyToken(scale: scale, weight: weight, fontFamily: fontFamily)
    }
}
