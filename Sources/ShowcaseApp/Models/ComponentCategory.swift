import SwiftUI

/// Represents a category of components in the design system
public enum ComponentCategory: String, CaseIterable, Identifiable {
    case foundation = "Foundation"
    case basic = "Basic"
    case navigation = "Navigation"
    case feedback = "Feedback"
    case form = "Form"
    case overlay = "Overlay"
    case dataDisplay = "Data Display"
    case utilities = "Utilities"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .foundation: return "paintbrush.fill"
        case .basic: return "square.on.square.fill"
        case .navigation: return "arrow.triangle.turn.up.right.diamond.fill"
        case .feedback: return "bell.fill"
        case .form: return "square.and.pencil"
        case .overlay: return "rectangle.on.rectangle.angled"
        case .dataDisplay: return "list.bullet.rectangle.fill"
        case .utilities: return "wrench.and.screwdriver.fill"
        }
    }

    public var description: String {
        switch self {
        case .foundation:
            return "Core design tokens including colors, typography, spacing, and icons"
        case .basic:
            return "Fundamental UI components like buttons, cards, avatars, and text fields"
        case .navigation:
            return "Navigation components including tab bars, navigation bars, and segmented controls"
        case .feedback:
            return "User feedback components such as alerts, toasts, and loading indicators"
        case .form:
            return "Form input components including pickers, sliders, and selection controls"
        case .overlay:
            return "Overlay components like modals, sheets, popovers, and tooltips"
        case .dataDisplay:
            return "Components for displaying data including lists, grids, and carousels"
        case .utilities:
            return "Utility components and helpers for animations, gestures, and accessibility"
        }
    }

    public var components: [ComponentInfo] {
        switch self {
        case .foundation:
            return [
                ComponentInfo(name: "Colors", icon: "paintpalette.fill", category: self),
                ComponentInfo(name: "Typography", icon: "textformat", category: self),
                ComponentInfo(name: "Spacing", icon: "ruler.fill", category: self),
                ComponentInfo(name: "Icons", icon: "star.fill", category: self),
                ComponentInfo(name: "Shadows", icon: "shadow", category: self)
            ]
        case .basic:
            return [
                ComponentInfo(name: "Button", icon: "rectangle.fill", category: self),
                ComponentInfo(name: "IconButton", icon: "circle.fill", category: self),
                ComponentInfo(name: "FloatingActionButton", icon: "plus.circle.fill", category: self),
                ComponentInfo(name: "Card", icon: "rectangle.portrait.fill", category: self),
                ComponentInfo(name: "Avatar", icon: "person.crop.circle.fill", category: self),
                ComponentInfo(name: "Badge", icon: "app.badge.fill", category: self),
                ComponentInfo(name: "Tag", icon: "tag.fill", category: self),
                ComponentInfo(name: "TextField", icon: "text.cursor", category: self)
            ]
        case .navigation:
            return [
                ComponentInfo(name: "TabBar", icon: "square.grid.2x2.fill", category: self),
                ComponentInfo(name: "NavigationBar", icon: "arrow.left.square.fill", category: self),
                ComponentInfo(name: "SegmentedControl", icon: "rectangle.split.3x1.fill", category: self)
            ]
        case .feedback:
            return [
                ComponentInfo(name: "Alert", icon: "exclamationmark.triangle.fill", category: self),
                ComponentInfo(name: "Toast", icon: "text.bubble.fill", category: self),
                ComponentInfo(name: "Snackbar", icon: "rectangle.bottomthird.inset.filled", category: self),
                ComponentInfo(name: "EmptyState", icon: "doc.text.fill", category: self),
                ComponentInfo(name: "LoadingIndicator", icon: "arrow.clockwise", category: self),
                ComponentInfo(name: "Skeleton", icon: "rectangle.fill", category: self),
                ComponentInfo(name: "Progress", icon: "chart.bar.fill", category: self)
            ]
        case .form:
            return [
                ComponentInfo(name: "Checkbox", icon: "checkmark.square.fill", category: self),
                ComponentInfo(name: "RadioButton", icon: "circle.inset.filled", category: self),
                ComponentInfo(name: "Toggle", icon: "switch.2", category: self),
                ComponentInfo(name: "Slider", icon: "slider.horizontal.3", category: self),
                ComponentInfo(name: "RangeSlider", icon: "slider.horizontal.below.rectangle", category: self),
                ComponentInfo(name: "DatePicker", icon: "calendar", category: self),
                ComponentInfo(name: "TimePicker", icon: "clock.fill", category: self),
                ComponentInfo(name: "Dropdown", icon: "chevron.down.square.fill", category: self),
                ComponentInfo(name: "MultiSelect", icon: "checklist", category: self)
            ]
        case .overlay:
            return [
                ComponentInfo(name: "Modal", icon: "rectangle.center.inset.filled", category: self),
                ComponentInfo(name: "BottomSheet", icon: "rectangle.bottomhalf.filled", category: self),
                ComponentInfo(name: "ActionSheet", icon: "list.bullet.rectangle", category: self),
                ComponentInfo(name: "Popover", icon: "bubble.left.fill", category: self),
                ComponentInfo(name: "Tooltip", icon: "text.bubble.fill", category: self),
                ComponentInfo(name: "ContextMenu", icon: "ellipsis.circle.fill", category: self)
            ]
        case .dataDisplay:
            return [
                ComponentInfo(name: "List", icon: "list.bullet", category: self),
                ComponentInfo(name: "Grid", icon: "square.grid.3x3.fill", category: self),
                ComponentInfo(name: "Carousel", icon: "rectangle.split.3x1", category: self),
                ComponentInfo(name: "Pagination", icon: "circle.grid.3x3.fill", category: self)
            ]
        case .utilities:
            return [
                ComponentInfo(name: "Animation", icon: "wand.and.stars", category: self),
                ComponentInfo(name: "Gesture", icon: "hand.tap.fill", category: self),
                ComponentInfo(name: "Accessibility", icon: "accessibility", category: self)
            ]
        }
    }
}

/// Information about a specific component
public struct ComponentInfo: Identifiable, Hashable {
    public let id = UUID()
    public let name: String
    public let icon: String
    public let category: ComponentCategory

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: ComponentInfo, rhs: ComponentInfo) -> Bool {
        lhs.id == rhs.id
    }
}
