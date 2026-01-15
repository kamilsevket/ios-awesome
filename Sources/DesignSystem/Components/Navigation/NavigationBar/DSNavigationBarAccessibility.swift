import SwiftUI

// MARK: - Navigation Bar Accessibility

/// Accessibility extensions and modifiers for DSNavigationBar components
public extension View {
    /// Adds navigation bar accessibility traits and labels
    func dsNavigationBarAccessibility(
        title: String,
        subtitle: String? = nil,
        isSearchActive: Bool = false
    ) -> some View {
        self
            .accessibilityElement(children: .contain)
            .accessibilityLabel(accessibilityLabel(title: title, subtitle: subtitle, isSearchActive: isSearchActive))
            .accessibilityAddTraits(.isHeader)
    }

    private func accessibilityLabel(title: String, subtitle: String?, isSearchActive: Bool) -> String {
        var label = "Navigation bar, \(title)"

        if let subtitle = subtitle {
            label += ", \(subtitle)"
        }

        if isSearchActive {
            label += ", search active"
        }

        return label
    }
}

// MARK: - Accessibility Identifiers

/// Standard accessibility identifiers for navigation bar components
public enum DSNavigationBarAccessibilityIdentifier {
    public static let navigationBar = "ds.navigationBar"
    public static let backButton = "ds.navigationBar.backButton"
    public static let title = "ds.navigationBar.title"
    public static let subtitle = "ds.navigationBar.subtitle"
    public static let largeTitle = "ds.navigationBar.largeTitle"
    public static let searchField = "ds.navigationBar.searchField"
    public static let searchClearButton = "ds.navigationBar.searchClearButton"
    public static let searchCancelButton = "ds.navigationBar.searchCancelButton"
    public static let leadingItems = "ds.navigationBar.leadingItems"
    public static let trailingItems = "ds.navigationBar.trailingItems"
}

// MARK: - Accessibility Modifier

/// A view modifier that enhances navigation bar accessibility
public struct DSNavigationBarAccessibilityModifier: ViewModifier {
    let title: String
    let subtitle: String?
    let isCollapsed: Bool
    let hasSearch: Bool
    let isSearchActive: Bool

    public init(
        title: String,
        subtitle: String? = nil,
        isCollapsed: Bool = false,
        hasSearch: Bool = false,
        isSearchActive: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isCollapsed = isCollapsed
        self.hasSearch = hasSearch
        self.isSearchActive = isSearchActive
    }

    public func body(content: Content) -> some View {
        content
            .accessibilityIdentifier(DSNavigationBarAccessibilityIdentifier.navigationBar)
            .accessibilityElement(children: .contain)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(.isHeader)
    }

    private var accessibilityLabel: String {
        var components: [String] = ["Navigation bar"]

        components.append(title)

        if let subtitle = subtitle {
            components.append(subtitle)
        }

        if isCollapsed {
            components.append("collapsed")
        }

        return components.joined(separator: ", ")
    }

    private var accessibilityHint: String {
        var hints: [String] = []

        if hasSearch {
            hints.append("Search available")
        }

        if isSearchActive {
            hints.append("Search is active")
        }

        return hints.joined(separator: ". ")
    }
}

// MARK: - View Extension

extension View {
    /// Applies comprehensive accessibility attributes to navigation bar
    public func dsNavigationBarAccessibilityEnhanced(
        title: String,
        subtitle: String? = nil,
        isCollapsed: Bool = false,
        hasSearch: Bool = false,
        isSearchActive: Bool = false
    ) -> some View {
        modifier(DSNavigationBarAccessibilityModifier(
            title: title,
            subtitle: subtitle,
            isCollapsed: isCollapsed,
            hasSearch: hasSearch,
            isSearchActive: isSearchActive
        ))
    }
}

// MARK: - VoiceOver Announcements

/// Utility for making VoiceOver announcements related to navigation
public struct DSNavigationBarAnnouncer {
    /// Announces navigation bar state changes
    public static func announceStateChange(
        title: String,
        isCollapsed: Bool
    ) {
        #if os(iOS)
        let message = isCollapsed
            ? "\(title), navigation bar collapsed"
            : "\(title), navigation bar expanded"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #endif
    }

    /// Announces search activation
    public static func announceSearchActivation(isActive: Bool) {
        #if os(iOS)
        let message = isActive
            ? "Search field activated"
            : "Search field deactivated"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #endif
    }

    /// Announces navigation
    public static func announceNavigation(destination: String) {
        #if os(iOS)
        let message = "Navigating to \(destination)"

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
        #endif
    }
}

// MARK: - Dynamic Type Support

/// Extension for handling Dynamic Type in navigation bars
public extension DSNavigationBarStyle {
    /// Returns adjusted heights based on current content size category
    func adjustedHeights(for sizeCategory: ContentSizeCategory) -> (standard: CGFloat, collapsed: CGFloat) {
        let multiplier = sizeCategory.scaleFactor

        return (
            standard: standardHeight * multiplier,
            collapsed: collapsedHeight * multiplier
        )
    }
}

extension ContentSizeCategory {
    var scaleFactor: CGFloat {
        switch self {
        case .extraSmall:
            return 0.85
        case .small:
            return 0.9
        case .medium:
            return 1.0
        case .large:
            return 1.0
        case .extraLarge:
            return 1.1
        case .extraExtraLarge:
            return 1.2
        case .extraExtraExtraLarge:
            return 1.3
        case .accessibilityMedium:
            return 1.4
        case .accessibilityLarge:
            return 1.5
        case .accessibilityExtraLarge:
            return 1.6
        case .accessibilityExtraExtraLarge:
            return 1.7
        case .accessibilityExtraExtraExtraLarge:
            return 1.8
        @unknown default:
            return 1.0
        }
    }
}

// MARK: - Reduce Motion Support

/// Extension for handling reduced motion preferences
public struct DSNavigationBarAnimationModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let animation: Animation

    public init(animation: Animation = .spring(response: 0.3, dampingFraction: 0.7)) {
        self.animation = animation
    }

    public func body(content: Content) -> some View {
        content
            .animation(reduceMotion ? .none : animation, value: UUID())
    }
}

extension View {
    /// Applies animation that respects reduce motion preference
    public func dsNavigationBarAnimation(_ animation: Animation = .spring(response: 0.3, dampingFraction: 0.7)) -> some View {
        modifier(DSNavigationBarAnimationModifier(animation: animation))
    }
}
