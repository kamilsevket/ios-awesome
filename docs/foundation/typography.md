# Typography System

DesignSystem provides a comprehensive typography system with semantic text styles, Dynamic Type support, and custom font integration.

## Overview

The typography system is built on Apple's Human Interface Guidelines with support for:

- Semantic text styles
- Dynamic Type scaling
- Custom fonts
- Accessibility

## Import

```swift
import DesignSystemTypography

// Or with main library
import DesignSystem
```

## Font Scales

### Display Styles

For headlines and hero text:

```swift
Text("Hero Title")
    .font(DSTypography.largeTitle)  // 34pt

Text("Page Title")
    .font(DSTypography.title)       // 28pt

Text("Section Title")
    .font(DSTypography.title2)      // 22pt

Text("Subsection")
    .font(DSTypography.title3)      // 20pt
```

### Content Styles

For body content and UI elements:

```swift
Text("Important Text")
    .font(DSTypography.headline)    // 17pt semibold

Text("Secondary Header")
    .font(DSTypography.subheadline) // 15pt

Text("Body content goes here...")
    .font(DSTypography.body)        // 17pt

Text("Callout text")
    .font(DSTypography.callout)     // 16pt
```

### Supporting Styles

For captions and labels:

```swift
Text("Footnote text")
    .font(DSTypography.footnote)    // 13pt

Text("Caption")
    .font(DSTypography.caption)     // 12pt

Text("Smaller caption")
    .font(DSTypography.caption2)    // 11pt
```

## Font Weights

```swift
// Apply weights to any style
Text("Light")
    .font(DSTypography.body.weight(.light))

Text("Regular")
    .font(DSTypography.body.weight(.regular))

Text("Medium")
    .font(DSTypography.body.weight(.medium))

Text("Semibold")
    .font(DSTypography.body.weight(.semibold))

Text("Bold")
    .font(DSTypography.body.weight(.bold))

Text("Heavy")
    .font(DSTypography.body.weight(.heavy))
```

## Text Styles

### Pre-configured Styles

```swift
// Headers
Text("Page Title")
    .textStyle(.pageTitle)

Text("Section Header")
    .textStyle(.sectionHeader)

// Content
Text("Body text")
    .textStyle(.bodyRegular)

Text("Emphasized text")
    .textStyle(.bodyEmphasis)

// Labels
Text("Button Label")
    .textStyle(.buttonLabel)

Text("Field label")
    .textStyle(.inputLabel)
```

### Custom Text Style

```swift
struct PriceText: View {
    let price: Double

    var body: some View {
        Text(price, format: .currency(code: "USD"))
            .font(DSTypography.title2)
            .fontWeight(.bold)
            .foregroundColor(DSColors.primary500)
    }
}
```

## Dynamic Type Support

All typography tokens automatically scale with Dynamic Type:

```swift
// Automatically scales with user's text size preference
Text("Accessible Text")
    .font(DSTypography.body)
```

### Testing Dynamic Type

```swift
struct TypeScalePreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Dynamic Type")
                .font(DSTypography.headline)
        }
        .environment(\.sizeCategory, .extraSmall)
        .previewDisplayName("Extra Small")

        VStack {
            Text("Dynamic Type")
                .font(DSTypography.headline)
        }
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        .previewDisplayName("Accessibility XXL")
    }
}
```

### Limiting Text Scaling

```swift
// Limit minimum size
Text("Fixed minimum")
    .font(DSTypography.caption)
    .dynamicTypeSize(.large...)

// Limit maximum size
Text("Fixed maximum")
    .font(DSTypography.body)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

// Fixed range
Text("Limited range")
    .font(DSTypography.headline)
    .dynamicTypeSize(.medium...DynamicTypeSize.xxLarge)
```

## Custom Fonts

### Registering Custom Fonts

1. Add font files to your project
2. Register in Info.plist or use DSTypography configuration

```swift
// In app initialization
DSTypography.configure(
    primaryFont: "CustomFont-Regular",
    primaryFontBold: "CustomFont-Bold"
)
```

### Font Configuration

```swift
// Configure custom font family
DSTypography.configure(
    fontFamily: DSFontFamily(
        regular: "Roboto-Regular",
        medium: "Roboto-Medium",
        semibold: "Roboto-SemiBold",
        bold: "Roboto-Bold"
    )
)
```

### Using Custom Fonts

```swift
// After configuration, all typography tokens use custom fonts
Text("Custom Font Text")
    .font(DSTypography.body)  // Uses configured font
```

## Line Height & Spacing

### Predefined Line Heights

```swift
// Tight line height (1.2)
Text("Tight spacing")
    .font(DSTypography.body)
    .lineSpacing(DSTypography.lineHeightTight)

// Default line height (1.5)
Text("Default spacing")
    .font(DSTypography.body)
    .lineSpacing(DSTypography.lineHeightDefault)

// Relaxed line height (1.75)
Text("Relaxed spacing")
    .font(DSTypography.body)
    .lineSpacing(DSTypography.lineHeightRelaxed)
```

### Letter Spacing

```swift
// Tight tracking
Text("TIGHT")
    .tracking(DSTypography.trackingTight)

// Normal tracking
Text("Normal")
    .tracking(DSTypography.trackingNormal)

// Wide tracking
Text("W I D E")
    .tracking(DSTypography.trackingWide)
```

## Typography Patterns

### Article Layout

```swift
struct ArticleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
                Text("Article Title")
                    .font(DSTypography.largeTitle)
                    .fontWeight(.bold)

                HStack {
                    Text("By Author Name")
                        .font(DSTypography.subheadline)
                        .foregroundColor(DSColors.textSecondary)

                    Text("•")

                    Text("Jan 15, 2024")
                        .font(DSTypography.subheadline)
                        .foregroundColor(DSColors.textSecondary)
                }

                Text(articleBody)
                    .font(DSTypography.body)
                    .lineSpacing(8)
            }
            .padding()
        }
    }
}
```

### Form Labels

```swift
struct FormField: View {
    let label: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            Text(label.uppercased())
                .font(DSTypography.caption)
                .fontWeight(.medium)
                .foregroundColor(DSColors.textSecondary)
                .tracking(DSTypography.trackingWide)

            TextField("", text: $text)
                .font(DSTypography.body)
        }
    }
}
```

### Price Display

```swift
struct PriceLabel: View {
    let price: Decimal
    let originalPrice: Decimal?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DSSpacing.xs) {
            Text(price, format: .currency(code: "USD"))
                .font(DSTypography.title2)
                .fontWeight(.bold)

            if let original = originalPrice {
                Text(original, format: .currency(code: "USD"))
                    .font(DSTypography.subheadline)
                    .strikethrough()
                    .foregroundColor(DSColors.textTertiary)
            }
        }
    }
}
```

## Typography Scale Reference

| Style | Size | Weight | Line Height |
|-------|------|--------|-------------|
| `largeTitle` | 34pt | Regular | 41pt |
| `title` | 28pt | Regular | 34pt |
| `title2` | 22pt | Regular | 28pt |
| `title3` | 20pt | Regular | 25pt |
| `headline` | 17pt | Semibold | 22pt |
| `subheadline` | 15pt | Regular | 20pt |
| `body` | 17pt | Regular | 22pt |
| `callout` | 16pt | Regular | 21pt |
| `footnote` | 13pt | Regular | 18pt |
| `caption` | 12pt | Regular | 16pt |
| `caption2` | 11pt | Regular | 13pt |

## Accessibility

### VoiceOver

```swift
// Headers are announced as headers
Text("Section Title")
    .font(DSTypography.headline)
    .accessibilityAddTraits(.isHeader)
```

### Minimum Touch Targets

Text elements in interactive contexts should have adequate touch targets:

```swift
Button {
    // action
} label: {
    Text("Tap Me")
        .font(DSTypography.body)
        .frame(minHeight: 44)  // Minimum touch target
}
```

## Best Practices

1. **Use semantic styles** - Choose styles based on meaning, not appearance
2. **Support Dynamic Type** - Don't disable text scaling
3. **Maintain hierarchy** - Use visual weight to establish importance
4. **Ensure contrast** - Pair with appropriate text colors
5. **Be consistent** - Use the same styles for similar content types
