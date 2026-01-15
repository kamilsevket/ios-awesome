# Icons System

DesignSystem integrates with SF Symbols and provides utilities for consistent icon usage.

## Overview

The icon system provides:
- SF Symbols integration
- Consistent sizing
- Color theming
- Custom icon support

## Import

```swift
import FoundationIcons

// Or with main library
import DesignSystem
```

## SF Symbols

### Basic Usage

```swift
// System symbol
Image(systemName: "heart.fill")

// With DS styling
DSIcon(systemName: "heart.fill")
```

### Icon Sizes

```swift
DSIcon(systemName: "star", size: .xs)   // 12pt
DSIcon(systemName: "star", size: .sm)   // 16pt
DSIcon(systemName: "star", size: .md)   // 20pt
DSIcon(systemName: "star", size: .lg)   // 24pt
DSIcon(systemName: "star", size: .xl)   // 32pt
DSIcon(systemName: "star", size: .xxl)  // 48pt
```

### Icon Colors

```swift
// Primary color
DSIcon(systemName: "heart.fill")
    .foregroundColor(DSColors.primary500)

// Semantic colors
DSIcon(systemName: "checkmark.circle.fill")
    .foregroundColor(DSColors.success)

DSIcon(systemName: "exclamationmark.triangle.fill")
    .foregroundColor(DSColors.warning)

DSIcon(systemName: "xmark.circle.fill")
    .foregroundColor(DSColors.error)
```

## Icon Weights

Match icon weight to text:

```swift
// Regular weight (default)
Image(systemName: "heart")
    .fontWeight(.regular)

// Match headline text
Image(systemName: "heart")
    .fontWeight(.semibold)

// Match body text
Image(systemName: "heart")
    .fontWeight(.regular)
```

## Rendering Modes

### Monochrome

Single color icons:

```swift
Image(systemName: "cloud.sun.fill")
    .symbolRenderingMode(.monochrome)
    .foregroundColor(DSColors.primary500)
```

### Hierarchical

Automatic depth with single color:

```swift
Image(systemName: "cloud.sun.fill")
    .symbolRenderingMode(.hierarchical)
    .foregroundColor(DSColors.primary500)
```

### Palette

Multiple custom colors:

```swift
Image(systemName: "cloud.sun.fill")
    .symbolRenderingMode(.palette)
    .foregroundStyle(DSColors.primary500, DSColors.warning)
```

### Multicolor

System-defined colors:

```swift
Image(systemName: "cloud.sun.fill")
    .symbolRenderingMode(.multicolor)
```

## Symbol Effects

### Pulse

```swift
Image(systemName: "heart.fill")
    .symbolEffect(.pulse)
```

### Bounce

```swift
Image(systemName: "heart.fill")
    .symbolEffect(.bounce, value: isFavorite)
```

### Variable Color

```swift
Image(systemName: "wifi")
    .symbolEffect(.variableColor.iterative)
```

## Icon in Components

### Buttons

```swift
DSButton(
    "Add to Cart",
    icon: Image(systemName: "cart.badge.plus")
) { }

DSIconButton(systemName: "heart.fill") { }
```

### Text Fields

```swift
DSTextField(
    "Search",
    text: $query,
    leadingIcon: Image(systemName: "magnifyingglass")
)
```

### List Items

```swift
DSListCard(
    title: "Settings",
    leadingIcon: Image(systemName: "gear")
)
```

### Badges

```swift
DSTag(
    "Swift",
    icon: Image(systemName: "swift")
)
```

## Custom Icons

### Asset Catalog

Add custom icons to asset catalog and use:

```swift
Image("custom-icon")
    .resizable()
    .frame(width: 24, height: 24)
```

### SVG Support

```swift
// SVG icons via asset catalog
Image("icon-svg")
```

## Icon Grid

Common icon sizes:

| Context | Size | Token |
|---------|------|-------|
| Navigation bar | 24pt | `.lg` |
| Tab bar | 24pt | `.lg` |
| List leading | 20pt | `.md` |
| Button icon | 16-20pt | `.sm`-`.md` |
| Badge icon | 12pt | `.xs` |
| Inline text | Match font | - |

## Accessibility

### Labels

```swift
Image(systemName: "heart.fill")
    .accessibilityLabel("Favorite")

// Or hide from accessibility
Image(systemName: "chevron.right")
    .accessibilityHidden(true)
```

### Scaling

Icons scale with Dynamic Type when used with text:

```swift
Label("Favorites", systemImage: "heart.fill")
    .font(DSTypography.body)
```

## Best Practices

1. **Use SF Symbols** when possible for consistency
2. **Match icon weight** to adjacent text weight
3. **Provide accessibility labels** for meaningful icons
4. **Use consistent sizes** across similar contexts
5. **Consider rendering mode** based on design needs
