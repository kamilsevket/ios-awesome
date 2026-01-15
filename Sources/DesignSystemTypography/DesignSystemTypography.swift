/// # Design System Typography
///
/// A comprehensive typography system for iOS applications with full Dynamic Type support.
///
/// ## Overview
///
/// This package provides a complete typography solution including:
/// - Font scale definitions following Apple HIG
/// - Dynamic Type support for all text sizes
/// - Custom font integration
/// - SwiftUI and UIKit support
///
/// ## Basic Usage
///
/// ### SwiftUI
///
/// ```swift
/// import DesignSystemTypography
///
/// // Using font extension
/// Text("Title").font(.ds.headline)
///
/// // Using text style modifier
/// Text("Body").textStyle(.body)
///
/// // Using typography token
/// Text("Custom").typography(.bodyBold)
/// ```
///
/// ### UIKit
///
/// ```swift
/// import DesignSystemTypography
///
/// // Using UIFont extension
/// label.font = UIFont.ds.headline
///
/// // Using typography token
/// label.apply(typography: .body)
/// ```
///
/// ## Font Scales
///
/// The following scales are available:
/// - Display: `largeTitle`, `title1`, `title2`, `title3`
/// - Content: `headline`, `body`, `callout`, `subheadline`
/// - Supporting: `footnote`, `caption1`, `caption2`
///
/// ## Custom Fonts
///
/// To use custom fonts:
///
/// ```swift
/// // Register font family
/// FontFamilyRegistry.shared.register(.inter)
///
/// // Load fonts
/// FontLoader.shared.loadFontFamily("Inter")
///
/// // Use with typography
/// Text("Custom").typography(TypographyToken(scale: .body, fontFamily: .inter))
/// ```

import SwiftUI

// This file serves as the main entry point and documentation for the package.
// All public types are exported from their respective files.
