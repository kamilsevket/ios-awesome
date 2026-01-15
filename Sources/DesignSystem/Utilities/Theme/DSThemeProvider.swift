import SwiftUI

// MARK: - Theme Environment Key

private struct DSThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: AnyTheme = AnyTheme(DSLightTheme())
}

public extension EnvironmentValues {
    /// The current Design System theme
    var dsTheme: AnyTheme {
        get { self[DSThemeEnvironmentKey.self] }
        set { self[DSThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - DSThemeProvider

/// A view that provides a theme to its child views via the environment.
///
/// Use `DSThemeProvider` to apply a theme to a view hierarchy:
///
/// ```swift
/// DSThemeProvider(theme: .dark) {
///     ContentView()
/// }
/// ```
///
/// Child views can access the theme using the environment:
///
/// ```swift
/// @Environment(\.dsTheme) var theme
///
/// var body: some View {
///     Text("Hello")
///         .foregroundColor(theme.textPrimary)
///         .background(theme.background)
/// }
/// ```
public struct DSThemeProvider<Content: View>: View {
    private let theme: AnyTheme
    private let content: Content

    /// Creates a theme provider with a specific theme.
    /// - Parameters:
    ///   - theme: The theme to provide
    ///   - content: The content view
    public init<T: DSTheme>(theme: T, @ViewBuilder content: () -> Content) {
        self.theme = AnyTheme(theme)
        self.content = content()
    }

    /// Creates a theme provider with a theme mode.
    /// - Parameters:
    ///   - mode: The theme mode (.light, .dark, or .system)
    ///   - content: The content view
    public init(mode: DSThemeMode, @ViewBuilder content: () -> Content) {
        switch mode {
        case .light:
            self.theme = AnyTheme(DSLightTheme())
        case .dark:
            self.theme = AnyTheme(DSDarkTheme())
        case .system:
            self.theme = AnyTheme(DSSystemTheme())
        }
        self.content = content()
    }

    public var body: some View {
        content
            .environment(\.dsTheme, theme)
            .preferredColorScheme(theme.colorScheme)
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a Design System theme to this view.
    /// - Parameter theme: The theme to apply
    /// - Returns: A view with the theme applied
    func dsTheme<T: DSTheme>(_ theme: T) -> some View {
        environment(\.dsTheme, AnyTheme(theme))
            .preferredColorScheme(theme.colorScheme)
    }

    /// Applies a theme mode to this view.
    /// - Parameter mode: The theme mode to apply
    /// - Returns: A view with the theme mode applied
    func dsThemeMode(_ mode: DSThemeMode) -> some View {
        let theme: AnyTheme
        switch mode {
        case .light:
            theme = AnyTheme(DSLightTheme())
        case .dark:
            theme = AnyTheme(DSDarkTheme())
        case .system:
            theme = AnyTheme(DSSystemTheme())
        }
        return environment(\.dsTheme, theme)
            .preferredColorScheme(mode.colorScheme)
    }

    /// Applies themed styling to common view properties.
    /// - Returns: A view styled with the current theme
    func dsThemedStyle() -> some View {
        modifier(DSThemedStyleModifier())
    }
}

// MARK: - Themed Style Modifier

/// A modifier that applies themed styling to a view
private struct DSThemedStyleModifier: ViewModifier {
    @Environment(\.dsTheme) private var theme

    func body(content: Content) -> some View {
        content
            .foregroundColor(theme.textPrimary)
            .tint(theme.primary)
    }
}

// MARK: - Theme-Aware Modifiers

public extension View {
    /// Sets the foreground color using the current theme's text primary color.
    func dsTextPrimary() -> some View {
        modifier(DSThemeColorModifier(keyPath: \.textPrimary))
    }

    /// Sets the foreground color using the current theme's text secondary color.
    func dsTextSecondary() -> some View {
        modifier(DSThemeColorModifier(keyPath: \.textSecondary))
    }

    /// Sets the foreground color using the current theme's text tertiary color.
    func dsTextTertiary() -> some View {
        modifier(DSThemeColorModifier(keyPath: \.textTertiary))
    }

    /// Sets the background using the current theme's background color.
    func dsBackground() -> some View {
        modifier(DSThemeBackgroundModifier(keyPath: \.background))
    }

    /// Sets the background using the current theme's surface color.
    func dsSurface() -> some View {
        modifier(DSThemeBackgroundModifier(keyPath: \.surface))
    }
}

// MARK: - Theme Color Modifier

private struct DSThemeColorModifier: ViewModifier {
    @Environment(\.dsTheme) private var theme
    let keyPath: KeyPath<AnyTheme, Color>

    func body(content: Content) -> some View {
        content.foregroundColor(theme[keyPath: keyPath])
    }
}

// MARK: - Theme Background Modifier

private struct DSThemeBackgroundModifier: ViewModifier {
    @Environment(\.dsTheme) private var theme
    let keyPath: KeyPath<AnyTheme, Color>

    func body(content: Content) -> some View {
        content.background(theme[keyPath: keyPath])
    }
}
