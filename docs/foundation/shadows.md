# Shadows & Elevation System

DesignSystem provides a consistent shadow system for creating depth and visual hierarchy.

## Overview

Shadows help establish visual hierarchy by indicating elevation. Higher elevation elements cast larger shadows.

## Shadow Presets

### Small Shadow

For subtle elevation (cards, buttons):

```swift
.shadow(DSShadow.small)

// Equivalent to:
// color: black @ 8% opacity
// radius: 4pt
// y offset: 2pt
```

### Medium Shadow

For moderate elevation (dropdowns, popovers):

```swift
.shadow(DSShadow.medium)

// Equivalent to:
// color: black @ 12% opacity
// radius: 8pt
// y offset: 4pt
```

### Large Shadow

For high elevation (modals, sheets):

```swift
.shadow(DSShadow.large)

// Equivalent to:
// color: black @ 16% opacity
// radius: 16pt
// y offset: 8pt
```

## Usage

### On Components

```swift
DSCard(style: .elevated) {
    content
}
// Automatically applies appropriate shadow

// Or manually:
Rectangle()
    .fill(Color.white)
    .shadow(DSShadow.medium)
```

### Custom Shadows

```swift
// Create custom shadow
let customShadow = DSShadow(
    color: .black.opacity(0.1),
    radius: 12,
    x: 0,
    y: 6
)

view.shadow(customShadow)
```

## Elevation Levels

| Level | Use Case | Shadow |
|-------|----------|--------|
| 0 | Flat content | None |
| 1 | Cards, tiles | Small |
| 2 | Dropdowns, menus | Medium |
| 3 | Dialogs, sheets | Large |

```swift
// Apply elevation
.elevation(.level1)  // Small shadow
.elevation(.level2)  // Medium shadow
.elevation(.level3)  // Large shadow
```

## Dark Mode

Shadows adapt to dark mode:

```swift
// Light mode: visible shadow
// Dark mode: reduced shadow with subtle glow

.shadow(DSShadow.medium)  // Automatically adapts
```

## Best Practices

1. **Use consistent elevation** - Same elevation for same component types
2. **Don't overuse shadows** - Too many shadows create visual noise
3. **Match the context** - Higher elements need more shadow
4. **Consider dark mode** - Test shadow visibility in both modes
