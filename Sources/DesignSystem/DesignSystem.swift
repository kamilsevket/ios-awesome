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

// MARK: - List Components
// - DSList: Customizable list wrapper with enhanced styling
// - DSListStyle: List style variants (plain, insetGrouped, grouped, sidebar)
// - DSSeparatorStyle: Separator style variants (none, singleLine, singleLineInset)
//
// - DSSwipeAction: Swipe action configuration
// - DSSwipeActionRole: Swipe action semantic roles (destructive, cancel, none)
// - DSSwipeActionsModifier: Modifier for adding swipe actions
// - View.dsSwipeActions(): View modifier for swipe actions
// - View.dsDeleteAction(): Convenience modifier for delete action
//
// - DSReorderableList: List with drag-to-reorder support
// - DSReorderHandleStyle: Reorder handle styles (none, standard, custom)
//
// - DSSection: Section with customizable header/footer
// - DSSectionHeader: Styled section header
// - DSSectionFooter: Styled section footer
// - DSSectionHeaderStyle: Header styles (plain, prominent, uppercase)
// - TextTransform: Text transformation options
//
// - DSStickyHeader: Sticky header for scroll views
// - DSStickyHeaderStyle: Sticky header styles (standard, blurred, solid)
// - DSStickyHeaderList: List with built-in sticky headers
//
// - DSPaginatedList: List with infinite scroll support
// - DSPaginationState: Pagination state (idle, loading, loaded, error, finished)
// - DSPaginationConfig: Pagination configuration options
// - DSInfiniteScrollModifier: Modifier for infinite scroll behavior
// - View.dsInfiniteScroll(): View modifier for infinite scroll

/// List type aliases for convenience
public typealias List = DSList
public typealias ListStyle = DSListStyle
public typealias SeparatorStyle = DSSeparatorStyle

public typealias SwipeAction = DSSwipeAction
public typealias SwipeActionRole = DSSwipeActionRole

public typealias ReorderableList = DSReorderableList
public typealias ReorderHandleStyle = DSReorderHandleStyle

public typealias Section = DSSection
public typealias SectionHeader = DSSectionHeader
public typealias SectionFooter = DSSectionFooter
public typealias SectionHeaderStyle = DSSectionHeaderStyle

public typealias StickyHeader = DSStickyHeader
public typealias StickyHeaderStyle = DSStickyHeaderStyle
public typealias StickyHeaderList = DSStickyHeaderList

public typealias PaginatedList = DSPaginatedList
public typealias PaginationState = DSPaginationState
public typealias PaginationConfig = DSPaginationConfig

// MARK: - Animation Utilities
// - Transition+Extensions: Design System transition presets (fadeIn, fadeOut, slideUp, slideDown, etc.)
// - Animation+Extensions: Spring presets (gentle, snappy, bouncy, stiff, interactive)
// - KeyframeAnimation: Multi-step keyframe animations (shake, bounce, pulse, wiggle, heartbeat)
// - DSLottieView: Lottie animation wrapper with loop modes and state management
// - AnimationPresets: Enum-based animation presets with reduce motion support
// - WithAnimationHelpers: Convenient animation execution helpers
// - DSAnimations: Namespace for animation helper functions
// - DSAnimationStateManager: Helper class to manage animation states
//
// Spring Presets:
// - Animation.ds.spring.gentle: Soft and slow (response: 0.5, damping: 0.8)
// - Animation.ds.spring.snappy: Quick and responsive (response: 0.3, damping: 0.7)
// - Animation.ds.spring.bouncy: Playful with overshoot (response: 0.4, damping: 0.5)
// - Animation.ds.spring.stiff: Very quick, minimal bounce (response: 0.2, damping: 0.9)
// - Animation.ds.spring.interactive: For gesture-driven animations (response: 0.15, damping: 0.86)
//
// Transition Presets:
// - AnyTransition.ds.fadeIn, fadeOut, fadeQuick, fadeSlow
// - AnyTransition.ds.slideUp, slideDown, slideLeft, slideRight
// - AnyTransition.ds.scale, scaleFromZero, bounce, popIn
// - AnyTransition.ds.modal, toast, snackbar
//
// View Modifiers:
// - View.dsShake(): Apply shake animation
// - View.dsBounce(): Apply bounce animation
// - View.dsPulse(): Apply pulse animation
// - View.dsWiggle(): Apply wiggle animation
// - View.dsHeartbeat(): Apply heartbeat animation
// - View.dsTransition(): Apply DS transition with reduce motion support
// - View.dsAnimation(): Apply DS animation with reduce motion support

/// Animation type aliases for convenience
public typealias AnimationPreset = DSAnimationPreset
public typealias SpringPreset = DSSpringPreset
public typealias EasingPreset = DSEasingPreset
public typealias LottieLoopMode = DSLottieLoopMode
public typealias LottieContentMode = DSLottieContentMode
public typealias LottieView = DSLottieView
public typealias AnimationStateManager = DSAnimationStateManager
