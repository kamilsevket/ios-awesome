# Button Components

DesignSystem provides a comprehensive set of button components for various use cases.

## Components

- [DSButton](#dsbutton) - Primary button component
- [DSIconButton](#dsiconbutton) - Icon-only button
- [DSFloatingActionButton](#dsfloatingactionbutton) - FAB for primary actions

---

## DSButton

A customizable button component with support for multiple styles, sizes, and states.

### Basic Usage

```swift
import DesignSystem

// Simple button
DSButton("Submit") {
    handleSubmit()
}

// With style
DSButton("Continue", style: .primary) {
    proceed()
}

DSButton("Cancel", style: .secondary) {
    dismiss()
}

DSButton("Learn More", style: .tertiary) {
    showInfo()
}
```

### Styles

| Style | Description | Use Case |
|-------|-------------|----------|
| `.primary` | Solid background, high emphasis | Primary actions (Submit, Save, Continue) |
| `.secondary` | Light background, medium emphasis | Secondary actions (Cancel, Back) |
| `.tertiary` | Transparent, low emphasis | Tertiary actions (Learn more, Skip) |

```swift
// Primary - main actions
DSButton("Save Changes", style: .primary) { }

// Secondary - alternative actions
DSButton("Discard", style: .secondary) { }

// Tertiary - low priority actions
DSButton("Skip for now", style: .tertiary) { }
```

### Sizes

```swift
// Small - compact spaces
DSButton("Edit", size: .small) { }

// Medium - default size
DSButton("Continue", size: .medium) { }

// Large - prominent actions
DSButton("Get Started", size: .large) { }
```

| Size | Height | Padding | Font |
|------|--------|---------|------|
| `.small` | 36pt | 8×16pt | Subheadline |
| `.medium` | 44pt | 12×24pt | Body Semibold |
| `.large` | 52pt | 16×32pt | Headline Semibold |

### Icons

```swift
// Leading icon (default)
DSButton(
    "Add Item",
    icon: Image(systemName: "plus")
) { }

// Trailing icon
DSButton(
    "Next",
    icon: Image(systemName: "arrow.right"),
    iconPosition: .trailing
) { }

// Icon with different styles
DSButton(
    "Download",
    style: .secondary,
    icon: Image(systemName: "arrow.down.circle")
) { }
```

### States

```swift
// Loading state
@State private var isLoading = false

DSButton(
    "Saving...",
    isLoading: isLoading
) {
    save()
}

// Disabled state
DSButton(
    "Submit",
    isEnabled: formIsValid
) {
    submit()
}

// Full width
DSButton(
    "Sign In",
    isFullWidth: true
) {
    signIn()
}
```

### Complete Example

```swift
struct CheckoutButton: View {
    @State private var isProcessing = false
    let total: Double

    var body: some View {
        DSButton(
            "Pay \(total.formatted(.currency(code: "USD")))",
            style: .primary,
            size: .large,
            icon: Image(systemName: "creditcard"),
            isFullWidth: true,
            isLoading: isProcessing,
            hapticFeedback: true
        ) {
            processPayment()
        }
    }
}
```

### Accessibility

DSButton includes built-in accessibility support:

```swift
// Default behavior - title becomes accessibility label
DSButton("Submit") { }
// VoiceOver: "Submit, Button"

// Loading state is announced
DSButton("Loading...", isLoading: true) { }
// VoiceOver: "Loading, Button, Loading"

// Custom accessibility
DSButton("X") { }
    .accessibilityLabel("Close")
    .accessibilityHint("Dismisses this dialog")
```

---

## DSIconButton

A button displaying only an icon, ideal for toolbars and compact spaces.

### Basic Usage

```swift
// Simple icon button
DSIconButton(systemName: "heart") {
    toggleFavorite()
}

// With custom image
DSIconButton(image: Image("custom-icon")) {
    handleTap()
}
```

### Variants

```swift
// Filled variant
DSIconButton(
    systemName: "heart.fill",
    variant: .filled
) { }

// Outlined variant
DSIconButton(
    systemName: "heart",
    variant: .outlined
) { }

// Ghost variant (no background)
DSIconButton(
    systemName: "heart",
    variant: .ghost
) { }
```

### Sizes

```swift
DSIconButton(systemName: "gear", size: .small) { }   // 32pt
DSIconButton(systemName: "gear", size: .medium) { }  // 44pt
DSIconButton(systemName: "gear", size: .large) { }   // 56pt
```

### States

```swift
// Toggle state
@State private var isFavorite = false

DSIconButton(
    systemName: isFavorite ? "heart.fill" : "heart",
    isSelected: isFavorite
) {
    isFavorite.toggle()
}

// Disabled state
DSIconButton(
    systemName: "trash",
    isEnabled: canDelete
) { }
```

### Toolbar Example

```swift
struct EditorToolbar: View {
    var body: some View {
        HStack(spacing: DSSpacing.sm) {
            DSIconButton(systemName: "bold") { }
            DSIconButton(systemName: "italic") { }
            DSIconButton(systemName: "underline") { }

            Divider()

            DSIconButton(systemName: "list.bullet") { }
            DSIconButton(systemName: "list.number") { }
        }
    }
}
```

---

## DSFloatingActionButton

A floating action button for primary actions, typically positioned at the bottom of the screen.

### Basic Usage

```swift
ZStack(alignment: .bottomTrailing) {
    // Main content
    ContentView()

    // FAB
    DSFloatingActionButton(systemName: "plus") {
        createNewItem()
    }
    .padding()
}
```

### Variants

```swift
// Standard FAB
DSFloatingActionButton(systemName: "plus") { }

// Extended FAB with label
DSFloatingActionButton(
    systemName: "plus",
    label: "Create"
) { }

// Mini FAB
DSFloatingActionButton(
    systemName: "arrow.up",
    size: .mini
) { }
```

### Positioning

```swift
// Bottom right (default)
.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

// Bottom center
.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

// Custom position
.position(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height - 120)
```

### Animation

```swift
// Auto-hide on scroll
@State private var showFAB = true

ScrollView {
    content
        .onScroll { offset in
            withAnimation {
                showFAB = offset.y < 100
            }
        }
}

DSFloatingActionButton(systemName: "plus") { }
    .opacity(showFAB ? 1 : 0)
    .scaleEffect(showFAB ? 1 : 0.5)
```

---

## Best Practices

### Button Hierarchy

Use button styles to establish visual hierarchy:

```swift
VStack(spacing: DSSpacing.md) {
    // Most important action
    DSButton("Save Changes", style: .primary, isFullWidth: true) { }

    // Alternative action
    DSButton("Cancel", style: .secondary, isFullWidth: true) { }

    // Least important
    DSButton("Delete Account", style: .tertiary) { }
}
```

### Touch Targets

All buttons maintain minimum 44pt touch targets (Apple HIG):

```swift
// Even small buttons have proper touch targets
DSButton("OK", size: .small) { }
// Visual: 36pt tall
// Touch target: 44pt minimum
```

### Loading States

Show loading state for async operations:

```swift
@State private var isSaving = false

DSButton("Save", isLoading: isSaving) {
    isSaving = true
    Task {
        await save()
        isSaving = false
    }
}
```

### Destructive Actions

Use red/destructive styling for dangerous actions:

```swift
DSButton("Delete", style: .tertiary) {
    confirmDelete()
}
.foregroundColor(.red)
```

---

## API Reference

### DSButton

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | required | Button label |
| `style` | `DSButtonStyle` | `.primary` | Visual style |
| `size` | `DSButtonSize` | `.medium` | Size variant |
| `icon` | `Image?` | `nil` | Optional icon |
| `iconPosition` | `DSButtonIconPosition` | `.leading` | Icon placement |
| `isFullWidth` | `Bool` | `false` | Expand to full width |
| `isLoading` | `Bool` | `false` | Show loading spinner |
| `isEnabled` | `Bool` | `true` | Interactive state |
| `hapticFeedback` | `Bool` | `true` | Trigger haptics |
| `action` | `() -> Void` | required | Tap handler |

### DSIconButton

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `systemName` | `String` | required | SF Symbol name |
| `variant` | `IconButtonVariant` | `.filled` | Visual variant |
| `size` | `IconButtonSize` | `.medium` | Size variant |
| `isSelected` | `Bool` | `false` | Selected state |
| `isEnabled` | `Bool` | `true` | Interactive state |
| `action` | `() -> Void` | required | Tap handler |
