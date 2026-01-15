# Custom Fonts

Integrating custom fonts with the typography system.

## Overview

DesignSystemTypography supports custom fonts while maintaining Dynamic Type support.

## Adding Custom Fonts

### 1. Add Font Files

Add your font files (.ttf or .otf) to your app bundle:

```
Resources/
├── Inter-Regular.ttf
├── Inter-Medium.ttf
├── Inter-SemiBold.ttf
└── Inter-Bold.ttf
```

### 2. Register Fonts in Info.plist

```xml
<key>UIAppFonts</key>
<array>
    <string>Inter-Regular.ttf</string>
    <string>Inter-Medium.ttf</string>
    <string>Inter-SemiBold.ttf</string>
    <string>Inter-Bold.ttf</string>
</array>
```

### 3. Configure Font Family

```swift
// Register the font family configuration
let interConfig = FontFamilyRegistry.FontFamilyConfiguration(
    familyName: "Inter",
    weightMapping: [
        .regular: "Inter-Regular",
        .medium: "Inter-Medium",
        .semibold: "Inter-SemiBold",
        .bold: "Inter-Bold"
    ]
)

FontFamilyRegistry.shared.register(interConfig)
```

### 4. Use Custom Fonts

```swift
// With typography token
let token = TypographyToken(scale: .body, fontFamily: .inter)
Text("Inter Body").typography(token)

// With font extension
Text("Inter Custom").font(Font.ds.custom("Inter", scale: .body))
```

## Loading Fonts Programmatically

For fonts bundled in frameworks or loaded from custom locations:

```swift
// Load a single font
FontLoader.shared.loadFont(named: "CustomFont-Regular")

// Load entire family
FontLoader.shared.loadFontFamily("CustomFont")

// Load from URL
if let url = Bundle.main.url(forResource: "CustomFont", withExtension: "ttf") {
    FontLoader.shared.loadFont(from: url)
}
```

## Font Loading Configuration

For app-wide font configuration:

```swift
let fontConfig = FontLoadingConfiguration(
    families: [
        .init(
            familyName: "Inter",
            weights: [.regular, .medium, .bold],
            registerConfiguration: .inter
        )
    ],
    bundle: .main
)

// In your app entry point
@main
struct MyApp: App {
    init() {
        _ = fontConfig.loadAll()
    }
}
```

## Using with SwiftUI Views

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Inter Typography")
                .typography(TypographyToken(
                    scale: .headline,
                    weight: .semibold,
                    fontFamily: .inter
                ))
        }
        .loadFonts(fontConfig)
    }
}
```

## Checking Font Availability

```swift
// Check if font is available
if FontLoader.shared.isFontAvailable("Inter-Regular") {
    // Use Inter
} else {
    // Fallback to system font
}

// List available fonts in a family
let fonts = FontLoader.shared.availableFonts(in: "Inter")
```

## Best Practices

1. **Always provide fallbacks**: Custom fonts may fail to load
2. **Test with Dynamic Type**: Ensure custom fonts scale properly
3. **Register before use**: Configure font families early in app lifecycle
4. **Use weight mapping**: Map weight names to actual font file names
