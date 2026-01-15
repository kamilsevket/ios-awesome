import SwiftUI

// MARK: - Text Style Modifier

/// Advanced text style modifier with full typography control
public struct TextStyleModifier: ViewModifier {
    public let scale: FontScale
    public let weight: DSFontWeight?
    public let fontFamily: FontFamily
    public let italic: Bool
    public let uppercase: Bool
    public let underline: Bool
    public let strikethrough: Bool
    public let color: Color?

    @Environment(\.sizeCategory) private var sizeCategory

    public init(
        scale: FontScale,
        weight: DSFontWeight? = nil,
        fontFamily: FontFamily = .system,
        italic: Bool = false,
        uppercase: Bool = false,
        underline: Bool = false,
        strikethrough: Bool = false,
        color: Color? = nil
    ) {
        self.scale = scale
        self.weight = weight
        self.fontFamily = fontFamily
        self.italic = italic
        self.uppercase = uppercase
        self.underline = underline
        self.strikethrough = strikethrough
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .font(resolvedFont)
            .italic(italic)
            .underline(underline)
            .strikethrough(strikethrough)
            .textCase(uppercase ? .uppercase : nil)
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
            .tracking(scale.letterSpacing)
    }

    private var resolvedFont: Font {
        let token = TypographyToken(
            scale: scale,
            weight: weight,
            fontFamily: fontFamily
        )
        return Font.ds.font(from: token)
    }

    private var lineSpacing: CGFloat {
        let baseSpacing = scale.defaultSize * (scale.lineHeightMultiplier - 1)
        return baseSpacing * sizeCategory.scaleFactor
    }
}

// MARK: - View Extensions for Text Style

extension View {
    /// Apply text style with all options
    public func textStyle(
        _ scale: FontScale,
        weight: DSFontWeight? = nil,
        fontFamily: FontFamily = .system,
        italic: Bool = false,
        uppercase: Bool = false,
        underline: Bool = false,
        strikethrough: Bool = false,
        color: Color? = nil
    ) -> some View {
        modifier(TextStyleModifier(
            scale: scale,
            weight: weight,
            fontFamily: fontFamily,
            italic: italic,
            uppercase: uppercase,
            underline: underline,
            strikethrough: strikethrough,
            color: color
        ))
    }
}

// MARK: - Semantic Text Styles

/// Semantic text style presets for common use cases
public struct SemanticTextStyle {
    public let scale: FontScale
    public let weight: DSFontWeight
    public let color: Color?

    private init(scale: FontScale, weight: DSFontWeight, color: Color? = nil) {
        self.scale = scale
        self.weight = weight
        self.color = color
    }

    // MARK: Primary Styles

    /// Primary title style
    public static let primaryTitle = SemanticTextStyle(scale: .title1, weight: .bold)

    /// Secondary title style
    public static let secondaryTitle = SemanticTextStyle(scale: .title2, weight: .semibold)

    /// Section header style
    public static let sectionHeader = SemanticTextStyle(scale: .headline, weight: .semibold)

    // MARK: Body Styles

    /// Primary body text
    public static let primaryBody = SemanticTextStyle(scale: .body, weight: .regular)

    /// Secondary body text
    public static let secondaryBody = SemanticTextStyle(scale: .callout, weight: .regular)

    /// Emphasized body text
    public static let emphasizedBody = SemanticTextStyle(scale: .body, weight: .semibold)

    // MARK: Supporting Styles

    /// Caption style
    public static let caption = SemanticTextStyle(scale: .caption1, weight: .regular)

    /// Label style
    public static let label = SemanticTextStyle(scale: .subheadline, weight: .medium)

    /// Button text style
    public static let button = SemanticTextStyle(scale: .body, weight: .semibold)

    /// Link text style
    public static let link = SemanticTextStyle(scale: .body, weight: .regular)
}

extension View {
    /// Apply a semantic text style
    public func semanticStyle(_ style: SemanticTextStyle) -> some View {
        self
            .textStyle(style.scale, weight: style.weight)
            .foregroundColor(style.color)
    }
}
