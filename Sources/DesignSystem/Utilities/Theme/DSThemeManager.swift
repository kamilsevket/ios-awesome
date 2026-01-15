import SwiftUI
import Combine

// MARK: - Theme Manager

/// A singleton manager for handling theme switching and persistence.
///
/// Use `DSThemeManager` to manage themes globally in your app:
///
/// ```swift
/// // Set theme mode
/// DSThemeManager.shared.setThemeMode(.dark)
///
/// // Set custom theme
/// DSThemeManager.shared.setTheme(MyCustomTheme())
///
/// // Observe theme changes
/// DSThemeManager.shared.$currentTheme
///     .sink { theme in
///         print("Theme changed to: \(theme.name)")
///     }
/// ```
@MainActor
public final class DSThemeManager: ObservableObject {
    // MARK: - Singleton

    /// The shared theme manager instance
    public static let shared = DSThemeManager()

    // MARK: - Published Properties

    /// The current active theme
    @Published public private(set) var currentTheme: AnyTheme

    /// The current theme mode
    @Published public private(set) var themeMode: DSThemeMode

    /// Available custom themes registered with the manager
    @Published public private(set) var customThemes: [String: AnyTheme] = [:]

    // MARK: - Private Properties

    private let userDefaultsKey = "ds_theme_mode"
    private let customThemeKey = "ds_custom_theme_name"

    // MARK: - Initialization

    private init() {
        // Load saved theme mode from UserDefaults
        let savedMode = UserDefaults.standard.string(forKey: userDefaultsKey)
        let mode = DSThemeMode(rawValue: savedMode ?? "") ?? .system

        self.themeMode = mode
        self.currentTheme = Self.theme(for: mode)
    }

    // MARK: - Public Methods

    /// Sets the theme mode and persists the preference.
    /// - Parameter mode: The theme mode to set
    public func setThemeMode(_ mode: DSThemeMode) {
        themeMode = mode
        currentTheme = Self.theme(for: mode)

        // Persist the preference
        UserDefaults.standard.set(mode.rawValue, forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: customThemeKey)
    }

    /// Sets a custom theme.
    /// - Parameter theme: The custom theme to set
    public func setTheme<T: DSTheme>(_ theme: T) {
        currentTheme = AnyTheme(theme)

        // Store custom theme name if registered
        if customThemes[theme.name] != nil {
            UserDefaults.standard.set(theme.name, forKey: customThemeKey)
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        }
    }

    /// Registers a custom theme for later use.
    /// - Parameter theme: The theme to register
    public func registerTheme<T: DSTheme>(_ theme: T) {
        customThemes[theme.name] = AnyTheme(theme)
    }

    /// Unregisters a custom theme.
    /// - Parameter name: The name of the theme to unregister
    public func unregisterTheme(named name: String) {
        customThemes.removeValue(forKey: name)
    }

    /// Retrieves a registered custom theme by name.
    /// - Parameter name: The theme name
    /// - Returns: The theme if found, nil otherwise
    public func theme(named name: String) -> AnyTheme? {
        if name == "Light" { return AnyTheme(DSLightTheme()) }
        if name == "Dark" { return AnyTheme(DSDarkTheme()) }
        if name == "System" { return AnyTheme(DSSystemTheme()) }
        return customThemes[name]
    }

    /// Toggles between light and dark mode.
    /// If in system mode, switches to light mode.
    public func toggleTheme() {
        switch themeMode {
        case .light:
            setThemeMode(.dark)
        case .dark:
            setThemeMode(.light)
        case .system:
            setThemeMode(.light)
        }
    }

    /// Cycles through light, dark, and system modes.
    public func cycleThemeMode() {
        switch themeMode {
        case .light:
            setThemeMode(.dark)
        case .dark:
            setThemeMode(.system)
        case .system:
            setThemeMode(.light)
        }
    }

    /// Resets to system theme mode.
    public func resetToDefault() {
        setThemeMode(.system)
    }

    // MARK: - Private Helpers

    private static func theme(for mode: DSThemeMode) -> AnyTheme {
        switch mode {
        case .light:
            return AnyTheme(DSLightTheme())
        case .dark:
            return AnyTheme(DSDarkTheme())
        case .system:
            return AnyTheme(DSSystemTheme())
        }
    }
}

// MARK: - Theme Manager View Modifier

/// A view modifier that syncs with the theme manager
public struct DSThemeManagerModifier: ViewModifier {
    @ObservedObject private var manager = DSThemeManager.shared

    public init() {}

    public func body(content: Content) -> some View {
        content
            .environment(\.dsTheme, manager.currentTheme)
            .preferredColorScheme(manager.currentTheme.colorScheme)
    }
}

// MARK: - View Extension

public extension View {
    /// Applies the global theme from DSThemeManager to this view.
    /// - Returns: A view that automatically updates when the theme changes
    func dsThemeManaged() -> some View {
        modifier(DSThemeManagerModifier())
    }
}
