# Selection Control Components

Form selection control components for the iOS Design System.

## Components

### DSCheckbox

A customizable checkbox component with support for checked, unchecked, and indeterminate states.

```swift
// Basic usage
@State private var isChecked = false

DSCheckbox(isChecked: $isChecked, label: "I agree to the terms")

// With indeterminate state (tri-state)
@State private var state: DSCheckboxState = .indeterminate

DSCheckbox(state: $state, label: "Select all")

// With custom colors
DSCheckbox(
    isChecked: $isChecked,
    label: "Custom checkbox",
    checkedColor: .green
)
```

**Features:**
- Three states: checked, unchecked, indeterminate
- Size variants: small, medium, large
- Label position: leading, trailing
- Custom colors
- Disabled state
- Animated transitions

### DSRadioButton

A radio button component for single selection from a set of options.

```swift
enum Gender: String, CaseIterable {
    case male, female, other
}

@State private var selectedGender: Gender? = nil

// With optional selection
DSRadioButton(
    value: .male,
    selection: $selectedGender,
    label: "Male"
)

// With non-optional selection
@State private var gender: Gender = .male

DSRadioButton(
    value: .male,
    selection: $gender,
    label: "Male"
)
```

**Features:**
- Size variants: small, medium, large
- Label position: leading, trailing
- Custom colors
- Disabled state
- Animated selection

### DSRadioGroup

A container component that manages a group of radio buttons with single selection enforcement.

```swift
enum PaymentMethod: String, CaseIterable {
    case creditCard = "Credit Card"
    case paypal = "PayPal"
    case applePay = "Apple Pay"
}

@State private var selectedMethod: PaymentMethod = .creditCard

// Using ViewBuilder
DSRadioGroup(selection: $selectedMethod) {
    DSRadio(.creditCard, "Credit Card")
    DSRadio(.paypal, "PayPal")
    DSRadio(.applePay, "Apple Pay")
}

// Using options array
DSRadioGroup(
    selection: $selectedMethod,
    options: PaymentMethod.allCases
) { option in
    option.rawValue
}

// Horizontal layout
DSRadioGroup(selection: $selectedMethod, axis: .horizontal) {
    DSRadio(.creditCard, "Credit Card")
    DSRadio(.paypal, "PayPal")
}
```

**Features:**
- Vertical and horizontal layouts
- Custom spacing
- Single selection enforcement
- Works with any Hashable type

### DSToggle

A toggle/switch component for on/off states.

```swift
@State private var isEnabled = false

// Basic usage
DSToggle(isOn: $isEnabled, label: "Push notifications")

// With custom colors
DSToggle(
    isOn: $isEnabled,
    label: "Dark mode",
    onColor: .purple
)

// Without label
DSToggle(isOn: $isEnabled, size: .small)
```

**Features:**
- Size variants: small, medium, large
- Label position: leading, trailing
- Custom track and thumb colors
- Disabled state
- Spring animation

## Accessibility

All components include comprehensive accessibility support:

- **VoiceOver**: Proper labels, values, and hints
- **Dynamic Type**: Font sizes adapt to user preferences
- **Touch Targets**: Minimum 44pt touch targets (Apple HIG)
- **Traits**: Appropriate accessibility traits (button, selected)

## Dark Mode

All components automatically adapt to light and dark mode using semantic colors from `DSColors`.

## Size Reference

| Component | Small | Medium | Large |
|-----------|-------|--------|-------|
| Checkbox | 18pt | 22pt | 26pt |
| RadioButton | 18pt | 22pt | 26pt |
| Toggle Track | 42x26pt | 51x31pt | 60x36pt |

## Touch Targets

All interactive elements maintain a minimum touch target of 44pt (as per Apple Human Interface Guidelines).
