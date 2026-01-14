# Using Font Scales

Understanding the typography scale system.

## Overview

The typography system provides 11 predefined font scales that follow Apple's Human Interface Guidelines while allowing customization.

## Font Scale Reference

### Display Styles

| Scale | Default Size | Line Height | Weight |
|-------|-------------|-------------|--------|
| largeTitle | 34pt | 1.2x | Regular |
| title1 | 28pt | 1.21x | Regular |
| title2 | 22pt | 1.27x | Regular |
| title3 | 20pt | 1.25x | Regular |

### Content Styles

| Scale | Default Size | Line Height | Weight |
|-------|-------------|-------------|--------|
| headline | 17pt | 1.29x | Semibold |
| body | 17pt | 1.29x | Regular |
| callout | 16pt | 1.31x | Regular |
| subheadline | 15pt | 1.33x | Regular |

### Supporting Styles

| Scale | Default Size | Line Height | Weight |
|-------|-------------|-------------|--------|
| footnote | 13pt | 1.38x | Regular |
| caption1 | 12pt | 1.33x | Regular |
| caption2 | 11pt | 1.27x | Regular |

## Using Font Scales

### SwiftUI

```swift
// Using font extension
Text("Large Title").font(.ds.largeTitle)
Text("Headline").font(.ds.headline)
Text("Body").font(.ds.body)

// With custom weight
Text("Bold Body").font(Font.ds.font(for: .body, weight: .bold))
```

### UIKit

```swift
label.font = UIFont.ds.headline
label.font = UIFont.ds.font(for: .body, weight: .bold)
```

## Dynamic Type Scaling

All scales automatically respond to the user's preferred content size:

```swift
// This scales from ~11pt to ~40pt+ depending on settings
Text("Accessible").font(.ds.body)
```

### Scale Factors by Content Size Category

| Category | Scale Factor |
|----------|-------------|
| Extra Small | 0.82x |
| Small | 0.88x |
| Medium | 0.94x |
| Large (Default) | 1.0x |
| Extra Large | 1.06x |
| Extra Extra Large | 1.12x |
| Extra Extra Extra Large | 1.18x |
| Accessibility Medium | 1.35x |
| Accessibility Large | 1.53x |
| Accessibility Extra Large | 1.76x |
| Accessibility Extra Extra Large | 2.0x |
| Accessibility Extra Extra Extra Large | 2.35x |

## Typography Tokens

For complete control over typography, use tokens:

```swift
let customToken = TypographyToken(
    scale: .body,
    weight: .medium,
    size: 18,                    // Override default size
    lineHeight: 26,              // Custom line height
    letterSpacing: -0.3          // Custom tracking
)

Text("Custom").typography(customToken)
```

## Predefined Token Variants

Common variants are predefined for convenience:

```swift
// Bold variants
Text("Bold Headline").typography(.headlineBold)
Text("Bold Body").typography(.bodyBold)

// Semantic styles
Text("Primary Title").semanticStyle(.primaryTitle)
Text("Section Header").semanticStyle(.sectionHeader)
```
