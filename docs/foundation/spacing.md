# Spacing & Layout System

DesignSystem provides a consistent spacing system based on an 8-point grid for predictable, harmonious layouts.

## Overview

The spacing system uses multiples of 4pt (base unit) to create consistent rhythm throughout your UI.

## Import

```swift
import DesignSystem
```

## Spacing Tokens

### Standard Spacing

```swift
DSSpacing.none   // 0pt
DSSpacing.xxs    // 2pt
DSSpacing.xs     // 4pt
DSSpacing.sm     // 8pt
DSSpacing.md     // 16pt
DSSpacing.lg     // 24pt
DSSpacing.xl     // 32pt
DSSpacing.xxl    // 48pt
DSSpacing.xxxl   // 64pt
```

### Usage Examples

```swift
// Stack spacing
VStack(spacing: DSSpacing.md) {
    Text("Title")
    Text("Subtitle")
}

// Padding
Text("Content")
    .padding(DSSpacing.lg)

// Horizontal padding
Text("Content")
    .padding(.horizontal, DSSpacing.md)

// Asymmetric padding
Text("Content")
    .padding(.top, DSSpacing.lg)
    .padding(.bottom, DSSpacing.md)
```

## Layout Constants

### Content Width

```swift
// Maximum content width for readability
DSLayout.maxContentWidth  // 640pt

// Apply to content
ScrollView {
    content
        .frame(maxWidth: DSLayout.maxContentWidth)
}
```

### Touch Targets

```swift
// Minimum touch target (Apple HIG)
DSLayout.minTouchTarget  // 44pt

// Apply to buttons
Button { } label: {
    Image(systemName: "heart")
}
.frame(minWidth: DSLayout.minTouchTarget, minHeight: DSLayout.minTouchTarget)
```

### Safe Area

```swift
// Standard safe area padding
DSLayout.safeAreaPadding  // 16pt

// Apply to screen edges
VStack {
    content
}
.padding(.horizontal, DSLayout.safeAreaPadding)
```

## Grid System

### Column Grid

```swift
// 2-column grid
LazyVGrid(
    columns: DSGrid.columns(2),
    spacing: DSSpacing.md
) {
    ForEach(items) { item in
        ItemView(item: item)
    }
}

// 3-column grid with custom spacing
LazyVGrid(
    columns: DSGrid.columns(3, spacing: DSSpacing.sm),
    spacing: DSSpacing.sm
) {
    content
}
```

### Adaptive Grid

```swift
// Adaptive columns based on minimum width
LazyVGrid(
    columns: DSGrid.adaptive(minWidth: 150),
    spacing: DSSpacing.md
) {
    content
}
```

## Component Spacing Guidelines

### Card Spacing

```swift
DSCard {
    VStack(alignment: .leading, spacing: DSSpacing.sm) {
        // Header
        Text("Title")
            .font(DSTypography.headline)

        // Content
        Text("Description")
            .font(DSTypography.body)

        // Footer - extra spacing from content
        HStack {
            DSButton("Action", size: .small) { }
        }
        .padding(.top, DSSpacing.xs)
    }
    .padding(DSSpacing.md)
}
```

### Form Spacing

```swift
VStack(spacing: DSSpacing.md) {
    // Field groups
    VStack(spacing: DSSpacing.sm) {
        DSTextField("First Name", text: $firstName)
        DSTextField("Last Name", text: $lastName)
    }

    // Separator
    Divider()
        .padding(.vertical, DSSpacing.sm)

    // Another group
    VStack(spacing: DSSpacing.sm) {
        DSTextField("Email", text: $email)
        DSTextField("Phone", text: $phone)
    }
}
.padding(DSSpacing.lg)
```

### List Spacing

```swift
VStack(spacing: DSSpacing.none) {
    ForEach(items) { item in
        DSListCard(title: item.title) { }
            .padding(.horizontal, DSSpacing.md)
            .padding(.vertical, DSSpacing.sm)

        Divider()
            .padding(.leading, DSSpacing.md)
    }
}
```

### Section Spacing

```swift
ScrollView {
    VStack(spacing: DSSpacing.xl) {
        // Hero section
        HeroView()
            .padding(.horizontal, DSSpacing.md)

        // Featured section
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            Text("Featured")
                .font(DSTypography.headline)
                .padding(.horizontal, DSSpacing.md)

            ScrollView(.horizontal) {
                HStack(spacing: DSSpacing.md) {
                    ForEach(featured) { item in
                        FeaturedCard(item: item)
                    }
                }
                .padding(.horizontal, DSSpacing.md)
            }
        }

        // Content section
        VStack(spacing: DSSpacing.md) {
            content
        }
        .padding(.horizontal, DSSpacing.md)
    }
    .padding(.vertical, DSSpacing.lg)
}
```

## Responsive Spacing

### Screen Size Adaptation

```swift
struct ResponsiveContainer: View {
    @Environment(\.horizontalSizeClass) var sizeClass

    var horizontalPadding: CGFloat {
        sizeClass == .compact ? DSSpacing.md : DSSpacing.xl
    }

    var body: some View {
        content
            .padding(.horizontal, horizontalPadding)
    }
}
```

### Dynamic Spacing

```swift
struct AdaptiveSpacing: View {
    var body: some View {
        GeometryReader { geometry in
            let spacing = geometry.size.width > 600
                ? DSSpacing.lg
                : DSSpacing.md

            VStack(spacing: spacing) {
                content
            }
        }
    }
}
```

## Spacing Reference

| Token | Value | Use Case |
|-------|-------|----------|
| `none` | 0pt | No spacing |
| `xxs` | 2pt | Hairline gaps |
| `xs` | 4pt | Tight grouping, icons |
| `sm` | 8pt | Related elements |
| `md` | 16pt | Standard component spacing |
| `lg` | 24pt | Section gaps |
| `xl` | 32pt | Major section breaks |
| `xxl` | 48pt | Page sections |
| `xxxl` | 64pt | Hero spacing |

## Visual Rhythm

### Establishing Hierarchy

```swift
VStack(spacing: 0) {
    // Page title - large top padding
    Text("Settings")
        .font(DSTypography.largeTitle)
        .padding(.top, DSSpacing.xxl)
        .padding(.bottom, DSSpacing.lg)

    // Section - medium spacing
    SettingsSection(title: "Account") {
        // Items - small spacing between
        SettingsRow(title: "Profile")
        SettingsRow(title: "Privacy")
    }
    .padding(.bottom, DSSpacing.lg)

    // Another section
    SettingsSection(title: "Preferences") {
        SettingsRow(title: "Theme")
        SettingsRow(title: "Language")
    }
}
```

## Best Practices

1. **Use tokens, not magic numbers** - Always use DSSpacing values
2. **Maintain consistency** - Same spacing for same relationships
3. **Respect the grid** - Stick to 4pt/8pt multiples
4. **Provide breathing room** - Don't overcrowd elements
5. **Test on devices** - Verify spacing on different screen sizes

## Common Patterns

### Inset Grouping

```swift
// Content inset from edges
content
    .padding(DSSpacing.md)
```

### Stack Grouping

```swift
// Items in a stack
VStack(spacing: DSSpacing.sm) {
    items
}
```

### Section Separation

```swift
// Between major sections
.padding(.vertical, DSSpacing.xl)
```

### Inline Elements

```swift
// Horizontal inline elements
HStack(spacing: DSSpacing.xs) {
    Image(systemName: "star")
    Text("Favorite")
}
```
