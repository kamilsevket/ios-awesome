import SwiftUI

// MARK: - DSNavigationBar

/// A customizable navigation bar component with iOS-style features
///
/// DSNavigationBar provides a flexible navigation bar implementation with support for:
/// - Large title mode with scroll-aware collapse
/// - Custom leading/trailing items
/// - Integrated search field
/// - Blur and transparent backgrounds
/// - Title and subtitle support
/// - Accessibility features
///
/// Example usage:
/// ```swift
/// DSNavigationBar(title: "Settings") {
///     DSBackButton()
/// } trailing: {
///     DSIconButton(icon: .gear) { }
/// }
/// .style(.largeTitle)
/// .searchable($searchText)
/// ```
public struct DSNavigationBar<Leading: View, Trailing: View>: View {
    // MARK: - Properties

    private let title: String
    private let subtitle: String?
    private let leading: Leading
    private let trailing: Trailing
    private var style: DSNavigationBarStyle
    private var backgroundStyle: DSNavigationBarBackgroundStyle
    private var shadowStyle: DSNavigationBarShadowStyle
    private var tintColor: Color
    private var titleColor: Color
    private var scrollOffset: CGFloat
    private var searchText: Binding<String>?
    private var isSearchActive: Binding<Bool>?
    private var searchPlaceholder: String
    private var showsDivider: Bool

    @Environment(\.colorScheme) private var colorScheme
    @State private var internalSearchActive = false

    private let collapseCalculator = DSScrollCollapseCalculator()

    // MARK: - Initialization

    /// Creates a navigation bar with title and leading/trailing views
    /// - Parameters:
    ///   - title: Main title text
    ///   - subtitle: Optional subtitle text
    ///   - leading: View builder for leading items
    ///   - trailing: View builder for trailing items
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading()
        self.trailing = trailing()
        self.style = .inline
        self.backgroundStyle = .defaultBlur
        self.shadowStyle = .subtle
        self.tintColor = .accentColor
        self.titleColor = .primary
        self.scrollOffset = 0
        self.searchText = nil
        self.isSearchActive = nil
        self.searchPlaceholder = "Search"
        self.showsDivider = true
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            navigationBarContent
                .frame(height: currentHeight)
                .background(backgroundView)
                .shadow(
                    color: shadowStyle.color.opacity(shadowOpacity),
                    radius: shadowStyle.radius,
                    x: shadowStyle.x,
                    y: shadowStyle.y
                )

            if showsDivider && collapseProgress > 0.5 {
                Divider()
                    .opacity(collapseProgress)
            }
        }
    }

    // MARK: - Navigation Bar Content

    @ViewBuilder
    private var navigationBarContent: some View {
        VStack(spacing: 0) {
            // Status bar spacer
            Spacer()
                .frame(height: safeAreaTop)

            // Main navigation bar area
            mainBarContent

            // Large title section (if applicable)
            if style.supportsCollapse && collapseProgress < 1 {
                largeTitleSection
            }

            // Search field (if enabled)
            if let searchText = searchText {
                searchFieldSection(searchText: searchText)
            }
        }
    }

    private var mainBarContent: some View {
        HStack(spacing: 8) {
            // Leading items
            HStack(spacing: 4) {
                leading
            }
            .frame(minWidth: 60, alignment: .leading)

            Spacer()

            // Inline title (shown when collapsed or inline style)
            if shouldShowInlineTitle {
                inlineTitleView
                    .opacity(inlineTitleOpacity)
            }

            Spacer()

            // Trailing items
            HStack(spacing: 4) {
                trailing
            }
            .frame(minWidth: 60, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
    }

    @ViewBuilder
    private var inlineTitleView: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(titleColor)
                .lineLimit(1)

            if let subtitle = subtitle, style == .inline {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }

    @ViewBuilder
    private var largeTitleSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: style.largeTitleSize, weight: .bold))
                .foregroundColor(titleColor)
                .lineLimit(1)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .opacity(largeTitleOpacity)
        .scaleEffect(largeTitleScale, anchor: .topLeading)
    }

    @ViewBuilder
    private func searchFieldSection(searchText: Binding<String>) -> some View {
        let isActive = isSearchActive ?? $internalSearchActive

        DSNavigationBarSearchField(
            text: searchText,
            isActive: isActive,
            placeholder: searchPlaceholder
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .opacity(searchFieldOpacity)
    }

    // MARK: - Background

    @ViewBuilder
    private var backgroundView: some View {
        switch backgroundStyle {
        case .solid(let color):
            color

        case .blur(let style):
            BlurView(style: style)

        case .gradient(let colors):
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )

        case .transparent:
            Color.clear
        }
    }

    // MARK: - Computed Properties

    private var collapseProgress: CGFloat {
        collapseCalculator.progress(for: scrollOffset)
    }

    private var currentHeight: CGFloat {
        let baseHeight = style.standardHeight + safeAreaTop

        if let _ = searchText {
            let searchHeight: CGFloat = 44
            let expandedHeight = baseHeight + searchHeight
            let collapsedHeight = style.collapsedHeight + safeAreaTop

            return collapseCalculator.height(
                expandedHeight: expandedHeight,
                collapsedHeight: collapsedHeight,
                progress: collapseProgress
            )
        }

        if style.supportsCollapse {
            return collapseCalculator.height(
                expandedHeight: baseHeight,
                collapsedHeight: style.collapsedHeight + safeAreaTop,
                progress: collapseProgress
            )
        }

        return baseHeight
    }

    private var safeAreaTop: CGFloat {
        #if os(iOS)
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.top ?? 0
        #else
        return 0
        #endif
    }

    private var shouldShowInlineTitle: Bool {
        switch style {
        case .inline, .transparent:
            return true
        case .largeTitle:
            return collapseProgress > 0.3
        case .custom(let config):
            return config.supportsCollapse ? collapseProgress > 0.3 : true
        }
    }

    private var inlineTitleOpacity: CGFloat {
        switch style {
        case .inline, .transparent:
            return 1
        case .largeTitle, .custom:
            return min(1, (collapseProgress - 0.3) / 0.7)
        }
    }

    private var largeTitleOpacity: CGFloat {
        collapseCalculator.largeTitleOpacity(for: collapseProgress)
    }

    private var largeTitleScale: CGFloat {
        collapseCalculator.largeTitleScale(for: collapseProgress)
    }

    private var searchFieldOpacity: CGFloat {
        max(0, 1 - collapseProgress * 1.5)
    }

    private var shadowOpacity: CGFloat {
        style == .transparent ? 0 : shadowStyle.opacity * min(1, collapseProgress + 0.3)
    }
}

// MARK: - Initializers for Empty Leading/Trailing

extension DSNavigationBar where Leading == EmptyView, Trailing == EmptyView {
    /// Creates a navigation bar with only a title
    public init(title: String, subtitle: String? = nil) {
        self.init(title: title, subtitle: subtitle) {
            EmptyView()
        } trailing: {
            EmptyView()
        }
    }
}

extension DSNavigationBar where Leading == EmptyView {
    /// Creates a navigation bar with title and trailing view
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.init(title: title, subtitle: subtitle) {
            EmptyView()
        } trailing: {
            trailing()
        }
    }
}

extension DSNavigationBar where Trailing == EmptyView {
    /// Creates a navigation bar with title and leading view
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leading: () -> Leading
    ) {
        self.init(title: title, subtitle: subtitle) {
            leading()
        } trailing: {
            EmptyView()
        }
    }
}

// MARK: - Modifiers

extension DSNavigationBar {
    /// Sets the navigation bar style
    public func style(_ style: DSNavigationBarStyle) -> DSNavigationBar {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the background style
    public func background(_ style: DSNavigationBarBackgroundStyle) -> DSNavigationBar {
        var copy = self
        copy.backgroundStyle = style
        return copy
    }

    /// Sets the shadow style
    public func shadow(_ style: DSNavigationBarShadowStyle) -> DSNavigationBar {
        var copy = self
        copy.shadowStyle = style
        return copy
    }

    /// Sets the tint color for interactive elements
    public func tintColor(_ color: Color) -> DSNavigationBar {
        var copy = self
        copy.tintColor = color
        return copy
    }

    /// Sets the title color
    public func titleColor(_ color: Color) -> DSNavigationBar {
        var copy = self
        copy.titleColor = color
        return copy
    }

    /// Binds the scroll offset for collapse behavior
    public func scrollOffset(_ offset: CGFloat) -> DSNavigationBar {
        var copy = self
        copy.scrollOffset = offset
        return copy
    }

    /// Adds a search field to the navigation bar
    public func searchable(
        _ text: Binding<String>,
        isActive: Binding<Bool>? = nil,
        placeholder: String = "Search"
    ) -> DSNavigationBar {
        var copy = self
        copy.searchText = text
        copy.isSearchActive = isActive
        copy.searchPlaceholder = placeholder
        return copy
    }

    /// Controls divider visibility
    public func showsDivider(_ show: Bool) -> DSNavigationBar {
        var copy = self
        copy.showsDivider = show
        return copy
    }
}

// MARK: - Blur View (UIKit Bridge)

#if os(iOS)
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#else
struct BlurView: View {
    let style: Any

    var body: some View {
        Color(.systemBackground).opacity(0.9)
    }
}
#endif
