# Accessibility Utilities

A comprehensive collection of accessibility utilities for the Design System, providing easy-to-use APIs for VoiceOver support, Dynamic Type, Reduce Motion, High Contrast, and Focus Management.

## Overview

These utilities help ensure your app is accessible to all users by providing:

- **DSAccessibility** - Simplified accessibility modifiers
- **DSAnnounce** - VoiceOver announcement helpers
- **DSDynamicType** - Dynamic Type support and scaling
- **DSReduceMotion** - Reduce Motion preference handling
- **DSHighContrast** - High contrast and color differentiation
- **DSFocusManagement** - Accessibility focus control

## Installation

These utilities are part of the DesignSystem module. Import it in your Swift file:

```swift
import DesignSystem
```

## Usage

### DSAccessibility Modifier

Apply comprehensive accessibility attributes with a single modifier:

```swift
// Basic usage
Button("Save") {
    saveDocument()
}
.dsAccessibility(
    label: "Save button",
    hint: "Saves your current document",
    traits: .isButton
)

// Convenience methods
Image(systemName: "heart.fill")
    .dsButtonAccessibility(label: "Like", hint: "Add to favorites")

Text("Settings")
    .dsHeaderAccessibility(label: "Settings section")

Link("Learn more", destination: url)
    .dsLinkAccessibility(label: "Learn more", hint: "Opens documentation")

// Grouping
HStack {
    Image(systemName: "person")
    Text("John Doe")
}
.dsAccessibilityGroup()

// Container
VStack {
    // Multiple elements
}
.dsAccessibilityContainer()

// Hidden from VoiceOver
Image(systemName: "decorative-star")
    .dsAccessibilityHidden()
```

### Announcements

Make VoiceOver announcements programmatically:

```swift
// Simple announcement
dsAnnounce("Item deleted")

// With priority
dsAnnounce("Error: Connection failed", priority: .immediate)

// Using the announcer
DSAnnouncer.shared.announce("Loading complete")
DSAnnouncer.shared.announceScreenChange("Settings")
DSAnnouncer.shared.announceError("Invalid input")
DSAnnouncer.shared.announceItemCount(5, itemType: "result")

// Announce on value change
Text("Items: \(count)")
    .dsAnnounce("Item count changed to \(count)", when: count)
```

### Dynamic Type

Support Dynamic Type text scaling:

```swift
// Constrain dynamic type range
Text("Body text")
    .dsDynamicTypeSize(.large, .accessibility3)

// Standard range (recommended for body text)
Text("Content")
    .dsDynamicTypeStandard()

// Compact range (for fixed-height elements)
Label("Tab", systemImage: "house")
    .dsDynamicTypeCompact()

// Adaptive layouts
DSDynamicTypeContainer { isAccessibilitySize in
    if isAccessibilitySize {
        VStack { /* Vertical layout */ }
    } else {
        HStack { /* Horizontal layout */ }
    }
}

// Scale values with Dynamic Type
@DSDynamicMetric var buttonHeight: CGFloat = 44
```

### Reduce Motion

Respect the Reduce Motion preference:

```swift
// Accessible animation
Rectangle()
    .frame(width: isExpanded ? 200 : 100)
    .dsReduceMotionAnimation(.spring(), value: isExpanded)

// Spring animation with automatic handling
Circle()
    .dsReduceMotionSpring(response: 0.3, dampingFraction: 0.7, value: isExpanded)

// Conditional content
DSMotionSafeView {
    AnimatedContent()
} reducedContent: {
    StaticContent()
}

// Accessible transitions
view.dsAccessibleTransition(.slide, reduced: .opacity)

// Property wrapper
@DSMotionSafe(standard: 1.0, reduced: 0.0)
var animationOpacity: Double
```

### High Contrast

Support high contrast and color differentiation modes:

```swift
// Alternative content for high contrast
Text("Status: Active")
    .dsHighContrast {
        Label("Status: Active", systemImage: "checkmark.circle")
    }

// Adaptive foreground color
Text("Label")
    .dsHighContrastForeground(standard: .gray, highContrast: .black)

// Border for color differentiation
StatusIndicator(color: .green)
    .dsDifferentiateWithoutColorBorder()

// Accessibility indicators with patterns/icons
DSAccessibilityIndicator(
    color: .red,
    pattern: .crosshatch,
    icon: "xmark"
)
```

### Focus Management

Control accessibility focus programmatically:

```swift
// Focus order
Text("Important")
    .dsFocusOrder(.critical)

TextField("First Name", text: $firstName)
    .dsFocusOrder(.high)

// Focus levels: .critical > .high > .normal > .low > .last

// Visible focus ring
TextField("Name", text: $name)
    .dsFocusRing(isFocused)

// Focus trap for modals (iOS 15+)
ModalContent()
    .dsFocusTrap(isPresented)

// Skip link for navigation
DSSkipLink(label: "Skip to main content") {
    // Move focus to main content
}

// Programmatic focus request (iOS 15+)
TextField("Search", text: $query)
    .dsAccessibilityFocusRequest(shouldFocus)
```

## WCAG Compliance

These utilities help achieve WCAG 2.1 compliance:

| Guideline | Utility | Level |
|-----------|---------|-------|
| 1.1.1 Non-text Content | `dsAccessibility`, `dsImageAccessibility` | A |
| 1.3.1 Info and Relationships | `dsHeaderAccessibility`, `dsAccessibilityContainer` | A |
| 1.4.1 Use of Color | `DSAccessibilityIndicator`, `dsDifferentiateWithoutColorBorder` | A |
| 1.4.3 Contrast | `DSHighContrast`, `dsHighContrastForeground` | AA |
| 2.1.1 Keyboard | `dsFocusOrder`, `DSFocusManagement` | A |
| 2.3.1 Three Flashes | `dsReduceMotionAnimation` | A |
| 2.4.1 Bypass Blocks | `DSSkipLink` | A |
| 2.4.3 Focus Order | `dsFocusOrder`, `DSFocusLevel` | A |
| 2.4.7 Focus Visible | `dsFocusRing` | AA |
| 4.1.2 Name, Role, Value | `dsAccessibility`, `dsButtonAccessibility` | A |

## Best Practices

1. **Always provide labels** - Every interactive element should have a clear accessibility label
2. **Use hints sparingly** - Hints should describe what happens, not the element itself
3. **Test with VoiceOver** - Enable VoiceOver to test your accessibility implementation
4. **Respect user preferences** - Always honor Reduce Motion and contrast settings
5. **Group related elements** - Use `dsAccessibilityGroup()` for elements that should be read together
6. **Hide decorative content** - Use `dsAccessibilityHidden()` for purely decorative elements

## Testing

Run the accessibility tests:

```bash
swift test --filter DSAccessibilityTests
swift test --filter DSDynamicTypeTests
swift test --filter DSReduceMotionTests
swift test --filter DSHighContrastTests
swift test --filter DSFocusManagementTests
```

## Preview Support

Preview providers are available for testing in Xcode:

- `DSAccessibilityModifier_Previews`
- `DSAnnounce_Previews`
- `DSDynamicType_Previews`
- `DSReduceMotion_Previews`
- `DSHighContrast_Previews`
- `DSFocusManagement_Previews`
