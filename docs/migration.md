# Migration Guide

This guide helps you migrate from standard SwiftUI components or other UI libraries to DesignSystem.

## From Standard SwiftUI

### Buttons

**Before (SwiftUI)**
```swift
Button("Submit") {
    handleSubmit()
}
.buttonStyle(.borderedProminent)
.controlSize(.large)
```

**After (DesignSystem)**
```swift
DSButton("Submit", style: .primary, size: .large) {
    handleSubmit()
}
```

### Text Fields

**Before (SwiftUI)**
```swift
VStack(alignment: .leading) {
    Text("Email")
        .font(.caption)
    TextField("Enter email", text: $email)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.emailAddress)
    if let error = emailError {
        Text(error)
            .font(.caption)
            .foregroundColor(.red)
    }
}
```

**After (DesignSystem)**
```swift
DSTextField(
    "Email",
    text: $email,
    type: .email,
    placeholder: "Enter email",
    error: emailError
)
```

### Cards

**Before (SwiftUI)**
```swift
VStack {
    content
}
.padding()
.background(Color(.systemBackground))
.cornerRadius(12)
.shadow(color: .black.opacity(0.1), radius: 8, y: 4)
```

**After (DesignSystem)**
```swift
DSCard(style: .elevated) {
    content
}
```

### Toggle/Switch

**Before (SwiftUI)**
```swift
Toggle("Enable notifications", isOn: $isEnabled)
```

**After (DesignSystem)**
```swift
DSSwitch("Enable notifications", isOn: $isEnabled)
```

### Progress Indicators

**Before (SwiftUI)**
```swift
ProgressView()
    .progressViewStyle(CircularProgressViewStyle())

ProgressView(value: progress)
    .progressViewStyle(LinearProgressViewStyle())
```

**After (DesignSystem)**
```swift
DSCircularProgress()

DSLinearProgress(progress: progress)
```

## Spacing Migration

Replace hardcoded spacing values:

| Old Value | DesignSystem Token |
|-----------|-------------------|
| `4` | `DSSpacing.xs` |
| `8` | `DSSpacing.sm` |
| `12` | `DSSpacing.sm` or `DSSpacing.md` |
| `16` | `DSSpacing.md` |
| `20` | `DSSpacing.md` or `DSSpacing.lg` |
| `24` | `DSSpacing.lg` |
| `32` | `DSSpacing.xl` |
| `48` | `DSSpacing.xxl` |

**Before**
```swift
VStack(spacing: 16) {
    content
}
.padding(24)
```

**After**
```swift
VStack(spacing: DSSpacing.md) {
    content
}
.padding(DSSpacing.lg)
```

## Color Migration

Replace system colors:

| System Color | DesignSystem Token |
|-------------|-------------------|
| `.primary` | `DSColors.textPrimary` |
| `.secondary` | `DSColors.textSecondary` |
| `.accentColor` | `DSColors.primary500` |
| `.red` | `DSColors.error` |
| `.green` | `DSColors.success` |
| `.orange` | `DSColors.warning` |
| `.blue` | `DSColors.info` |
| `.systemBackground` | `DSColors.background` |
| `.systemGray6` | `DSColors.surface` |

**Before**
```swift
Text("Error")
    .foregroundColor(.red)
    .background(Color(.systemBackground))
```

**After**
```swift
Text("Error")
    .foregroundColor(DSColors.error)
    .background(DSColors.background)
```

## Typography Migration

Replace font modifiers:

| SwiftUI Font | DesignSystem Typography |
|-------------|------------------------|
| `.largeTitle` | `DSTypography.largeTitle` |
| `.title` | `DSTypography.title` |
| `.title2` | `DSTypography.title2` |
| `.title3` | `DSTypography.title3` |
| `.headline` | `DSTypography.headline` |
| `.subheadline` | `DSTypography.subheadline` |
| `.body` | `DSTypography.body` |
| `.callout` | `DSTypography.callout` |
| `.footnote` | `DSTypography.footnote` |
| `.caption` | `DSTypography.caption` |
| `.caption2` | `DSTypography.caption2` |

**Before**
```swift
Text("Title")
    .font(.headline)
```

**After**
```swift
Text("Title")
    .font(DSTypography.headline)
```

## Component Mapping

### Navigation

| SwiftUI | DesignSystem |
|---------|-------------|
| `TabView` | `DSTabBar` |
| `NavigationView` | `NavigationStack` + `DSNavigationBar` |
| `Picker` (segmented) | `DSSegmentedControl` |

### Forms

| SwiftUI | DesignSystem |
|---------|-------------|
| `TextField` | `DSTextField` |
| `SecureField` | `DSTextField(type: .password)` |
| `Toggle` | `DSSwitch` |
| `Picker` | `DSSelect` / `DSDropdownMenu` |
| `Slider` | `DSSlider` |
| `DatePicker` | `DSDatePicker` |

### Feedback

| SwiftUI | DesignSystem |
|---------|-------------|
| `.alert()` | `DSAlert` |
| `.confirmationDialog()` | `DSConfirmationDialog` |
| `.sheet()` | `DSBottomSheet` |
| `ProgressView` | `DSCircularProgress` / `DSLinearProgress` |

## Step-by-Step Migration

### 1. Add the Package

```swift
// In Package.swift or via Xcode
.package(url: "https://github.com/kamilsevket/ios-awesome.git", from: "1.0.0")
```

### 2. Import the Library

```swift
import DesignSystem
```

### 3. Replace Tokens First

Start by replacing colors, spacing, and typography tokens while keeping existing components:

```swift
// Phase 1: Replace tokens
VStack(spacing: DSSpacing.md) {  // Was: 16
    Text("Title")
        .font(DSTypography.headline)  // Was: .headline
        .foregroundColor(DSColors.textPrimary)  // Was: .primary
}
.padding(DSSpacing.lg)  // Was: 24
```

### 4. Replace Components Incrementally

Replace components one at a time:

```swift
// Phase 2: Replace components
// Week 1: Buttons
DSButton("Action") { }

// Week 2: Text fields
DSTextField("Email", text: $email)

// Week 3: Cards
DSCard { content }
```

### 5. Update Layouts

Adopt DesignSystem layout patterns:

```swift
// Phase 3: Layout patterns
struct ScreenView: View {
    var body: some View {
        VStack(spacing: 0) {
            DSNavigationBar(title: "Screen")

            ScrollView {
                VStack(spacing: DSSpacing.lg) {
                    // Content
                }
                .padding(DSSpacing.md)
            }
        }
    }
}
```

## Common Issues

### Import Conflicts

If you have naming conflicts with existing code:

```swift
// Use explicit module reference
import DesignSystem

let button = DesignSystem.DSButton("Tap") { }
```

### Custom Themes

If you have custom theming, integrate with DesignSystem:

```swift
// Configure at app launch
DSTheme.configure(
    primaryColor: YourTheme.primary,
    secondaryColor: YourTheme.secondary
)
```

### Breaking Changes

When updating DesignSystem versions, check the [Changelog](CHANGELOG.md) for breaking changes and migration notes.

## Coexistence Strategy

You can use DesignSystem components alongside existing code:

```swift
struct HybridView: View {
    var body: some View {
        VStack {
            // DesignSystem component
            DSButton("New Button") { }

            // Existing component (migrate later)
            Button("Legacy Button") { }
                .buttonStyle(.bordered)
        }
    }
}
```

## Verification Checklist

After migration, verify:

- [ ] All buttons use `DSButton`
- [ ] Text fields use `DSTextField`
- [ ] Cards use `DSCard`
- [ ] Spacing uses `DSSpacing` tokens
- [ ] Colors use `DSColors` tokens
- [ ] Typography uses `DSTypography`
- [ ] Dark mode works correctly
- [ ] Accessibility is maintained
- [ ] Dynamic Type scales properly
