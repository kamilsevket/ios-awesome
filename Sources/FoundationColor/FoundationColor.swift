/// FoundationColor - A comprehensive color system for iOS applications
///
/// This package provides a consistent, accessible color palette with automatic
/// dark/light mode support via Asset Catalog.
///
/// # Usage
///
/// ## SwiftUI
/// ```swift
/// import FoundationColor
///
/// // Using Color extensions
/// Text("Hello").foregroundColor(.primary500)
/// Rectangle().fill(.secondary300)
///
/// // Using namespaced semantic colors
/// Text("Success!").foregroundColor(Color.semantic.success)
/// View().background(Color.ui.background)
///
/// // Using ColorTokens directly
/// ColorTokens.Primary.shade500
/// ColorTokens.Semantic.error
/// ```
///
/// ## UIKit
/// ```swift
/// import FoundationColor
///
/// label.textColor = .primary500
/// view.backgroundColor = .uiBackground
/// ```
///
/// # Color Palette
///
/// - **Primary**: Blue tones (50-900 shades)
/// - **Secondary**: Green tones (50-900 shades)
/// - **Tertiary**: Purple tones (50-900 shades)
/// - **Semantic**: success, warning, error, info (with light variants)
/// - **UI**: background, surface, text colors, border, divider
///
/// # Accessibility
///
/// All color combinations are designed to meet WCAG AA contrast requirements.
/// Use darker shades (600+) for text on light backgrounds.

@_exported import struct SwiftUI.Color

#if canImport(UIKit)
@_exported import class UIKit.UIColor
#endif
