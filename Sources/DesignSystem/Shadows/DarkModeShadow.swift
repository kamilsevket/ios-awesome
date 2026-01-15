import SwiftUI

// MARK: - Dark Mode Shadow Configuration

/// Configuration for dark mode shadow behavior.
public struct DarkModeShadowConfig: Sendable {
    /// Multiplier for shadow opacity in dark mode.
    public let opacityMultiplier: Double

    /// Whether to add a subtle glow effect in dark mode.
    public let enableGlow: Bool

    /// The glow color for dark mode (typically a lighter color).
    public let glowColor: Color

    /// The glow opacity.
    public let glowOpacity: Double

    public init(
        opacityMultiplier: Double = 3.0,
        enableGlow: Bool = false,
        glowColor: Color = .white,
        glowOpacity: Double = 0.05
    ) {
        self.opacityMultiplier = opacityMultiplier
        self.enableGlow = enableGlow
        self.glowColor = glowColor
        self.glowOpacity = glowOpacity
    }

    /// Default configuration for standard dark mode shadows.
    public static let standard = DarkModeShadowConfig()

    /// Configuration with subtle glow for enhanced visibility.
    public static let withGlow = DarkModeShadowConfig(
        enableGlow: true,
        glowOpacity: 0.08
    )

    /// Subtle configuration for minimal dark mode shadows.
    public static let subtle = DarkModeShadowConfig(opacityMultiplier: 2.0)
}

// MARK: - Adaptive Shadow Modifier

/// A view modifier that applies shadows with enhanced dark mode adaptation.
public struct AdaptiveShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let token: ShadowToken
    private let config: DarkModeShadowConfig

    public init(token: ShadowToken, config: DarkModeShadowConfig = .standard) {
        self.token = token
        self.config = config
    }

    public func body(content: Content) -> some View {
        content
            .shadow(
                color: shadowColor,
                radius: token.blur / 2,
                x: token.x,
                y: token.y
            )
            .applyGlow()
    }

    private var shadowColor: Color {
        if colorScheme == .dark {
            return Color.black.opacity(token.opacity * config.opacityMultiplier)
        }
        return token.color
    }

    @ViewBuilder
    private func applyGlow() -> some View {
        if colorScheme == .dark && config.enableGlow && token != .none {
            self.shadow(
                color: config.glowColor.opacity(config.glowOpacity),
                radius: token.blur / 4,
                x: 0,
                y: -token.y / 2
            )
        }
    }
}

// MARK: - Private Glow Extension

private extension View {
    @ViewBuilder
    func shadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        self.modifier(GlowShadowModifier(color: color, radius: radius, x: x, y: y))
    }
}

private struct GlowShadowModifier: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    func body(content: Content) -> some View {
        content.shadow(color: color, radius: radius, x: x, y: y)
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a shadow with custom dark mode configuration.
    ///
    /// - Parameters:
    ///   - token: The shadow token to apply.
    ///   - darkModeConfig: Configuration for dark mode shadow behavior.
    /// - Returns: A view with adaptive shadow applied.
    ///
    /// Usage:
    /// ```swift
    /// Card()
    ///     .adaptiveShadow(.md, darkModeConfig: .withGlow)
    /// ```
    func adaptiveShadow(
        _ token: ShadowToken,
        darkModeConfig: DarkModeShadowConfig = .standard
    ) -> some View {
        modifier(AdaptiveShadowModifier(token: token, config: darkModeConfig))
    }
}

// MARK: - Color Scheme Specific Shadow

public extension View {
    /// Applies different shadow tokens based on the color scheme.
    ///
    /// - Parameters:
    ///   - lightToken: Shadow token for light mode.
    ///   - darkToken: Shadow token for dark mode.
    /// - Returns: A view with color scheme specific shadow.
    func shadow(
        light lightToken: ShadowToken,
        dark darkToken: ShadowToken
    ) -> some View {
        modifier(ColorSchemeSpecificShadowModifier(
            lightToken: lightToken,
            darkToken: darkToken
        ))
    }
}

/// A view modifier that applies different shadows based on color scheme.
public struct ColorSchemeSpecificShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    private let lightToken: ShadowToken
    private let darkToken: ShadowToken

    public init(lightToken: ShadowToken, darkToken: ShadowToken) {
        self.lightToken = lightToken
        self.darkToken = darkToken
    }

    public func body(content: Content) -> some View {
        let token = colorScheme == .dark ? darkToken : lightToken
        content.shadow(token)
    }
}
