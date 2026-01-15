# Slider Components

This module provides customizable slider components for selecting single values or ranges.

## Components

### DSSlider

A single-value slider for selecting a value within a range.

```swift
// Basic usage
DSSlider(value: $volume, range: 0...100)

// With step increments
DSSlider(value: $brightness, range: 0...100)
    .step(10)
    .showValueLabel()

// Fully customized
DSSlider(value: $temperature, range: 16...30)
    .size(.large)
    .style(.gradient)
    .tintColor(.orange)
    .step(0.5)
    .showValueLabel()
    .valueLabelFormat { "\($0)°C" }
    .showTicks()
    .showMinMaxLabels()
    .hapticFeedback(true)
```

### DSRangeSlider

A dual-thumb slider for selecting a min-max range.

```swift
// Basic usage
DSRangeSlider(range: $priceRange, bounds: 0...1000)

// Price filter example
DSRangeSlider(range: $priceRange, bounds: 0...1000)
    .step(50)
    .showValueLabels()
    .showBoundsLabels()
    .valueLabelFormat { "$\(Int($0))" }
    .minDistance(100)

// With all features
DSRangeSlider(range: $ageRange, bounds: 18...100)
    .size(.medium)
    .tintColor(.purple)
    .showValueLabels()
    .showTicks()
    .step(5)
    .minDistance(10)
    .hapticFeedback(true)
```

## Size Variants

Both sliders support three size variants:

| Size | Track Height | Thumb Size | Tick Size |
|------|-------------|------------|-----------|
| `.small` | 2pt | 16pt | 4pt |
| `.medium` | 4pt | 24pt | 6pt |
| `.large` | 6pt | 32pt | 8pt |

## Style Variants

- `.standard` - Simple filled track
- `.filled` - Solid fill color
- `.gradient` - Gradient fill (customizable colors)

## Thumb Styles

Pre-defined thumb styles:

```swift
.thumbStyle(.default)   // White with shadow
.thumbStyle(.bordered)  // White with primary border
.thumbStyle(.minimal)   // Smaller, no shadow
```

Custom thumb style:

```swift
.thumbStyle(DSSliderThumbStyle(
    size: 28,
    color: .white,
    borderColor: .blue,
    borderWidth: 2,
    shadowRadius: 4,
    shape: .circle  // or .roundedSquare or .custom(AnyShape)
))
```

## Features

### Value Labels
```swift
.showValueLabel()                          // Shows value above slider
.valueLabelFormat { "\(Int($0))%" }        // Custom format
```

### Step Increments
```swift
.step(10)           // Snaps to increments of 10
.showTicks()        // Shows tick marks at each step
```

### Min/Max Labels
```swift
.showMinMaxLabels()                        // Shows range bounds
.minLabel("Silent")                        // Custom min label
.maxLabel("Loud")                          // Custom max label
```

### Haptic Feedback
```swift
.hapticFeedback(true)   // Enabled by default on iOS
```

Provides tactile feedback when:
- Crossing step boundaries (when step is set)
- Moving significant distances (when no step is set)

### Range Slider Minimum Distance
```swift
.minDistance(20)    // Thumbs cannot be closer than 20 units
```

## Accessibility

Both components include full accessibility support:

- VoiceOver labels and values
- Adjustable trait for DSSlider
- Proper value announcements

## Dark Mode

Both components automatically adapt to dark mode using the design system color tokens.

## Callbacks

```swift
// DSSlider
.onValueChanged { newValue in
    print("Value changed to: \(newValue)")
}

// DSRangeSlider
.onRangeChanged { newRange in
    print("Range changed to: \(newRange.lowerBound) - \(newRange.upperBound)")
}
```

## Type Support

DSSlider supports multiple numeric types:

```swift
// Double (default)
DSSlider(value: $doubleValue, range: 0.0...1.0)

// Int
DSSlider(value: $intValue, range: 0...100)

// Float
DSSlider(value: $floatValue, range: 0.0...1.0)
```

DSRangeSlider supports:

```swift
// Double
DSRangeSlider(range: $doubleRange, bounds: 0.0...100.0)

// Int
DSRangeSlider(range: $intRange, bounds: 0...100)
```
