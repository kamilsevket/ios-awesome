# DS Theme - Design System Theme Management

A comprehensive theme management system for SwiftUI applications with support for light/dark modes, custom themes, and persistence.

## Features

- **DSTheme Protocol** - Define custom themes with your own color palette
- **DSThemeProvider** - Environment-based theme injection
- **DSThemeManager** - Singleton for global theme management
- **Built-in Themes** - Light, Dark, and System themes
- **Custom Theme Support** - Create and register custom themes
- **Persistence** - Automatic UserDefaults persistence
- **Preview Support** - Easy theme previews for development

## Quick Start

### Basic Usage

```swift
import DesignSystem

// Wrap your app content with DSThemeProvider
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            DSThemeProvider(mode: .system) {
                ContentView()
            }
        }
    }
}

// Access theme in any view
struct ContentView: View {
    @Environment(\.dsTheme) var theme

    var body: some View {
        VStack {
            Text("Hello World")
                .foregroundColor(theme.textPrimary)
        }
        .background(theme.background)
    }
}
```

### Using DSThemeManager

```swift
// Set theme mode globally
DSThemeManager.shared.setThemeMode(.dark)

// Toggle between light/dark
DSThemeManager.shared.toggleTheme()

// Cycle through all modes
DSThemeManager.shared.cycleThemeMode()

// Use with view modifier
ContentView()
    .dsThemeManaged()
```

### Creating Custom Themes

```swift
struct BrandTheme: DSTheme {
    var name: String { "Brand" }
    var colorScheme: ColorScheme? { .light }

    // Primary colors
    var primary: Color { Color(hex: "#FF6B00") }
    var secondary: Color { Color(hex: "#00B4D8") }

    // Background colors
    var background: Color { .white }
    var backgroundSecondary: Color { Color(hex: "#F5F5F5") }

    // Surface colors
    var surface: Color { .white }
    var surfaceElevated: Color { .white }

    // Semantic colors
    var success: Color { .green }
    var warning: Color { .orange }
    var error: Color { .red }
    var info: Color { .blue }

    // Text colors
    var textPrimary: Color { .black }
    var textSecondary: Color { .gray }
    var textTertiary: Color { Color.gray.opacity(0.5) }

    // Border & divider
    var border: Color { Color.gray.opacity(0.2) }
    var divider: Color { Color.gray.opacity(0.1) }
}

// Register and use
DSThemeManager.shared.registerTheme(BrandTheme())
DSThemeManager.shared.setTheme(BrandTheme())
```

## API Reference

### DSTheme Protocol

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | Theme identifier |
| `colorScheme` | `ColorScheme?` | Preferred color scheme (nil = system) |
| `primary` | `Color` | Primary brand color |
| `primaryVariant` | `Color` | Primary color variant |
| `onPrimary` | `Color` | Color for content on primary |
| `secondary` | `Color` | Secondary brand color |
| `secondaryVariant` | `Color` | Secondary color variant |
| `onSecondary` | `Color` | Color for content on secondary |
| `background` | `Color` | Main background |
| `backgroundSecondary` | `Color` | Secondary background |
| `onBackground` | `Color` | Color for content on background |
| `surface` | `Color` | Surface color (cards, sheets) |
| `surfaceElevated` | `Color` | Elevated surface |
| `onSurface` | `Color` | Color for content on surface |
| `success` | `Color` | Success semantic color |
| `warning` | `Color` | Warning semantic color |
| `error` | `Color` | Error semantic color |
| `info` | `Color` | Info semantic color |
| `textPrimary` | `Color` | Primary text color |
| `textSecondary` | `Color` | Secondary text color |
| `textTertiary` | `Color` | Tertiary/disabled text |
| `border` | `Color` | Border color |
| `divider` | `Color` | Divider color |

### DSThemeMode

```swift
enum DSThemeMode {
    case light   // Force light mode
    case dark    // Force dark mode
    case system  // Follow system appearance
}
```

### DSThemeManager Methods

| Method | Description |
|--------|-------------|
| `setThemeMode(_:)` | Set theme mode (persisted) |
| `setTheme(_:)` | Set a custom theme |
| `registerTheme(_:)` | Register a custom theme |
| `unregisterTheme(named:)` | Remove a registered theme |
| `theme(named:)` | Get theme by name |
| `toggleTheme()` | Toggle between light/dark |
| `cycleThemeMode()` | Cycle through all modes |
| `resetToDefault()` | Reset to system mode |

### View Modifiers

| Modifier | Description |
|----------|-------------|
| `.dsTheme(_:)` | Apply a specific theme |
| `.dsThemeMode(_:)` | Apply a theme mode |
| `.dsThemeManaged()` | Sync with DSThemeManager |
| `.dsThemedStyle()` | Apply themed text and tint |
| `.dsTextPrimary()` | Primary text color |
| `.dsTextSecondary()` | Secondary text color |
| `.dsTextTertiary()` | Tertiary text color |
| `.dsBackground()` | Background color |
| `.dsSurface()` | Surface color |

## Preview Support

```swift
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        // Shows view in both light and dark mode
        DSThemePreview {
            MyView()
        }
    }
}

// Or preview color swatch
struct ColorSwatch_Previews: PreviewProvider {
    static var previews: some View {
        DSThemeColorSwatchView()
            .dsTheme(DSThemes.dark)
    }
}
```

## Best Practices

1. **Use Environment** - Access theme via `@Environment(\.dsTheme)` for reactive updates
2. **Wrap at Root** - Apply `DSThemeProvider` at app root for consistent theming
3. **Custom Themes** - Implement `DSTheme` protocol for brand-specific colors
4. **Preview Testing** - Use `DSThemePreview` to test both modes
5. **Persistence** - Use `DSThemeManager` for automatic preference saving
