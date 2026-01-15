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
