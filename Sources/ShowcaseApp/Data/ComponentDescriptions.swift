import Foundation

/// Component descriptions for documentation
public enum ComponentDescriptions {

    public static func description(for componentName: String) -> String {
        switch componentName {
        // Foundation
        case "Colors":
            return "Design system color tokens providing semantic colors for the entire design system. All colors automatically support light and dark mode with primary, secondary, success, warning, error, and info semantic colors."

        case "Typography":
            return "Typography system following Apple Human Interface Guidelines with support for Dynamic Type. Includes scales from Large Title to Caption with appropriate weights and line heights."

        case "Spacing":
            return "Consistent spacing scale tokens from extra-small (4pt) to extra-extra-large (32pt). Ensures visual harmony and proper touch targets (minimum 44pt) throughout the design system."

        case "Icons":
            return "Unified icon system supporting SF Symbols and custom icons. Provides consistent sizing (xs to xxl) and weight options with proper accessibility support."

        case "Shadows":
            return "Elevation system with predefined shadow presets (small, medium, large) for creating depth hierarchy in the UI. Automatically adapts to light and dark mode."

        // Basic
        case "Button":
            return "A customizable button component with support for multiple visual styles (primary, secondary, tertiary), size variants (small, medium, large), loading state with spinner, icon support, and haptic feedback."

        case "IconButton":
            return "Icon-only button variant optimized for toolbar actions and compact UI. Supports all button styles and sizes with proper touch targets."

        case "FloatingActionButton":
            return "Floating action button (FAB) for primary actions. Features elevated appearance, customizable size, and smooth animations."

        case "Card":
            return "Versatile card container with multiple styles (flat, outlined, elevated, filled). Supports configurable padding, corner radius, and shadow with optional interactive state."

        case "Avatar":
            return "User avatar component with fallback chain: image → initials → icon. Supports multiple sizes, status indicators (online, offline, busy, away), and avatar groups."

        case "Badge":
            return "Notification and status badge component with semantic colors (primary, success, warning, error) and shape variants (rounded, pill)."

        case "Tag":
            return "Tag component for categorization and filtering. Supports selectable and removable variants with customizable colors."

        case "TextField":
            return "Text input field with floating label, validation states, character counter, and helper text. Supports secure entry, multiline, and search variants."

        // Navigation
        case "TabBar":
            return "Bottom tab bar navigation component with support for badges, custom icons, and scrollable variants for more than 5 tabs."

        case "NavigationBar":
            return "Top navigation bar with back button, title, large title mode, and action items. Includes scroll observer for dynamic appearance changes."

        case "SegmentedControl":
            return "Segmented control for switching between related views or options. Supports custom styling and accessibility features."

        // Feedback
        case "Alert":
            return "Alert component for displaying important messages with icon, title, message, and action buttons. Supports info, success, warning, and error types."

        case "Toast":
            return "Temporary notification toast that appears briefly and auto-dismisses. Managed by ToastManager for queuing multiple toasts."

        case "Snackbar":
            return "Bottom-positioned notification with optional action button. Ideal for undo operations and brief confirmations."

        case "EmptyState":
            return "Empty state view for when content is not available. Includes icon, title, description, and optional action button."

        case "LoadingIndicator":
            return "Loading indicators including circular spinner, with customizable size and color. Supports indeterminate loading states."

        case "Skeleton":
            return "Skeleton loading placeholder with shimmer animation. Used to indicate content is loading while maintaining layout structure."

        case "Progress":
            return "Progress indicators including linear bar and circular variants. Supports determinate progress with percentage and indeterminate loading."

        // Form
        case "Checkbox":
            return "Checkbox control for boolean selection with customizable checked/unchecked states and accessibility support."

        case "RadioButton":
            return "Radio button for single selection within a group. Includes RadioGroup container for managing selection state."

        case "Toggle":
            return "Toggle switch for on/off states with customizable tint color and label support."

        case "Slider":
            return "Single-value slider for selecting from a range. Supports step values, min/max labels, and custom track colors."

        case "RangeSlider":
            return "Dual-thumb range slider for selecting a value range. Useful for price ranges and filter controls."

        case "DatePicker":
            return "Date picker component with multiple display styles (compact, graphical, wheel) and customizable date range."

        case "TimePicker":
            return "Time picker component for selecting hours and minutes with 12/24 hour format support."

        case "Dropdown":
            return "Dropdown menu for single selection from a list of options. Supports search functionality and grouping."

        case "MultiSelect":
            return "Multi-select dropdown allowing selection of multiple options with chip display and search."

        // Overlay
        case "Modal":
            return "Modal dialog for focused interactions requiring user attention. Supports custom content and action buttons."

        case "BottomSheet":
            return "Bottom sheet component with drag-to-dismiss, multiple detent heights, and smooth animations."

        case "ActionSheet":
            return "iOS-style action sheet presenting a list of actions from the bottom of the screen."

        case "Popover":
            return "Popover for displaying additional content anchored to a specific element. Includes arrow pointing to source."

        case "Tooltip":
            return "Small tooltip for providing brief explanatory text on hover or long-press."

        case "ContextMenu":
            return "Context menu appearing on long-press with a list of relevant actions for the target element."

        // Data Display
        case "List":
            return "List component with sections, sticky headers, swipe actions, and reordering support. Optimized for large datasets."

        case "Grid":
            return "Grid layouts including basic grid, adaptive grid, and masonry layout for displaying items in columns."

        case "Carousel":
            return "Horizontal scrolling carousel with page indicators, auto-scroll, and card variants."

        case "Pagination":
            return "Pagination control for navigating through pages of content with numbered buttons and navigation arrows."

        // Utilities
        case "Animation":
            return "Animation utilities including presets, keyframe animations, transitions, and Lottie animation support."

        case "Gesture":
            return "Gesture utilities for tap, swipe, pan, pinch, and rotation gestures with haptic feedback integration."

        case "Accessibility":
            return "Accessibility utilities for VoiceOver labels, hints, traits, and reduced motion support."

        default:
            return "A component of the design system."
        }
    }
}
