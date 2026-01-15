# Best Practices

Guidelines for using DesignSystem effectively in your iOS applications.

## Design Principles

### 1. Consistency

Use design tokens instead of hardcoded values:

```swift
// Good
VStack(spacing: DSSpacing.md) {
    Text("Title")
        .foregroundColor(DSColors.textPrimary)
}

// Avoid
VStack(spacing: 16) {
    Text("Title")
        .foregroundColor(.black)
}
```

### 2. Component Composition

Build complex UIs by composing simple components:

```swift
// Good - composable components
struct UserCard: View {
    let user: User

    var body: some View {
        DSCard {
            HStack(spacing: DSSpacing.md) {
                DSAvatar(initials: user.initials, size: .md)

                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text(user.name)
                        .font(DSTypography.headline)
                    Text(user.email)
                        .font(DSTypography.subheadline)
                        .foregroundColor(DSColors.textSecondary)
                }
            }
        }
    }
}
```

### 3. Semantic Usage

Choose components based on their meaning, not appearance:

```swift
// Good - semantic intent
DSButton("Delete", style: .tertiary) { }
    .foregroundColor(DSColors.error)

// For primary actions
DSButton("Save", style: .primary) { }

// For secondary actions
DSButton("Cancel", style: .secondary) { }
```

## Accessibility

### VoiceOver Support

Ensure all interactive elements are accessible:

```swift
// Provide meaningful labels
DSIconButton(systemName: "heart.fill") { }
    .accessibilityLabel("Add to favorites")

// Add hints for complex actions
DSButton("Delete") { }
    .accessibilityHint("Permanently removes this item")

// Group related content
VStack {
    Text(title)
    Text(subtitle)
}
.accessibilityElement(children: .combine)
```

### Dynamic Type

Support text scaling:

```swift
// Good - uses system fonts that scale
Text("Content")
    .font(DSTypography.body)

// Ensure layouts adapt
ScrollView {
    VStack(spacing: DSSpacing.md) {
        // Content wraps appropriately
    }
}
```

### Touch Targets

Maintain minimum 44pt touch targets:

```swift
// Built into DSButton
DSButton("Tap", size: .small) { }  // Still has 44pt touch target

// For custom elements
Button { } label: {
    Image(systemName: "xmark")
}
.frame(minWidth: 44, minHeight: 44)
```

## Performance

### Lazy Loading

Use lazy containers for large lists:

```swift
// Good - lazy loading
LazyVStack(spacing: DSSpacing.md) {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}

// Avoid - loads all items immediately
VStack(spacing: DSSpacing.md) {
    ForEach(items) { item in
        ItemRow(item: item)
    }
}
```

### Image Optimization

Handle images efficiently:

```swift
// Good - async loading with placeholder
AsyncImage(url: imageURL) { image in
    image
        .resizable()
        .aspectRatio(contentMode: .fill)
} placeholder: {
    DSSkeleton()
}

// Cache images appropriately
// Use thumbnail sizes where possible
```

### State Management

Minimize view updates:

```swift
// Good - specific bindings
struct ItemView: View {
    let item: Item
    @Binding var isSelected: Bool

    var body: some View {
        DSCard {
            // Only updates when isSelected changes
        }
    }
}

// Avoid - passing entire model
struct ItemView: View {
    @ObservedObject var viewModel: ViewModel  // Updates for any change
}
```

## Error Handling

### Form Validation

Show errors clearly:

```swift
struct LoginForm: View {
    @State private var email = ""
    @State private var emailError: String?

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSTextField(
                "Email",
                text: $email,
                type: .email,
                error: emailError
            )
            .onChange(of: email) { _ in
                validateEmail()
            }
        }
    }

    private func validateEmail() {
        if email.isEmpty {
            emailError = nil
        } else if !email.contains("@") {
            emailError = "Please enter a valid email"
        } else {
            emailError = nil
        }
    }
}
```

### Empty States

Handle empty data gracefully:

```swift
if items.isEmpty {
    DSEmptyState(
        icon: Image(systemName: "tray"),
        title: "No Items",
        message: "Add your first item to get started",
        action: DSButton("Add Item") { addItem() }
    )
} else {
    List(items) { item in
        ItemRow(item: item)
    }
}
```

### Loading States

Show progress during async operations:

```swift
struct DataView: View {
    @State private var isLoading = true
    @State private var data: [Item] = []

    var body: some View {
        Group {
            if isLoading {
                VStack(spacing: DSSpacing.md) {
                    ForEach(0..<5, id: \.self) { _ in
                        DSSkeleton()
                            .frame(height: 60)
                    }
                }
            } else {
                List(data) { item in
                    ItemRow(item: item)
                }
            }
        }
        .task {
            data = await fetchData()
            isLoading = false
        }
    }
}
```

## Layout Patterns

### Screen Structure

Follow consistent screen layouts:

```swift
struct ScreenTemplate: View {
    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar
            DSNavigationBar(title: "Screen Title")

            // Scrollable content
            ScrollView {
                VStack(spacing: DSSpacing.lg) {
                    // Content sections
                }
                .padding(DSSpacing.md)
            }

            // Bottom action (if needed)
            SafeAreaFooter {
                DSButton("Action", isFullWidth: true) { }
            }
        }
    }
}
```

### Form Layout

Structure forms consistently:

```swift
Form {
    // Group related fields
    Section("Personal Information") {
        DSTextField("First Name", text: $firstName)
        DSTextField("Last Name", text: $lastName)
    }

    Section("Contact") {
        DSTextField("Email", text: $email, type: .email)
        DSTextField("Phone", text: $phone, type: .phone)
    }

    // Primary action at bottom
    Section {
        DSButton("Save", style: .primary, isFullWidth: true) {
            save()
        }
    }
}
```

### Card Grids

Create responsive card layouts:

```swift
LazyVGrid(
    columns: [
        GridItem(.adaptive(minimum: 160), spacing: DSSpacing.md)
    ],
    spacing: DSSpacing.md
) {
    ForEach(items) { item in
        DSCard {
            ItemContent(item: item)
        }
    }
}
.padding(DSSpacing.md)
```

## Dark Mode

### Testing Both Modes

Always test in both light and dark mode:

```swift
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
            .previewDisplayName("Light")

        MyView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark")
    }
}
```

### Custom Colors

When using custom colors, provide dark mode variants:

```swift
// In asset catalog: provide Any Appearance and Dark variants

// Or programmatically:
let adaptiveColor = Color(UIColor { traits in
    traits.userInterfaceStyle == .dark ? darkColor : lightColor
})
```

## Component Selection Guide

| Need | Component |
|------|-----------|
| Primary action | `DSButton(style: .primary)` |
| Secondary action | `DSButton(style: .secondary)` |
| Icon-only action | `DSIconButton` |
| Text input | `DSTextField` |
| Secure input | `DSTextField(type: .password)` |
| Toggle setting | `DSSwitch` |
| Multiple choice | `DSCheckbox` |
| Single choice | `DSRadioButton` |
| Range selection | `DSSlider` |
| Dropdown selection | `DSSelect` |
| Content container | `DSCard` |
| Status indicator | `DSBadge` |
| User representation | `DSAvatar` |
| Loading state | `DSCircularProgress` / `DSSkeleton` |
| Error display | `DSAlert` |
| Quick feedback | `DSToast` |
| Empty content | `DSEmptyState` |
| Modal content | `DSBottomSheet` |
| Action list | `DSActionSheet` |

## Code Organization

### Component Files

Keep component code organized:

```
Features/
├── Home/
│   ├── HomeView.swift
│   ├── HomeViewModel.swift
│   └── Components/
│       ├── FeaturedCard.swift
│       └── CategoryRow.swift
```

### Reusable Components

Extract repeated patterns:

```swift
// Good - reusable component
struct SectionHeader: View {
    let title: String
    let action: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(DSTypography.headline)

            Spacer()

            if let action = action {
                DSButton("See All", style: .tertiary, size: .small, action: action)
            }
        }
    }
}
```

## Testing

### Preview Coverage

Create comprehensive previews:

```swift
struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // All styles
            VStack {
                DSButton("Primary", style: .primary) { }
                DSButton("Secondary", style: .secondary) { }
                DSButton("Tertiary", style: .tertiary) { }
            }
            .previewDisplayName("Styles")

            // All sizes
            VStack {
                DSButton("Small", size: .small) { }
                DSButton("Medium", size: .medium) { }
                DSButton("Large", size: .large) { }
            }
            .previewDisplayName("Sizes")

            // States
            VStack {
                DSButton("Loading", isLoading: true) { }
                DSButton("Disabled", isEnabled: false) { }
            }
            .previewDisplayName("States")
        }
        .padding()
    }
}
```

### Accessibility Audits

Test with accessibility tools:

1. Enable VoiceOver and navigate through your app
2. Test with various Dynamic Type sizes
3. Use Accessibility Inspector in Xcode
4. Verify color contrast ratios
