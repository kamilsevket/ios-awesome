// MARK: - Shadows & Elevation System
//
// A comprehensive shadow and elevation system for iOS design systems.
//
// ## Overview
//
// This module provides:
// - **Shadow Tokens**: Predefined shadow styles (none, sm, md, lg, xl)
// - **Elevation Levels**: Semantic elevation system (level0-5)
// - **Material Backgrounds**: Blur effects with optional elevation
// - **Dark Mode Support**: Automatic shadow adaptation for dark mode
// - **UIKit Bridge**: Full UIKit compatibility
//
// ## Quick Start
//
// ### SwiftUI
//
// ```swift
// // Apply shadow token
// Card()
//     .shadow(.ds.md)
//
// // Apply elevation level
// Button("Action")
//     .elevation(.raised)
//
// // Material background with elevation
// Text("Blurred")
//     .materialBackground(.ultraThin, elevation: .card, cornerRadius: 12)
// ```
//
// ### UIKit
//
// ```swift
// // Apply to UIView
// view.applyShadow(.md)
// view.applyElevation(.card)
//
// // Use ElevatedView subclass
// let card = CardView()
// card.elevationLevel = .card
// ```
//
// ## Shadow Specifications
//
// | Token | Blur | Y Offset | Opacity (Light) | Opacity (Dark) |
// |-------|------|----------|-----------------|----------------|
// | none  | 0    | 0        | 0               | 0              |
// | sm    | 4    | 2        | 0.10            | 0.30           |
// | md    | 8    | 4        | 0.15            | 0.40           |
// | lg    | 16   | 8        | 0.20            | 0.50           |
// | xl    | 24   | 12       | 0.25            | 0.60           |
//
// ## Elevation Mapping
//
// | Level  | Shadow Token | Use Case                    |
// |--------|--------------|-----------------------------||
// | level0 | none         | Flat surfaces               |
// | level1 | sm           | Cards, tiles                |
// | level2 | md           | Raised buttons, FABs        |
// | level3 | md           | Navigation bars, app bars   |
// | level4 | lg           | Dialogs, pickers            |
// | level5 | xl           | Modals, overlays            |

@_exported import SwiftUI

// Re-export all public types
public typealias Shadow = ShadowToken
public typealias Elevation = ElevationLevel
