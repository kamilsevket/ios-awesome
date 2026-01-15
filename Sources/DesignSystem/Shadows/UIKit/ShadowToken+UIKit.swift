#if canImport(UIKit)
import UIKit

// MARK: - UIKit Shadow Extensions

public extension ShadowToken {
    /// Applies this shadow token to a CALayer.
    ///
    /// - Parameters:
    ///   - layer: The layer to apply the shadow to.
    ///   - isDarkMode: Whether to use dark mode shadow values.
    func apply(to layer: CALayer, isDarkMode: Bool = false) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Float(isDarkMode ? darkModeOpacity : opacity)
        layer.shadowRadius = blur / 2
        layer.shadowOffset = CGSize(width: x, height: y)
    }

    /// Applies this shadow token to a UIView.
    ///
    /// - Parameters:
    ///   - view: The view to apply the shadow to.
    ///   - isDarkMode: Whether to use dark mode shadow values.
    func apply(to view: UIView, isDarkMode: Bool = false) {
        apply(to: view.layer, isDarkMode: isDarkMode)
    }
}

// MARK: - CALayer Extension

public extension CALayer {
    /// Applies a design system shadow token to this layer.
    ///
    /// - Parameters:
    ///   - token: The shadow token to apply.
    ///   - isDarkMode: Whether to use dark mode shadow values.
    func applyShadow(_ token: ShadowToken, isDarkMode: Bool = false) {
        token.apply(to: self, isDarkMode: isDarkMode)
    }

    /// Removes shadow from this layer.
    func removeShadow() {
        shadowOpacity = 0
        shadowRadius = 0
        shadowOffset = .zero
    }

    /// Configures shadow path for better performance.
    ///
    /// Call this after the layer's bounds are set for optimized shadow rendering.
    ///
    /// - Parameter cornerRadius: The corner radius to use for the shadow path.
    func configureShadowPath(cornerRadius: CGFloat = 0) {
        shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
}

// MARK: - UIView Extension

public extension UIView {
    /// Applies a design system shadow token to this view.
    ///
    /// - Parameters:
    ///   - token: The shadow token to apply.
    ///   - isDarkMode: Whether to use dark mode shadow values.
    func applyShadow(_ token: ShadowToken, isDarkMode: Bool = false) {
        layer.applyShadow(token, isDarkMode: isDarkMode)
    }

    /// Applies a design system elevation level to this view.
    ///
    /// - Parameters:
    ///   - level: The elevation level to apply.
    ///   - isDarkMode: Whether to use dark mode shadow values.
    func applyElevation(_ level: ElevationLevel, isDarkMode: Bool = false) {
        applyShadow(level.shadowToken, isDarkMode: isDarkMode)
    }

    /// Removes shadow from this view.
    func removeShadow() {
        layer.removeShadow()
    }

    /// Updates shadow for the current trait collection.
    ///
    /// Call this in `traitCollectionDidChange` to update shadows for dark mode.
    ///
    /// - Parameter token: The shadow token currently applied.
    func updateShadowForTraitCollection(_ token: ShadowToken) {
        let isDarkMode = traitCollection.userInterfaceStyle == .dark
        applyShadow(token, isDarkMode: isDarkMode)
    }
}

// MARK: - Shadow Configuration Struct

/// A configuration object for UIKit shadow properties.
public struct UIShadowConfiguration {
    public let color: UIColor
    public let opacity: Float
    public let radius: CGFloat
    public let offset: CGSize

    public init(token: ShadowToken, isDarkMode: Bool = false) {
        self.color = .black
        self.opacity = Float(isDarkMode ? token.darkModeOpacity : token.opacity)
        self.radius = token.blur / 2
        self.offset = CGSize(width: token.x, height: token.y)
    }

    /// Applies this configuration to a CALayer.
    public func apply(to layer: CALayer) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
    }
}
#endif
