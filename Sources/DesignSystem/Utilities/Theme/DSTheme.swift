import SwiftUI

// MARK: - DSTheme Protocol

/// Protocol defining the structure of a Design System theme.
///
/// Implement this protocol to create custom themes with your own color palette.
///
/// Usage:
/// ```swift
/// struct MyCustomTheme: DSTheme {
///     var name: String { "Custom" }
///     var colorScheme: ColorScheme? { .light }
///     var primary: Color { .blue }
///     // ... other colors
/// }
/// ```
public protocol DSTheme: Sendable {
    /// The unique name of the theme
    var name: String { get }

    /// The preferred color scheme for this theme (nil follows system)
    var colorScheme: ColorScheme? { get }

    // MARK: - Primary Colors

    /// Primary brand color
    var primary: Color { get }

    /// Primary color variant (lighter or darker)
    var primaryVariant: Color { get }

    /// Color to use on top of primary surfaces
    var onPrimary: Color { get }

    // MARK: - Secondary Colors

    /// Secondary brand color
    var secondary: Color { get }

    /// Secondary color variant
    var secondaryVariant: Color { get }

    /// Color to use on top of secondary surfaces
    var onSecondary: Color { get }

    // MARK: - Background Colors

    /// Main background color
    var background: Color { get }

    /// Secondary background color
    var backgroundSecondary: Color { get }

    /// Color to use on top of background
    var onBackground: Color { get }

    // MARK: - Surface Colors

    /// Surface color for cards, sheets, etc.
    var surface: Color { get }

    /// Elevated surface color
    var surfaceElevated: Color { get }

    /// Color to use on top of surface
    var onSurface: Color { get }

    // MARK: - Semantic Colors

    /// Success state color
    var success: Color { get }

    /// Warning state color
    var warning: Color { get }

    /// Error state color
    var error: Color { get }

    /// Info state color
    var info: Color { get }

    // MARK: - Text Colors

    /// Primary text color
    var textPrimary: Color { get }

    /// Secondary text color
    var textSecondary: Color { get }

    /// Tertiary/disabled text color
    var textTertiary: Color { get }

    // MARK: - Border & Divider

    /// Border color
    var border: Color { get }

    /// Divider color
    var divider: Color { get }
}

// MARK: - Default Implementations

public extension DSTheme {
    /// Default primary variant is the same as primary
    var primaryVariant: Color { primary }

    /// Default secondary variant is the same as secondary
    var secondaryVariant: Color { secondary }

    /// Default on-primary is white
    var onPrimary: Color { .white }

    /// Default on-secondary is white
    var onSecondary: Color { .white }

    /// Default on-background is text primary
    var onBackground: Color { textPrimary }

    /// Default on-surface is text primary
    var onSurface: Color { textPrimary }

    /// Default secondary background
    var backgroundSecondary: Color { background.opacity(0.95) }

    /// Default elevated surface
    var surfaceElevated: Color { surface }
}

// MARK: - Theme Mode

/// Represents the theme mode preference
public enum DSThemeMode: String, CaseIterable, Sendable {
    /// Light theme
    case light

    /// Dark theme
    case dark

    /// Follow system appearance
    case system

    /// The corresponding ColorScheme, nil for system
    public var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}

// MARK: - AnyTheme (Type Erasure)

/// Type-erased wrapper for DSTheme to allow storing different theme types
public struct AnyTheme: DSTheme, @unchecked Sendable {
    private let _name: () -> String
    private let _colorScheme: () -> ColorScheme?
    private let _primary: () -> Color
    private let _primaryVariant: () -> Color
    private let _onPrimary: () -> Color
    private let _secondary: () -> Color
    private let _secondaryVariant: () -> Color
    private let _onSecondary: () -> Color
    private let _background: () -> Color
    private let _backgroundSecondary: () -> Color
    private let _onBackground: () -> Color
    private let _surface: () -> Color
    private let _surfaceElevated: () -> Color
    private let _onSurface: () -> Color
    private let _success: () -> Color
    private let _warning: () -> Color
    private let _error: () -> Color
    private let _info: () -> Color
    private let _textPrimary: () -> Color
    private let _textSecondary: () -> Color
    private let _textTertiary: () -> Color
    private let _border: () -> Color
    private let _divider: () -> Color

    public init<T: DSTheme>(_ theme: T) {
        _name = { theme.name }
        _colorScheme = { theme.colorScheme }
        _primary = { theme.primary }
        _primaryVariant = { theme.primaryVariant }
        _onPrimary = { theme.onPrimary }
        _secondary = { theme.secondary }
        _secondaryVariant = { theme.secondaryVariant }
        _onSecondary = { theme.onSecondary }
        _background = { theme.background }
        _backgroundSecondary = { theme.backgroundSecondary }
        _onBackground = { theme.onBackground }
        _surface = { theme.surface }
        _surfaceElevated = { theme.surfaceElevated }
        _onSurface = { theme.onSurface }
        _success = { theme.success }
        _warning = { theme.warning }
        _error = { theme.error }
        _info = { theme.info }
        _textPrimary = { theme.textPrimary }
        _textSecondary = { theme.textSecondary }
        _textTertiary = { theme.textTertiary }
        _border = { theme.border }
        _divider = { theme.divider }
    }

    public var name: String { _name() }
    public var colorScheme: ColorScheme? { _colorScheme() }
    public var primary: Color { _primary() }
    public var primaryVariant: Color { _primaryVariant() }
    public var onPrimary: Color { _onPrimary() }
    public var secondary: Color { _secondary() }
    public var secondaryVariant: Color { _secondaryVariant() }
    public var onSecondary: Color { _onSecondary() }
    public var background: Color { _background() }
    public var backgroundSecondary: Color { _backgroundSecondary() }
    public var onBackground: Color { _onBackground() }
    public var surface: Color { _surface() }
    public var surfaceElevated: Color { _surfaceElevated() }
    public var onSurface: Color { _onSurface() }
    public var success: Color { _success() }
    public var warning: Color { _warning() }
    public var error: Color { _error() }
    public var info: Color { _info() }
    public var textPrimary: Color { _textPrimary() }
    public var textSecondary: Color { _textSecondary() }
    public var textTertiary: Color { _textTertiary() }
    public var border: Color { _border() }
    public var divider: Color { _divider() }
}
