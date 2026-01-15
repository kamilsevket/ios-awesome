import XCTest
import SwiftUI
@testable import DesignSystem

final class DSThemeTests: XCTestCase {

    // MARK: - DSThemeMode Tests

    func testThemeModeColorScheme() {
        XCTAssertEqual(DSThemeMode.light.colorScheme, .light)
        XCTAssertEqual(DSThemeMode.dark.colorScheme, .dark)
        XCTAssertNil(DSThemeMode.system.colorScheme)
    }

    func testThemeModeAllCases() {
        let allCases = DSThemeMode.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.light))
        XCTAssertTrue(allCases.contains(.dark))
        XCTAssertTrue(allCases.contains(.system))
    }

    func testThemeModeRawValue() {
        XCTAssertEqual(DSThemeMode.light.rawValue, "light")
        XCTAssertEqual(DSThemeMode.dark.rawValue, "dark")
        XCTAssertEqual(DSThemeMode.system.rawValue, "system")
    }

    // MARK: - Light Theme Tests

    func testLightThemeName() {
        let theme = DSLightTheme()
        XCTAssertEqual(theme.name, "Light")
    }

    func testLightThemeColorScheme() {
        let theme = DSLightTheme()
        XCTAssertEqual(theme.colorScheme, .light)
    }

    func testLightThemeColorsNotNil() {
        let theme = DSLightTheme()

        // Primary colors
        XCTAssertNotNil(theme.primary)
        XCTAssertNotNil(theme.primaryVariant)
        XCTAssertNotNil(theme.onPrimary)

        // Secondary colors
        XCTAssertNotNil(theme.secondary)
        XCTAssertNotNil(theme.secondaryVariant)
        XCTAssertNotNil(theme.onSecondary)

        // Background colors
        XCTAssertNotNil(theme.background)
        XCTAssertNotNil(theme.backgroundSecondary)
        XCTAssertNotNil(theme.onBackground)

        // Surface colors
        XCTAssertNotNil(theme.surface)
        XCTAssertNotNil(theme.surfaceElevated)
        XCTAssertNotNil(theme.onSurface)

        // Semantic colors
        XCTAssertNotNil(theme.success)
        XCTAssertNotNil(theme.warning)
        XCTAssertNotNil(theme.error)
        XCTAssertNotNil(theme.info)

        // Text colors
        XCTAssertNotNil(theme.textPrimary)
        XCTAssertNotNil(theme.textSecondary)
        XCTAssertNotNil(theme.textTertiary)

        // Border & divider
        XCTAssertNotNil(theme.border)
        XCTAssertNotNil(theme.divider)
    }

    // MARK: - Dark Theme Tests

    func testDarkThemeName() {
        let theme = DSDarkTheme()
        XCTAssertEqual(theme.name, "Dark")
    }

    func testDarkThemeColorScheme() {
        let theme = DSDarkTheme()
        XCTAssertEqual(theme.colorScheme, .dark)
    }

    func testDarkThemeColorsNotNil() {
        let theme = DSDarkTheme()

        // Primary colors
        XCTAssertNotNil(theme.primary)
        XCTAssertNotNil(theme.primaryVariant)
        XCTAssertNotNil(theme.onPrimary)

        // Secondary colors
        XCTAssertNotNil(theme.secondary)
        XCTAssertNotNil(theme.secondaryVariant)
        XCTAssertNotNil(theme.onSecondary)

        // Background colors
        XCTAssertNotNil(theme.background)
        XCTAssertNotNil(theme.backgroundSecondary)
        XCTAssertNotNil(theme.onBackground)

        // Surface colors
        XCTAssertNotNil(theme.surface)
        XCTAssertNotNil(theme.surfaceElevated)
        XCTAssertNotNil(theme.onSurface)

        // Semantic colors
        XCTAssertNotNil(theme.success)
        XCTAssertNotNil(theme.warning)
        XCTAssertNotNil(theme.error)
        XCTAssertNotNil(theme.info)

        // Text colors
        XCTAssertNotNil(theme.textPrimary)
        XCTAssertNotNil(theme.textSecondary)
        XCTAssertNotNil(theme.textTertiary)

        // Border & divider
        XCTAssertNotNil(theme.border)
        XCTAssertNotNil(theme.divider)
    }

    // MARK: - System Theme Tests

    func testSystemThemeName() {
        let theme = DSSystemTheme()
        XCTAssertEqual(theme.name, "System")
    }

    func testSystemThemeColorScheme() {
        let theme = DSSystemTheme()
        XCTAssertNil(theme.colorScheme)
    }

    // MARK: - AnyTheme Tests

    func testAnyThemeWrapsLightTheme() {
        let lightTheme = DSLightTheme()
        let anyTheme = AnyTheme(lightTheme)

        XCTAssertEqual(anyTheme.name, "Light")
        XCTAssertEqual(anyTheme.colorScheme, .light)
    }

    func testAnyThemeWrapsDarkTheme() {
        let darkTheme = DSDarkTheme()
        let anyTheme = AnyTheme(darkTheme)

        XCTAssertEqual(anyTheme.name, "Dark")
        XCTAssertEqual(anyTheme.colorScheme, .dark)
    }

    // MARK: - DSThemes Namespace Tests

    func testDSThemesLight() {
        let theme = DSThemes.light
        XCTAssertEqual(theme.name, "Light")
    }

    func testDSThemesDark() {
        let theme = DSThemes.dark
        XCTAssertEqual(theme.name, "Dark")
    }

    func testDSThemesSystem() {
        let theme = DSThemes.system
        XCTAssertEqual(theme.name, "System")
    }

    // MARK: - Custom Theme Tests

    func testCustomThemeConformance() {
        struct CustomTheme: DSTheme {
            var name: String { "Custom" }
            var colorScheme: ColorScheme? { .light }
            var primary: Color { .red }
            var secondary: Color { .green }
            var background: Color { .white }
            var surface: Color { .white }
            var success: Color { .green }
            var warning: Color { .orange }
            var error: Color { .red }
            var info: Color { .blue }
            var textPrimary: Color { .black }
            var textSecondary: Color { .gray }
            var textTertiary: Color { .gray.opacity(0.5) }
            var border: Color { .gray.opacity(0.3) }
            var divider: Color { .gray.opacity(0.2) }
        }

        let customTheme = CustomTheme()
        XCTAssertEqual(customTheme.name, "Custom")
        XCTAssertEqual(customTheme.colorScheme, .light)

        // Test default implementations
        XCTAssertNotNil(customTheme.primaryVariant)
        XCTAssertNotNil(customTheme.secondaryVariant)
        XCTAssertNotNil(customTheme.onPrimary)
        XCTAssertNotNil(customTheme.onSecondary)
        XCTAssertNotNil(customTheme.backgroundSecondary)
        XCTAssertNotNil(customTheme.surfaceElevated)
        XCTAssertNotNil(customTheme.onBackground)
        XCTAssertNotNil(customTheme.onSurface)

        // Test AnyTheme wrapping
        let anyTheme = AnyTheme(customTheme)
        XCTAssertEqual(anyTheme.name, "Custom")
    }
}
