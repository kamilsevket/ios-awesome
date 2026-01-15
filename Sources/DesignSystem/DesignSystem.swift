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
// - DSEmptyState: Empty/placeholder state component
// - DSEmptyStateType: Type enum (empty, error, noResults, offline, custom)
// - DSEmptyStateSize: Size variants (small, medium, large)
// - DSEmptyStateAction: Action button configuration
// - DSEmptyStateActionStyle: Action button styles (primary, secondary)
//
// Factory methods available:
// - DSEmptyState.error(): Creates an error state
// - DSEmptyState.noResults(): Creates a no results state
// - DSEmptyState.offline(): Creates an offline state

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

// MARK: - Picker Components
// - DSDatePicker: Styled date picker wrapper
// - DSTimePicker: Styled time picker wrapper
// - DSDateTimePicker: Combined date and time picker
// - DSCustomPicker: Generic picker for custom items
// - DSWheelPicker: iOS wheel-style picker
// - DSMultiWheelPicker: Multi-column wheel picker
// - DSPickerStyle: Picker style configurations
// - DSDateFormatters: Date formatting utilities
// - DSDateTemplate: Common date format templates

// MARK: - Overlay Components
// - DSPopover: Attached popover with arrow positioning
// - DSPopoverEdge: Edge enum for popover positioning (top, bottom, leading, trailing)
// - DSPopoverStyle: Style configuration for popovers
// - View.dsPopover(): View modifier for popover presentation
//
// - DSTooltip: Information tooltip with delay support
// - DSTooltipEdge: Edge enum for tooltip positioning
// - DSTooltipStyle: Style configuration for tooltips (default, info, warning, error)
// - View.dsTooltip(): View modifier for tooltip presentation
//
// - DSContextMenu: Styled context menu wrapper
// - DSMenuItem: Menu item with icon and role support
// - DSMenuSection: Section for grouping menu items
// - DSContextMenuButton: Button that shows menu on tap
// - View.dsContextMenu(): View modifier for context menu
//
// - DSActionSheet: Custom action sheet with rich styling
// - DSActionSheetAction: Action configuration for action sheets
// - DSActionSheetStyle: Style configuration for action sheets
// - View.dsActionSheet(): View modifier for action sheet presentation

/// Overlay type aliases for convenience
public typealias Popover = DSPopover
public typealias PopoverEdge = DSPopoverEdge
public typealias PopoverStyle = DSPopoverStyle

public typealias Tooltip = DSTooltip
public typealias TooltipEdge = DSTooltipEdge
public typealias TooltipStyle = DSTooltipStyle

public typealias MenuItem = DSMenuItem
public typealias MenuSection = DSMenuSection
public typealias ContextMenuButton = DSContextMenuButton

public typealias ActionSheet = DSActionSheet
public typealias ActionSheetAction = DSActionSheetAction
public typealias ActionSheetStyle = DSActionSheetStyle
