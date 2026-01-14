import SwiftUI

// MARK: - SwiftUI Color Extensions

public extension Color {

    // MARK: - Primary Shades

    static var primary50: Color { ColorTokens.Primary.shade50 }
    static var primary100: Color { ColorTokens.Primary.shade100 }
    static var primary200: Color { ColorTokens.Primary.shade200 }
    static var primary300: Color { ColorTokens.Primary.shade300 }
    static var primary400: Color { ColorTokens.Primary.shade400 }
    static var primary500: Color { ColorTokens.Primary.shade500 }
    static var primary600: Color { ColorTokens.Primary.shade600 }
    static var primary700: Color { ColorTokens.Primary.shade700 }
    static var primary800: Color { ColorTokens.Primary.shade800 }
    static var primary900: Color { ColorTokens.Primary.shade900 }

    // MARK: - Secondary Shades

    static var secondary50: Color { ColorTokens.Secondary.shade50 }
    static var secondary100: Color { ColorTokens.Secondary.shade100 }
    static var secondary200: Color { ColorTokens.Secondary.shade200 }
    static var secondary300: Color { ColorTokens.Secondary.shade300 }
    static var secondary400: Color { ColorTokens.Secondary.shade400 }
    static var secondary500: Color { ColorTokens.Secondary.shade500 }
    static var secondary600: Color { ColorTokens.Secondary.shade600 }
    static var secondary700: Color { ColorTokens.Secondary.shade700 }
    static var secondary800: Color { ColorTokens.Secondary.shade800 }
    static var secondary900: Color { ColorTokens.Secondary.shade900 }

    // MARK: - Tertiary Shades

    static var tertiary50: Color { ColorTokens.Tertiary.shade50 }
    static var tertiary100: Color { ColorTokens.Tertiary.shade100 }
    static var tertiary200: Color { ColorTokens.Tertiary.shade200 }
    static var tertiary300: Color { ColorTokens.Tertiary.shade300 }
    static var tertiary400: Color { ColorTokens.Tertiary.shade400 }
    static var tertiary500: Color { ColorTokens.Tertiary.shade500 }
    static var tertiary600: Color { ColorTokens.Tertiary.shade600 }
    static var tertiary700: Color { ColorTokens.Tertiary.shade700 }
    static var tertiary800: Color { ColorTokens.Tertiary.shade800 }
    static var tertiary900: Color { ColorTokens.Tertiary.shade900 }

    // MARK: - Semantic Colors Namespace

    enum semantic {
        public static var success: Color { ColorTokens.Semantic.success }
        public static var successLight: Color { ColorTokens.Semantic.successLight }
        public static var warning: Color { ColorTokens.Semantic.warning }
        public static var warningLight: Color { ColorTokens.Semantic.warningLight }
        public static var error: Color { ColorTokens.Semantic.error }
        public static var errorLight: Color { ColorTokens.Semantic.errorLight }
        public static var info: Color { ColorTokens.Semantic.info }
        public static var infoLight: Color { ColorTokens.Semantic.infoLight }
    }

    // MARK: - UI Colors Namespace

    enum ui {
        public static var background: Color { ColorTokens.UI.background }
        public static var backgroundSecondary: Color { ColorTokens.UI.backgroundSecondary }
        public static var surface: Color { ColorTokens.UI.surface }
        public static var surfaceElevated: Color { ColorTokens.UI.surfaceElevated }
        public static var textPrimary: Color { ColorTokens.UI.textPrimary }
        public static var textSecondary: Color { ColorTokens.UI.textSecondary }
        public static var textTertiary: Color { ColorTokens.UI.textTertiary }
        public static var textInverse: Color { ColorTokens.UI.textInverse }
        public static var border: Color { ColorTokens.UI.border }
        public static var divider: Color { ColorTokens.UI.divider }
    }
}

// MARK: - ShapeStyle Conformance

public extension ShapeStyle where Self == Color {

    // MARK: - Primary

    static var primary50: Color { .primary50 }
    static var primary100: Color { .primary100 }
    static var primary200: Color { .primary200 }
    static var primary300: Color { .primary300 }
    static var primary400: Color { .primary400 }
    static var primary500: Color { .primary500 }
    static var primary600: Color { .primary600 }
    static var primary700: Color { .primary700 }
    static var primary800: Color { .primary800 }
    static var primary900: Color { .primary900 }

    // MARK: - Secondary

    static var secondary50: Color { .secondary50 }
    static var secondary100: Color { .secondary100 }
    static var secondary200: Color { .secondary200 }
    static var secondary300: Color { .secondary300 }
    static var secondary400: Color { .secondary400 }
    static var secondary500: Color { .secondary500 }
    static var secondary600: Color { .secondary600 }
    static var secondary700: Color { .secondary700 }
    static var secondary800: Color { .secondary800 }
    static var secondary900: Color { .secondary900 }

    // MARK: - Tertiary

    static var tertiary50: Color { .tertiary50 }
    static var tertiary100: Color { .tertiary100 }
    static var tertiary200: Color { .tertiary200 }
    static var tertiary300: Color { .tertiary300 }
    static var tertiary400: Color { .tertiary400 }
    static var tertiary500: Color { .tertiary500 }
    static var tertiary600: Color { .tertiary600 }
    static var tertiary700: Color { .tertiary700 }
    static var tertiary800: Color { .tertiary800 }
    static var tertiary900: Color { .tertiary900 }
}
