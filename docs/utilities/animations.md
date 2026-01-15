# Animation Utilities

DesignSystem provides animation presets and utilities for consistent, smooth animations.

## Overview

The animation system includes:
- Pre-built animation presets
- Transition utilities
- Keyframe animations
- Lottie integration

## Animation Presets

### Duration Presets

```swift
// Fast animations (UI feedback)
DSAnimation.durationFast     // 0.15s

// Default animations (most transitions)
DSAnimation.durationDefault  // 0.3s

// Slow animations (emphasis)
DSAnimation.durationSlow     // 0.5s
```

### Easing Curves

```swift
// Standard easing (most animations)
DSAnimation.easeDefault      // easeInOut

// Enter animations
DSAnimation.easeIn           // easeIn

// Exit animations
DSAnimation.easeOut          // easeOut

// Spring animations
DSAnimation.spring           // spring with damping
```

## Using Animations

### Basic Usage

```swift
withAnimation(DSAnimation.default) {
    isExpanded.toggle()
}
```

### On State Changes

```swift
@State private var isVisible = false

content
    .opacity(isVisible ? 1 : 0)
    .animation(DSAnimation.default, value: isVisible)
```

### Spring Animations

```swift
withAnimation(DSAnimation.spring) {
    scale = 1.2
}
```

## Transition Presets

### Fade

```swift
if isVisible {
    content
        .transition(.dsOpacity)
}
```

### Slide

```swift
if isVisible {
    content
        .transition(.dsSlide)
}

// Direction variants
.transition(.dsSlideFromBottom)
.transition(.dsSlideFromTop)
.transition(.dsSlideFromLeading)
.transition(.dsSlideFromTrailing)
```

### Scale

```swift
if isVisible {
    content
        .transition(.dsScale)
}
```

### Combined

```swift
if isVisible {
    content
        .transition(.dsFadeScale)  // Opacity + scale
}
```

## View Modifiers

### Fade In

```swift
content
    .dsFadeIn()  // Appears with fade animation

// With delay
content
    .dsFadeIn(delay: 0.2)
```

### Slide In

```swift
content
    .dsSlideIn(from: .bottom)

// With animation customization
content
    .dsSlideIn(from: .leading, animation: DSAnimation.spring)
```

### Bounce

```swift
DSButton("Tap") { }
    .dsBounce(on: buttonPressed)
```

### Pulse

```swift
Image(systemName: "heart.fill")
    .dsPulse()
```

### Shake

```swift
DSTextField("Email", text: $email)
    .dsShake(on: hasError)
```

## Keyframe Animations

### Basic Keyframes

```swift
content
    .keyframeAnimation(
        KeyframeTrack(\.opacity) {
            LinearKeyframe(1.0, duration: 0.2)
            LinearKeyframe(0.5, duration: 0.1)
            LinearKeyframe(1.0, duration: 0.2)
        }
    )
```

### Complex Sequences

```swift
content
    .keyframeAnimation(
        KeyframeTrack(\.scale) {
            SpringKeyframe(1.2, duration: 0.15)
            SpringKeyframe(1.0, duration: 0.3)
        },
        KeyframeTrack(\.rotation) {
            LinearKeyframe(.degrees(10), duration: 0.1)
            LinearKeyframe(.degrees(-10), duration: 0.1)
            LinearKeyframe(.zero, duration: 0.2)
        }
    )
```

## Lottie Animations

### Basic Usage

```swift
DSLottieView(name: "loading-animation")
```

### With Controls

```swift
DSLottieView(
    name: "success-animation",
    loopMode: .playOnce,
    autoPlay: true
)

// Manual control
@State private var playAnimation = false

DSLottieView(
    name: "celebration",
    loopMode: .loop,
    play: $playAnimation
)
```

### Progress-based

```swift
DSLottieView(
    name: "progress-animation",
    progress: downloadProgress
)
```

## Animation Helpers

### Delayed Execution

```swift
withAnimation(DSAnimation.default.delay(0.2)) {
    showContent = true
}
```

### Staggered Animations

```swift
ForEach(items.indices, id: \.self) { index in
    ItemView(item: items[index])
        .dsFadeIn(delay: Double(index) * 0.1)
}
```

### Chained Animations

```swift
func animateSequence() {
    withAnimation(DSAnimation.default) {
        step1 = true
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        withAnimation(DSAnimation.default) {
            step2 = true
        }
    }
}
```

## Performance Tips

### Use Explicit Animations

```swift
// Good - explicit animation
.animation(DSAnimation.default, value: isExpanded)

// Avoid - implicit animation on all changes
.animation(DSAnimation.default)
```

### Reduce Motion

Respect user preferences:

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

withAnimation(reduceMotion ? nil : DSAnimation.default) {
    isExpanded.toggle()
}
```

### Animation Completion

```swift
withAnimation(DSAnimation.default) {
    isAnimating = true
}

DispatchQueue.main.asyncAfter(deadline: .now() + DSAnimation.durationDefault) {
    // Animation complete
    isAnimating = false
}
```

## Best Practices

1. **Use presets** for consistency
2. **Respect reduce motion** settings
3. **Keep animations short** - under 500ms
4. **Use spring animations** for natural feel
5. **Avoid animating layout** when possible
6. **Test on device** - simulators may differ
