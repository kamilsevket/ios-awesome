# Grid Components

A comprehensive set of grid layout components for displaying collections of items in various grid configurations.

## Overview

The Grid Components module provides flexible, performant grid layouts for iOS applications. It includes pure SwiftUI implementations as well as a UICollectionView bridge for advanced use cases.

## Components

### DSGrid

The base grid component that wraps SwiftUI's `LazyVGrid` with design system styling.

```swift
// Fixed columns
DSGrid(items, columns: .fixed(3)) { item in
    GridItemView(item)
}

// Adaptive columns
DSGrid(items, columns: .adaptive(minimum: 150)) { item in
    GridItemView(item)
}

// Flexible columns
DSGrid(items, columns: .flexible(count: 4, minimumSize: 100)) { item in
    GridItemView(item)
}
```

### DSAdaptiveGrid

An adaptive grid that automatically adjusts columns based on available width.

```swift
DSAdaptiveGrid(items, minimumItemWidth: 150) { item in
    GridItemView(item)
}

// With maximum width constraint
DSAdaptiveGrid(items, minimumItemWidth: 150, maximumItemWidth: 300) { item in
    GridItemView(item)
}
```

### DSResponsiveGrid

A grid that uses different column counts for different size classes.

```swift
DSResponsiveGrid(
    items,
    compactColumns: 2,    // iPhone portrait
    regularColumns: 4     // iPad, iPhone landscape
) { item in
    GridItemView(item)
}
```

### DSMasonryGrid

A Pinterest-style masonry layout with varying item heights.

```swift
DSMasonryGrid(items, columns: 2) { item in
    MasonryItemView(item)
}

// With custom spacing
DSMasonryGrid(
    items,
    columns: 3,
    horizontalSpacing: 8,
    verticalSpacing: 16
) { item in
    MasonryItemView(item)
}
```

### DSWaterfallGrid

An enhanced masonry grid that dynamically balances columns based on item heights.

```swift
DSWaterfallGrid(items, columns: 2) { item in
    WaterfallItemView(item)
}
```

### DSScrollableGrid

A convenience wrapper that includes a ScrollView.

```swift
DSScrollableGrid(items, columns: .fixed(3)) { item in
    GridItemView(item)
}
```

### DSCollectionView (UIKit Bridge)

A SwiftUI wrapper for UICollectionView for advanced layouts and better performance with large datasets.

```swift
DSCollectionView(
    items: items,
    layout: .grid(columns: 3)
) { item in
    CollectionCell(item: item)
} onSelect: { item in
    // Handle selection
} onPrefetch: { items in
    // Prefetch data
}
```

## Selection Support

All grid components support item selection:

```swift
@State private var selection: Set<Item.ID> = []

// Single selection
DSGrid(
    items,
    columns: .fixed(3),
    selection: $selection,
    selectionMode: .single
) { item in
    GridItemView(item, isSelected: selection.contains(item.id))
}

// Multiple selection
DSGrid(
    items,
    columns: .fixed(3),
    selection: $selection,
    selectionMode: .multiple
) { item in
    GridItemView(item, isSelected: selection.contains(item.id))
}

// Multiple selection with maximum
DSGrid(
    items,
    columns: .fixed(3),
    selection: $selection,
    selectionMode: .multiple(max: 5)
) { item in
    GridItemView(item, isSelected: selection.contains(item.id))
}
```

## Column Configuration

### DSGridColumns

```swift
// Fixed number of columns
.fixed(3)

// Adaptive based on minimum width
.adaptive(minimum: 150)
.adaptive(minimum: 150, maximum: 300)

// Flexible with minimum size
.flexible(count: 4, minimumSize: 100)
```

## Spacing Configuration

### DSGridSpacing

```swift
// Uniform spacing
DSGridSpacing(uniform: 16)

// Custom horizontal/vertical
DSGridSpacing(horizontal: 8, vertical: 16)

// Presets
.none  // 0pt
.xs    // 4pt
.sm    // 8pt (default)
.md    // 16pt
.lg    // 24pt
```

## UICollectionView Layouts

The `DSCollectionLayout` enum provides various layout options:

```swift
// Standard grid
.grid(columns: 3, spacing: 8)

// Adaptive grid
.adaptive(minItemWidth: 150, spacing: 8)

// List layout
.list(rowHeight: 60, spacing: 4)

// Waterfall/masonry
.waterfall(columns: 2, spacing: 8)
```

## Best Practices

1. **Choose the right grid type:**
   - Use `DSGrid` for simple, fixed layouts
   - Use `DSAdaptiveGrid` for responsive layouts
   - Use `DSMasonryGrid` for Pinterest-style layouts
   - Use `DSCollectionView` for large datasets or complex layouts

2. **Performance:**
   - All grids use lazy loading by default
   - For very large datasets, prefer `DSCollectionView` with prefetching
   - Use appropriate item sizes to minimize layout recalculations

3. **Selection:**
   - Provide visual feedback for selected items
   - Consider accessibility when implementing selection

4. **Accessibility:**
   - Grid items automatically include selection traits
   - Add meaningful accessibility labels to grid items

## Dark Mode Support

All grid components automatically support dark mode through the design system color tokens. Use `DSColors` for consistent theming.

## Requirements

- iOS 15.0+
- Swift 5.9+
