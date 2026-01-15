#if canImport(UIKit)
import UIKit

// MARK: - UIImage + SFSymbol

public extension UIImage {
    /// Creates a UIImage from an SF Symbol
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to create an image from
    ///   - configuration: Optional symbol configuration for customization
    /// - Returns: A UIImage of the SF Symbol, or nil if the symbol is unavailable
    convenience init?(sfSymbol: SFSymbol, configuration: UIImage.SymbolConfiguration? = nil) {
        self.init(systemName: sfSymbol.systemName, withConfiguration: configuration)
    }

    /// Creates a UIImage from an SF Symbol with a specific point size
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to create an image from
    ///   - pointSize: The point size for the symbol
    ///   - weight: The weight of the symbol (default: .regular)
    /// - Returns: A UIImage of the SF Symbol, or nil if the symbol is unavailable
    convenience init?(
        sfSymbol: SFSymbol,
        pointSize: CGFloat,
        weight: UIImage.SymbolWeight = .regular
    ) {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        self.init(systemName: sfSymbol.systemName, withConfiguration: config)
    }

    /// Creates a UIImage from an SF Symbol with an IconSize
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to create an image from
    ///   - size: The IconSize enum value
    ///   - weight: The weight of the symbol (default: .regular)
    /// - Returns: A UIImage of the SF Symbol, or nil if the symbol is unavailable
    convenience init?(
        sfSymbol: SFSymbol,
        size: IconSize,
        weight: UIImage.SymbolWeight = .regular
    ) {
        let config = UIImage.SymbolConfiguration(pointSize: size.pointSize, weight: weight)
        self.init(systemName: sfSymbol.systemName, withConfiguration: config)
    }
}

// MARK: - UIImage + CustomIcon

public extension UIImage {
    /// Creates a UIImage from a custom icon
    /// - Parameter customIcon: The custom icon to create an image from
    /// - Returns: A UIImage of the custom icon, or nil if the asset is not found
    convenience init?(customIcon: CustomIcon) {
        self.init(named: customIcon.assetName, in: .module, compatibleWith: nil)
    }
}

// MARK: - UIImageView Convenience

public extension UIImageView {
    /// Sets the image to an SF Symbol
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to display
    ///   - configuration: Optional symbol configuration
    func setImage(sfSymbol: SFSymbol, configuration: UIImage.SymbolConfiguration? = nil) {
        self.image = UIImage(sfSymbol: sfSymbol, configuration: configuration)
    }

    /// Sets the image to an SF Symbol with a specific size
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to display
    ///   - size: The IconSize to use
    ///   - weight: The weight of the symbol
    func setImage(sfSymbol: SFSymbol, size: IconSize, weight: UIImage.SymbolWeight = .regular) {
        self.image = UIImage(sfSymbol: sfSymbol, size: size, weight: weight)
    }

    /// Sets the image to a custom icon
    /// - Parameter customIcon: The custom icon to display
    func setImage(customIcon: CustomIcon) {
        self.image = UIImage(customIcon: customIcon)
    }
}

// MARK: - UIButton Convenience

public extension UIButton {
    /// Sets the button image to an SF Symbol
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to display
    ///   - state: The button state for the image (default: .normal)
    ///   - configuration: Optional symbol configuration
    func setImage(
        sfSymbol: SFSymbol,
        for state: UIControl.State = .normal,
        configuration: UIImage.SymbolConfiguration? = nil
    ) {
        let image = UIImage(sfSymbol: sfSymbol, configuration: configuration)
        setImage(image, for: state)
    }

    /// Sets the button image to an SF Symbol with a specific size
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to display
    ///   - size: The IconSize to use
    ///   - weight: The weight of the symbol
    ///   - state: The button state for the image (default: .normal)
    func setImage(
        sfSymbol: SFSymbol,
        size: IconSize,
        weight: UIImage.SymbolWeight = .regular,
        for state: UIControl.State = .normal
    ) {
        let image = UIImage(sfSymbol: sfSymbol, size: size, weight: weight)
        setImage(image, for: state)
    }

    /// Sets the button image to a custom icon
    /// - Parameters:
    ///   - customIcon: The custom icon to display
    ///   - state: The button state for the image (default: .normal)
    func setImage(
        customIcon: CustomIcon,
        for state: UIControl.State = .normal
    ) {
        let image = UIImage(customIcon: customIcon)
        setImage(image, for: state)
    }
}

// MARK: - UIBarButtonItem Convenience

public extension UIBarButtonItem {
    /// Creates a bar button item with an SF Symbol
    /// - Parameters:
    ///   - sfSymbol: The SF Symbol to display
    ///   - style: The button style (default: .plain)
    ///   - target: The target object
    ///   - action: The action selector
    convenience init(
        sfSymbol: SFSymbol,
        style: UIBarButtonItem.Style = .plain,
        target: Any?,
        action: Selector?
    ) {
        let image = UIImage(sfSymbol: sfSymbol)
        self.init(image: image, style: style, target: target, action: action)
    }

    /// Creates a bar button item with a custom icon
    /// - Parameters:
    ///   - customIcon: The custom icon to display
    ///   - style: The button style (default: .plain)
    ///   - target: The target object
    ///   - action: The action selector
    convenience init(
        customIcon: CustomIcon,
        style: UIBarButtonItem.Style = .plain,
        target: Any?,
        action: Selector?
    ) {
        let image = UIImage(customIcon: customIcon)
        self.init(image: image, style: style, target: target, action: action)
    }
}

// MARK: - Symbol Weight Conversion

public extension UIImage.SymbolWeight {
    /// Creates a UIImage.SymbolWeight from an IconWeight
    init(_ iconWeight: IconWeight) {
        switch iconWeight {
        case .ultraLight: self = .ultraLight
        case .thin: self = .thin
        case .light: self = .light
        case .regular: self = .regular
        case .medium: self = .medium
        case .semibold: self = .semibold
        case .bold: self = .bold
        case .heavy: self = .heavy
        case .black: self = .black
        }
    }
}
#endif
