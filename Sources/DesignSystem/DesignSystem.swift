// DesignSystem
// A comprehensive SwiftUI component library

@_exported import SwiftUI

// Re-export all public components for easy access
// Usage: import DesignSystem

// MARK: - Badge Components
// - DSBadge: Notification count badge
// - DSStatusBadge: Status indicator (online, offline, etc.)
// - DSTag: Label/tag component
// - DSFilterChip: Single-selection filter chip
// - DSSelectableChip: Multi-selection chip
// - View+Badge: Badge overlay modifiers

// MARK: - Feedback Components
// - DSToast: Simple message toast
// - DSSnackbar: Toast with action button
// - DSToastManager: Queue management singleton
// - DSToastContainerView: Container for displaying toasts
// - DSToastType: Toast type enum (success, error, warning, info)
// - DSToastDuration: Duration configuration (short, long, indefinite)
// - DSToastPosition: Position configuration (top, bottom)
// - DSToastItem: Toast item model
// - View.toastContainer(): View modifier for toast support

// MARK: - Selection Controls
// - DSCheckbox: Checkbox with checked, unchecked, and indeterminate states
// - DSRadioButton: Radio button for single selection
// - DSRadioGroup: Container for grouping radio buttons with single selection
// - DSRadio: Simplified radio button for use within DSRadioGroup
// - DSToggle: Toggle/switch for on/off states

/// Selection Controls type aliases for convenience
public typealias Checkbox = DSCheckbox
public typealias CheckboxState = DSCheckboxState
public typealias CheckboxSize = DSCheckboxSize

public typealias RadioButton = DSRadioButton
public typealias RadioButtonSize = DSRadioButtonSize
public typealias RadioGroup = DSRadioGroup
public typealias Radio = DSRadio

public typealias Toggle = DSToggle
public typealias ToggleSize = DSToggleSize
