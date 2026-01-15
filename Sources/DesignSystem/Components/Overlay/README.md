# Overlay Components

Popover, tooltip, context menu, and action sheet components for the Design System.

## Components

### DSPopover

A styled popover component with arrow positioning.

```swift
// Basic usage
Button("Show Popover") {
    showPopover = true
}
.dsPopover(isPresented: $showPopover, edge: .bottom) {
    VStack {
        Text("Popover Title")
            .font(.headline)
        Text("Some content here")
            .font(.subheadline)
    }
}

// With custom style
.dsPopover(isPresented: $show, edge: .top, style: .menu) {
    // Menu-style popover content
}
```

**Features:**
- Arrow positioning (top, bottom, leading, trailing)
- Auto-dismiss on tap outside
- Configurable styles (default, compact, menu)
- Spring animations
- Dark mode support
- Accessibility support

### DSTooltip

Information tooltip with configurable delay and auto-dismiss.

```swift
// Automatic tooltip (shows on hover/long-press)
Button("Help") { }
    .dsTooltip("Click here for more information")

// With custom delay and duration
Image(systemName: "questionmark.circle")
    .dsTooltip(
        "Additional help text",
        edge: .bottom,
        delay: 0.5,
        duration: 3.0
    )

// Manual control
.dsTooltip(isPresented: $showTooltip, "Tooltip text")

// Different styles
.dsTooltip("Info message", style: .info)
.dsTooltip("Warning message", style: .warning)
.dsTooltip("Error message", style: .error)
```

**Features:**
- Configurable show delay
- Auto-dismiss after duration
- Multiple edge positions
- Style variants (default, info, warning, error)
- Accessibility support

### DSContextMenu

Styled context menu wrapper with menu items.

```swift
// Basic context menu
Image("photo")
    .dsContextMenu {
        DSMenuItem("Edit", systemImage: "pencil") {
            // Edit action
        }
        DSMenuItem("Share", systemImage: "square.and.arrow.up") {
            // Share action
        }
        Divider()
        DSMenuItem("Delete", systemImage: "trash", role: .destructive) {
            // Delete action
        }
    }

// With sections
.dsContextMenu {
    DSMenuSection(header: "Actions") {
        DSMenuItem("Edit", systemImage: "pencil") { }
        DSMenuItem("Move", systemImage: "folder") { }
    }
    DSMenuSection {
        DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
    }
}

// With custom preview
.dsContextMenu {
    DSMenuItem("Edit", systemImage: "pencil") { }
} preview: {
    Image("photo")
        .resizable()
        .frame(width: 300, height: 300)
}

// Menu button (shows on tap, not long press)
DSContextMenuButton {
    DSMenuItem("Option 1") { }
    DSMenuItem("Option 2") { }
} label: {
    Image(systemName: "ellipsis.circle")
}
```

**Features:**
- Native context menu feel
- Menu items with icons and roles
- Sections with headers
- Custom preview support
- DSContextMenuButton for tap-to-show menus

### DSActionSheet

Custom action sheet with rich styling options.

```swift
// Basic action sheet
.dsActionSheet(
    isPresented: $showSheet,
    title: "Photo Options",
    message: "Choose what to do with this photo",
    actions: [
        .default("Save to Photos", systemImage: "square.and.arrow.down") {
            savePhoto()
        },
        .default("Share", systemImage: "square.and.arrow.up") {
            sharePhoto()
        },
        .destructive("Delete", systemImage: "trash") {
            deletePhoto()
        }
    ]
)

// Without header
.dsActionSheet(
    isPresented: $show,
    actions: [
        .default("Edit", systemImage: "pencil") { },
        .destructive("Delete", systemImage: "trash") { }
    ]
)

// Custom cancel action
.dsActionSheet(
    isPresented: $show,
    actions: [...],
    cancelAction: .cancel("Dismiss") {
        // Custom cancel action
    }
)
```

**Features:**
- Title and message header
- Actions with icons
- Destructive action styling
- Drag to dismiss
- Custom cancel action
- Dark mode support
- Accessibility support

## Styles

### DSPopoverStyle

| Style | Description |
|-------|-------------|
| `.default` | Standard popover with medium shadow |
| `.compact` | Smaller padding and corner radius |
| `.menu` | Menu-style with secondary background |

### DSTooltipStyle

| Style | Description |
|-------|-------------|
| `.default` | Dark background, light text |
| `.info` | Blue background |
| `.warning` | Yellow background |
| `.error` | Red background |

### DSActionSheetStyle

| Style | Description |
|-------|-------------|
| `.default` | Standard with drag indicator |
| `.compact` | Smaller buttons, no drag indicator |

## Accessibility

All overlay components support accessibility:

- **VoiceOver**: Proper labels and hints
- **Dynamic Type**: Text scales appropriately
- **Reduce Motion**: Respects system settings
- **Modal Traits**: Components marked as modal when appropriate

## Dark Mode

All components automatically adapt to light and dark mode using semantic colors.
