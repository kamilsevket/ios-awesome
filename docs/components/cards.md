# Card Components

DesignSystem provides flexible card components for displaying grouped content with consistent styling.

## Components

- [DSCard](#dscard) - Base card container
- [DSImageCard](#dsimagecard) - Card with featured image
- [DSListCard](#dslistcard) - Card optimized for list items
- [DSExpandableCard](#dsexpandablecard) - Collapsible card
- [DSInteractiveCard](#dsinteractivecard) - Tappable card with actions

---

## DSCard

The base card component providing a styled container with elevation and padding.

### Basic Usage

```swift
import DesignSystem

DSCard {
    VStack(alignment: .leading, spacing: DSSpacing.sm) {
        Text("Card Title")
            .font(.headline)
        Text("Card description goes here")
            .font(.body)
            .foregroundColor(.secondary)
    }
}
```

### Styles

```swift
// Elevated (default) - with shadow
DSCard(style: .elevated) {
    content
}

// Outlined - border only
DSCard(style: .outlined) {
    content
}

// Filled - solid background
DSCard(style: .filled) {
    content
}

// Ghost - minimal, no border
DSCard(style: .ghost) {
    content
}
```

### Padding

```swift
// No padding
DSCard(padding: .zero) {
    Image("hero")
        .resizable()
}

// Small padding
DSCard(padding: .small) {
    content
}

// Medium padding (default)
DSCard(padding: .medium) {
    content
}

// Large padding
DSCard(padding: .large) {
    content
}
```

### Corner Radius

```swift
// Default radius
DSCard {
    content
}

// Custom radius
DSCard(cornerRadius: 24) {
    content
}

// No radius
DSCard(cornerRadius: 0) {
    content
}
```

---

## DSImageCard

A card with a featured image at the top or as a background.

### Basic Usage

```swift
DSImageCard(
    image: Image("product-photo"),
    title: "Product Name",
    subtitle: "$99.99"
)
```

### Image Positions

```swift
// Top image (default)
DSImageCard(
    image: Image("photo"),
    imagePosition: .top,
    title: "Title"
)

// Background image
DSImageCard(
    image: Image("background"),
    imagePosition: .background,
    title: "Overlay Title"
)

// Leading image
DSImageCard(
    image: Image("thumbnail"),
    imagePosition: .leading,
    title: "Horizontal Card"
)
```

### Aspect Ratio

```swift
// Square
DSImageCard(
    image: image,
    aspectRatio: 1.0,
    title: "Square Card"
)

// Wide (16:9)
DSImageCard(
    image: image,
    aspectRatio: 16/9,
    title: "Wide Card"
)

// Portrait (3:4)
DSImageCard(
    image: image,
    aspectRatio: 3/4,
    title: "Portrait Card"
)
```

### Complete Example

```swift
struct ProductCard: View {
    let product: Product

    var body: some View {
        DSImageCard(
            image: AsyncImage(url: product.imageURL) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            },
            imagePosition: .top,
            aspectRatio: 4/3,
            title: product.name,
            subtitle: product.price.formatted(.currency(code: "USD"))
        ) {
            // Footer content
            HStack {
                DSTag(product.category, variant: .primary)
                Spacer()
                DSIconButton(systemName: "heart") {
                    toggleFavorite()
                }
            }
        }
    }
}
```

---

## DSListCard

Optimized for displaying list items with leading accessory, title, subtitle, and trailing content.

### Basic Usage

```swift
DSListCard(
    title: "Settings",
    leadingIcon: Image(systemName: "gear")
)
```

### With Subtitle

```swift
DSListCard(
    title: "John Doe",
    subtitle: "john.doe@example.com",
    leadingContent: {
        DSAvatar(initials: "JD", size: .md)
    }
)
```

### Trailing Content

```swift
// Disclosure indicator
DSListCard(
    title: "Privacy",
    leadingIcon: Image(systemName: "lock"),
    showDisclosure: true
)

// Custom trailing
DSListCard(
    title: "Notifications",
    leadingIcon: Image(systemName: "bell"),
    trailing: {
        DSBadge(count: 5)
    }
)

// Toggle
DSListCard(
    title: "Dark Mode",
    leadingIcon: Image(systemName: "moon"),
    trailing: {
        Toggle("", isOn: $isDarkMode)
    }
)
```

### List Example

```swift
struct SettingsView: View {
    var body: some View {
        VStack(spacing: DSSpacing.xs) {
            DSListCard(
                title: "Account",
                subtitle: "Manage your account settings",
                leadingIcon: Image(systemName: "person.circle"),
                showDisclosure: true
            ) {
                navigateToAccount()
            }

            DSListCard(
                title: "Notifications",
                subtitle: "Configure push notifications",
                leadingIcon: Image(systemName: "bell"),
                showDisclosure: true
            ) {
                navigateToNotifications()
            }

            DSListCard(
                title: "Privacy",
                leadingIcon: Image(systemName: "lock.shield"),
                showDisclosure: true
            ) {
                navigateToPrivacy()
            }
        }
    }
}
```

---

## DSExpandableCard

A card that can expand/collapse to show/hide additional content.

### Basic Usage

```swift
@State private var isExpanded = false

DSExpandableCard(
    isExpanded: $isExpanded,
    header: {
        Text("FAQ Question")
            .font(.headline)
    },
    content: {
        Text("This is the detailed answer that appears when expanded.")
            .font(.body)
    }
)
```

### With Preview

```swift
DSExpandableCard(
    isExpanded: $isExpanded,
    header: {
        HStack {
            Image(systemName: "questionmark.circle")
            Text("How do I reset my password?")
        }
    },
    preview: {
        // Shows when collapsed
        Text("Click here to learn about password reset...")
            .lineLimit(2)
    },
    content: {
        // Shows when expanded
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text("To reset your password:")
            Text("1. Go to Settings")
            Text("2. Tap 'Account'")
            Text("3. Select 'Change Password'")
        }
    }
)
```

### Accordion Pattern

```swift
struct FAQView: View {
    @State private var expandedIndex: Int?

    let faqs = [
        FAQ(question: "...", answer: "..."),
        // ...
    ]

    var body: some View {
        VStack(spacing: DSSpacing.sm) {
            ForEach(faqs.indices, id: \.self) { index in
                DSExpandableCard(
                    isExpanded: Binding(
                        get: { expandedIndex == index },
                        set: { if $0 { expandedIndex = index } else { expandedIndex = nil } }
                    ),
                    header: { Text(faqs[index].question) },
                    content: { Text(faqs[index].answer) }
                )
            }
        }
    }
}
```

---

## DSInteractiveCard

A card with built-in tap handling, press states, and optional actions.

### Basic Usage

```swift
DSInteractiveCard {
    // Card content
    Text("Tap me")
} action: {
    handleTap()
}
```

### With Highlight

```swift
DSInteractiveCard(
    highlightOnPress: true
) {
    HStack {
        Image(systemName: "star.fill")
        Text("Premium Feature")
        Spacer()
        Image(systemName: "chevron.right")
    }
} action: {
    showPremiumFeature()
}
```

### Selectable Cards

```swift
struct SelectableCardGrid: View {
    @State private var selectedId: String?

    let items: [Item]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items) { item in
                DSInteractiveCard(
                    isSelected: selectedId == item.id,
                    selectionStyle: .checkmark
                ) {
                    VStack {
                        Image(item.image)
                        Text(item.title)
                    }
                } action: {
                    selectedId = item.id
                }
            }
        }
    }
}
```

---

## Best Practices

### Card Hierarchy

```swift
// Primary card - elevated
DSCard(style: .elevated) {
    importantContent
}

// Secondary card - outlined
DSCard(style: .outlined) {
    secondaryContent
}

// Tertiary card - ghost
DSCard(style: .ghost) {
    minimalContent
}
```

### Content Spacing

```swift
DSCard {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
        // Header
        HStack {
            Text("Title").font(.headline)
            Spacer()
            DSIconButton(systemName: "ellipsis") { }
        }

        // Body
        Text("Description text...")
            .font(.body)

        // Footer
        HStack {
            DSButton("Action", size: .small) { }
            Spacer()
            Text("2 hours ago")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
```

### Responsive Cards

```swift
struct ResponsiveCardGrid: View {
    var body: some View {
        GeometryReader { geometry in
            let columns = geometry.size.width > 600 ? 3 : 2

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: columns),
                spacing: DSSpacing.md
            ) {
                ForEach(items) { item in
                    DSCard {
                        ItemContent(item: item)
                    }
                }
            }
        }
    }
}
```

---

## API Reference

### DSCard

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `style` | `CardStyle` | `.elevated` | Visual style |
| `padding` | `CardPadding` | `.medium` | Internal padding |
| `cornerRadius` | `CGFloat` | `12` | Corner radius |
| `content` | `ViewBuilder` | required | Card content |

### CardStyle

| Style | Background | Border | Shadow |
|-------|------------|--------|--------|
| `.elevated` | Surface | None | Yes |
| `.outlined` | Transparent | Yes | None |
| `.filled` | Secondary | None | None |
| `.ghost` | Transparent | None | None |

### DSImageCard

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `image` | `Image` | required | Featured image |
| `imagePosition` | `ImagePosition` | `.top` | Image placement |
| `aspectRatio` | `CGFloat?` | `nil` | Image aspect ratio |
| `title` | `String` | required | Card title |
| `subtitle` | `String?` | `nil` | Card subtitle |
| `footer` | `ViewBuilder?` | `nil` | Footer content |

### DSExpandableCard

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isExpanded` | `Binding<Bool>` | required | Expansion state |
| `header` | `ViewBuilder` | required | Always visible header |
| `preview` | `ViewBuilder?` | `nil` | Collapsed preview |
| `content` | `ViewBuilder` | required | Expanded content |
| `animationDuration` | `Double` | `0.3` | Animation duration |
