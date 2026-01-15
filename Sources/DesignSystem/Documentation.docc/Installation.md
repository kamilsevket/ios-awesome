# Installation

Add DesignSystem to your iOS project using Swift Package Manager.

## Overview

DesignSystem is distributed as a Swift Package and can be added to your project using Xcode or directly in your Package.swift file.

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Xcode 15.0+
- Swift 5.9+

## Using Xcode

1. Open your project in Xcode
2. Select **File > Add Package Dependencies...**
3. Enter the repository URL: `https://github.com/kamilsevket/ios-awesome.git`
4. Select your version rule
5. Click **Add Package**

## Using Package.swift

Add the dependency to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/kamilsevket/ios-awesome.git", from: "1.0.0")
]
```

Then add the product to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "DesignSystem", package: "ios-awesome")
    ]
)
```

## Available Products

| Product | Description |
|---------|-------------|
| `DesignSystem` | Complete component library |
| `FoundationColor` | Color system only |
| `DesignSystemTypography` | Typography system only |
| `FoundationIcons` | Icon assets only |
| `GestureUtilities` | Gesture handling utilities |

## Selective Imports

Import only what you need to reduce binary size:

```swift
// Full library
import DesignSystem

// Or specific modules
import FoundationColor
import DesignSystemTypography
```
