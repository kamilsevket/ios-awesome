import CoreGraphics

// MARK: - Spacing Tokens

/// Design System spacing tokens based on 4pt grid system.
///
/// All spacing values are multiples of 4pt to ensure visual consistency
/// and alignment across the entire application.
///
/// ## Usage
/// ```swift
/// // SwiftUI
/// .padding(.ds.md)        // 16pt
/// .padding(.horizontal, Spacing.lg)  // 24pt
///
/// // Direct access
/// let margin = Spacing.md  // 16pt
/// ```
///
/// ## Scale Reference
/// - `xxs`: 2pt  - Micro adjustments
/// - `xs`:  4pt  - Tight spacing
/// - `sm`:  8pt  - Small spacing
/// - `md`:  16pt - Medium/default spacing
/// - `lg`:  24pt - Large spacing
/// - `xl`:  32pt - Extra large spacing
/// - `xxl`: 48pt - Maximum spacing
public enum Spacing {

    // MARK: - Base Unit

    /// The base unit for all spacing calculations (4pt)
    public static let baseUnit: CGFloat = 4

    // MARK: - Spacing Scale

    /// Extra extra small spacing: 2pt
    /// Use for micro adjustments and tight layouts
    public static let xxs: CGFloat = 2

    /// Extra small spacing: 4pt (1x base unit)
    /// Use for tight spacing between related elements
    public static let xs: CGFloat = 4

    /// Small spacing: 8pt (2x base unit)
    /// Use for spacing within components
    public static let sm: CGFloat = 8

    /// Medium spacing: 16pt (4x base unit)
    /// Default spacing for most use cases
    public static let md: CGFloat = 16

    /// Large spacing: 24pt (6x base unit)
    /// Use for spacing between sections
    public static let lg: CGFloat = 24

    /// Extra large spacing: 32pt (8x base unit)
    /// Use for major section breaks
    public static let xl: CGFloat = 32

    /// Extra extra large spacing: 48pt (12x base unit)
    /// Use for page-level spacing and large gaps
    public static let xxl: CGFloat = 48

    // MARK: - Semantic Spacing

    /// Zero spacing
    public static let none: CGFloat = 0

    /// Inline spacing for text elements: 4pt
    public static let inline: CGFloat = xs

    /// Stack spacing for vertical layouts: 8pt
    public static let stack: CGFloat = sm

    /// Inset spacing for container padding: 16pt
    public static let inset: CGFloat = md

    /// Section spacing between major sections: 24pt
    public static let section: CGFloat = lg

    /// Page margin spacing: 16pt
    public static let pageMargin: CGFloat = md
}

// MARK: - SpacingToken Enum

/// Enumeration of all spacing tokens for type-safe usage
public enum SpacingToken: CGFloat, CaseIterable, Sendable {
    case none = 0
    case xxs = 2
    case xs = 4
    case sm = 8
    case md = 16
    case lg = 24
    case xl = 32
    case xxl = 48

    /// The CGFloat value of this spacing token
    public var value: CGFloat { rawValue }

    /// Returns the spacing value as a multiple of the base unit
    public var gridMultiple: Int {
        switch self {
        case .none: return 0
        case .xxs: return 0 // Special case: half base unit
        case .xs: return 1
        case .sm: return 2
        case .md: return 4
        case .lg: return 6
        case .xl: return 8
        case .xxl: return 12
        }
    }

    /// Human-readable description of the token
    public var description: String {
        switch self {
        case .none: return "None (0pt)"
        case .xxs: return "XXS (2pt)"
        case .xs: return "XS (4pt)"
        case .sm: return "SM (8pt)"
        case .md: return "MD (16pt)"
        case .lg: return "LG (24pt)"
        case .xl: return "XL (32pt)"
        case .xxl: return "XXL (48pt)"
        }
    }
}

// MARK: - Directional Spacing

/// Directional spacing helpers for horizontal layouts
public enum HorizontalSpacing {
    public static let xxs: CGFloat = Spacing.xxs
    public static let xs: CGFloat = Spacing.xs
    public static let sm: CGFloat = Spacing.sm
    public static let md: CGFloat = Spacing.md
    public static let lg: CGFloat = Spacing.lg
    public static let xl: CGFloat = Spacing.xl
    public static let xxl: CGFloat = Spacing.xxl

    /// Standard horizontal content padding
    public static let contentPadding: CGFloat = Spacing.md

    /// Standard horizontal margin for screen edges
    public static let screenMargin: CGFloat = Spacing.md
}

/// Directional spacing helpers for vertical layouts
public enum VerticalSpacing {
    public static let xxs: CGFloat = Spacing.xxs
    public static let xs: CGFloat = Spacing.xs
    public static let sm: CGFloat = Spacing.sm
    public static let md: CGFloat = Spacing.md
    public static let lg: CGFloat = Spacing.lg
    public static let xl: CGFloat = Spacing.xl
    public static let xxl: CGFloat = Spacing.xxl

    /// Standard vertical content padding
    public static let contentPadding: CGFloat = Spacing.md

    /// Standard vertical section spacing
    public static let sectionSpacing: CGFloat = Spacing.lg
}

// MARK: - Spacing Namespace Extensions

extension Spacing {
    /// Horizontal spacing namespace
    public enum horizontal {
        public static let xxs: CGFloat = HorizontalSpacing.xxs
        public static let xs: CGFloat = HorizontalSpacing.xs
        public static let sm: CGFloat = HorizontalSpacing.sm
        public static let md: CGFloat = HorizontalSpacing.md
        public static let lg: CGFloat = HorizontalSpacing.lg
        public static let xl: CGFloat = HorizontalSpacing.xl
        public static let xxl: CGFloat = HorizontalSpacing.xxl
    }

    /// Vertical spacing namespace
    public enum vertical {
        public static let xxs: CGFloat = VerticalSpacing.xxs
        public static let xs: CGFloat = VerticalSpacing.xs
        public static let sm: CGFloat = VerticalSpacing.sm
        public static let md: CGFloat = VerticalSpacing.md
        public static let lg: CGFloat = VerticalSpacing.lg
        public static let xl: CGFloat = VerticalSpacing.xl
        public static let xxl: CGFloat = VerticalSpacing.xxl
    }
}

// MARK: - Custom Spacing

extension Spacing {
    /// Creates a custom spacing value based on the 4pt grid.
    /// - Parameter multiplier: Number of base units (4pt each)
    /// - Returns: The calculated spacing value
    ///
    /// Example:
    /// ```swift
    /// Spacing.custom(3)  // Returns 12pt
    /// Spacing.custom(5)  // Returns 20pt
    /// ```
    public static func custom(_ multiplier: Int) -> CGFloat {
        CGFloat(multiplier) * baseUnit
    }

    /// Creates a custom spacing value, clamped to valid token values.
    /// - Parameter value: The desired spacing value
    /// - Returns: The nearest valid spacing token value
    public static func nearestToken(to value: CGFloat) -> SpacingToken {
        let tokens = SpacingToken.allCases
        return tokens.min(by: { abs($0.value - value) < abs($1.value - value) }) ?? .md
    }
}
