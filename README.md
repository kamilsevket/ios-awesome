# DesignSystem

A comprehensive, modular design system for iOS/iPadOS/macOS/tvOS/watchOS built with SwiftUI.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%2015%20%7C%20macOS%2012%20%7C%20tvOS%2015%20%7C%20watchOS%208-blue.svg)](https://developer.apple.com)
[![SPM](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)

## Overview

DesignSystem provides a complete set of UI components, design tokens, and utilities for building consistent, accessible, and beautiful applications across all Apple platforms.

### Key Features

- **Foundation Tokens** - Colors, typography, spacing, shadows, and icons
- **50+ UI Components** - Buttons, cards, forms, navigation, overlays, and more
- **Full Accessibility** - VoiceOver, Dynamic Type, and accessibility traits
- **Dark Mode** - Automatic light/dark mode support
- **Multi-Platform** - iOS, macOS, tvOS, and watchOS support
- **Modular Architecture** - Import only what you need

## Quick Start

### Installation

Add DesignSystem to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/kamilsevket/ios-awesome.git", from: "1.0.0")
]
```

### Basic Usage

```swift
import DesignSystem

struct ContentView: View {
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSButton("Get Started", style: .primary) {
                // Action
            }

            DSTextField(
                "Email",
                text: $email,
                type: .email
            )

            DSCard {
                Text("Welcome to DesignSystem")
            }
        }
        .padding(DSSpacing.lg)
    }
}
```

## Available Libraries

| Library | Description |
|---------|-------------|
| `DesignSystem` | Core components and utilities |
| `FoundationColor` | Color system with semantic colors |
| `DesignSystemTypography` | Typography scales and fonts |
| `FoundationIcons` | Icon system and assets |
| `GestureUtilities` | Gesture recognizers and handlers |

## Component Categories

### Foundation
- [Color System](docs/foundation/colors.md) - Primary, secondary, semantic colors
- [Typography](docs/foundation/typography.md) - Font scales and text styles
- [Spacing](docs/foundation/spacing.md) - Consistent spacing tokens
- [Shadows](docs/foundation/shadows.md) - Elevation and depth
- [Icons](docs/foundation/icons.md) - SF Symbols and custom icons

### Basic Components
- [Buttons](docs/components/buttons.md) - DSButton, DSIconButton, DSFloatingActionButton
- [Text Fields](docs/components/textfields.md) - DSTextField with validation
- [Cards](docs/components/cards.md) - DSCard, DSImageCard, DSExpandableCard
- [Badges & Tags](Sources/DesignSystem/Components/Badge/README.md) - DSBadge, DSTag, DSFilterChip
- [Avatars](docs/components/avatars.md) - DSAvatar, DSAvatarGroup

### Navigation
- [Tab Bar](docs/components/tabbar.md) - DSTabBar, DSScrollableTabBar
- [Navigation Bar](docs/components/navbar.md) - DSNavigationBar with search
- [Segmented Control](docs/components/segmented.md) - DSSegmentedControl

### Forms
- [Selection Controls](Sources/DesignSystem/Components/Selection/README.md) - Checkbox, Radio, Switch, Toggle
- [Sliders](Sources/DesignSystem/Components/Slider/README.md) - DSSlider, DSRangeSlider
- [Pickers](Sources/DesignSystem/Components/Picker/README.md) - Date, Time, Custom pickers
- [Dropdowns](Sources/DesignSystem/Components/Dropdown/README.md) - DSSelect, DSSearchableDropdown

### Feedback
- [Alerts & Dialogs](Sources/DesignSystem/Components/Alerts/README.md) - DSAlert, DSConfirmationDialog
- [Toast & Snackbar](Sources/DesignSystem/Components/Feedback/README.md) - DSToast, DSSnackbar
- [Loading](docs/components/loading.md) - Progress indicators, skeletons
- [Empty States](docs/components/empty-states.md) - DSEmptyState

### Data Display
- [Lists](Sources/DesignSystem/Components/List/README.md) - DSList with swipe actions
- [Grids](Sources/DesignSystem/Components/Grid/README.md) - DSGrid, DSMasonryGrid
- [Carousel](docs/components/carousel.md) - DSCarousel, DSPageView

### Overlays
- [Modals & Sheets](Sources/DesignSystem/Components/Overlay/README.md) - DSBottomSheet, DSActionSheet
- [Popovers & Tooltips](docs/components/popovers.md) - DSPopover, DSTooltip

### Utilities
- [Animations](docs/utilities/animations.md) - Presets and custom animations
- [Gestures](docs/utilities/gestures.md) - Swipe, long press, pan
- [Accessibility](Sources/DesignSystem/Utilities/Accessibility/README.md) - VoiceOver, Dynamic Type

## Documentation

- [Getting Started](docs/getting-started.md)
- [Installation Guide](docs/installation.md)
- [Best Practices](docs/best-practices.md)
- [Migration Guide](docs/migration.md)
- [API Reference](docs/api-reference/index.md)

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.9+
- Xcode 15.0+

## Architecture

```
DesignSystem/
├── Sources/
│   ├── DesignSystem/           # Core components
│   │   ├── Animation/          # Animation utilities
│   │   ├── Components/         # UI components
│   │   └── Utilities/          # Helper utilities
│   ├── FoundationColor/        # Color system
│   ├── DesignSystemTypography/ # Typography system
│   ├── FoundationIcons/        # Icon assets
│   └── GestureUtilities/       # Gesture handling
├── Tests/                      # Unit & snapshot tests
└── docs/                       # Documentation
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is available under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Support

- [Documentation](docs/)
- [Issues](https://github.com/kamilsevket/ios-awesome/issues)
- [Discussions](https://github.com/kamilsevket/ios-awesome/discussions)
