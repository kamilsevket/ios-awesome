# Gesture Utilities

DesignSystem provides gesture utilities for common interaction patterns.

## Overview

The GestureUtilities module includes:
- Swipe gestures
- Long press handling
- Pan gestures
- Pinch/zoom gestures

## Import

```swift
import GestureUtilities

// Or with main library
import DesignSystem
```

## Swipe Gestures

### Basic Swipe

```swift
content
    .onSwipe(.left) {
        handleLeftSwipe()
    }
```

### All Directions

```swift
content
    .onSwipe(.left) { handleLeft() }
    .onSwipe(.right) { handleRight() }
    .onSwipe(.up) { handleUp() }
    .onSwipe(.down) { handleDown() }
```

### With Velocity

```swift
content
    .onSwipe(.left, minimumDistance: 50) { velocity in
        // velocity.width, velocity.height
        handleSwipe(velocity: velocity)
    }
```

## Long Press

### Basic Long Press

```swift
content
    .onLongPress {
        showContextMenu()
    }
```

### Custom Duration

```swift
content
    .onLongPress(minimumDuration: 0.5) {
        showQuickActions()
    }
```

### With Preview

```swift
@State private var isPressing = false

content
    .scaleEffect(isPressing ? 0.95 : 1.0)
    .onLongPress(
        pressing: { isPressing = $0 },
        perform: {
            showMenu()
        }
    )
```

## Pan Gestures

### Draggable

```swift
@State private var offset = CGSize.zero

content
    .offset(offset)
    .onPan { translation in
        offset = translation
    } onEnded: { velocity in
        // Snap back or apply velocity
        withAnimation(.spring()) {
            offset = .zero
        }
    }
```

### Constrained Dragging

```swift
content
    .onPan(
        axis: .horizontal,  // Restrict to horizontal
        bounds: -100...100   // Limit range
    ) { offset in
        horizontalOffset = offset
    }
```

## Pinch & Zoom

### Basic Zoom

```swift
@State private var scale: CGFloat = 1.0

Image("photo")
    .scaleEffect(scale)
    .onPinch { newScale in
        scale = newScale
    }
```

### With Limits

```swift
Image("photo")
    .scaleEffect(scale)
    .onPinch(
        minScale: 1.0,
        maxScale: 4.0
    ) { newScale in
        scale = newScale
    }
```

### Combined Pan & Zoom

```swift
@State private var scale: CGFloat = 1.0
@State private var offset = CGSize.zero

Image("photo")
    .scaleEffect(scale)
    .offset(offset)
    .onPinchAndPan(
        scale: $scale,
        offset: $offset
    )
```

## Gesture Modifiers

### Tap with Count

```swift
// Double tap
content
    .onTapGesture(count: 2) {
        toggleZoom()
    }

// Triple tap
content
    .onTapGesture(count: 3) {
        resetView()
    }
```

### Exclusive Gestures

```swift
content
    .gesture(
        TapGesture()
            .onEnded { handleTap() }
            .exclusively(before:
                LongPressGesture()
                    .onEnded { _ in handleLongPress() }
            )
    )
```

### Simultaneous Gestures

```swift
content
    .gesture(
        DragGesture()
            .simultaneously(with: RotationGesture())
            .onChanged { value in
                // Handle both gestures
            }
    )
```

## Haptic Feedback

### Impact Feedback

```swift
content
    .onTapGesture {
        DSHaptics.impact(.light)
        handleTap()
    }

// Intensity levels
DSHaptics.impact(.light)
DSHaptics.impact(.medium)
DSHaptics.impact(.heavy)
```

### Selection Feedback

```swift
content
    .onChange(of: selectedIndex) { _ in
        DSHaptics.selection()
    }
```

### Notification Feedback

```swift
// Success
DSHaptics.notification(.success)

// Warning
DSHaptics.notification(.warning)

// Error
DSHaptics.notification(.error)
```

## Common Patterns

### Swipe to Delete

```swift
struct SwipeToDeleteRow: View {
    @State private var offset: CGFloat = 0
    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .trailing) {
            // Delete background
            Color.red
                .overlay(
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding(.trailing, 20),
                    alignment: .trailing
                )

            // Content
            content
                .offset(x: offset)
                .onPan(axis: .horizontal) { translation in
                    offset = min(0, translation.width)
                } onEnded: { velocity in
                    if offset < -100 || velocity.width < -500 {
                        onDelete()
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }
        }
    }
}
```

### Pull to Refresh

```swift
ScrollView {
    content
}
.onPullToRefresh {
    await refreshData()
}
```

### Dismiss with Drag

```swift
@State private var dragOffset: CGFloat = 0
@Environment(\.dismiss) var dismiss

VStack {
    sheetContent
}
.offset(y: dragOffset)
.onPan(axis: .vertical) { translation in
    dragOffset = max(0, translation.height)
} onEnded: { velocity in
    if dragOffset > 150 || velocity.height > 500 {
        dismiss()
    } else {
        withAnimation(.spring()) {
            dragOffset = 0
        }
    }
}
```

## Accessibility

### Gesture Alternatives

Provide button alternatives for gestures:

```swift
content
    .onSwipe(.left) { deleteItem() }
    .accessibilityAction(.delete) { deleteItem() }
```

### Custom Actions

```swift
content
    .onLongPress { showMenu() }
    .accessibilityAction(named: "Show menu") {
        showMenu()
    }
```

## Best Practices

1. **Provide visual feedback** during gestures
2. **Use appropriate thresholds** for gesture recognition
3. **Include haptic feedback** for confirmations
4. **Support accessibility** with alternative actions
5. **Test on device** - gestures feel different than in simulator
