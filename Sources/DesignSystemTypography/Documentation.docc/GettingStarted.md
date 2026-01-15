# Getting Started with DesignSystemTypography

Learn how to integrate typography into your app.

## Overview

This guide walks you through the basics of using DesignSystemTypography in your iOS application.

## Installation

Add DesignSystemTypography to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "YOUR_PACKAGE_URL", from: "1.0.0")
]
```

## Basic Usage

### SwiftUI

The simplest way to use typography in SwiftUI is through the font extension:

```swift
import SwiftUI
import DesignSystemTypography

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Welcome")
                .font(.ds.largeTitle)

            Text("This is body text")
                .font(.ds.body)

            Text("A footnote")
                .font(.ds.footnote)
        }
    }
}
```

### Using Text Style Modifier

For more control, use the `textStyle` modifier:

```swift
Text("Headline")
    .textStyle(.headline)

Text("Bold Body")
    .textStyle(.body, weight: .bold)
```

### Using Typography Tokens

For complete typography control:

```swift
Text("Custom Typography")
    .typography(TypographyToken(
        scale: .body,
        weight: .medium,
        fontFamily: .inter
    ))
```

### UIKit

In UIKit, use the UIFont extension:

```swift
import UIKit
import DesignSystemTypography

class ViewController: UIViewController {
    let titleLabel = UILabel()
    let bodyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont.ds.title1
        bodyLabel.font = UIFont.ds.body

        // Or with full typography:
        bodyLabel.apply(typography: .body)
    }
}
```

## Dynamic Type Support

All fonts automatically support Dynamic Type. Users' accessibility settings are respected:

```swift
// This automatically scales with user preferences
Text("Accessible Text")
    .font(.ds.body)
```

To test different size categories in previews:

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.sizeCategory, .accessibilityExtraLarge)
    }
}
```

## Next Steps

- Learn about <doc:UsingFontScales> for detailed scale information
- Explore <doc:CustomFonts> for custom font integration
