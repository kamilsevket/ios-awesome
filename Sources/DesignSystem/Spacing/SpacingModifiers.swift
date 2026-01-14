import SwiftUI

// MARK: - Spacing View Modifiers

/// A view modifier that applies consistent spacing using design system tokens
public struct SpacingModifier: ViewModifier {
    let edges: Edge.Set
    let token: SpacingToken

    public init(edges: Edge.Set = .all, token: SpacingToken) {
        self.edges = edges
        self.token = token
    }

    public func body(content: Content) -> some View {
        content.padding(edges, token.value)
    }
}

/// A view modifier for applying inset spacing (equal padding on all sides)
public struct InsetSpacingModifier: ViewModifier {
    let horizontal: SpacingToken
    let vertical: SpacingToken

    public init(horizontal: SpacingToken = .md, vertical: SpacingToken = .md) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontal.value)
            .padding(.vertical, vertical.value)
    }
}

/// A view modifier for stack spacing (consistent gap between items)
public struct StackSpacingModifier: ViewModifier {
    let spacing: SpacingToken
    let axis: Axis

    public init(spacing: SpacingToken = .md, axis: Axis = .vertical) {
        self.spacing = spacing
        self.axis = axis
    }

    public func body(content: Content) -> some View {
        content
    }
}

// MARK: - View Extension for Modifiers

extension View {
    /// Applies spacing using a design system token
    /// - Parameters:
    ///   - edges: The edges to apply spacing to
    ///   - token: The spacing token to use
    /// - Returns: A view with the spacing applied
    public func spacing(_ edges: Edge.Set = .all, _ token: SpacingToken) -> some View {
        modifier(SpacingModifier(edges: edges, token: token))
    }

    /// Applies inset spacing with separate horizontal and vertical values
    /// - Parameters:
    ///   - horizontal: Horizontal spacing token
    ///   - vertical: Vertical spacing token
    /// - Returns: A view with inset spacing
    public func insetSpacing(
        horizontal: SpacingToken = .md,
        vertical: SpacingToken = .md
    ) -> some View {
        modifier(InsetSpacingModifier(horizontal: horizontal, vertical: vertical))
    }

    /// Applies uniform inset spacing
    /// - Parameter token: The spacing token for all sides
    /// - Returns: A view with uniform inset spacing
    public func insetSpacing(_ token: SpacingToken) -> some View {
        modifier(InsetSpacingModifier(horizontal: token, vertical: token))
    }
}

// MARK: - Card Spacing Modifier

/// A view modifier that applies card-like spacing and styling
public struct CardSpacingModifier: ViewModifier {
    let inset: SpacingToken
    let cornerRadius: CGFloat

    public init(inset: SpacingToken = .md, cornerRadius: CGFloat = LayoutConstants.cardCornerRadius) {
        self.inset = inset
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .padding(inset.value)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemBackground))
            )
    }
}

extension View {
    /// Applies card-style spacing with optional corner radius
    /// - Parameters:
    ///   - inset: Interior padding token
    ///   - cornerRadius: Corner radius for the card
    /// - Returns: A card-styled view
    public func cardSpacing(
        inset: SpacingToken = .md,
        cornerRadius: CGFloat = LayoutConstants.cardCornerRadius
    ) -> some View {
        modifier(CardSpacingModifier(inset: inset, cornerRadius: cornerRadius))
    }
}

// MARK: - Divider with Spacing

/// A divider with built-in spacing
public struct SpacedDivider: View {
    let spacing: SpacingToken
    let color: Color

    public init(spacing: SpacingToken = .md, color: Color = Color(.separator)) {
        self.spacing = spacing
        self.color = color
    }

    public var body: some View {
        Divider()
            .background(color)
            .padding(.vertical, spacing.value)
    }
}

// MARK: - Section Spacing Modifier

/// A view modifier for section-level spacing
public struct SectionSpacingModifier: ViewModifier {
    let topSpacing: SpacingToken
    let bottomSpacing: SpacingToken
    let horizontalInset: SpacingToken

    public init(
        topSpacing: SpacingToken = .lg,
        bottomSpacing: SpacingToken = .md,
        horizontalInset: SpacingToken = .md
    ) {
        self.topSpacing = topSpacing
        self.bottomSpacing = bottomSpacing
        self.horizontalInset = horizontalInset
    }

    public func body(content: Content) -> some View {
        content
            .padding(.top, topSpacing.value)
            .padding(.bottom, bottomSpacing.value)
            .padding(.horizontal, horizontalInset.value)
    }
}

extension View {
    /// Applies section-level spacing
    /// - Parameters:
    ///   - topSpacing: Top padding token
    ///   - bottomSpacing: Bottom padding token
    ///   - horizontalInset: Horizontal padding token
    /// - Returns: A view with section spacing
    public func sectionSpacing(
        topSpacing: SpacingToken = .lg,
        bottomSpacing: SpacingToken = .md,
        horizontalInset: SpacingToken = .md
    ) -> some View {
        modifier(SectionSpacingModifier(
            topSpacing: topSpacing,
            bottomSpacing: bottomSpacing,
            horizontalInset: horizontalInset
        ))
    }
}

// MARK: - List Row Spacing Modifier

/// A view modifier for list row spacing
public struct ListRowSpacingModifier: ViewModifier {
    let verticalPadding: SpacingToken
    let horizontalPadding: SpacingToken
    let minHeight: CGFloat

    public init(
        verticalPadding: SpacingToken = .sm,
        horizontalPadding: SpacingToken = .md,
        minHeight: CGFloat = LayoutConstants.listRowMinHeight
    ) {
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.minHeight = minHeight
    }

    public func body(content: Content) -> some View {
        content
            .padding(.vertical, verticalPadding.value)
            .padding(.horizontal, horizontalPadding.value)
            .frame(minHeight: minHeight)
    }
}

extension View {
    /// Applies list row spacing
    /// - Parameters:
    ///   - verticalPadding: Vertical padding token
    ///   - horizontalPadding: Horizontal padding token
    ///   - minHeight: Minimum row height
    /// - Returns: A view with list row spacing
    public func listRowSpacing(
        verticalPadding: SpacingToken = .sm,
        horizontalPadding: SpacingToken = .md,
        minHeight: CGFloat = LayoutConstants.listRowMinHeight
    ) -> some View {
        modifier(ListRowSpacingModifier(
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding,
            minHeight: minHeight
        ))
    }
}

// MARK: - Touch Target Modifier

/// Ensures a view meets minimum touch target requirements
public struct TouchTargetModifier: ViewModifier {
    let minSize: CGFloat

    public init(minSize: CGFloat = LayoutConstants.minTouchTarget) {
        self.minSize = minSize
    }

    public func body(content: Content) -> some View {
        content
            .frame(minWidth: minSize, minHeight: minSize)
            .contentShape(Rectangle())
    }
}

extension View {
    /// Ensures the view meets minimum touch target size
    /// - Parameter minSize: Minimum touch target size (default: 44pt)
    /// - Returns: A view with guaranteed minimum touch target size
    public func touchTarget(minSize: CGFloat = LayoutConstants.minTouchTarget) -> some View {
        modifier(TouchTargetModifier(minSize: minSize))
    }
}

// MARK: - Spacing Debug Modifier

#if DEBUG
/// A debug modifier that visualizes spacing boundaries
public struct SpacingDebugModifier: ViewModifier {
    let color: Color

    public init(color: Color = .red) {
        self.color = color
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .stroke(color, lineWidth: 1)
            )
            .background(color.opacity(0.1))
    }
}

extension View {
    /// Debug helper to visualize view bounds
    /// - Parameter color: The color for the debug overlay
    /// - Returns: A view with debug visualization
    public func debugSpacing(color: Color = .red) -> some View {
        modifier(SpacingDebugModifier(color: color))
    }
}
#endif
