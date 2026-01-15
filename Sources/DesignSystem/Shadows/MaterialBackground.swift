import SwiftUI

// MARK: - Material Style

/// Design system material styles for blur effects and translucent backgrounds.
public enum DSMaterialStyle: CaseIterable, Sendable {
    /// Ultra-thin material with maximum transparency.
    case ultraThin
    /// Thin material with high transparency.
    case thin
    /// Regular material with balanced transparency.
    case regular
    /// Thick material with low transparency.
    case thick
    /// Ultra-thick material (chromeMaterial) with minimal transparency.
    case ultraThick

    /// The corresponding SwiftUI Material.
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public var material: Material {
        switch self {
        case .ultraThin: return .ultraThinMaterial
        case .thin: return .thinMaterial
        case .regular: return .regularMaterial
        case .thick: return .thickMaterial
        case .ultraThick: return .ultraThickMaterial
        }
    }
}

// MARK: - Material Background Modifier

/// A view modifier that applies a material background with optional elevation.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct MaterialBackgroundModifier: ViewModifier {
    private let style: DSMaterialStyle
    private let elevation: ElevationLevel?
    private let cornerRadius: CGFloat

    public init(
        style: DSMaterialStyle,
        elevation: ElevationLevel? = nil,
        cornerRadius: CGFloat = 0
    ) {
        self.style = style
        self.elevation = elevation
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(style.material)
            )
            .applyElevation(elevation)
    }
}

// MARK: - Private Elevation Helper

private extension View {
    @ViewBuilder
    func applyElevation(_ level: ElevationLevel?) -> some View {
        if let level = level {
            self.elevation(level)
        } else {
            self
        }
    }
}

// MARK: - View Extension

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {
    /// Applies a material background with optional elevation.
    ///
    /// - Parameters:
    ///   - style: The material style to apply.
    ///   - elevation: Optional elevation level for shadow.
    ///   - cornerRadius: Corner radius for the background.
    /// - Returns: A view with the material background applied.
    ///
    /// Usage:
    /// ```swift
    /// Text("Blurred")
    ///     .materialBackground(.ultraThin)
    ///
    /// Card()
    ///     .materialBackground(.regular, elevation: .card, cornerRadius: 12)
    /// ```
    func materialBackground(
        _ style: DSMaterialStyle,
        elevation: ElevationLevel? = nil,
        cornerRadius: CGFloat = 0
    ) -> some View {
        modifier(MaterialBackgroundModifier(
            style: style,
            elevation: elevation,
            cornerRadius: cornerRadius
        ))
    }

    /// Applies an ultra-thin material background.
    ///
    /// Convenience method for the most common blur effect.
    func blurredBackground(cornerRadius: CGFloat = 0) -> some View {
        materialBackground(.ultraThin, cornerRadius: cornerRadius)
    }

    /// Applies a frosted glass effect with elevation.
    ///
    /// - Parameters:
    ///   - cornerRadius: Corner radius for the background.
    ///   - elevation: Elevation level for the glass effect.
    /// - Returns: A view with a frosted glass appearance.
    func frostedGlass(
        cornerRadius: CGFloat = 16,
        elevation: ElevationLevel = .raised
    ) -> some View {
        materialBackground(.thin, elevation: elevation, cornerRadius: cornerRadius)
    }
}

// MARK: - Vibrancy Effect

/// A container that applies vibrancy effect to its content.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct VibrancyContainer<Content: View>: View {
    private let material: DSMaterialStyle
    private let content: Content

    public init(
        material: DSMaterialStyle = .thin,
        @ViewBuilder content: () -> Content
    ) {
        self.material = material
        self.content = content()
    }

    public var body: some View {
        content
            .background(material.material)
    }
}
