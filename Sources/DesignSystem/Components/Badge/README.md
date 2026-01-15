# Badge & Tag Components

Notification ve labeling için badge/tag component seti.

## Components

### DSBadge
Sayı gösteren notification badge.

```swift
// Basic usage
DSBadge(count: 5)

// With custom max count (shows "49+" for counts > 49)
DSBadge(count: 100, maxCount: 49)

// Show badge even when count is 0
DSBadge(count: 0, showZero: true)

// Size variants
DSBadge(count: 3, size: .sm)  // Small
DSBadge(count: 3, size: .md)  // Medium (default)
```

**Features:**
- 99+ gösterimi (configurable)
- Animasyonlu count update
- Accessibility support

### DSStatusBadge
Durum göstergesi (dot + optional text).

```swift
// Dot only
DSStatusBadge(.online)

// With text
DSStatusBadge(.online, text: "Active")
DSStatusBadge(.busy, text: "Do Not Disturb")

// Size variants
DSStatusBadge(.away, size: .sm)

// Without pulse animation
DSStatusBadge(.online, showPulse: false)
```

**Status Types:**
- `.online` - Yeşil, pulse animasyonlu
- `.offline` - Gri
- `.busy` - Kırmızı
- `.away` - Sarı

### DSTag
Etiket/label görünümü.

```swift
// Basic tag
DSTag("Swift")

// With icon
DSTag("Apple", icon: Image(systemName: "apple.logo"))

// Color variants
DSTag("Success", variant: .success)
DSTag("Warning", variant: .warning)
DSTag("Error", variant: .error)

// Dismissible
DSTag("Remove me") {
    // Handle dismiss
}

// Size variants
DSTag("Small", size: .sm)
```

**Variants:** `.default`, `.primary`, `.success`, `.warning`, `.error`, `.info`

### DSFilterChip
Single-selection filtreleme için chip.

```swift
@State private var isSelected = false

DSFilterChip("All", isSelected: $isSelected)

// With icon
DSFilterChip("Recent", icon: Image(systemName: "clock"), isSelected: $isSelected)

// Size variants
DSFilterChip("Small", size: .sm, isSelected: $isSelected)
```

### DSSelectableChip
Multi-selection için chip.

```swift
@State private var isSelected = false

DSSelectableChip("Swift", isSelected: $isSelected)

// With icon
DSSelectableChip("Photos", icon: Image(systemName: "photo"), isSelected: $isSelected)

// With dismiss button
DSSelectableChip("Removable", isSelected: $isSelected) {
    // Handle dismiss
}
```

**Multi-select Group:**
```swift
@State private var selection: Set<String> = []

DSSelectableChipGroup(
    items: ["Swift", "Kotlin", "Rust"],
    labelKeyPath: \.self,
    selection: $selection
)
```

## View Modifiers

### Badge Overlay
```swift
// Notification badge on icon
Image(systemName: "bell.fill")
    .badgeOverlay(count: 5)

// Custom alignment
Image(systemName: "cart.fill")
    .badgeOverlay(count: 3, alignment: .topLeading)

// Status badge on avatar
Circle()
    .statusBadgeOverlay(.online)
```

## Accessibility

Tüm component'ler accessibility desteği içerir:
- VoiceOver labels
- Accessibility traits (button, selected state)
- Dynamic type support

## Design Tokens

### Colors
- `DSColors.badgeRed` - Badge background
- `DSColors.statusOnline/Offline/Busy/Away` - Status colors
- `DSColors.chipBackground` - Chip background
- `DSColors.primary/success/warning/error/info` - Semantic colors

### Spacing
- `DSSpacing.minTouchTarget` - 44pt (Apple HIG)
- Size variants: `.sm`, `.md`

## Dark Mode

Tüm component'ler dark mode desteği içerir:
- Automatic color adaptation
- Environment-aware backgrounds
