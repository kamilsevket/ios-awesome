# Getting Started with DesignSystem

Learn how to integrate DesignSystem into your iOS project and create your first component.

## Overview

This guide walks you through adding DesignSystem to your project and using your first components.

## Adding the Package

Add DesignSystem using Swift Package Manager:

1. In Xcode, select **File > Add Package Dependencies...**
2. Enter the repository URL
3. Select the version and click **Add Package**

## Your First Component

Import the library and use a component:

```swift
import SwiftUI
import DesignSystem

struct ContentView: View {
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSButton("Get Started", style: .primary) {
                print("Button tapped!")
            }
        }
        .padding()
    }
}
```

## Using Design Tokens

Apply consistent spacing and colors:

```swift
VStack(spacing: DSSpacing.md) {
    Text("Hello, World!")
        .foregroundColor(DSColors.textPrimary)
}
.padding(DSSpacing.lg)
.background(DSColors.background)
```

## Next Steps

- Explore the component library
- Learn about design tokens
- Review accessibility guidelines
