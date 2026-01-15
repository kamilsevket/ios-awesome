import SwiftUI

// MARK: - Scrollable Tab Bar

/// A horizontally scrollable tab bar for many tabs
///
/// Usage:
/// ```swift
/// DSScrollableTabBar(selection: $selectedCategory, items: categories)
/// ```
public struct DSScrollableTabBar<Tag: Hashable>: View {

    // MARK: - Properties

    @Binding private var selection: Tag
    private let items: [DSTabBarItem<Tag>]
    private let style: DSScrollableTabBarStyle
    private let size: DSScrollableTabBarSize
    private let tintColor: Color
    private let backgroundColor: Color?
    private let showsIndicator: Bool
    private let contentPadding: EdgeInsets

    @Namespace private var indicatorNamespace
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a scrollable tab bar
    /// - Parameters:
    ///   - selection: Binding to the currently selected tab
    ///   - items: Array of tab bar items
    ///   - style: Visual style of the tabs
    ///   - size: Size variant of the tabs
    ///   - tintColor: Color for selected state
    ///   - backgroundColor: Background color of the container
    ///   - showsIndicator: Whether to show scroll indicator
    ///   - contentPadding: Padding around the scrollable content
    public init(
        selection: Binding<Tag>,
        items: [DSTabBarItem<Tag>],
        style: DSScrollableTabBarStyle = .underline,
        size: DSScrollableTabBarSize = .standard,
        tintColor: Color = .blue,
        backgroundColor: Color? = nil,
        showsIndicator: Bool = false,
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    ) {
        self._selection = selection
        self.items = items
        self.style = style
        self.size = size
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.showsIndicator = showsIndicator
        self.contentPadding = contentPadding
    }

    // MARK: - Body

    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: showsIndicator) {
                HStack(spacing: style.itemSpacing) {
                    ForEach(items) { item in
                        tabItem(item)
                            .id(item.id)
                    }
                }
                .padding(contentPadding)
            }
            .background(resolvedBackgroundColor)
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .frame(height: size.height)
    }

    // MARK: - Tab Item

    @ViewBuilder
    private func tabItem(_ item: DSTabBarItem<Tag>) -> some View {
        let isSelected = selection == item.id

        Button(action: { selectTab(item.id) }) {
            tabItemContent(item, isSelected: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }

    @ViewBuilder
    private func tabItemContent(_ item: DSTabBarItem<Tag>, isSelected: Bool) -> some View {
        switch style {
        case .underline:
            underlineStyle(item, isSelected: isSelected)
        case .pill:
            pillStyle(item, isSelected: isSelected)
        case .chip:
            chipStyle(item, isSelected: isSelected)
        case .text:
            textStyle(item, isSelected: isSelected)
        }
    }

    // MARK: - Underline Style

    private func underlineStyle(_ item: DSTabBarItem<Tag>, isSelected: Bool) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                if !item.icon.isEmpty {
                    Image(systemName: item.icon(selected: isSelected))
                        .font(.system(size: size.iconSize, weight: isSelected ? .semibold : .regular))
                }

                if item.hasTitle {
                    Text(item.title)
                        .font(.system(size: size.fontSize, weight: isSelected ? .semibold : .medium))
                }
            }
            .foregroundColor(isSelected ? tintColor : .gray)
            .overlay(alignment: .topTrailing) {
                badgeOverlay(item)
            }

            // Underline indicator
            Rectangle()
                .fill(isSelected ? tintColor : Color.clear)
                .frame(height: 2)
                .cornerRadius(1)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Pill Style

    private func pillStyle(_ item: DSTabBarItem<Tag>, isSelected: Bool) -> some View {
        HStack(spacing: 6) {
            if !item.icon.isEmpty {
                Image(systemName: item.icon(selected: isSelected))
                    .font(.system(size: size.iconSize - 2, weight: isSelected ? .semibold : .regular))
            }

            if item.hasTitle {
                Text(item.title)
                    .font(.system(size: size.fontSize, weight: isSelected ? .semibold : .medium))
            }
        }
        .foregroundColor(isSelected ? .white : .gray)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            if isSelected {
                Capsule()
                    .fill(tintColor)
                    .matchedGeometryEffect(id: "scrollable-pill", in: indicatorNamespace)
            } else {
                Capsule()
                    .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
            }
        }
        .overlay(alignment: .topTrailing) {
            badgeOverlay(item)
                .offset(x: 8, y: -8)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    // MARK: - Chip Style

    private func chipStyle(_ item: DSTabBarItem<Tag>, isSelected: Bool) -> some View {
        HStack(spacing: 6) {
            if !item.icon.isEmpty {
                Image(systemName: item.icon(selected: isSelected))
                    .font(.system(size: size.iconSize - 4, weight: .medium))
            }

            if item.hasTitle {
                Text(item.title)
                    .font(.system(size: size.fontSize, weight: .medium))
            }
        }
        .foregroundColor(isSelected ? tintColor : .primary.opacity(0.7))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? tintColor.opacity(0.15) : Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isSelected ? tintColor : Color.clear, lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            badgeOverlay(item)
                .offset(x: 6, y: -6)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    // MARK: - Text Style

    private func textStyle(_ item: DSTabBarItem<Tag>, isSelected: Bool) -> some View {
        Text(item.title)
            .font(.system(size: size.fontSize, weight: isSelected ? .bold : .medium))
            .foregroundColor(isSelected ? tintColor : .gray)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(alignment: .topTrailing) {
                badgeOverlay(item)
                    .offset(x: 8, y: -4)
            }
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    // MARK: - Badge Overlay

    @ViewBuilder
    private func badgeOverlay(_ item: DSTabBarItem<Tag>) -> some View {
        if let badge = item.badge, badge.isVisible {
            DSTabBadgeView(badge: badge)
        }
    }

    // MARK: - Computed Properties

    private var resolvedBackgroundColor: Color {
        if let backgroundColor = backgroundColor {
            return backgroundColor
        }
        return colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.98)
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

// MARK: - Scrollable Tab Bar Style

/// Visual style for scrollable tab bar items
public enum DSScrollableTabBarStyle {
    /// Underline indicator below selected tab
    case underline
    /// Pill-shaped selection background
    case pill
    /// Chip/tag style with rounded corners
    case chip
    /// Text only with color change
    case text

    /// Spacing between tab items
    public var itemSpacing: CGFloat {
        switch self {
        case .underline:
            return 16
        case .pill:
            return 8
        case .chip:
            return 8
        case .text:
            return 12
        }
    }
}

// MARK: - Scrollable Tab Bar Size

/// Size variants for scrollable tab bar
public enum DSScrollableTabBarSize {
    /// Small compact size
    case small
    /// Standard size
    case standard
    /// Large size
    case large

    /// Height of the tab bar
    public var height: CGFloat {
        switch self {
        case .small:
            return 36
        case .standard:
            return 44
        case .large:
            return 52
        }
    }

    /// Font size for labels
    public var fontSize: CGFloat {
        switch self {
        case .small:
            return 13
        case .standard:
            return 15
        case .large:
            return 17
        }
    }

    /// Icon size
    public var iconSize: CGFloat {
        switch self {
        case .small:
            return 14
        case .standard:
            return 16
        case .large:
            return 20
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DSScrollableTabBar_Previews: PreviewProvider {
    enum Category: String, CaseIterable {
        case all = "All"
        case technology = "Technology"
        case sports = "Sports"
        case entertainment = "Entertainment"
        case business = "Business"
        case health = "Health"
        case science = "Science"
        case travel = "Travel"
    }

    struct PreviewWrapper: View {
        @State private var selected: Category = .all
        let style: DSScrollableTabBarStyle
        let size: DSScrollableTabBarSize

        var body: some View {
            VStack(spacing: 0) {
                DSScrollableTabBar(
                    selection: $selected,
                    items: Category.allCases.enumerated().map { index, category in
                        DSTabBarItem(
                            category,
                            title: category.rawValue,
                            icon: iconFor(category),
                            badge: index == 2 ? .count(5) : nil
                        )
                    },
                    style: style,
                    size: size
                )

                Spacer()

                Text("Selected: \(selected.rawValue)")
                    .font(.headline)

                Spacer()
            }
        }

        func iconFor(_ category: Category) -> String {
            switch category {
            case .all: return "square.grid.2x2"
            case .technology: return "laptopcomputer"
            case .sports: return "sportscourt"
            case .entertainment: return "film"
            case .business: return "briefcase"
            case .health: return "heart"
            case .science: return "atom"
            case .travel: return "airplane"
            }
        }
    }

    static var previews: some View {
        Group {
            PreviewWrapper(style: .underline, size: .standard)
                .previewDisplayName("Underline")

            PreviewWrapper(style: .pill, size: .standard)
                .previewDisplayName("Pill")

            PreviewWrapper(style: .chip, size: .standard)
                .previewDisplayName("Chip")

            PreviewWrapper(style: .text, size: .standard)
                .previewDisplayName("Text Only")

            PreviewWrapper(style: .pill, size: .large)
                .previewDisplayName("Large Pill")

            PreviewWrapper(style: .chip, size: .small)
                .previewDisplayName("Small Chip")
        }
    }
}
#endif
