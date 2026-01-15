import XCTest
import SwiftUI
@testable import DesignSystem

@MainActor
final class DSThemeManagerTests: XCTestCase {

    override func setUp() async throws {
        // Reset to default before each test
        DSThemeManager.shared.resetToDefault()

        // Clear any stored preferences
        UserDefaults.standard.removeObject(forKey: "ds_theme_mode")
        UserDefaults.standard.removeObject(forKey: "ds_custom_theme_name")
    }

    // MARK: - Singleton Tests

    func testSharedInstance() {
        let instance1 = DSThemeManager.shared
        let instance2 = DSThemeManager.shared
        XCTAssertTrue(instance1 === instance2)
    }

    // MARK: - Theme Mode Tests

    func testInitialThemeMode() {
        // After reset, should be system
        let manager = DSThemeManager.shared
        XCTAssertEqual(manager.themeMode, .system)
    }

    func testSetThemeModeLight() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.light)

        XCTAssertEqual(manager.themeMode, .light)
        XCTAssertEqual(manager.currentTheme.name, "Light")
    }

    func testSetThemeModeDark() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.dark)

        XCTAssertEqual(manager.themeMode, .dark)
        XCTAssertEqual(manager.currentTheme.name, "Dark")
    }

    func testSetThemeModeSystem() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.system)

        XCTAssertEqual(manager.themeMode, .system)
        XCTAssertEqual(manager.currentTheme.name, "System")
    }

    // MARK: - Toggle Theme Tests

    func testToggleFromLight() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.light)
        manager.toggleTheme()

        XCTAssertEqual(manager.themeMode, .dark)
    }

    func testToggleFromDark() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.dark)
        manager.toggleTheme()

        XCTAssertEqual(manager.themeMode, .light)
    }

    func testToggleFromSystem() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.system)
        manager.toggleTheme()

        XCTAssertEqual(manager.themeMode, .light)
    }

    // MARK: - Cycle Theme Tests

    func testCycleFromLight() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.light)
        manager.cycleThemeMode()

        XCTAssertEqual(manager.themeMode, .dark)
    }

    func testCycleFromDark() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.dark)
        manager.cycleThemeMode()

        XCTAssertEqual(manager.themeMode, .system)
    }

    func testCycleFromSystem() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.system)
        manager.cycleThemeMode()

        XCTAssertEqual(manager.themeMode, .light)
    }

    func testFullCycle() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.light)

        manager.cycleThemeMode() // light -> dark
        XCTAssertEqual(manager.themeMode, .dark)

        manager.cycleThemeMode() // dark -> system
        XCTAssertEqual(manager.themeMode, .system)

        manager.cycleThemeMode() // system -> light
        XCTAssertEqual(manager.themeMode, .light)
    }

    // MARK: - Reset Tests

    func testResetToDefault() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.dark)
        manager.resetToDefault()

        XCTAssertEqual(manager.themeMode, .system)
    }

    // MARK: - Custom Theme Tests

    func testSetCustomTheme() {
        struct MyTheme: DSTheme {
            var name: String { "MyTheme" }
            var colorScheme: ColorScheme? { .light }
            var primary: Color { .purple }
            var secondary: Color { .pink }
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

        let manager = DSThemeManager.shared
        manager.setTheme(MyTheme())

        XCTAssertEqual(manager.currentTheme.name, "MyTheme")
    }

    // MARK: - Custom Theme Registration Tests

    func testRegisterCustomTheme() {
        struct BrandTheme: DSTheme {
            var name: String { "Brand" }
            var colorScheme: ColorScheme? { .light }
            var primary: Color { .orange }
            var secondary: Color { .yellow }
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

        let manager = DSThemeManager.shared
        manager.registerTheme(BrandTheme())

        XCTAssertNotNil(manager.customThemes["Brand"])
        XCTAssertEqual(manager.customThemes.count, 1)
    }

    func testUnregisterCustomTheme() {
        struct TempTheme: DSTheme {
            var name: String { "Temp" }
            var colorScheme: ColorScheme? { .light }
            var primary: Color { .red }
            var secondary: Color { .blue }
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

        let manager = DSThemeManager.shared
        manager.registerTheme(TempTheme())
        XCTAssertNotNil(manager.customThemes["Temp"])

        manager.unregisterTheme(named: "Temp")
        XCTAssertNil(manager.customThemes["Temp"])
    }

    // MARK: - Theme Lookup Tests

    func testThemeNamedLight() {
        let manager = DSThemeManager.shared
        let theme = manager.theme(named: "Light")

        XCTAssertNotNil(theme)
        XCTAssertEqual(theme?.name, "Light")
    }

    func testThemeNamedDark() {
        let manager = DSThemeManager.shared
        let theme = manager.theme(named: "Dark")

        XCTAssertNotNil(theme)
        XCTAssertEqual(theme?.name, "Dark")
    }

    func testThemeNamedSystem() {
        let manager = DSThemeManager.shared
        let theme = manager.theme(named: "System")

        XCTAssertNotNil(theme)
        XCTAssertEqual(theme?.name, "System")
    }

    func testThemeNamedNonExistent() {
        let manager = DSThemeManager.shared
        let theme = manager.theme(named: "NonExistent")

        XCTAssertNil(theme)
    }

    func testThemeNamedCustom() {
        struct CustomLookupTheme: DSTheme {
            var name: String { "CustomLookup" }
            var colorScheme: ColorScheme? { .dark }
            var primary: Color { .cyan }
            var secondary: Color { .mint }
            var background: Color { .black }
            var surface: Color { .gray }
            var success: Color { .green }
            var warning: Color { .orange }
            var error: Color { .red }
            var info: Color { .blue }
            var textPrimary: Color { .white }
            var textSecondary: Color { .gray }
            var textTertiary: Color { .gray.opacity(0.5) }
            var border: Color { .gray.opacity(0.3) }
            var divider: Color { .gray.opacity(0.2) }
        }

        let manager = DSThemeManager.shared
        manager.registerTheme(CustomLookupTheme())

        let theme = manager.theme(named: "CustomLookup")
        XCTAssertNotNil(theme)
        XCTAssertEqual(theme?.name, "CustomLookup")
    }

    // MARK: - Persistence Tests

    func testThemeModePersistence() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.dark)

        // Check UserDefaults
        let savedMode = UserDefaults.standard.string(forKey: "ds_theme_mode")
        XCTAssertEqual(savedMode, "dark")
    }

    func testThemeModePersistenceCleared() {
        let manager = DSThemeManager.shared
        manager.setThemeMode(.dark)
        manager.setThemeMode(.system)

        let savedMode = UserDefaults.standard.string(forKey: "ds_theme_mode")
        XCTAssertEqual(savedMode, "system")
    }
}
