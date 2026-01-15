import SwiftUI

// MARK: - Size Class

/// Size class categories for responsive layouts
public enum SizeClass: String, CaseIterable, Sendable {
    /// Compact size (iPhone portrait, iPad split view)
    case compact

    /// Regular size (iPhone landscape, iPad portrait)
    case regular

    /// Large size (iPad landscape, large displays)
    case large

    /// The minimum width for this size class
    public var minWidth: CGFloat {
        switch self {
        case .compact: return 0
        case .regular: return 600
        case .large: return 1024
        }
    }

    /// The maximum width for this size class
    public var maxWidth: CGFloat {
        switch self {
        case .compact: return 599
        case .regular: return 1023
        case .large: return .infinity
        }
    }

    /// The recommended content width for this size class
    public var contentWidth: CGFloat {
        switch self {
        case .compact: return LayoutConstants.compactContentWidth
        case .regular: return LayoutConstants.maxContentWidth
        case .large: return LayoutConstants.maxContentWidth
        }
    }

    /// The recommended number of grid columns for this size class
    public var gridColumns: Int {
        switch self {
        case .compact: return 4
        case .regular: return 8
        case .large: return 12
        }
    }
}

// MARK: - Responsive Breakpoints

/// Breakpoint definitions for responsive layouts
public enum ResponsiveBreakpoints {

    // MARK: - Width Breakpoints

    /// Compact width breakpoint (iPhone portrait)
    public static let compactWidth: CGFloat = 600

    /// Regular width breakpoint (iPad portrait)
    public static let regularWidth: CGFloat = 1024

    /// Large width breakpoint (iPad landscape)
    public static let largeWidth: CGFloat = 1366

    // MARK: - Device Widths

    /// iPhone SE width
    public static let iPhoneSE: CGFloat = 320

    /// iPhone standard width
    public static let iPhoneStandard: CGFloat = 375

    /// iPhone Plus/Max width
    public static let iPhonePlus: CGFloat = 414

    /// iPhone Pro Max width
    public static let iPhoneProMax: CGFloat = 428

    /// iPad Mini width (portrait)
    public static let iPadMiniPortrait: CGFloat = 744

    /// iPad width (portrait)
    public static let iPadPortrait: CGFloat = 820

    /// iPad Pro 11" width (portrait)
    public static let iPadPro11Portrait: CGFloat = 834

    /// iPad Pro 12.9" width (portrait)
    public static let iPadPro12Portrait: CGFloat = 1024

    // MARK: - Helpers

    /// Determines the size class for a given width
    /// - Parameter width: The width to evaluate
    /// - Returns: The appropriate size class
    public static func sizeClass(for width: CGFloat) -> SizeClass {
        if width < compactWidth {
            return .compact
        } else if width < regularWidth {
            return .regular
        } else {
            return .large
        }
    }

    /// Checks if the width is considered compact
    /// - Parameter width: The width to check
    /// - Returns: True if compact
    public static func isCompact(_ width: CGFloat) -> Bool {
        width < compactWidth
    }

    /// Checks if the width is considered regular
    /// - Parameter width: The width to check
    /// - Returns: True if regular
    public static func isRegular(_ width: CGFloat) -> Bool {
        width >= compactWidth && width < regularWidth
    }

    /// Checks if the width is considered large
    /// - Parameter width: The width to check
    /// - Returns: True if large
    public static func isLarge(_ width: CGFloat) -> Bool {
        width >= regularWidth
    }
}

// MARK: - Responsive Environment Key

private struct ResponsiveSizeClassKey: EnvironmentKey {
    static let defaultValue: SizeClass = .compact
}

extension EnvironmentValues {
    /// The current responsive size class
    public var responsiveSizeClass: SizeClass {
        get { self[ResponsiveSizeClassKey.self] }
        set { self[ResponsiveSizeClassKey.self] = newValue }
    }
}

// MARK: - Responsive Container

/// A container that provides responsive size class to its content
public struct ResponsiveContainer<Content: View>: View {
    private let content: (SizeClass) -> Content

    public init(@ViewBuilder content: @escaping (SizeClass) -> Content) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { geometry in
            let sizeClass = ResponsiveBreakpoints.sizeClass(for: geometry.size.width)
            content(sizeClass)
                .environment(\.responsiveSizeClass, sizeClass)
        }
    }
}

// MARK: - Responsive Value

/// A type that holds different values for each size class
public struct ResponsiveValue<T> {
    public let compact: T
    public let regular: T
    public let large: T

    public init(compact: T, regular: T, large: T) {
        self.compact = compact
        self.regular = regular
        self.large = large
    }

    /// Creates a responsive value with the same value for all size classes
    public init(_ value: T) {
        self.compact = value
        self.regular = value
        self.large = value
    }

    /// Returns the value for the given size class
    public func value(for sizeClass: SizeClass) -> T {
        switch sizeClass {
        case .compact: return compact
        case .regular: return regular
        case .large: return large
        }
    }
}

// MARK: - Responsive Spacing

/// Pre-defined responsive spacing values
public enum ResponsiveSpacing {

    /// Responsive page margins
    public static let pageMargin = ResponsiveValue(
        compact: Spacing.md,
        regular: Spacing.lg,
        large: Spacing.xl
    )

    /// Responsive section spacing
    public static let sectionSpacing = ResponsiveValue(
        compact: Spacing.lg,
        regular: Spacing.xl,
        large: Spacing.xxl
    )

    /// Responsive item spacing
    public static let itemSpacing = ResponsiveValue(
        compact: Spacing.sm,
        regular: Spacing.md,
        large: Spacing.md
    )

    /// Responsive card padding
    public static let cardPadding = ResponsiveValue(
        compact: Spacing.md,
        regular: Spacing.lg,
        large: Spacing.lg
    )

    /// Responsive grid gap
    public static let gridGap = ResponsiveValue(
        compact: Spacing.sm,
        regular: Spacing.md,
        large: Spacing.lg
    )
}

// MARK: - Responsive View Modifiers

extension View {
    /// Applies responsive padding based on size class
    /// - Parameter responsive: Responsive spacing values
    /// - Returns: View with responsive padding
    @ViewBuilder
    public func responsivePadding(_ responsive: ResponsiveValue<CGFloat>) -> some View {
        ResponsiveContainer { sizeClass in
            self.padding(responsive.value(for: sizeClass))
        }
    }

    /// Applies responsive horizontal padding
    @ViewBuilder
    public func responsiveHorizontalPadding() -> some View {
        ResponsiveContainer { sizeClass in
            self.padding(.horizontal, ResponsiveSpacing.pageMargin.value(for: sizeClass))
        }
    }

    /// Applies responsive frame width
    /// - Parameter responsive: Responsive width values
    /// - Returns: View with responsive width
    @ViewBuilder
    public func responsiveWidth(_ responsive: ResponsiveValue<CGFloat?>) -> some View {
        ResponsiveContainer { sizeClass in
            self.frame(maxWidth: responsive.value(for: sizeClass))
        }
    }

    /// Constrains content to maximum readable width on larger screens
    @ViewBuilder
    public func readableContentWidth() -> some View {
        ResponsiveContainer { sizeClass in
            switch sizeClass {
            case .compact:
                self
            case .regular, .large:
                self.frame(maxWidth: LayoutConstants.maxContentWidth)
            }
        }
    }
}

// MARK: - Responsive Grid

/// Calculates grid columns based on size class
public struct ResponsiveGrid {

    /// Returns the number of columns for a grid layout
    /// - Parameters:
    ///   - sizeClass: The current size class
    ///   - itemMinWidth: Minimum width per item
    ///   - containerWidth: Available container width
    /// - Returns: Number of columns
    public static func columns(
        for sizeClass: SizeClass,
        itemMinWidth: CGFloat = 160,
        containerWidth: CGFloat
    ) -> Int {
        let availableWidth = containerWidth - (2 * ResponsiveSpacing.pageMargin.value(for: sizeClass))
        let gap = ResponsiveSpacing.gridGap.value(for: sizeClass)

        var columns = Int(availableWidth / (itemMinWidth + gap))
        columns = max(1, min(columns, sizeClass.gridColumns))

        return columns
    }

    /// Creates adaptive grid columns
    /// - Parameter minWidth: Minimum item width
    /// - Returns: Array of GridItem for LazyVGrid
    public static func adaptiveColumns(minWidth: CGFloat = 160) -> [GridItem] {
        [GridItem(.adaptive(minimum: minWidth, maximum: .infinity))]
    }

    /// Creates fixed grid columns for a size class
    /// - Parameters:
    ///   - count: Number of columns
    ///   - spacing: Spacing between columns
    /// - Returns: Array of GridItem for LazyVGrid
    public static func fixedColumns(count: Int, spacing: CGFloat = Spacing.md) -> [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: count)
    }
}
