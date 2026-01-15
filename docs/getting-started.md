# Getting Started

This guide will help you get up and running with DesignSystem in your iOS project.

## Prerequisites

Before you begin, ensure you have:
- Xcode 15.0 or later
- iOS 15.0+ deployment target
- Swift 5.9+

## Step 1: Add the Package

Add DesignSystem to your project using Swift Package Manager:

1. In Xcode, go to **File > Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/kamilsevket/ios-awesome.git`
3. Select the version rule (recommended: "Up to Next Major Version")
4. Choose which libraries to add to your target

## Step 2: Import the Library

Import DesignSystem in your Swift files:

```swift
import DesignSystem
```

For specific modules:

```swift
import FoundationColor      // Color system only
import DesignSystemTypography  // Typography only
import FoundationIcons      // Icons only
import GestureUtilities     // Gesture handling
```

## Step 3: Create Your First Component

### Basic Button

```swift
import SwiftUI
import DesignSystem

struct MyView: View {
    var body: some View {
        VStack(spacing: DSSpacing.md) {
            // Primary button
            DSButton("Continue", style: .primary) {
                print("Button tapped!")
            }

            // Secondary button with icon
            DSButton(
                "Settings",
                style: .secondary,
                icon: Image(systemName: "gear")
            ) {
                // Open settings
            }

            // Full-width loading button
            DSButton(
                "Saving...",
                style: .primary,
                isFullWidth: true,
                isLoading: true
            ) { }
        }
        .padding()
    }
}
```

### Text Input

```swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: DSSpacing.md) {
            DSTextField(
                "Email",
                text: $email,
                type: .email,
                placeholder: "Enter your email"
            )

            DSTextField(
                "Password",
                text: $password,
                type: .password,
                placeholder: "Enter your password"
            )

            DSButton("Sign In", style: .primary, isFullWidth: true) {
                signIn()
            }
        }
        .padding()
    }
}
```

### Card Layout

```swift
struct ProductCard: View {
    var body: some View {
        DSCard(style: .elevated) {
            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                Image("product")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()

                VStack(alignment: .leading, spacing: DSSpacing.xs) {
                    Text("Product Name")
                        .font(.headline)

                    Text("$99.99")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    DSButton("Add to Cart", size: .small) {
                        addToCart()
                    }
                }
                .padding()
            }
        }
    }
}
```

## Step 4: Apply Design Tokens

Use consistent spacing, colors, and typography throughout your app:

### Spacing

```swift
VStack(spacing: DSSpacing.md) {   // 16pt
    Text("Title")
        .padding(.horizontal, DSSpacing.lg)  // 24pt

    Text("Description")
        .padding(.bottom, DSSpacing.xl)      // 32pt
}
```

### Typography

```swift
Text("Headline")
    .font(DSTypography.headline)

Text("Body text")
    .font(DSTypography.body)

Text("Caption")
    .font(DSTypography.caption)
    .foregroundColor(DSColors.textSecondary)
```

### Colors

```swift
Rectangle()
    .fill(DSColors.primary)

Text("Success!")
    .foregroundColor(DSColors.success)

View()
    .background(DSColors.background)
```

## Step 5: Enable Dark Mode Support

All components automatically support dark mode. To preview both modes:

```swift
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Light Mode")

        ContentView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
```

## Step 6: Accessibility

DesignSystem components are built with accessibility in mind:

```swift
// Components have built-in accessibility labels
DSButton("Submit", style: .primary) { }
// VoiceOver: "Submit, Button"

// Add custom accessibility hints
DSButton("Delete", style: .tertiary) { }
    .accessibilityHint("Removes this item permanently")

// Support Dynamic Type
Text("Readable text")
    .font(DSTypography.body)  // Automatically scales
```

## Next Steps

- [Installation Guide](installation.md) - Detailed installation options
- [Component Catalog](components/) - Browse all available components
- [Best Practices](best-practices.md) - Design patterns and guidelines
- [API Reference](api-reference/) - Complete API documentation

## Example Projects

Check out these example implementations:

```swift
// Complete form example
struct RegistrationForm: View {
    @State private var name = ""
    @State private var email = ""
    @State private var agreeToTerms = false
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.lg) {
                // Avatar selection
                DSAvatar(
                    initials: String(name.prefix(2)).uppercased(),
                    size: .xl
                )

                // Form fields
                DSTextField("Name", text: $name)
                DSTextField("Email", text: $email, type: .email)

                // Checkbox
                DSCheckbox(
                    "I agree to the Terms of Service",
                    isChecked: $agreeToTerms
                )

                // Submit button
                DSButton(
                    "Create Account",
                    style: .primary,
                    isFullWidth: true,
                    isLoading: isLoading,
                    isEnabled: !name.isEmpty && !email.isEmpty && agreeToTerms
                ) {
                    createAccount()
                }
            }
            .padding()
        }
        .navigationTitle("Sign Up")
    }
}
```

## Troubleshooting

### Package Resolution Issues

If you encounter package resolution issues:

1. In Xcode, go to **File > Packages > Reset Package Caches**
2. Clean the build folder: **Product > Clean Build Folder**
3. Restart Xcode

### Missing Symbols

Ensure all required modules are imported:

```swift
import DesignSystem          // Main components
import FoundationColor       // If using DSColors directly
import DesignSystemTypography // If using DSTypography directly
```

### Minimum Deployment Target

If you see deployment target errors, update your project settings to iOS 15.0+.
