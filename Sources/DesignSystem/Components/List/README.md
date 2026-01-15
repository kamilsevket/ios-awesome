# List Components

A comprehensive collection of list and collection components for building data-driven interfaces in SwiftUI.

## Components

### DSList
A customizable list wrapper with enhanced styling options.

```swift
DSList(items) { item in
    ItemRow(item)
}
.separatorStyle(.singleLineInset)
.onDelete { indexSet in
    items.remove(atOffsets: indexSet)
}
.onMove { from, to in
    items.move(fromOffsets: from, toOffset: to)
}
.onRefresh {
    await loadData()
}
```

**Features:**
- Multiple list styles (plain, insetGrouped, grouped, sidebar)
- Separator customization
- Pull to refresh support
- Delete and move actions
- Edit mode integration

### DSSwipeActions
Swipe action modifiers for list rows.

```swift
ItemRow(item)
    .dsSwipeActions(
        leading: [
            .pin(isPinned: item.isPinned) { item.isPinned.toggle() },
            .markAsRead(isRead: item.isRead) { item.isRead.toggle() }
        ],
        trailing: [
            .delete { deleteItem(item) },
            .archive { archiveItem(item) }
        ]
    )
```

**Built-in Actions:**
- `.delete()` - Standard delete action
- `.archive()` - Archive action
- `.pin()` / `.unpin()` - Pin/unpin toggle
- `.share()` - Share action
- `.flag()` / `.unflag()` - Flag toggle
- `.markAsRead()` / `.markAsUnread()` - Read status toggle
- `.edit()` - Edit action

### DSReorderableList
A list with built-in drag-to-reorder support.

```swift
@State var items: [Item] = [...]

DSReorderableList($items) { item in
    ItemRow(item)
}
.handleStyle(.standard)
.onReorder { from, to in
    // Handle reorder callback
}
```

**Handle Styles:**
- `.none` - No visible handle
- `.standard` - System horizontal lines icon
- `.custom(Image)` - Custom handle icon

### DSSection
Section component with customizable headers and footers.

```swift
List {
    DSSection(header: "Account") {
        SettingsRow(title: "Profile")
        SettingsRow(title: "Privacy")
    }

    DSSection(
        header: "Notifications",
        footer: "Configure how you receive notifications"
    ) {
        NotificationSettings()
    }
    .collapsible()
}
```

**Header Styles:**
- `.plain` - Standard subheadline font
- `.prominent` - Bold headline font
- `.uppercase` - Uppercase caption text

### DSStickyHeader
Sticky section headers that remain visible during scroll.

```swift
DSStickyHeaderList(sections) { section in
    Text(section.title)
        .font(.headline)
} sectionContent: { section in
    ForEach(section.items) { item in
        ItemRow(item)
    }
}
.headerStyle(.blurred)
```

**Header Styles:**
- `.standard` - 95% opacity background
- `.blurred` - Blurred background effect
- `.solid` - Fully opaque background

### DSPaginatedList
List with infinite scroll/pagination support.

```swift
@State var items: [Item] = []
@State var state: DSPaginationState = .idle

DSPaginatedList(items, state: $state) { item in
    ItemRow(item)
} onLoadMore: {
    await loadNextPage()
}
.onRefresh {
    await refreshData()
}
.onRetry {
    state = .idle
}
```

**Pagination States:**
- `.idle` - Ready to load
- `.loading` - Currently loading
- `.loaded` - Data loaded, can load more
- `.error(String)` - Error occurred
- `.finished` - No more data

## Customization

### Separator Styles
```swift
DSList(items) { ... }
    .separatorStyle(.none)           // No separators
    .separatorStyle(.singleLine)     // Full-width line
    .separatorStyle(.singleLineInset) // Indented line
    .separatorColor(.gray)           // Custom color
```

### Background Colors
```swift
DSList(items) { ... }
    .backgroundColor(DSColors.backgroundSecondary)
```

## Accessibility

All list components include comprehensive accessibility support:
- VoiceOver labels and hints
- Reorder handle accessibility
- Loading state announcements
- Error message accessibility
- Header traits for section navigation

## Dark Mode

All components automatically adapt to light and dark mode using the design system color tokens.

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+

## Related Components

- [DSAvatar](../Avatar/README.md) - For list item avatars
- [DSSkeleton](../Loading/README.md) - For loading placeholders
- [DSBadge](../Badge/README.md) - For notification badges
