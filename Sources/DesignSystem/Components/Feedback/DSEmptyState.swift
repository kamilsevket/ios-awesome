import SwiftUI

// MARK: - Empty State Type

/// Defines the type/variant of empty state
public enum DSEmptyStateType: Equatable {
    /// Generic empty state for no content
    case empty
    /// Error state for failures
    case error
    /// No search results found
    case noResults
    /// Device is offline
    case offline
    /// Custom type with configurable icon and colors
    case custom(icon: String, iconColor: Color)

    /// Default icon name for each type
    var defaultIcon: String {
        switch self {
        case .empty:
            return "tray"
        case .error:
            return "exclamationmark.triangle"
        case .noResults:
            return "magnifyingglass"
        case .offline:
            return "wifi.slash"
        case .custom(let icon, _):
            return icon
        }
    }

    /// Icon color for each type
    func iconColor(colorScheme: ColorScheme) -> Color {
        switch self {
        case .empty, .noResults:
            return colorScheme == .dark ? DSColors.emptyStateIconDark : DSColors.emptyStateIcon
        case .error:
            return DSColors.error
        case .offline:
            return DSColors.warning
        case .custom(_, let color):
            return color
        }
    }

    /// Accessibility prefix for VoiceOver
    var accessibilityPrefix: String {
        switch self {
        case .empty:
            return "Empty"
        case .error:
            return "Error"
        case .noResults:
            return "No results"
        case .offline:
            return "Offline"
        case .custom:
            return "Status"
        }
    }
}

// MARK: - Empty State Size

/// Defines the size variant of the empty state
public enum DSEmptyStateSize {
    case small
    case medium
    case large

    var iconSize: CGFloat {
        switch self {
        case .small: return 40
        case .medium: return 56
        case .large: return 72
        }
    }

    var titleFont: Font {
        switch self {
        case .small: return .subheadline.weight(.semibold)
        case .medium: return .headline.weight(.semibold)
        case .large: return .title3.weight(.bold)
        }
    }

    var descriptionFont: Font {
        switch self {
        case .small: return .caption
        case .medium: return .subheadline
        case .large: return .body
        }
    }

    var spacing: CGFloat {
        switch self {
        case .small: return DSSpacing.sm
        case .medium: return DSSpacing.md
        case .large: return DSSpacing.lg
        }
    }

    var iconContainerSize: CGFloat {
        switch self {
        case .small: return 64
        case .medium: return 88
        case .large: return 112
        }
    }
}

// MARK: - Empty State Action

/// Represents an action button for the empty state
public struct DSEmptyStateAction {
    public let title: String
    public let style: DSEmptyStateActionStyle
    public let action: () -> Void

    public init(
        title: String,
        style: DSEmptyStateActionStyle = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }

    /// Factory method for primary action
    public static func primary(_ title: String, action: @escaping () -> Void) -> DSEmptyStateAction {
        DSEmptyStateAction(title: title, style: .primary, action: action)
    }

    /// Factory method for secondary action
    public static func secondary(_ title: String, action: @escaping () -> Void) -> DSEmptyStateAction {
        DSEmptyStateAction(title: title, style: .secondary, action: action)
    }
}

/// Defines the visual style of the action button
public enum DSEmptyStateActionStyle {
    case primary
    case secondary

    var backgroundColor: Color {
        switch self {
        case .primary:
            return DSColors.primary
        case .secondary:
            return Color(.systemGray5)
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .primary
        }
    }
}

// MARK: - DSEmptyState

/// A customizable empty state component for displaying placeholder content
///
/// DSEmptyState provides a consistent empty state implementation with support for:
/// - Multiple types (empty, error, noResults, offline, custom)
/// - Size variants (small, medium, large)
/// - Custom icon or SF Symbol
/// - Illustration support with custom SwiftUI views
/// - Optional action button
/// - Custom content slot
/// - Centered responsive layout
/// - Full accessibility support
///
/// Example usage:
/// ```swift
/// DSEmptyState(
///     icon: .tray,
///     title: "No items",
///     description: "Add your first item",
///     action: ("Add Item") { addItem() }
/// )
///
/// DSEmptyState(
///     type: .error,
///     title: "Something went wrong",
///     description: "Please try again later",
///     action: .primary("Retry") { retry() }
/// )
///
/// DSEmptyState(
///     type: .noResults,
///     title: "No results found",
///     description: "Try adjusting your search"
/// )
/// ```
public struct DSEmptyState<CustomContent: View>: View {

    // MARK: - Properties

    private let type: DSEmptyStateType
    private let icon: String?
    private let title: String
    private let description: String?
    private let size: DSEmptyStateSize
    private let action: DSEmptyStateAction?
    private let customContent: CustomContent?
    private let illustration: AnyView?
    private let showIconBackground: Bool

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates an empty state with all customization options
    /// - Parameters:
    ///   - type: The type of empty state (default: .empty)
    ///   - icon: Optional custom icon name (overrides type's default icon)
    ///   - title: The main title text
    ///   - description: Optional description text
    ///   - size: Size variant (default: .medium)
    ///   - action: Optional action button configuration
    ///   - showIconBackground: Whether to show a background circle behind the icon (default: true)
    ///   - illustration: Optional custom illustration view
    ///   - customContent: Optional custom content view below the description
    public init(
        type: DSEmptyStateType = .empty,
        icon: String? = nil,
        title: String,
        description: String? = nil,
        size: DSEmptyStateSize = .medium,
        action: DSEmptyStateAction? = nil,
        showIconBackground: Bool = true,
        illustration: AnyView? = nil,
        @ViewBuilder customContent: () -> CustomContent
    ) {
        self.type = type
        self.icon = icon
        self.title = title
        self.description = description
        self.size = size
        self.action = action
        self.showIconBackground = showIconBackground
        self.illustration = illustration
        self.customContent = customContent()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: size.spacing * 1.5) {
            illustrationOrIcon
            textContent
            customContentView
            actionButton
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(DSSpacing.xl)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var illustrationOrIcon: some View {
        if let illustration = illustration {
            illustration
                .accessibilityHidden(true)
        } else {
            iconView
        }
    }

    @ViewBuilder
    private var iconView: some View {
        let iconName = icon ?? type.defaultIcon
        let iconColor = type.iconColor(colorScheme: colorScheme)

        ZStack {
            if showIconBackground {
                Circle()
                    .fill(iconColor.opacity(0.1))
                    .frame(width: size.iconContainerSize, height: size.iconContainerSize)
            }

            Image(systemName: iconName)
                .font(.system(size: size.iconSize, weight: .medium))
                .foregroundColor(iconColor)
        }
        .accessibilityHidden(true)
    }

    private var textContent: some View {
        VStack(spacing: size.spacing) {
            Text(title)
                .font(size.titleFont)
                .foregroundColor(Color(.label))
                .multilineTextAlignment(.center)

            if let description = description {
                Text(description)
                    .font(size.descriptionFont)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
    }

    @ViewBuilder
    private var customContentView: some View {
        if let content = customContent {
            content
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        if let action = action {
            Button(action: action.action) {
                Text(action.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(action.style.foregroundColor)
                    .padding(.horizontal, DSSpacing.xl)
                    .padding(.vertical, DSSpacing.md)
                    .frame(minHeight: DSSpacing.minTouchTarget)
                    .background(action.style.backgroundColor)
                    .cornerRadius(10)
            }
            .accessibilityLabel(action.title)
            .accessibilityAddTraits(.isButton)
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var label = "\(type.accessibilityPrefix): \(title)"
        if let description = description {
            label += ". \(description)"
        }
        if let action = action {
            label += ". \(action.title) button available"
        }
        return label
    }
}

// MARK: - Convenience Initializers (No Custom Content)

extension DSEmptyState where CustomContent == EmptyView {

    /// Creates an empty state without custom content
    public init(
        type: DSEmptyStateType = .empty,
        icon: String? = nil,
        title: String,
        description: String? = nil,
        size: DSEmptyStateSize = .medium,
        action: DSEmptyStateAction? = nil,
        showIconBackground: Bool = true,
        illustration: AnyView? = nil
    ) {
        self.type = type
        self.icon = icon
        self.title = title
        self.description = description
        self.size = size
        self.action = action
        self.showIconBackground = showIconBackground
        self.illustration = illustration
        self.customContent = nil
    }

    /// Creates an empty state with a tuple-style action
    /// - Parameters:
    ///   - icon: SF Symbol name
    ///   - title: Main title text
    ///   - description: Optional description
    ///   - action: Tuple of (title, action closure)
    public init(
        icon: String,
        title: String,
        description: String? = nil,
        action: (String, () -> Void)? = nil
    ) {
        self.type = .empty
        self.icon = icon
        self.title = title
        self.description = description
        self.size = .medium
        self.showIconBackground = true
        self.illustration = nil
        self.customContent = nil

        if let action = action {
            self.action = DSEmptyStateAction(title: action.0, action: action.1)
        } else {
            self.action = nil
        }
    }
}

// MARK: - Type-Specific Factory Methods

extension DSEmptyState where CustomContent == EmptyView {

    /// Creates an error state view
    public static func error(
        title: String = "Something went wrong",
        description: String? = "Please try again later",
        retryAction: (() -> Void)? = nil
    ) -> DSEmptyState {
        DSEmptyState(
            type: .error,
            title: title,
            description: description,
            action: retryAction.map { .primary("Retry", action: $0) }
        )
    }

    /// Creates a no results state view
    public static func noResults(
        title: String = "No results found",
        description: String? = "Try adjusting your search or filters",
        clearAction: (() -> Void)? = nil
    ) -> DSEmptyState {
        DSEmptyState(
            type: .noResults,
            title: title,
            description: description,
            action: clearAction.map { .secondary("Clear filters", action: $0) }
        )
    }

    /// Creates an offline state view
    public static func offline(
        title: String = "You're offline",
        description: String? = "Check your internet connection and try again",
        retryAction: (() -> Void)? = nil
    ) -> DSEmptyState {
        DSEmptyState(
            type: .offline,
            title: title,
            description: description,
            action: retryAction.map { .primary("Try again", action: $0) }
        )
    }
}

// MARK: - Preview

#if DEBUG
struct DSEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xxl) {
                sectionHeader("Generic Empty State")
                DSEmptyState(
                    icon: "tray",
                    title: "No items",
                    description: "Add your first item to get started",
                    action: ("Add Item", { })
                )
                .frame(height: 300)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)

                Divider()

                sectionHeader("Error State")
                DSEmptyState.error(retryAction: { })
                    .frame(height: 300)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)

                Divider()

                sectionHeader("No Results State")
                DSEmptyState.noResults(clearAction: { })
                    .frame(height: 300)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)

                Divider()

                sectionHeader("Offline State")
                DSEmptyState.offline(retryAction: { })
                    .frame(height: 300)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)
            }
            .padding()
        }
        .previewDisplayName("All Types")

        // Size variants
        ScrollView {
            VStack(spacing: DSSpacing.xxl) {
                sectionHeader("Small")
                DSEmptyState(
                    type: .empty,
                    title: "No items",
                    description: "Add your first item",
                    size: .small
                )
                .frame(height: 200)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)

                sectionHeader("Medium (Default)")
                DSEmptyState(
                    type: .empty,
                    title: "No items",
                    description: "Add your first item",
                    size: .medium
                )
                .frame(height: 250)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)

                sectionHeader("Large")
                DSEmptyState(
                    type: .empty,
                    title: "No items",
                    description: "Add your first item",
                    size: .large
                )
                .frame(height: 320)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
            }
            .padding()
        }
        .previewDisplayName("Size Variants")

        // Dark mode
        ScrollView {
            VStack(spacing: DSSpacing.xxl) {
                DSEmptyState(
                    icon: "tray",
                    title: "No items",
                    description: "Add your first item",
                    action: ("Add Item", { })
                )
                .frame(height: 300)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)

                DSEmptyState.error(retryAction: { })
                    .frame(height: 300)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)

                DSEmptyState.offline(retryAction: { })
                    .frame(height: 300)
                    .background(Color(.systemGroupedBackground))
                    .cornerRadius(12)
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")

        // Custom content
        DSEmptyState(
            type: .empty,
            title: "No favorites yet",
            description: "Items you favorite will appear here"
        ) {
            HStack(spacing: DSSpacing.md) {
                Image(systemName: "heart")
                Text("Tap the heart icon to favorite items")
            }
            .font(.caption)
            .foregroundColor(Color(.tertiaryLabel))
            .padding(.top, DSSpacing.sm)
        }
        .frame(height: 350)
        .padding()
        .previewDisplayName("Custom Content")

        // Without icon background
        DSEmptyState(
            type: .empty,
            icon: "folder",
            title: "No files",
            description: "Your files will appear here",
            showIconBackground: false
        )
        .frame(height: 300)
        .padding()
        .previewDisplayName("No Icon Background")
    }

    static func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
#endif
