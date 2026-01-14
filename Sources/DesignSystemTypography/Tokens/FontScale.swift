import SwiftUI

/// Typography scale following Apple's Human Interface Guidelines
/// with Design System customizations for consistent typography.
public enum FontScale: String, CaseIterable, Sendable {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption1
    case caption2

    /// Default point size for each scale (at standard Dynamic Type size)
    public var defaultSize: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title1: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subheadline: return 15
        case .footnote: return 13
        case .caption1: return 12
        case .caption2: return 11
        }
    }

    /// Default line height multiplier for each scale
    public var lineHeightMultiplier: CGFloat {
        switch self {
        case .largeTitle: return 1.2
        case .title1: return 1.21
        case .title2: return 1.27
        case .title3: return 1.25
        case .headline: return 1.29
        case .body: return 1.29
        case .callout: return 1.31
        case .subheadline: return 1.33
        case .footnote: return 1.38
        case .caption1: return 1.33
        case .caption2: return 1.27
        }
    }

    /// Letter spacing (tracking) in points
    public var letterSpacing: CGFloat {
        switch self {
        case .largeTitle: return 0.37
        case .title1: return 0.36
        case .title2: return 0.35
        case .title3: return 0.38
        case .headline: return -0.41
        case .body: return -0.41
        case .callout: return -0.31
        case .subheadline: return -0.23
        case .footnote: return -0.08
        case .caption1: return 0
        case .caption2: return 0.06
        }
    }

    /// Default font weight for each scale
    public var defaultWeight: DSFontWeight {
        switch self {
        case .largeTitle: return .regular
        case .title1: return .regular
        case .title2: return .regular
        case .title3: return .regular
        case .headline: return .semibold
        case .body: return .regular
        case .callout: return .regular
        case .subheadline: return .regular
        case .footnote: return .regular
        case .caption1: return .regular
        case .caption2: return .regular
        }
    }

    /// Corresponding SwiftUI Text.Style for Dynamic Type
    public var textStyle: Font.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1: return .title
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .body: return .body
        case .callout: return .callout
        case .subheadline: return .subheadline
        case .footnote: return .footnote
        case .caption1: return .caption
        case .caption2: return .caption2
        }
    }

    /// Semantic description for accessibility
    public var accessibilityDescription: String {
        switch self {
        case .largeTitle: return "Large title text"
        case .title1: return "Title level 1 text"
        case .title2: return "Title level 2 text"
        case .title3: return "Title level 3 text"
        case .headline: return "Headline text"
        case .body: return "Body text"
        case .callout: return "Callout text"
        case .subheadline: return "Subheadline text"
        case .footnote: return "Footnote text"
        case .caption1: return "Caption text"
        case .caption2: return "Secondary caption text"
        }
    }
}
