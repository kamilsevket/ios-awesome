import SwiftUI

// MARK: - Light Theme

/// The default light theme for the Design System
public struct DSLightTheme: DSTheme {
    public init() {}

    public var name: String { "Light" }
    public var colorScheme: ColorScheme? { .light }

    // MARK: - Primary Colors

    public var primary: Color { Color(red: 0.0, green: 0.48, blue: 1.0) } // #007AFF
    public var primaryVariant: Color { Color(red: 0.0, green: 0.38, blue: 0.85) }
    public var onPrimary: Color { .white }

    // MARK: - Secondary Colors

    public var secondary: Color { Color(red: 0.2, green: 0.78, blue: 0.35) } // #34C759
    public var secondaryVariant: Color { Color(red: 0.18, green: 0.68, blue: 0.30) }
    public var onSecondary: Color { .white }

    // MARK: - Background Colors

    public var background: Color { Color(red: 0.95, green: 0.95, blue: 0.97) } // #F2F2F7
    public var backgroundSecondary: Color { .white }
    public var onBackground: Color { Color(red: 0.0, green: 0.0, blue: 0.0) }

    // MARK: - Surface Colors

    public var surface: Color { .white }
    public var surfaceElevated: Color { .white }
    public var onSurface: Color { Color(red: 0.0, green: 0.0, blue: 0.0) }

    // MARK: - Semantic Colors

    public var success: Color { Color(red: 0.2, green: 0.78, blue: 0.35) } // #34C759
    public var warning: Color { Color(red: 1.0, green: 0.58, blue: 0.0) } // #FF9500
    public var error: Color { Color(red: 1.0, green: 0.23, blue: 0.19) } // #FF3B30
    public var info: Color { Color(red: 0.35, green: 0.78, blue: 0.98) } // #5AC8FA

    // MARK: - Text Colors

    public var textPrimary: Color { Color(red: 0.0, green: 0.0, blue: 0.0) }
    public var textSecondary: Color { Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.6) }
    public var textTertiary: Color { Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.3) }

    // MARK: - Border & Divider

    public var border: Color { Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.2) }
    public var divider: Color { Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.1) }
}

// MARK: - Dark Theme

/// The default dark theme for the Design System
public struct DSDarkTheme: DSTheme {
    public init() {}

    public var name: String { "Dark" }
    public var colorScheme: ColorScheme? { .dark }

    // MARK: - Primary Colors

    public var primary: Color { Color(red: 0.04, green: 0.52, blue: 1.0) } // #0A84FF
    public var primaryVariant: Color { Color(red: 0.25, green: 0.61, blue: 1.0) }
    public var onPrimary: Color { .white }

    // MARK: - Secondary Colors

    public var secondary: Color { Color(red: 0.19, green: 0.82, blue: 0.35) } // #30D158
    public var secondaryVariant: Color { Color(red: 0.25, green: 0.88, blue: 0.42) }
    public var onSecondary: Color { .black }

    // MARK: - Background Colors

    public var background: Color { Color(red: 0.0, green: 0.0, blue: 0.0) } // #000000
    public var backgroundSecondary: Color { Color(red: 0.11, green: 0.11, blue: 0.12) } // #1C1C1E
    public var onBackground: Color { .white }

    // MARK: - Surface Colors

    public var surface: Color { Color(red: 0.11, green: 0.11, blue: 0.12) } // #1C1C1E
    public var surfaceElevated: Color { Color(red: 0.17, green: 0.17, blue: 0.18) } // #2C2C2E
    public var onSurface: Color { .white }

    // MARK: - Semantic Colors

    public var success: Color { Color(red: 0.19, green: 0.82, blue: 0.35) } // #30D158
    public var warning: Color { Color(red: 1.0, green: 0.62, blue: 0.04) } // #FF9F0A
    public var error: Color { Color(red: 1.0, green: 0.27, blue: 0.23) } // #FF453A
    public var info: Color { Color(red: 0.39, green: 0.82, blue: 1.0) } // #64D2FF

    // MARK: - Text Colors

    public var textPrimary: Color { .white }
    public var textSecondary: Color { Color(red: 0.92, green: 0.92, blue: 0.96).opacity(0.6) }
    public var textTertiary: Color { Color(red: 0.92, green: 0.92, blue: 0.96).opacity(0.3) }

    // MARK: - Border & Divider

    public var border: Color { Color(red: 0.33, green: 0.33, blue: 0.35) }
    public var divider: Color { Color(red: 0.33, green: 0.33, blue: 0.35).opacity(0.6) }
}

// MARK: - System Theme

/// A theme that follows the system appearance
/// Uses light colors in light mode and dark colors in dark mode
public struct DSSystemTheme: DSTheme {
    @Environment(\.colorScheme) private var systemColorScheme

    private let lightTheme = DSLightTheme()
    private let darkTheme = DSDarkTheme()

    public init() {}

    public var name: String { "System" }
    public var colorScheme: ColorScheme? { nil }

    private var currentTheme: DSTheme {
        systemColorScheme == .dark ? darkTheme : lightTheme
    }

    public var primary: Color { currentTheme.primary }
    public var primaryVariant: Color { currentTheme.primaryVariant }
    public var onPrimary: Color { currentTheme.onPrimary }
    public var secondary: Color { currentTheme.secondary }
    public var secondaryVariant: Color { currentTheme.secondaryVariant }
    public var onSecondary: Color { currentTheme.onSecondary }
    public var background: Color { currentTheme.background }
    public var backgroundSecondary: Color { currentTheme.backgroundSecondary }
    public var onBackground: Color { currentTheme.onBackground }
    public var surface: Color { currentTheme.surface }
    public var surfaceElevated: Color { currentTheme.surfaceElevated }
    public var onSurface: Color { currentTheme.onSurface }
    public var success: Color { currentTheme.success }
    public var warning: Color { currentTheme.warning }
    public var error: Color { currentTheme.error }
    public var info: Color { currentTheme.info }
    public var textPrimary: Color { currentTheme.textPrimary }
    public var textSecondary: Color { currentTheme.textSecondary }
    public var textTertiary: Color { currentTheme.textTertiary }
    public var border: Color { currentTheme.border }
    public var divider: Color { currentTheme.divider }
}

// MARK: - Theme Namespace

/// Namespace for accessing built-in themes
public enum DSThemes {
    /// Light theme
    public static let light = DSLightTheme()

    /// Dark theme
    public static let dark = DSDarkTheme()

    /// System theme (follows device appearance)
    public static let system = DSSystemTheme()
}
