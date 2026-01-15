import CoreGraphics

// MARK: - Spacing Tokens

/// Design System spacing tokens based on 4pt grid system.
///
/// All spacing values are multiples of 4pt to ensure visual consistency
/// and alignment across the entire application.
///
/// ## Usage
/// ```swift
/// .padding(Spacing.md)  // 16pt
/// let margin = Spacing.lg  // 24pt
/// ```
public enum Spacing {

    // MARK: - Base Unit

    /// The base unit for all spacing calculations (4pt)
    public static let baseUnit: CGFloat = 4

    // MARK: - Spacing Scale

    /// Extra extra small spacing: 2pt
    public static let xxs: CGFloat = 2

    /// Extra small spacing: 4pt (1x base unit)
    public static let xs: CGFloat = 4

    /// Small spacing: 8pt (2x base unit)
    public static let sm: CGFloat = 8

    /// Medium spacing: 16pt (4x base unit)
    public static let md: CGFloat = 16

    /// Large spacing: 24pt (6x base unit)
    public static let lg: CGFloat = 24

    /// Extra large spacing: 32pt (8x base unit)
    public static let xl: CGFloat = 32

    /// Extra extra large spacing: 48pt (12x base unit)
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
}
