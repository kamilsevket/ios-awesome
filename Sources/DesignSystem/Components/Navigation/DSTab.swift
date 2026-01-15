import SwiftUI

// MARK: - Tab View

/// Individual tab item view for DSTabBar
public struct DSTab<Tag: Hashable>: View {

    // MARK: - Properties

    private let item: DSTabBarItem<Tag>
    private let isSelected: Bool
    private let displayMode: DSTabDisplayMode
    private let size: DSTabBarSize
    private let tintColor: Color
    private let action: () -> Void

    @State private var isPressed = false

    // MARK: - Initialization

    /// Creates a tab view
    /// - Parameters:
    ///   - item: The tab bar item configuration
    ///   - isSelected: Whether this tab is currently selected
    ///   - displayMode: How to display the tab content
    ///   - size: Size variant of the tab bar
    ///   - tintColor: Color for selected state
    ///   - action: Action to perform when tapped
    public init(
        item: DSTabBarItem<Tag>,
        isSelected: Bool,
        displayMode: DSTabDisplayMode = .iconAndTitle,
        size: DSTabBarSize = .standard,
        tintColor: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.displayMode = displayMode
        self.size = size
        self.tintColor = tintColor
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: handleTap) {
            tabContent
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
        .frame(height: size.height)
        .contentShape(Rectangle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(isSelected ? "" : "Double tap to select")
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        VStack(spacing: size.iconTitleSpacing) {
            if shouldShowIcon {
                iconView
            }

            if shouldShowTitle {
                titleView
            }
        }
        .overlay(alignment: .topTrailing) {
            badgeView
        }
    }

    // MARK: - Icon View

    @ViewBuilder
    private var iconView: some View {
        Image(systemName: item.icon(selected: isSelected))
            .font(.system(size: size.iconSize, weight: isSelected ? .semibold : .regular))
            .foregroundColor(foregroundColor)
            .symbolRenderingMode(.hierarchical)
    }

    // MARK: - Title View

    @ViewBuilder
    private var titleView: some View {
        Text(item.title)
            .font(.system(size: size.fontSize, weight: isSelected ? .semibold : .medium))
            .foregroundColor(foregroundColor)
            .lineLimit(1)
    }

    // MARK: - Badge View

    @ViewBuilder
    private var badgeView: some View {
        if let badge = item.badge, badge.isVisible {
            DSTabBadgeView(badge: badge)
                .offset(x: badgeOffset.x, y: badgeOffset.y)
        }
    }

    // MARK: - Computed Properties

    private var shouldShowIcon: Bool {
        switch displayMode {
        case .iconAndTitle, .iconOnly:
            return true
        case .titleOnly:
            return false
        case .adaptive:
            return true
        }
    }

    private var shouldShowTitle: Bool {
        guard item.hasTitle else { return false }
        switch displayMode {
        case .iconAndTitle:
            return true
        case .iconOnly:
            return false
        case .titleOnly:
            return true
        case .adaptive:
            return true
        }
    }

    private var foregroundColor: Color {
        isSelected ? tintColor : .gray
    }

    private var badgeOffset: CGPoint {
        switch displayMode {
        case .iconOnly:
            return CGPoint(x: 8, y: -4)
        case .titleOnly:
            return CGPoint(x: 12, y: -2)
        default:
            return CGPoint(x: 10, y: -2)
        }
    }

    private var accessibilityLabel: String {
        var label = item.title.isEmpty ? "Tab" : item.title
        if let badge = item.badge, badge.isVisible {
            switch badge {
            case .count(let value):
                label += ", \(value) notifications"
            case .dot:
                label += ", has updates"
            case .text(let value):
                label += ", \(value)"
            }
        }
        return label
    }

    // MARK: - Actions

    private func handleTap() {
        triggerHapticFeedback()
        action()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        #endif
    }
}

// MARK: - Badge View

/// Badge overlay view for tab items
public struct DSTabBadgeView: View {

    // MARK: - Properties

    public let badge: DSTabBadge

    @State private var animationScale: CGFloat = 1.0

    // MARK: - Initialization

    public init(badge: DSTabBadge) {
        self.badge = badge
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if badge.isDot {
                dotBadge
            } else if let displayValue = badge.displayValue {
                textBadge(displayValue)
            }
        }
        .scaleEffect(animationScale)
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                animationScale = 1.0
            }
        }
        .onChange(of: badge) { _ in
            animateBadgeChange()
        }
    }

    // MARK: - Dot Badge

    private var dotBadge: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 8, height: 8)
    }

    // MARK: - Text Badge

    private func textBadge(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, text.count == 1 ? 5 : 4)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(Color.red)
            )
            .frame(minWidth: 16, minHeight: 16)
    }

    // MARK: - Animation

    private func animateBadgeChange() {
        animationScale = 0.5
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            animationScale = 1.0
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSTab_Previews: PreviewProvider {
    enum SampleTab: String, CaseIterable {
        case home
        case search
        case favorites
        case profile
    }

    static var previews: some View {
        VStack(spacing: 32) {
            // Standard tabs
            sectionHeader("Standard Tabs")
            HStack(spacing: 0) {
                DSTab(
                    item: DSTabBarItem(.home, title: "Home", icon: "house"),
                    isSelected: true,
                    action: {}
                )
                DSTab(
                    item: DSTabBarItem(.search, title: "Search", icon: "magnifyingglass"),
                    isSelected: false,
                    action: {}
                )
                DSTab(
                    item: DSTabBarItem(.favorites, title: "Favorites", icon: "heart", badge: .count(5)),
                    isSelected: false,
                    action: {}
                )
                DSTab(
                    item: DSTabBarItem(.profile, title: "Profile", icon: "person", badge: .dot),
                    isSelected: false,
                    action: {}
                )
            }
            .padding(.horizontal)

            // Icon only
            sectionHeader("Icon Only Mode")
            HStack(spacing: 0) {
                DSTab(
                    item: .iconOnly(.home, icon: "house"),
                    isSelected: true,
                    displayMode: .iconOnly,
                    action: {}
                )
                DSTab(
                    item: .iconOnly(.search, icon: "magnifyingglass"),
                    isSelected: false,
                    displayMode: .iconOnly,
                    action: {}
                )
                DSTab(
                    item: .iconOnly(.favorites, icon: "heart", badge: .count(99)),
                    isSelected: false,
                    displayMode: .iconOnly,
                    action: {}
                )
            }
            .padding(.horizontal)

            // Large size
            sectionHeader("Large Size")
            HStack(spacing: 0) {
                DSTab(
                    item: DSTabBarItem(.home, title: "Home", icon: "house"),
                    isSelected: true,
                    size: .large,
                    action: {}
                )
                DSTab(
                    item: DSTabBarItem(.search, title: "Search", icon: "magnifyingglass"),
                    isSelected: false,
                    size: .large,
                    action: {}
                )
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 32)
        .previewDisplayName("DSTab Variants")
    }

    static func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
}
#endif
