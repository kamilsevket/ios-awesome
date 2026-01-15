# Dropdown & Select Components

This module provides dropdown and select components for form inputs with support for single selection, multi-selection, and searchable options.

## Components

### DSDropdownMenu

A dropdown menu component that displays a list of actions.

```swift
DSDropdownMenu(
    items: [
        DSDropdownMenuItem(title: "Edit", icon: Image(systemName: "pencil")),
        DSDropdownMenuItem(title: "Delete", icon: Image(systemName: "trash"), isDestructive: true)
    ],
    onSelect: { item in
        print("Selected: \(item.title)")
    }
) {
    Image(systemName: "ellipsis")
}
```

#### Features
- Supports icons, subtitles, and destructive actions
- Disabled state for individual items
- Uses native SwiftUI Menu for proper system behavior
- Accessible with VoiceOver support

### DSSelect

A form select input for single selection.

```swift
@State private var selectedCountry: String?

DSSelect(selection: $selectedCountry, options: ["USA", "Canada", "Mexico"])
    .placeholder("Select country")
    .label("Country")
    .helperText("Select your country of residence")
```

#### Features
- Multiple style variants (standard, outlined, filled)
- Placeholder text
- Label and helper text
- Error state with message
- Clear button
- Leading icon support
- Custom option types via `DSSelectOption` protocol

### DSMultiSelect

A multi-select component with chip display.

```swift
@State private var selectedTags: Set<String> = []

DSMultiSelect(selections: $selectedTags, options: ["Swift", "iOS", "SwiftUI"])
    .searchable()
    .placeholder("Select tags")
    .label("Tags")
```

#### Features
- Multiple selection with chip display
- Search/filter functionality
- Checkbox indicators
- Clear all button
- Configurable max displayed chips
- Error state support

### DSSearchableDropdown

A searchable dropdown with custom item rendering.

```swift
@State private var selectedUser: User?

DSSearchableDropdown(
    selection: $selectedUser,
    options: users
) { user in
    HStack {
        Image(systemName: "person.circle")
        VStack(alignment: .leading) {
            Text(user.name)
            Text(user.email).font(.caption)
        }
    }
}
.placeholder("Search users...")
.label("Assign To")
```

#### Features
- Real-time search filtering
- Custom item rendering
- Empty state message
- Keyboard navigation support
- Selection indicator

## Protocols

### DSSelectOption

Implement this protocol for custom option types:

```swift
struct Country: DSSelectOption {
    let id: String
    let displayText: String
    let code: String

    init(name: String, code: String) {
        self.id = code
        self.displayText = name
        self.code = code
    }
}
```

## Accessibility

All components include:
- VoiceOver labels and hints
- Selection state announcements
- Keyboard navigation support
- Proper focus management

## Dark Mode

All components automatically adapt to light and dark color schemes using the design system color tokens.

## Style Variants

### DSSelect Styles
- `.standard` - Underline style
- `.outlined` - Border style (default)
- `.filled` - Background fill style

## Modifiers

Common modifiers available on select components:
- `.placeholder(_:)` - Set placeholder text
- `.label(_:)` - Set field label
- `.helperText(_:)` - Set helper text
- `.errorMessage(_:)` - Set error message
- `.disabled(_:)` - Disable the component
- `.searchable()` - Enable search (DSMultiSelect)
- `.leadingIcon(_:)` - Add leading icon (DSSelect)
