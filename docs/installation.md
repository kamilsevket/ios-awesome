# Installation Guide

This guide covers all installation methods and configuration options for DesignSystem.

## Swift Package Manager (Recommended)

### Using Xcode

1. Open your project in Xcode
2. Go to **File > Add Package Dependencies...**
3. Enter the repository URL:
   ```
   https://github.com/kamilsevket/ios-awesome.git
   ```
4. Select your version rule:
   - **Up to Next Major Version** (recommended): `1.0.0`
   - **Exact Version**: `1.0.0`
   - **Branch**: `main`
5. Click **Add Package**
6. Select the libraries you want to add:
   - `DesignSystem` - Core components (most common)
   - `FoundationColor` - Color system only
   - `DesignSystemTypography` - Typography system only
   - `FoundationIcons` - Icon system only
   - `GestureUtilities` - Gesture handling utilities

### Using Package.swift

Add the dependency to your `Package.swift` file:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    dependencies: [
        .package(
            url: "https://github.com/kamilsevket/ios-awesome.git",
            from: "1.0.0"
        )
    ],
    targets: [
        .target(
            name: "YourApp",
            dependencies: [
                .product(name: "DesignSystem", package: "ios-awesome"),
                // Add other modules as needed:
                // .product(name: "FoundationColor", package: "ios-awesome"),
                // .product(name: "DesignSystemTypography", package: "ios-awesome"),
            ]
        )
    ]
)
```

## Available Libraries

### DesignSystem (Main)

The complete component library including all UI components.

```swift
import DesignSystem

// Access all components
DSButton("Tap me") { }
DSTextField("Email", text: $email)
DSCard { /* content */ }
```

**Includes:**
- All UI components (Buttons, Cards, Forms, etc.)
- Animation utilities
- Accessibility helpers
- View modifiers

### FoundationColor

Standalone color system with semantic colors and dark mode support.

```swift
import FoundationColor

// Primary colors
let primary = DSColors.primary500
let secondary = DSColors.secondary300

// Semantic colors
let success = DSColors.success
let error = DSColors.error

// UI colors (auto-adapt to dark mode)
let background = DSColors.background
let textPrimary = DSColors.textPrimary
```

**Color Palettes:**
- Primary (50-900)
- Secondary (50-900)
- Tertiary (50-900)
- Semantic (success, warning, error, info)
- UI (background, surface, text, border)

### DesignSystemTypography

Typography system with font scales and text styles.

```swift
import DesignSystemTypography

// Font scales
Text("Large Title")
    .font(DSTypography.largeTitle)

Text("Body")
    .font(DSTypography.body)

Text("Caption")
    .font(DSTypography.caption)
```

**Font Scales:**
- largeTitle, title, title2, title3
- headline, subheadline
- body, callout
- footnote, caption, caption2

### FoundationIcons

Icon system and asset management.

```swift
import FoundationIcons

// Access icons
let homeIcon = DSIcons.home
let settingsIcon = DSIcons.settings
```

### GestureUtilities

Advanced gesture recognition and handling.

```swift
import GestureUtilities

// Swipe gestures
view.onSwipe(.left) { /* handle */ }

// Long press with customization
view.onLongPress(minimumDuration: 0.5) { /* handle */ }
```

## Platform Requirements

| Platform | Minimum Version |
|----------|-----------------|
| iOS      | 15.0           |
| macOS    | 12.0           |
| tvOS     | 15.0           |
| watchOS  | 8.0            |

## Xcode Requirements

- **Xcode 15.0** or later
- **Swift 5.9** or later

## Selective Import

For smaller binary size, import only what you need:

```swift
// Full library (all components)
import DesignSystem

// OR specific modules
import FoundationColor         // ~50KB
import DesignSystemTypography  // ~30KB
import FoundationIcons         // ~100KB (includes assets)
import GestureUtilities        // ~20KB
```

## Configuration

### Custom Theme Setup

Configure the design system theme at app launch:

```swift
import SwiftUI
import DesignSystem

@main
struct MyApp: App {
    init() {
        // Configure custom colors (optional)
        DSTheme.configure(
            primaryColor: Color("BrandPrimary"),
            secondaryColor: Color("BrandSecondary")
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Environment Setup

Pass theme configuration through the environment:

```swift
ContentView()
    .environment(\.dsTheme, customTheme)
```

## Troubleshooting

### Package Resolution Fails

1. **Reset Package Caches**
   ```
   File > Packages > Reset Package Caches
   ```

2. **Clean Derived Data**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

3. **Verify Network Access**
   Ensure you can access GitHub from your network.

### Linker Errors

If you see "undefined symbol" errors:

1. Verify the library is added to your target
2. Check **Build Phases > Link Binary With Libraries**
3. Ensure the import statement matches the product name

### Resource Bundle Missing

For `FoundationColor`, `DesignSystemTypography`, or `FoundationIcons`:

```swift
// These modules include resource bundles that should be
// automatically copied. If assets are missing, verify:
// 1. Clean build folder
// 2. Re-add the package dependency
```

### Minimum Deployment Target

Error: `Compiling for iOS 14.0, but module requires iOS 15.0`

**Solution:** Update your deployment target in:
- Project settings > General > Deployment Info
- Or in `Package.swift`:
  ```swift
  platforms: [.iOS(.v15)]
  ```

## Updating

### Check for Updates

1. In Xcode, go to **File > Packages > Update to Latest Package Versions**
2. Or right-click the package in the navigator and select **Update Package**

### Version Pinning

To pin to a specific version:

```swift
.package(url: "...", exact: "1.2.3")
```

To allow minor updates:

```swift
.package(url: "...", from: "1.0.0")
```

## Next Steps

- [Getting Started](getting-started.md) - Your first component
- [Component Catalog](components/) - Browse all components
- [Best Practices](best-practices.md) - Usage guidelines
