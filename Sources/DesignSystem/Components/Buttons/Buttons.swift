/// Button Components Module
///
/// This module provides a comprehensive set of button components for the design system.
///
/// ## Components
///
/// ### DSButton
/// The primary button component for general actions. Supports:
/// - Three visual styles: `.primary`, `.secondary`, `.tertiary`
/// - Three sizes: `.small`, `.medium`, `.large`
/// - Icon support with leading/trailing positioning
/// - Loading state with spinner
/// - Full-width option
/// - Haptic feedback
///
/// ```swift
/// // Basic usage
/// DSButton("Save", style: .primary) { save() }
///
/// // With icon
/// DSButton("Add Item", icon: Image(systemName: "plus")) { add() }
///
/// // Loading state
/// DSButton("Submit", isLoading: isLoading) { submit() }
///
/// // Full width
/// DSButton("Continue", isFullWidth: true) { next() }
/// ```
///
/// ### DSIconButton
/// A button displaying only an icon, perfect for toolbars and compact actions.
/// - Three styles: `.filled`, `.tinted`, `.plain`
/// - Circular or rounded rectangle shape
/// - Convenience initializers for common actions
///
/// ```swift
/// // Custom icon
/// DSIconButton(systemName: "star.fill", accessibilityLabel: "Favorite") { }
///
/// // Convenience factories
/// DSIconButton.close { dismiss() }
/// DSIconButton.add { addItem() }
/// DSIconButton.delete { removeItem() }
/// ```
///
/// ### DSFloatingActionButton
/// Material Design-style floating action button for primary screen actions.
/// - Regular circular FAB
/// - Extended FAB with text
/// - Custom positioning modifier
///
/// ```swift
/// // Regular FAB
/// DSFloatingActionButton(systemName: "plus", accessibilityLabel: "Add") {
///     createItem()
/// }
///
/// // Extended FAB
/// DSFloatingActionButton.extended(systemName: "plus", title: "Create") {
///     createItem()
/// }
///
/// // Positioned in view
/// List { ... }
///     .floatingActionButton(
///         DSFloatingActionButton(systemName: "plus", accessibilityLabel: "Add") { }
///     )
/// ```
///
/// ## Accessibility
///
/// All button components are designed with accessibility in mind:
/// - Minimum 44×44pt touch targets (medium size and above)
/// - VoiceOver labels and hints
/// - Proper disabled state handling
/// - Loading state announcements
///
/// ## Design Tokens
///
/// Buttons use system colors and adapt to dark mode automatically.
/// The accent color can be customized at the app level.

import SwiftUI

// Re-export all button components
// This file serves as the public API for the Buttons module
