import SwiftUI

// MARK: - Page View Configuration

/// Configuration options for the page view.
public struct DSPageViewConfiguration: Sendable {
    /// Whether to show page indicators.
    public var showIndicators: Bool

    /// Style of the page indicators.
    public var indicatorStyle: DSPageIndicatorStyle

    /// Position of the page indicators.
    public var indicatorPosition: DSPageIndicatorPosition

    /// Whether to enable swipe gestures for navigation.
    public var swipeEnabled: Bool

    /// Whether to allow programmatic navigation.
    public var programmaticNavigation: Bool

    /// Animation duration for page transitions.
    public var animationDuration: Double

    public init(
        showIndicators: Bool = true,
        indicatorStyle: DSPageIndicatorStyle = .dots,
        indicatorPosition: DSPageIndicatorPosition = .bottom,
        swipeEnabled: Bool = true,
        programmaticNavigation: Bool = true,
        animationDuration: Double = 0.3
    ) {
        self.showIndicators = showIndicators
        self.indicatorStyle = indicatorStyle
        self.indicatorPosition = indicatorPosition
        self.swipeEnabled = swipeEnabled
        self.programmaticNavigation = programmaticNavigation
        self.animationDuration = animationDuration
    }
}

/// Position of page indicators.
public enum DSPageIndicatorPosition: Sendable {
    case top
    case bottom
    case overlay
}

// MARK: - DSPageView

/// A page view component for displaying full-screen pages with swipe navigation.
///
/// Example usage:
/// ```swift
/// let onboardingPages = [
///     OnboardingPage(title: "Welcome", image: "star"),
///     OnboardingPage(title: "Features", image: "gear"),
///     OnboardingPage(title: "Get Started", image: "rocket")
/// ]
///
/// DSPageView(pages: onboardingPages) { page in
///     OnboardingPageView(page: page)
/// }
/// .indicatorStyle(.capsule)
/// ```
public struct DSPageView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View where Data.Index == Int {
    // MARK: - Properties

    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    private var configuration: DSPageViewConfiguration

    @Binding private var currentPage: Int
    @State private var dragOffset: CGFloat = 0
    @GestureState private var isDragging: Bool = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initializers

    /// Creates a page view with a binding to the current page.
    /// - Parameters:
    ///   - data: Collection of page data
    ///   - id: KeyPath to identify each page
    ///   - currentPage: Binding to the current page index
    ///   - content: View builder for each page
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        currentPage: Binding<Int>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self._currentPage = currentPage
        self.content = content
        self.configuration = DSPageViewConfiguration()
    }

    /// Creates a page view with internal state management.
    /// - Parameters:
    ///   - data: Collection of page data
    ///   - id: KeyPath to identify each page
    ///   - content: View builder for each page
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self._currentPage = .constant(0)
        self.content = content
        self.configuration = DSPageViewConfiguration()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            if configuration.showIndicators && configuration.indicatorPosition == .top {
                indicatorView
                    .padding(.top, Spacing.sm)
            }

            GeometryReader { geometry in
                ZStack {
                    pageContent(geometry: geometry)

                    if configuration.showIndicators && configuration.indicatorPosition == .overlay {
                        VStack {
                            Spacer()
                            indicatorView
                                .padding(.bottom, Spacing.xl)
                        }
                    }
                }
            }

            if configuration.showIndicators && configuration.indicatorPosition == .bottom {
                indicatorView
                    .padding(.bottom, Spacing.sm)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Page view with \(data.count) pages")
        .accessibilityValue("Page \(currentPage + 1) of \(data.count)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                navigateToNext()
            case .decrement:
                navigateToPrevious()
            @unknown default:
                break
            }
        }
    }

    // MARK: - Private Views

    private func pageContent(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                content(item)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .offset(x: calculateOffset(containerWidth: geometry.size.width))
        .gesture(configuration.swipeEnabled ? dragGesture(containerWidth: geometry.size.width) : nil)
        .animation(
            reduceMotion ? nil : .spring(response: configuration.animationDuration, dampingFraction: 0.8),
            value: currentPage
        )
    }

    private var indicatorView: some View {
        DSPageIndicator(
            currentPage: currentPage,
            totalPages: data.count,
            style: configuration.indicatorStyle,
            onPageTap: { index in
                navigateToPage(index)
            }
        )
    }

    // MARK: - Gesture Handling

    private func dragGesture(containerWidth: CGFloat) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in
                state = true
            }
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                handleDragEnd(value: value, containerWidth: containerWidth)
            }
    }

    private func handleDragEnd(value: DragGesture.Value, containerWidth: CGFloat) {
        let threshold = containerWidth / 4
        let velocity = value.predictedEndTranslation.width - value.translation.width

        if value.translation.width < -threshold || velocity < -500 {
            navigateToNext()
        } else if value.translation.width > threshold || velocity > 500 {
            navigateToPrevious()
        }

        dragOffset = 0
    }

    // MARK: - Navigation

    private func calculateOffset(containerWidth: CGFloat) -> CGFloat {
        let pageOffset = CGFloat(currentPage) * -containerWidth
        return pageOffset + dragOffset
    }

    private func navigateToPage(_ index: Int) {
        guard configuration.programmaticNavigation else { return }

        let targetIndex = max(0, min(data.count - 1, index))

        if reduceMotion {
            currentPage = targetIndex
        } else {
            withAnimation(.spring(response: configuration.animationDuration, dampingFraction: 0.8)) {
                currentPage = targetIndex
            }
        }
    }

    private func navigateToNext() {
        if currentPage < data.count - 1 {
            navigateToPage(currentPage + 1)
        }
    }

    private func navigateToPrevious() {
        if currentPage > 0 {
            navigateToPage(currentPage - 1)
        }
    }
}

// MARK: - Identifiable Data Extension

extension DSPageView where Data.Element: Identifiable, ID == Data.Element.ID {
    /// Creates a page view with identifiable data.
    public init(
        pages: Data,
        currentPage: Binding<Int>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = pages
        self.id = \Data.Element.id
        self._currentPage = currentPage
        self.content = content
        self.configuration = DSPageViewConfiguration()
    }

    /// Creates a page view with identifiable data and internal state.
    public init(
        pages: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = pages
        self.id = \Data.Element.id
        self._currentPage = .constant(0)
        self.content = content
        self.configuration = DSPageViewConfiguration()
    }
}

// MARK: - Modifier Methods

extension DSPageView {
    /// Sets the indicator style.
    public func indicatorStyle(_ style: DSPageIndicatorStyle) -> DSPageView {
        var view = self
        view.configuration.indicatorStyle = style
        return view
    }

    /// Sets the indicator position.
    public func indicatorPosition(_ position: DSPageIndicatorPosition) -> DSPageView {
        var view = self
        view.configuration.indicatorPosition = position
        return view
    }

    /// Shows or hides page indicators.
    public func showIndicators(_ show: Bool = true) -> DSPageView {
        var view = self
        view.configuration.showIndicators = show
        return view
    }

    /// Enables or disables swipe navigation.
    public func swipeEnabled(_ enabled: Bool = true) -> DSPageView {
        var view = self
        view.configuration.swipeEnabled = enabled
        return view
    }

    /// Sets the animation duration for page transitions.
    public func animationDuration(_ duration: Double) -> DSPageView {
        var view = self
        view.configuration.animationDuration = duration
        return view
    }

    /// Applies a custom configuration.
    public func configuration(_ config: DSPageViewConfiguration) -> DSPageView {
        var view = self
        view.configuration = config
        return view
    }
}

// MARK: - Preview

#if DEBUG
struct DSPageView_Previews: PreviewProvider {
    static var previews: some View {
        PageViewPreviewContainer()
            .previewDisplayName("Page View Examples")
    }
}

private struct PageViewPreviewContainer: View {
    @State private var currentPage = 0

    let pages = [
        PageData(title: "Welcome", subtitle: "Get started with our app", color: .blue),
        PageData(title: "Discover", subtitle: "Explore amazing features", color: .purple),
        PageData(title: "Connect", subtitle: "Join our community", color: .green),
        PageData(title: "Start", subtitle: "Begin your journey", color: .orange)
    ]

    var body: some View {
        TabView {
            // Basic Page View
            DSPageView(pages, id: \.title, currentPage: $currentPage) { page in
                VStack(spacing: Spacing.lg) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)

                    Text(page.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(page.subtitle)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(page.color.gradient)
            }
            .indicatorStyle(.capsule)
            .tabItem {
                Label("Capsule", systemImage: "circle.fill")
            }

            // Dots Style
            DSPageView(pages, id: \.title, currentPage: $currentPage) { page in
                VStack(spacing: Spacing.lg) {
                    Text(page.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(page.subtitle)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
            }
            .indicatorStyle(.dots)
            .tabItem {
                Label("Dots", systemImage: "circle")
            }

            // Progress Style
            DSPageView(pages, id: \.title, currentPage: $currentPage) { page in
                VStack(spacing: Spacing.lg) {
                    Circle()
                        .fill(page.color)
                        .frame(width: 100, height: 100)

                    Text(page.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .indicatorStyle(.progress)
            .indicatorPosition(.top)
            .tabItem {
                Label("Progress", systemImage: "chart.bar.fill")
            }

            // Overlay Indicator
            DSPageView(pages, id: \.title, currentPage: $currentPage) { page in
                ZStack {
                    page.color.gradient
                        .ignoresSafeArea()

                    VStack {
                        Text(page.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .indicatorStyle(.numbered)
            .indicatorPosition(.overlay)
            .tabItem {
                Label("Overlay", systemImage: "square.stack")
            }
        }
    }
}

private struct PageData: Hashable {
    let title: String
    let subtitle: String
    let color: Color
}
#endif
