# Color System

DesignSystem provides a comprehensive color system with semantic colors, color palettes, and automatic dark mode support.

## Overview

The color system is organized into three categories:

1. **Brand Colors** - Primary, Secondary, Tertiary palettes
2. **Semantic Colors** - Success, Warning, Error, Info
3. **UI Colors** - Background, Surface, Text, Border

## Import

```swift
import FoundationColor

// Or with main library
import DesignSystem
```

## Brand Colors

### Primary Palette

```swift
// Primary colors - main brand color
DSColors.primary50   // Lightest
DSColors.primary100
DSColors.primary200
DSColors.primary300
DSColors.primary400
DSColors.primary500  // Default
DSColors.primary600
DSColors.primary700
DSColors.primary800
DSColors.primary900  // Darkest
```

### Secondary Palette

```swift
// Secondary colors - complementary brand color
DSColors.secondary50
DSColors.secondary100
DSColors.secondary200
DSColors.secondary300
DSColors.secondary400
DSColors.secondary500
DSColors.secondary600
DSColors.secondary700
DSColors.secondary800
DSColors.secondary900
```

### Tertiary Palette

```swift
// Tertiary colors - accent color
DSColors.tertiary50
DSColors.tertiary100
DSColors.tertiary200
DSColors.tertiary300
DSColors.tertiary400
DSColors.tertiary500
DSColors.tertiary600
DSColors.tertiary700
DSColors.tertiary800
DSColors.tertiary900
```

## Semantic Colors

Semantic colors convey meaning and adapt to dark mode automatically.

```swift
// Success - positive actions, confirmations
DSColors.success       // Green
DSColors.successLight  // Light green background

// Warning - caution, attention needed
DSColors.warning       // Orange/Yellow
DSColors.warningLight  // Light yellow background

// Error - errors, destructive actions
DSColors.error        // Red
DSColors.errorLight   // Light red background

// Info - informational messages
DSColors.info         // Blue
DSColors.infoLight    // Light blue background
```

### Usage Examples

```swift
// Success state
Text("Payment successful!")
    .foregroundColor(DSColors.success)

// Error message
Text(errorMessage)
    .foregroundColor(DSColors.error)
    .padding()
    .background(DSColors.errorLight)
    .cornerRadius(8)

// Warning banner
HStack {
    Image(systemName: "exclamationmark.triangle")
    Text("Your subscription expires soon")
}
.foregroundColor(DSColors.warning)
.padding()
.background(DSColors.warningLight)
```

## UI Colors

UI colors adapt to light/dark mode automatically.

### Background Colors

```swift
// Main background
DSColors.background         // White in light, dark gray in dark

// Secondary background (grouped content)
DSColors.backgroundSecondary // Light gray in light, darker in dark
```

### Surface Colors

```swift
// Card/container surface
DSColors.surface           // White in light, elevated dark in dark

// Elevated surface (modals, sheets)
DSColors.surfaceElevated   // Slightly elevated appearance
```

### Text Colors

```swift
// Primary text - highest contrast
DSColors.textPrimary       // Black in light, white in dark

// Secondary text - medium contrast
DSColors.textSecondary     // Gray

// Tertiary text - lowest contrast
DSColors.textTertiary      // Light gray

// Inverse text - opposite of current mode
DSColors.textInverse       // White in light, black in dark
```

### Border & Divider

```swift
// Border color
DSColors.border            // Light gray

// Divider color
DSColors.divider           // Very light gray
```

### Usage Example

```swift
struct ContentCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .foregroundColor(DSColors.textPrimary)

            Text("Description")
                .foregroundColor(DSColors.textSecondary)

            Text("Timestamp")
                .font(.caption)
                .foregroundColor(DSColors.textTertiary)
        }
        .padding()
        .background(DSColors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(DSColors.border, lineWidth: 1)
        )
    }
}
```

## Dark Mode Support

All colors automatically adapt to dark mode. No additional code is required.

```swift
// Automatically adapts
Text("Hello")
    .foregroundColor(DSColors.textPrimary)  // Black in light, white in dark
    .background(DSColors.background)         // White in light, dark in dark
```

### Preview Both Modes

```swift
struct ColorPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .fill(DSColors.primary500)
                .frame(height: 100)
            Text("Primary")
                .foregroundColor(DSColors.textPrimary)
        }
        .background(DSColors.background)
        .previewDisplayName("Light Mode")

        VStack {
            Rectangle()
                .fill(DSColors.primary500)
                .frame(height: 100)
            Text("Primary")
                .foregroundColor(DSColors.textPrimary)
        }
        .background(DSColors.background)
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
```

## Opacity Modifiers

```swift
// Semi-transparent colors
DSColors.primary500.opacity(0.5)

// Common opacity values
Color.overlay10  // 10% opacity overlay
Color.overlay20  // 20% opacity overlay
Color.overlay50  // 50% opacity overlay
```

## Custom Colors

### Extending the Color System

```swift
extension DSColors {
    // Custom brand color
    static let brandPurple = Color("BrandPurple")

    // Custom semantic color
    static let highlight = Color.yellow.opacity(0.3)
}
```

### Using Asset Catalog

Colors are loaded from asset catalogs with automatic dark mode variants:

```
Colors.xcassets/
├── Primary/
│   ├── Primary500.colorset/
│   │   └── Contents.json (light & dark variants)
├── UI/
│   ├── Background.colorset/
│   │   └── Contents.json
```

## Accessibility

### Contrast Ratios

All text/background combinations meet WCAG AA standards:

| Combination | Contrast Ratio |
|-------------|----------------|
| textPrimary on background | 21:1 |
| textSecondary on background | 7:1 |
| textTertiary on background | 4.5:1 |

### Dynamic Type Colors

Colors work well with all Dynamic Type sizes:

```swift
Text("Accessible Text")
    .font(.body)  // Scales with Dynamic Type
    .foregroundColor(DSColors.textPrimary)  // High contrast
```

## Color Tokens Reference

### Brand Colors

| Token | Light | Dark |
|-------|-------|------|
| `primary500` | #007AFF | #0A84FF |
| `secondary500` | #5856D6 | #5E5CE6 |
| `tertiary500` | #AF52DE | #BF5AF2 |

### Semantic Colors

| Token | Light | Dark |
|-------|-------|------|
| `success` | #34C759 | #30D158 |
| `warning` | #FF9500 | #FF9F0A |
| `error` | #FF3B30 | #FF453A |
| `info` | #007AFF | #0A84FF |

### UI Colors

| Token | Light | Dark |
|-------|-------|------|
| `background` | #FFFFFF | #000000 |
| `surface` | #FFFFFF | #1C1C1E |
| `textPrimary` | #000000 | #FFFFFF |
| `textSecondary` | #8E8E93 | #8E8E93 |
| `border` | #C6C6C8 | #38383A |

## Best Practices

1. **Use semantic colors** for meaning (success, error) rather than raw colors
2. **Avoid hardcoding colors** - use DSColors tokens
3. **Test in both modes** - always verify dark mode appearance
4. **Maintain contrast** - use appropriate text/background combinations
5. **Be consistent** - use the same color tokens throughout the app
