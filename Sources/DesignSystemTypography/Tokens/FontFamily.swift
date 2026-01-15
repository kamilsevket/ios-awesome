import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Font family configuration for the design system
public struct FontFamily: Sendable, Equatable {
    public let name: String?
    public let isSystem: Bool

    /// System font (SF Pro on Apple platforms)
    public static let system = FontFamily(name: nil, isSystem: true)

    /// SF Pro font family
    public static let sfPro = FontFamily(name: "SF Pro", isSystem: true)

    /// SF Pro Display for large titles
    public static let sfProDisplay = FontFamily(name: "SF Pro Display", isSystem: true)

    /// SF Pro Text for body text
    public static let sfProText = FontFamily(name: "SF Pro Text", isSystem: true)

    /// SF Pro Rounded
    public static let sfProRounded = FontFamily(name: "SF Pro Rounded", isSystem: false)

    /// SF Mono for monospaced text
    public static let sfMono = FontFamily(name: "SF Mono", isSystem: false)

    /// New York serif font
    public static let newYork = FontFamily(name: "New York", isSystem: false)

    /// Custom font family
    public static func custom(_ name: String) -> FontFamily {
        FontFamily(name: name, isSystem: false)
    }

    /// Inter font family (commonly used alternative)
    public static let inter = FontFamily(name: "Inter", isSystem: false)

    /// Initialize with font name
    public init(name: String?, isSystem: Bool = false) {
        self.name = name
        self.isSystem = isSystem
    }
}

// MARK: - Font Family Registry

/// Registry for managing custom font families
public final class FontFamilyRegistry: @unchecked Sendable {
    public static let shared = FontFamilyRegistry()

    private var registeredFamilies: [String: FontFamilyConfiguration] = [:]
    private let lock = NSLock()

    private init() {}

    /// Configuration for a font family
    public struct FontFamilyConfiguration: Sendable {
        public let familyName: String
        public let weightMapping: [DSFontWeight: String]
        public let italicSuffix: String?

        public init(
            familyName: String,
            weightMapping: [DSFontWeight: String],
            italicSuffix: String? = "-Italic"
        ) {
            self.familyName = familyName
            self.weightMapping = weightMapping
            self.italicSuffix = italicSuffix
        }
    }

    /// Register a custom font family
    public func register(_ configuration: FontFamilyConfiguration) {
        lock.lock()
        defer { lock.unlock() }
        registeredFamilies[configuration.familyName] = configuration
    }

    /// Get configuration for a font family
    public func configuration(for familyName: String) -> FontFamilyConfiguration? {
        lock.lock()
        defer { lock.unlock() }
        return registeredFamilies[familyName]
    }

    /// Get the font name for a specific weight
    public func fontName(
        for family: FontFamily,
        weight: DSFontWeight,
        italic: Bool = false
    ) -> String? {
        guard let name = family.name else { return nil }

        lock.lock()
        let config = registeredFamilies[name]
        lock.unlock()

        if let config = config {
            var fontName = config.weightMapping[weight] ?? "\(name)-\(weight.rawValue.capitalized)"
            if italic, let suffix = config.italicSuffix {
                fontName += suffix
            }
            return fontName
        }

        // Default naming convention
        var fontName = "\(name)-\(weight.rawValue.capitalized)"
        if italic {
            fontName += "Italic"
        }
        return fontName
    }
}

// MARK: - Predefined Font Configurations

extension FontFamilyRegistry.FontFamilyConfiguration {
    /// Inter font family configuration
    public static let inter = FontFamilyRegistry.FontFamilyConfiguration(
        familyName: "Inter",
        weightMapping: [
            .ultraLight: "Inter-Thin",
            .thin: "Inter-ExtraLight",
            .light: "Inter-Light",
            .regular: "Inter-Regular",
            .medium: "Inter-Medium",
            .semibold: "Inter-SemiBold",
            .bold: "Inter-Bold",
            .heavy: "Inter-ExtraBold",
            .black: "Inter-Black"
        ]
    )

    /// SF Pro configuration
    public static let sfPro = FontFamilyRegistry.FontFamilyConfiguration(
        familyName: "SF Pro",
        weightMapping: [
            .ultraLight: "SFProText-Ultralight",
            .thin: "SFProText-Thin",
            .light: "SFProText-Light",
            .regular: "SFProText-Regular",
            .medium: "SFProText-Medium",
            .semibold: "SFProText-Semibold",
            .bold: "SFProText-Bold",
            .heavy: "SFProText-Heavy",
            .black: "SFProText-Black"
        ]
    )
}
