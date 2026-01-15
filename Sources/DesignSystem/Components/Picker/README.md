# Picker Components

A comprehensive set of picker components for date, time, and custom value selection.

## Components

### DSDatePicker

A styled wrapper around SwiftUI's DatePicker for date selection.

```swift
// Basic usage
DSDatePicker(selection: $date)

// With label and options
DSDatePicker("Birth Date", selection: $birthDate)
    .displayMode(.inline)
    .minimumDate(.now)
    .maximumDate(Calendar.current.date(byAdding: .year, value: 1, to: .now)!)
    .pickerVariant(.outlined)
```

**Display Modes:**
- `.compact` - Single-line compact display
- `.inline` / `.graphical` - Full calendar view
- `.wheel` - iOS wheel style

### DSTimePicker

A styled wrapper for time-only selection.

```swift
// Basic usage
DSTimePicker(selection: $time)

// With options
DSTimePicker("Meeting Time", selection: $meetingTime)
    .displayMode(.wheel)
    .minuteInterval(15)
    .pickerVariant(.filled)
```

### DSDateTimePicker

Combined date and time picker.

```swift
// Basic usage
DSDateTimePicker(selection: $dateTime)

// Stacked layout
DSDateTimePicker("Appointment", selection: $appointment)
    .displayMode(.stacked)
    .minimumDate(.now)
    .pickerVariant(.outlined)
```

**Display Modes:**
- `.compact` - Compact inline display
- `.inline` - Full graphical display
- `.stacked` - Vertical date/time layout
- `.sideBySide` - Horizontal date/time layout

### DSCustomPicker

Generic picker for custom item selection.

```swift
struct Option: Hashable, Identifiable {
    let id: String
    let name: String
}

let options = [
    Option(id: "1", name: "Option 1"),
    Option(id: "2", name: "Option 2"),
]

// Menu style
DSCustomPicker("Select", selection: $selected, items: options) { item in
    Text(item.name)
}
.displayMode(.menu)
.pickerVariant(.outlined)

// Inline list style
DSCustomPicker("Select", selection: $selected, items: options) { item in
    HStack {
        Image(systemName: "star")
        Text(item.name)
    }
}
.displayMode(.inline)

// Segmented style
DSCustomPicker(selection: $selected, items: options) { item in
    Text(item.name)
}
.displayMode(.segmented)
```

### DSWheelPicker

iOS-style wheel picker for scrollable selection.

```swift
// Single wheel
DSWheelPicker("Select Number", selection: $number, items: Array(1...100)) { num in
    Text("\(num)")
}
.pickerVariant(.outlined)

// Multi-column wheel (e.g., for time)
DSMultiWheelPicker(
    "Select Time",
    selections: [$hour, $minute],
    columns: [Array(0...23), Array(0...59)]
) { column, value in
    Text(String(format: "%02d", value))
}
.pickerVariant(.filled)
```

## Styling

### Size Variants

All pickers support size variants:

```swift
.pickerSize(.small)   // Compact
.pickerSize(.medium)  // Default
.pickerSize(.large)   // Larger touch targets
```

### Visual Variants

```swift
.pickerVariant(.default)   // No border/background
.pickerVariant(.outlined)  // Border
.pickerVariant(.filled)    // Background fill
```

## Date Formatting

Use `DSDateFormatters` for consistent date formatting:

```swift
// Pre-configured formatters
let dateString = DSDateFormatters.shortDate.string(from: date)
let timeString = DSDateFormatters.shortTime.string(from: date)
let dateTimeString = DSDateFormatters.mediumDateTime.string(from: date)

// Custom formats
let custom = DSDateFormatters.custom(format: "EEEE, MMM d").string(from: date)

// Localized templates
let localized = DSDateFormatters.localized(template: DSDateTemplate.monthDay).string(from: date)

// Date extensions
date.formatted(with: DSDateFormatters.longDate)
date.formatted(format: "yyyy-MM-dd")
date.relativeFormatted() // "2 days ago"
```

### Common Templates

```swift
DSDateTemplate.monthDay         // "January 1"
DSDateTemplate.monthDayYear     // "January 1, 2024"
DSDateTemplate.dayOfWeek        // "Monday"
DSDateTemplate.hourMinute       // "1:30 PM"
DSDateTemplate.yearMonth        // "January 2024"
```

## Date Validation

```swift
// Range checking
date.isWithin(start: startDate, end: endDate)
date.isBefore(otherDate)
date.isAfter(otherDate)

// Convenience properties
date.isToday
date.isYesterday
date.isTomorrow
date.isPast
date.isFuture
```

## Accessibility

All picker components include:
- VoiceOver labels and hints
- Proper accessibility traits
- Disabled state announcements

## Localization

All pickers support localization:

```swift
DSDatePicker(selection: $date)
    .locale(Locale(identifier: "tr_TR"))
    .calendar(Calendar(identifier: .gregorian))
```

## Dark Mode

All components automatically adapt to light/dark mode with appropriate colors and contrasts.
