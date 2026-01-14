import SwiftUI

// MARK: - Design System Namespace

/// Design System namespace for SwiftUI extensions
public struct DesignSystemSpacing {
    public let xxs: CGFloat = Spacing.xxs
    public let xs: CGFloat = Spacing.xs
    public let sm: CGFloat = Spacing.sm
    public let md: CGFloat = Spacing.md
    public let lg: CGFloat = Spacing.lg
    public let xl: CGFloat = Spacing.xl
    public let xxl: CGFloat = Spacing.xxl
    public let none: CGFloat = Spacing.none

    fileprivate init() {}
}

// MARK: - Edge Insets Extensions

extension EdgeInsets {
    /// Design System spacing namespace
    public static let ds = DesignSystemSpacing()

    /// Creates uniform edge insets using a spacing token
    public static func uniform(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
    }

    /// Creates uniform edge insets using a spacing token enum
    public static func uniform(_ token: SpacingToken) -> EdgeInsets {
        uniform(token.value)
    }

    /// Creates horizontal edge insets
    public static func horizontal(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    }

    /// Creates horizontal edge insets using a spacing token
    public static func horizontal(_ token: SpacingToken) -> EdgeInsets {
        horizontal(token.value)
    }

    /// Creates vertical edge insets
    public static func vertical(_ spacing: CGFloat) -> EdgeInsets {
        EdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)
    }

    /// Creates vertical edge insets using a spacing token
    public static func vertical(_ token: SpacingToken) -> EdgeInsets {
        vertical(token.value)
    }

    /// Creates edge insets with custom values per edge
    public static func edges(
        top: CGFloat = 0,
        leading: CGFloat = 0,
        bottom: CGFloat = 0,
        trailing: CGFloat = 0
    ) -> EdgeInsets {
        EdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    /// Creates edge insets using spacing tokens
    public static func edges(
        top: SpacingToken = .none,
        leading: SpacingToken = .none,
        bottom: SpacingToken = .none,
        trailing: SpacingToken = .none
    ) -> EdgeInsets {
        EdgeInsets(
            top: top.value,
            leading: leading.value,
            bottom: bottom.value,
            trailing: trailing.value
        )
    }
}

// MARK: - CGFloat Design System Extension

extension CGFloat {
    /// Design System spacing namespace
    public static let ds = DesignSystemSpacing()
}

// MARK: - View Padding Extensions

extension View {
    /// Applies padding using a spacing token on all edges
    /// - Parameter token: The spacing token to use
    /// - Returns: A view with the specified padding
    @ViewBuilder
    public func padding(_ token: SpacingToken) -> some View {
        self.padding(token.value)
    }

    /// Applies padding using a spacing token on specific edges
    /// - Parameters:
    ///   - edges: The edges to apply padding to
    ///   - token: The spacing token to use
    /// - Returns: A view with the specified padding
    @ViewBuilder
    public func padding(_ edges: Edge.Set, _ token: SpacingToken) -> some View {
        self.padding(edges, token.value)
    }

    /// Applies horizontal padding using a spacing token
    /// - Parameter token: The spacing token to use
    /// - Returns: A view with horizontal padding
    @ViewBuilder
    public func horizontalPadding(_ token: SpacingToken) -> some View {
        self.padding(.horizontal, token.value)
    }

    /// Applies horizontal padding using a spacing value
    /// - Parameter spacing: The spacing value to use
    /// - Returns: A view with horizontal padding
    @ViewBuilder
    public func horizontalPadding(_ spacing: CGFloat = Spacing.md) -> some View {
        self.padding(.horizontal, spacing)
    }

    /// Applies vertical padding using a spacing token
    /// - Parameter token: The spacing token to use
    /// - Returns: A view with vertical padding
    @ViewBuilder
    public func verticalPadding(_ token: SpacingToken) -> some View {
        self.padding(.vertical, token.value)
    }

    /// Applies vertical padding using a spacing value
    /// - Parameter spacing: The spacing value to use
    /// - Returns: A view with vertical padding
    @ViewBuilder
    public func verticalPadding(_ spacing: CGFloat = Spacing.md) -> some View {
        self.padding(.vertical, spacing)
    }

    /// Applies content padding (standard page margins)
    /// - Returns: A view with standard content padding
    @ViewBuilder
    public func contentPadding() -> some View {
        self.padding(.horizontal, Spacing.pageMargin)
            .padding(.vertical, Spacing.md)
    }

    /// Applies section padding (larger vertical spacing)
    /// - Returns: A view with section-level padding
    @ViewBuilder
    public func sectionPadding() -> some View {
        self.padding(.horizontal, Spacing.pageMargin)
            .padding(.vertical, Spacing.section)
    }
}

// MARK: - Stack Spacing Extensions

extension VStack {
    /// Creates a VStack with design system spacing
    /// - Parameters:
    ///   - alignment: Horizontal alignment
    ///   - token: Spacing token for item spacing
    ///   - content: Content builder
    public init(
        alignment: HorizontalAlignment = .center,
        spacing token: SpacingToken,
        @ViewBuilder content: () -> Content
    ) {
        self.init(alignment: alignment, spacing: token.value, content: content)
    }
}

extension HStack {
    /// Creates an HStack with design system spacing
    /// - Parameters:
    ///   - alignment: Vertical alignment
    ///   - token: Spacing token for item spacing
    ///   - content: Content builder
    public init(
        alignment: VerticalAlignment = .center,
        spacing token: SpacingToken,
        @ViewBuilder content: () -> Content
    ) {
        self.init(alignment: alignment, spacing: token.value, content: content)
    }
}

// MARK: - LazyStack Extensions

extension LazyVStack {
    /// Creates a LazyVStack with design system spacing
    /// - Parameters:
    ///   - alignment: Horizontal alignment
    ///   - token: Spacing token for item spacing
    ///   - pinnedViews: Pinned header/footer views
    ///   - content: Content builder
    public init(
        alignment: HorizontalAlignment = .center,
        spacing token: SpacingToken,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: token.value,
            pinnedViews: pinnedViews,
            content: content
        )
    }
}

extension LazyHStack {
    /// Creates a LazyHStack with design system spacing
    /// - Parameters:
    ///   - alignment: Vertical alignment
    ///   - token: Spacing token for item spacing
    ///   - pinnedViews: Pinned header/footer views
    ///   - content: Content builder
    public init(
        alignment: VerticalAlignment = .center,
        spacing token: SpacingToken,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            alignment: alignment,
            spacing: token.value,
            pinnedViews: pinnedViews,
            content: content
        )
    }
}

// MARK: - Spacer Extensions

extension Spacer {
    /// Creates a fixed-size spacer using a spacing token
    /// - Parameter token: The spacing token for the spacer size
    /// - Returns: A spacer view with fixed size
    public static func fixed(_ token: SpacingToken) -> some View {
        Spacer()
            .frame(width: token.value, height: token.value)
    }

    /// Creates a horizontal spacer with fixed width
    /// - Parameter token: The spacing token for the width
    /// - Returns: A spacer view with fixed width
    public static func horizontal(_ token: SpacingToken) -> some View {
        Spacer()
            .frame(width: token.value)
    }

    /// Creates a vertical spacer with fixed height
    /// - Parameter token: The spacing token for the height
    /// - Returns: A spacer view with fixed height
    public static func vertical(_ token: SpacingToken) -> some View {
        Spacer()
            .frame(height: token.value)
    }
}

// MARK: - Frame Extensions

extension View {
    /// Adds minimum spacing constraints to a view
    /// - Parameters:
    ///   - minWidth: Minimum width token
    ///   - minHeight: Minimum height token
    /// - Returns: View with minimum size constraints
    @ViewBuilder
    public func minSize(
        width minWidth: SpacingToken? = nil,
        height minHeight: SpacingToken? = nil
    ) -> some View {
        self.frame(
            minWidth: minWidth?.value,
            minHeight: minHeight?.value
        )
    }
}

// MARK: - Grid Spacing

extension View {
    /// Validates that a value conforms to the 4pt grid
    /// - Parameter value: The value to check
    /// - Returns: True if the value is on the 4pt grid
    public static func isOnGrid(_ value: CGFloat) -> Bool {
        value.truncatingRemainder(dividingBy: Spacing.baseUnit) == 0 || value == Spacing.xxs
    }
}
