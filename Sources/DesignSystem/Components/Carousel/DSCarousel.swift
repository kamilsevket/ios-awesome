import SwiftUI

// MARK: - Carousel Configuration

/// Configuration options for the carousel behavior.
public struct DSCarouselConfiguration: Sendable {
    /// Spacing between items in the carousel.
    public var itemSpacing: CGFloat

    /// Horizontal padding for the carousel container.
    public var horizontalPadding: CGFloat

    /// Whether to show page indicators.
    public var showIndicators: Bool

    /// Whether to enable infinite/loop scrolling.
    public var isLoopEnabled: Bool

    /// Whether to show peek of adjacent items.
    public var showPeek: Bool

    /// Amount of peek for adjacent items.
    public var peekAmount: CGFloat

    /// Whether to snap to items.
    public var snapEnabled: Bool

    /// Auto-scroll interval in seconds (nil to disable).
    public var autoScrollInterval: TimeInterval?

    /// Whether auto-scroll pauses on user interaction.
    public var pauseAutoScrollOnInteraction: Bool

    public init(
        itemSpacing: CGFloat = Spacing.md,
        horizontalPadding: CGFloat = Spacing.md,
        showIndicators: Bool = true,
        isLoopEnabled: Bool = false,
        showPeek: Bool = false,
        peekAmount: CGFloat = 20,
        snapEnabled: Bool = true,
        autoScrollInterval: TimeInterval? = nil,
        pauseAutoScrollOnInteraction: Bool = true
    ) {
        self.itemSpacing = itemSpacing
        self.horizontalPadding = horizontalPadding
        self.showIndicators = showIndicators
        self.isLoopEnabled = isLoopEnabled
        self.showPeek = showPeek
        self.peekAmount = peekAmount
        self.snapEnabled = snapEnabled
        self.autoScrollInterval = autoScrollInterval
        self.pauseAutoScrollOnInteraction = pauseAutoScrollOnInteraction
    }
}

// MARK: - DSCarousel

/// A horizontal scrolling carousel component with snap behavior and page indicators.
///
/// Example usage:
/// ```swift
/// let items = ["Item 1", "Item 2", "Item 3"]
///
/// DSCarousel(items, id: \.self) { item in
///     Text(item)
///         .frame(maxWidth: .infinity)
///         .frame(height: 200)
///         .background(Color.blue)
///         .cornerRadius(12)
/// }
/// .showIndicators()
/// .autoScroll(interval: 3)
/// ```
public struct DSCarousel<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    // MARK: - Properties

    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    private var configuration: DSCarouselConfiguration

    @State private var currentIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var autoScrollTimer: Timer?
    @State private var containerWidth: CGFloat = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initializers

    /// Creates a carousel with identifiable data.
    /// - Parameters:
    ///   - data: Collection of items to display
    ///   - id: KeyPath to identify each item
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.content = content
        self.configuration = DSCarouselConfiguration()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: Spacing.sm) {
            GeometryReader { geometry in
                let itemWidth = calculateItemWidth(containerWidth: geometry.size.width)

                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: configuration.itemSpacing) {
                            ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                                content(item)
                                    .frame(width: itemWidth)
                                    .id(index)
                            }
                        }
                        .padding(.horizontal, configuration.horizontalPadding)
                    }
                    .scrollTargetBehavior(configuration.snapEnabled ? .paging : .automatic)
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { _ in
                                handleDragStart()
                            }
                            .onEnded { value in
                                handleDragEnd(value: value, itemWidth: itemWidth, scrollProxy: scrollProxy)
                            }
                    )
                    .onChange(of: currentIndex) { _, newValue in
                        scrollToIndex(newValue, proxy: scrollProxy)
                    }
                    .onAppear {
                        containerWidth = geometry.size.width
                        setupAutoScroll()
                    }
                    .onDisappear {
                        stopAutoScroll()
                    }
                }
            }
            .frame(height: nil)

            if configuration.showIndicators && data.count > 1 {
                DSPageIndicator(
                    currentPage: currentIndex,
                    totalPages: data.count,
                    onPageTap: { index in
                        navigateToIndex(index)
                    }
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Carousel with \(data.count) items")
        .accessibilityValue("Page \(currentIndex + 1) of \(data.count)")
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

    // MARK: - Private Methods

    private func calculateItemWidth(containerWidth: CGFloat) -> CGFloat {
        let totalPadding = configuration.horizontalPadding * 2
        let peekWidth = configuration.showPeek ? configuration.peekAmount * 2 : 0
        return containerWidth - totalPadding - peekWidth
    }

    private func handleDragStart() {
        isDragging = true
        if configuration.pauseAutoScrollOnInteraction {
            stopAutoScroll()
        }
    }

    private func handleDragEnd(value: DragGesture.Value, itemWidth: CGFloat, scrollProxy: ScrollViewProxy) {
        isDragging = false

        if configuration.snapEnabled {
            let threshold = itemWidth / 3
            let translation = value.translation.width

            if translation < -threshold {
                navigateToNext()
            } else if translation > threshold {
                navigateToPrevious()
            }
        }

        if configuration.autoScrollInterval != nil && configuration.pauseAutoScrollOnInteraction {
            setupAutoScroll()
        }
    }

    private func navigateToIndex(_ index: Int) {
        var targetIndex = index

        if configuration.isLoopEnabled {
            if targetIndex < 0 {
                targetIndex = data.count - 1
            } else if targetIndex >= data.count {
                targetIndex = 0
            }
        } else {
            targetIndex = max(0, min(data.count - 1, targetIndex))
        }

        if reduceMotion {
            currentIndex = targetIndex
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentIndex = targetIndex
            }
        }
    }

    private func navigateToNext() {
        navigateToIndex(currentIndex + 1)
    }

    private func navigateToPrevious() {
        navigateToIndex(currentIndex - 1)
    }

    private func scrollToIndex(_ index: Int, proxy: ScrollViewProxy) {
        if reduceMotion {
            proxy.scrollTo(index, anchor: .center)
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                proxy.scrollTo(index, anchor: .center)
            }
        }
    }

    private func setupAutoScroll() {
        guard let interval = configuration.autoScrollInterval, !reduceMotion else { return }

        stopAutoScroll()

        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if !isDragging {
                navigateToNext()
            }
        }
    }

    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
}

// MARK: - Identifiable Data Extension

extension DSCarousel where Data.Element: Identifiable, ID == Data.Element.ID {
    /// Creates a carousel with identifiable data.
    /// - Parameters:
    ///   - data: Collection of identifiable items
    ///   - content: View builder for each item
    public init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = \Data.Element.id
        self.content = content
        self.configuration = DSCarouselConfiguration()
    }
}

// MARK: - Modifier Methods

extension DSCarousel {
    /// Shows or hides page indicators.
    public func showIndicators(_ show: Bool = true) -> DSCarousel {
        var carousel = self
        carousel.configuration.showIndicators = show
        return carousel
    }

    /// Enables auto-scroll with the specified interval.
    public func autoScroll(interval: TimeInterval) -> DSCarousel {
        var carousel = self
        carousel.configuration.autoScrollInterval = interval
        return carousel
    }

    /// Enables or disables infinite loop scrolling.
    public func loopEnabled(_ enabled: Bool = true) -> DSCarousel {
        var carousel = self
        carousel.configuration.isLoopEnabled = enabled
        return carousel
    }

    /// Shows peek of adjacent items.
    public func showPeek(_ amount: CGFloat = 20) -> DSCarousel {
        var carousel = self
        carousel.configuration.showPeek = true
        carousel.configuration.peekAmount = amount
        return carousel
    }

    /// Sets the spacing between carousel items.
    public func itemSpacing(_ spacing: CGFloat) -> DSCarousel {
        var carousel = self
        carousel.configuration.itemSpacing = spacing
        return carousel
    }

    /// Sets the horizontal padding for the carousel.
    public func horizontalPadding(_ padding: CGFloat) -> DSCarousel {
        var carousel = self
        carousel.configuration.horizontalPadding = padding
        return carousel
    }

    /// Enables or disables snap behavior.
    public func snapEnabled(_ enabled: Bool = true) -> DSCarousel {
        var carousel = self
        carousel.configuration.snapEnabled = enabled
        return carousel
    }

    /// Configures whether auto-scroll pauses on user interaction.
    public func pauseAutoScrollOnInteraction(_ pause: Bool = true) -> DSCarousel {
        var carousel = self
        carousel.configuration.pauseAutoScrollOnInteraction = pause
        return carousel
    }

    /// Applies a custom configuration to the carousel.
    public func configuration(_ config: DSCarouselConfiguration) -> DSCarousel {
        var carousel = self
        carousel.configuration = config
        return carousel
    }
}

// MARK: - Preview

#if DEBUG
struct DSCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPreviewContainer()
            .previewDisplayName("Carousel Examples")
    }
}

private struct CarouselPreviewContainer: View {
    let items = ["First", "Second", "Third", "Fourth", "Fifth"]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                Text("Basic Carousel")
                    .font(.headline)

                DSCarousel(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.gradient)
                        .frame(height: 180)
                        .overlay(
                            Text(item)
                                .font(.title2)
                                .foregroundColor(.white)
                        )
                }
                .frame(height: 220)

                Divider()

                Text("Carousel with Peek")
                    .font(.headline)

                DSCarousel(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.gradient)
                        .frame(height: 160)
                        .overlay(
                            Text(item)
                                .font(.title3)
                                .foregroundColor(.white)
                        )
                }
                .showPeek(30)
                .frame(height: 200)

                Divider()

                Text("Auto-scroll Carousel")
                    .font(.headline)

                DSCarousel(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.gradient)
                        .frame(height: 140)
                        .overlay(
                            Text(item)
                                .font(.title3)
                                .foregroundColor(.white)
                        )
                }
                .autoScroll(interval: 3)
                .loopEnabled()
                .frame(height: 180)

                Divider()

                Text("No Indicators")
                    .font(.headline)

                DSCarousel(items, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.gradient)
                        .frame(height: 120)
                        .overlay(
                            Text(item)
                                .foregroundColor(.white)
                        )
                }
                .showIndicators(false)
                .frame(height: 130)
            }
            .padding()
        }
    }
}
#endif
