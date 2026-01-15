// MARK: - Spacing Module Exports
//
// This file provides convenient access to all spacing-related types and values.
//
// ## Quick Reference
//
// ### Spacing Tokens (4pt Grid)
// ```swift
// Spacing.xxs   // 2pt
// Spacing.xs    // 4pt
// Spacing.sm    // 8pt
// Spacing.md    // 16pt (default)
// Spacing.lg    // 24pt
// Spacing.xl    // 32pt
// Spacing.xxl   // 48pt
// ```
//
// ### SwiftUI Usage
// ```swift
// // Padding with tokens
// .padding(.ds.md)                    // 16pt all sides
// .padding(.horizontal, .ds.lg)       // 24pt horizontal
// .padding(.sm)                       // Using SpacingToken enum
//
// // Stack spacing
// VStack(spacing: .md) { }            // 16pt between items
// HStack(spacing: .sm) { }            // 8pt between items
//
// // View modifiers
// .spacing(.all, .md)                 // Modifier-based padding
// .insetSpacing(.md)                  // Uniform inset
// .cardSpacing(inset: .md)            // Card-style spacing
// .touchTarget()                      // Ensure 44pt minimum
//
// // Responsive spacing
// .responsiveHorizontalPadding()      // Adapts to size class
// .readableContentWidth()             // Max width on larger screens
// ```
//
// ### UIKit Usage
// ```swift
// // Edge insets
// view.directionalLayoutMargins = .uniform(.md)
// stackView.setSpacing(.sm)
// stackView.setContentInsets(.md)
//
// // Layout
// collectionLayout.setSectionInsets(.md)
// collectionLayout.setMinimumSpacing(line: .sm, item: .sm)
// ```
//
// ### Layout Constants
// ```swift
// LayoutConstants.buttonHeight        // 44pt
// LayoutConstants.minTouchTarget      // 44pt
// LayoutConstants.cardCornerRadius    // 12pt
// LayoutConstants.iconSize            // 24pt
// ```
//
// ### Responsive Breakpoints
// ```swift
// ResponsiveBreakpoints.compactWidth  // 600pt
// ResponsiveBreakpoints.regularWidth  // 1024pt
//
// ResponsiveContainer { sizeClass in
//     // sizeClass is .compact, .regular, or .large
// }
// ```
//
// ### Safe Area
// ```swift
// SafeAreaReader { insets in
//     // Access safe area insets
// }
// .bottomSafePadding(.md)             // Safe + additional padding
// ```

import Foundation

// Re-export all public types for convenience
public typealias DS = DesignSystemSpacing
