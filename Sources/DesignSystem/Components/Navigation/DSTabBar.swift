import SwiftUI

// MARK: - Tab Bar

/// A customizable tab bar component with animated selection indicator
///
/// Usage:
/// ```swift
/// DSTabBar(selection: $selectedTab, items: [
///     DSTabBarItem(.home, title: "Home", icon: "house"),
///     DSTabBarItem(.search, title: "Search", icon: "magnifyingglass"),
///     DSTabBarItem(.profile, title: "Profile", icon: "person", badge: .count(3))
/// ])
/// ```
public struct DSTabBar<Tag: Hashable>: View {

    // MARK: - Properties

    @Binding private var selection: Tag
    private let items: [DSTabBarItem<Tag>]
    private let style: DSTabBarStyle
    private let size: DSTabBarSize
    private let displayMode: DSTabDisplayMode
    private let tintColor: Color
    private let backgroundColor: Color
    private let showDivider: Bool
    private let safeAreaAware: Bool

    @Namespace private var indicatorNamespace
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a tab bar with the given items
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - items: Array of tab bar items
    ///   - style: Visual style of the tab bar
    ///   - size: Size variant of the tab bar
    ///   - displayMode: How to display tab content
    ///   - tintColor: Color for selected tab
    ///   - backgroundColor: Background color of the tab bar
    ///   - showDivider: Whether to show top divider
    ///   - safeAreaAware: Whether to add bottom safe area padding
    public init(
        selection: Binding<Tag>,
        items: [DSTabBarItem<Tag>],
        style: DSTabBarStyle = .standard,
        size: DSTabBarSize = .standard,
        displayMode: DSTabDisplayMode = .iconAndTitle,
        tintColor: Color = .blue,
        backgroundColor: Color? = nil,
        showDivider: Bool = true,
        safeAreaAware: Bool = true
    ) {
        self._selection = selection
        self.items = items
        self.style = style
        self.size = size
        self.displayMode = displayMode
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor ?? defaultBackgroundColor
        self.showDivider = showDivider
        self.safeAreaAware = safeAreaAware
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            if showDivider && style != .floating {
                divider
            }

            tabBarContent
                .frame(height: size.height)
                .background(tabBarBackground)
        }
        .background(safeAreaBackground)
    }

    // MARK: - Tab Bar Content

    @ViewBuilder
    private var tabBarContent: some View {
        switch style {
        case .standard:
            standardTabBar
        case .pill:
            pillTabBar
        case .underline:
            underlineTabBar
        case .floating:
            floatingTabBar
        }
    }

    // MARK: - Standard Style

    private var standardTabBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                DSTab(
                    item: item,
                    isSelected: selection == item.id,
                    displayMode: displayMode,
                    size: size,
                    tintColor: tintColor,
                    action: { selectTab(item.id) }
                )
            }
        }
    }

    // MARK: - Pill Style

    private var pillTabBar: some View {
        HStack(spacing: 4) {
            ForEach(items) { item in
                pillTabItem(item)
            }
        }
        .padding(.horizontal, 8)
    }

    private func pillTabItem(_ item: DSTabBarItem<Tag>) -> some View {
        let isSelected = selection == item.id

        return Button(action: { selectTab(item.id) }) {
            HStack(spacing: 6) {
                Image(systemName: item.icon(selected: isSelected))
                    .font(.system(size: size.iconSize - 2, weight: isSelected ? .semibold : .regular))

                if item.hasTitle && displayMode != .iconOnly {
                    Text(item.title)
                        .font(.system(size: size.fontSize + 1, weight: isSelected ? .semibold : .medium))
                        .lineLimit(1)
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background {
                if isSelected {
                    Capsule()
                        .fill(tintColor)
                        .matchedGeometryEffect(id: "pill", in: indicatorNamespace)
                }
            }
            .overlay {
                if let badge = item.badge, badge.isVisible {
                    DSTabBadgeView(badge: badge)
                        .offset(x: pillBadgeOffset(item), y: -12)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    private func pillBadgeOffset(_ item: DSTabBarItem<Tag>) -> CGFloat {
        if item.hasTitle && displayMode != .iconOnly {
            return CGFloat(item.title.count * 4)
        }
        return 16
    }

    // MARK: - Underline Style

    private var underlineTabBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(items) { item in
                    underlineTabItem(item)
                }
            }

            // Animated underline indicator
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / CGFloat(items.count)
                let selectedIndex = items.firstIndex { $0.id == selection } ?? 0

                Rectangle()
                    .fill(tintColor)
                    .frame(width: tabWidth - 32, height: 3)
                    .cornerRadius(1.5)
                    .offset(x: (tabWidth * CGFloat(selectedIndex)) + 16)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selection)
            }
            .frame(height: 3)
        }
    }

    private func underlineTabItem(_ item: DSTabBarItem<Tag>) -> some View {
        let isSelected = selection == item.id

        return Button(action: { selectTab(item.id) }) {
            VStack(spacing: size.iconTitleSpacing) {
                Image(systemName: item.icon(selected: isSelected))
                    .font(.system(size: size.iconSize, weight: isSelected ? .semibold : .regular))

                if item.hasTitle && displayMode != .iconOnly {
                    Text(item.title)
                        .font(.system(size: size.fontSize, weight: isSelected ? .semibold : .medium))
                        .lineLimit(1)
                }
            }
            .foregroundColor(isSelected ? tintColor : .gray)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .topTrailing) {
                if let badge = item.badge, badge.isVisible {
                    DSTabBadgeView(badge: badge)
                        .offset(x: 10, y: -2)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    // MARK: - Floating Style

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                DSTab(
                    item: item,
                    isSelected: selection == item.id,
                    displayMode: displayMode,
                    size: size,
                    tintColor: tintColor,
                    action: { selectTab(item.id) }
                )
            }
        }
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(backgroundColor)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 24)
    }

    // MARK: - Background Views

    private var divider: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 0.5)
    }

    @ViewBuilder
    private var tabBarBackground: some View {
        if style.hasBackground && style != .floating {
            backgroundColor
        }
    }

    @ViewBuilder
    private var safeAreaBackground: some View {
        if safeAreaAware {
            GeometryReader { geometry in
                backgroundColor
                    .frame(height: geometry.safeAreaInsets.bottom)
                    .offset(y: size.height)
            }
        }
    }

    private var defaultBackgroundColor: Color {
        colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.98)
    }

    // MARK: - Actions

    private func selectTab(_ tag: Tag) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selection = tag
        }
        triggerHapticFeedback()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - Result Builder Support

/// Result builder for declarative tab bar item creation
@resultBuilder
public struct DSTabBarBuilder<Tag: Hashable> {
    public static func buildBlock(_ components: DSTabBarItem<Tag>...) -> [DSTabBarItem<Tag>] {
        components
    }

    public static func buildArray(_ components: [[DSTabBarItem<Tag>]]) -> [DSTabBarItem<Tag>] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [DSTabBarItem<Tag>]?) -> [DSTabBarItem<Tag>] {
        component ?? []
    }

    public static func buildEither(first component: [DSTabBarItem<Tag>]) -> [DSTabBarItem<Tag>] {
        component
    }

    public static func buildEither(second component: [DSTabBarItem<Tag>]) -> [DSTabBarItem<Tag>] {
        component
    }
}

// MARK: - Convenience Initializer with Result Builder

extension DSTabBar {
    /// Creates a tab bar using result builder syntax
    /// ```swift
    /// DSTabBar(selection: $tab) {
    ///     DSTabBarItem(.home, title: "Home", icon: "house")
    ///     DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
    /// }
    /// ```
    public init(
        selection: Binding<Tag>,
        style: DSTabBarStyle = .standard,
        size: DSTabBarSize = .standard,
        displayMode: DSTabDisplayMode = .iconAndTitle,
        tintColor: Color = .blue,
        backgroundColor: Color? = nil,
        showDivider: Bool = true,
        safeAreaAware: Bool = true,
        @DSTabBarBuilder<Tag> items: () -> [DSTabBarItem<Tag>]
    ) {
        self.init(
            selection: selection,
            items: items(),
            style: style,
            size: size,
            displayMode: displayMode,
            tintColor: tintColor,
            backgroundColor: backgroundColor,
            showDivider: showDivider,
            safeAreaAware: safeAreaAware
        )
    }
}

// MARK: - View Extension

extension View {
    /// Adds a tab bar at the bottom of the view
    public func dsTabBar<Tag: Hashable>(
        selection: Binding<Tag>,
        items: [DSTabBarItem<Tag>],
        style: DSTabBarStyle = .standard,
        size: DSTabBarSize = .standard,
        displayMode: DSTabDisplayMode = .iconAndTitle,
        tintColor: Color = .blue
    ) -> some View {
        VStack(spacing: 0) {
            self
            DSTabBar(
                selection: selection,
                items: items,
                style: style,
                size: size,
                displayMode: displayMode,
                tintColor: tintColor
            )
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSTabBar_Previews: PreviewProvider {
    enum Tab: String, CaseIterable {
        case home
        case search
        case notifications
        case profile
    }

    struct PreviewWrapper: View {
        @State private var selectedTab: Tab = .home

        let style: DSTabBarStyle
        let displayMode: DSTabDisplayMode
        let size: DSTabBarSize

        var body: some View {
            VStack(spacing: 0) {
                Spacer()

                Text("Selected: \(selectedTab.rawValue)")
                    .font(.headline)

                Spacer()

                DSTabBar(selection: $selectedTab, style: style, size: size, displayMode: displayMode) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                    DSTabBarItem(.notifications, title: "Alerts", icon: "bell", badge: .count(5))
                    DSTabBarItem(.profile, title: "Profile", icon: "person", badge: .dot)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    static var previews: some View {
        Group {
            PreviewWrapper(style: .standard, displayMode: .iconAndTitle, size: .standard)
                .previewDisplayName("Standard")

            PreviewWrapper(style: .pill, displayMode: .iconAndTitle, size: .standard)
                .previewDisplayName("Pill Style")

            PreviewWrapper(style: .underline, displayMode: .iconAndTitle, size: .standard)
                .previewDisplayName("Underline Style")

            PreviewWrapper(style: .floating, displayMode: .iconAndTitle, size: .standard)
                .previewDisplayName("Floating Style")

            PreviewWrapper(style: .standard, displayMode: .iconOnly, size: .compact)
                .previewDisplayName("Icon Only - Compact")

            PreviewWrapper(style: .standard, displayMode: .iconAndTitle, size: .large)
                .previewDisplayName("Large Size")
        }
    }
}
#endif
