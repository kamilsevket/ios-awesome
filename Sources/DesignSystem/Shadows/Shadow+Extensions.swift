import SwiftUI

// MARK: - Shadow View Modifier

/// A view modifier that applies design system shadow tokens with automatic dark mode adaptation.
public struct DSShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let token: ShadowToken

    public init(token: ShadowToken) {
        self.token = token
    }

    public func body(content: Content) -> some View {
        content
            .shadow(
                color: shadowColor,
                radius: token.blur / 2,
                x: token.x,
                y: token.y
            )
    }

    private var shadowColor: Color {
        colorScheme == .dark ? token.darkModeColor : token.color
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a design system shadow token to the view.
    ///
    /// The shadow automatically adapts to dark mode with adjusted opacity.
    ///
    /// - Parameter token: The shadow token to apply.
    /// - Returns: A view with the shadow applied.
    ///
    /// Usage:
    /// ```swift
    /// Rectangle()
    ///     .shadow(.ds.md)
    /// ```
    func shadow(_ token: ShadowToken) -> some View {
        modifier(DSShadowModifier(token: token))
    }

    /// Applies multiple layered shadows for a more realistic depth effect.
    ///
    /// - Parameter token: The shadow token to use as the base.
    /// - Returns: A view with layered shadows applied.
    func layeredShadow(_ token: ShadowToken) -> some View {
        modifier(LayeredShadowModifier(token: token))
    }
}

// MARK: - Layered Shadow Modifier

/// A view modifier that applies multiple shadow layers for more realistic depth.
public struct LayeredShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let token: ShadowToken

    public init(token: ShadowToken) {
        self.token = token
    }

    public func body(content: Content) -> some View {
        content
            .shadow(
                color: primaryShadowColor,
                radius: token.blur / 2,
                x: token.x,
                y: token.y
            )
            .shadow(
                color: secondaryShadowColor,
                radius: token.blur / 4,
                x: token.x,
                y: token.y / 2
            )
    }

    private var primaryShadowColor: Color {
        colorScheme == .dark ? token.darkModeColor : token.color
    }

    private var secondaryShadowColor: Color {
        let opacity = colorScheme == .dark ? token.darkModeOpacity * 0.5 : token.opacity * 0.5
        return Color.black.opacity(opacity)
    }
}

// MARK: - Conditional Shadow Modifier

public extension View {
    /// Conditionally applies a shadow based on a boolean condition.
    ///
    /// - Parameters:
    ///   - condition: Whether to apply the shadow.
    ///   - token: The shadow token to apply when condition is true.
    /// - Returns: A view with or without the shadow.
    @ViewBuilder
    func shadow(_ token: ShadowToken, when condition: Bool) -> some View {
        if condition {
            self.shadow(token)
        } else {
            self
        }
    }
}
