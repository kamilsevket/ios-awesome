import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import CoreText
import CoreGraphics

// MARK: - Font Loader

/// Utility for loading and registering custom fonts
public final class FontLoader: @unchecked Sendable {
    public static let shared = FontLoader()

    private var loadedFonts: Set<String> = []
    private let lock = NSLock()

    private init() {}

    // MARK: - Font Loading

    /// Load a font from a file URL
    @discardableResult
    public func loadFont(from url: URL) -> Bool {
        lock.lock()
        defer { lock.unlock() }

        let fontName = url.deletingPathExtension().lastPathComponent

        guard !loadedFonts.contains(fontName) else {
            return true
        }

        guard let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            return false
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)

        if success {
            loadedFonts.insert(fontName)
        }

        return success
    }

    /// Load a font from bundle resources
    @discardableResult
    public func loadFont(
        named name: String,
        extension ext: String = "ttf",
        in bundle: Bundle = .main
    ) -> Bool {
        guard let url = bundle.url(forResource: name, withExtension: ext) else {
            return false
        }
        return loadFont(from: url)
    }

    /// Load all fonts from a directory
    public func loadFonts(from directory: URL, extensions: [String] = ["ttf", "otf"]) -> Int {
        var loadedCount = 0

        guard let files = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        ) else {
            return 0
        }

        for file in files {
            if extensions.contains(file.pathExtension.lowercased()) {
                if loadFont(from: file) {
                    loadedCount += 1
                }
            }
        }

        return loadedCount
    }

    /// Load a font family (all weight variants)
    public func loadFontFamily(
        _ familyName: String,
        weights: [DSFontWeight] = DSFontWeight.allCases,
        extension ext: String = "ttf",
        in bundle: Bundle = .main
    ) -> [DSFontWeight: Bool] {
        var results: [DSFontWeight: Bool] = [:]

        for weight in weights {
            let fontName = "\(familyName)-\(weight.rawValue.capitalized)"
            results[weight] = loadFont(named: fontName, extension: ext, in: bundle)
        }

        return results
    }

    // MARK: - Font Availability

    /// Check if a font is available
    public func isFontAvailable(_ fontName: String) -> Bool {
        #if canImport(UIKit)
        return UIFont(name: fontName, size: 12) != nil
        #elseif canImport(AppKit)
        return NSFont(name: fontName, size: 12) != nil
        #else
        return false
        #endif
    }

    /// Check if a font family is available
    public func isFontFamilyAvailable(_ familyName: String) -> Bool {
        #if canImport(UIKit)
        return UIFont.familyNames.contains(familyName)
        #elseif canImport(AppKit)
        return NSFontManager.shared.availableFontFamilies.contains(familyName)
        #else
        return false
        #endif
    }

    /// Get all available font names for a family
    public func availableFonts(in familyName: String) -> [String] {
        #if canImport(UIKit)
        return UIFont.fontNames(forFamilyName: familyName)
        #elseif canImport(AppKit)
        return NSFontManager.shared.availableMembers(ofFontFamily: familyName)?.compactMap {
            $0.first as? String
        } ?? []
        #else
        return []
        #endif
    }
}

// MARK: - Font Loading Configuration

/// Configuration for automatic font loading
public struct FontLoadingConfiguration: Sendable {
    public let families: [FontFamilyLoadConfig]
    public let bundle: Bundle

    public init(families: [FontFamilyLoadConfig], bundle: Bundle = .main) {
        self.families = families
        self.bundle = bundle
    }

    public struct FontFamilyLoadConfig: Sendable {
        public let familyName: String
        public let weights: [DSFontWeight]
        public let fileExtension: String
        public let registerConfiguration: FontFamilyRegistry.FontFamilyConfiguration?

        public init(
            familyName: String,
            weights: [DSFontWeight] = DSFontWeight.allCases,
            fileExtension: String = "ttf",
            registerConfiguration: FontFamilyRegistry.FontFamilyConfiguration? = nil
        ) {
            self.familyName = familyName
            self.weights = weights
            self.fileExtension = fileExtension
            self.registerConfiguration = registerConfiguration
        }
    }

    /// Load all configured fonts
    @discardableResult
    public func loadAll() -> [String: [DSFontWeight: Bool]] {
        var results: [String: [DSFontWeight: Bool]] = [:]

        for family in families {
            results[family.familyName] = FontLoader.shared.loadFontFamily(
                family.familyName,
                weights: family.weights,
                extension: family.fileExtension,
                in: bundle
            )

            if let config = family.registerConfiguration {
                FontFamilyRegistry.shared.register(config)
            }
        }

        return results
    }
}

// MARK: - SwiftUI Font Loading Modifier

/// ViewModifier that ensures fonts are loaded before displaying content
public struct FontLoadingModifier: ViewModifier {
    public let configuration: FontLoadingConfiguration
    @State private var fontsLoaded = false

    public init(configuration: FontLoadingConfiguration) {
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if !fontsLoaded {
                    _ = configuration.loadAll()
                    fontsLoaded = true
                }
            }
    }
}

extension View {
    /// Ensure fonts are loaded before displaying
    public func loadFonts(_ configuration: FontLoadingConfiguration) -> some View {
        modifier(FontLoadingModifier(configuration: configuration))
    }
}
