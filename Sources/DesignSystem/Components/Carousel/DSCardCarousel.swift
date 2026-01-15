import SwiftUI

// MARK: - Card Carousel Configuration

/// Configuration options for the 3D card carousel.
public struct DSCardCarouselConfiguration: Sendable {
    /// Spacing between cards.
    public var cardSpacing: CGFloat

    /// Scale factor for non-focused cards (0.0 to 1.0).
    public var scaleEffect: CGFloat

    /// Opacity for non-focused cards (0.0 to 1.0).
    public var opacityEffect: CGFloat

    /// Rotation angle in degrees for 3D effect.
    public var rotationDegrees: Double

    /// Whether to show page indicators.
    public var showIndicators: Bool

    /// Indicator style.
    public var indicatorStyle: DSPageIndicatorStyle

    /// Whether to enable infinite loop.
    public var isLoopEnabled: Bool

    /// Auto-scroll interval (nil to disable).
    public var autoScrollInterval: TimeInterval?

    /// Enable/disable 3D perspective effect.
    public var enable3DEffect: Bool

    public init(
        cardSpacing: CGFloat = -40,
        scaleEffect: CGFloat = 0.85,
        opacityEffect: CGFloat = 0.6,
        rotationDegrees: Double = 15,
        showIndicators: Bool = true,
        indicatorStyle: DSPageIndicatorStyle = .capsule,
        isLoopEnabled: Bool = true,
        autoScrollInterval: TimeInterval? = nil,
        enable3DEffect: Bool = true
    ) {
        self.cardSpacing = cardSpacing
        self.scaleEffect = scaleEffect
        self.opacityEffect = opacityEffect
        self.rotationDegrees = rotationDegrees
        self.showIndicators = showIndicators
        self.indicatorStyle = indicatorStyle
        self.isLoopEnabled = isLoopEnabled
        self.autoScrollInterval = autoScrollInterval
        self.enable3DEffect = enable3DEffect
    }
}

// MARK: - DSCardCarousel

/// A 3D card carousel with perspective effects and smooth animations.
///
/// Example usage:
/// ```swift
/// let cards = [
///     CardItem(title: "Card 1", color: .blue),
///     CardItem(title: "Card 2", color: .purple),
///     CardItem(title: "Card 3", color: .green)
/// ]
///
/// DSCardCarousel(cards, id: \.title) { card in
///     RoundedRectangle(cornerRadius: 16)
///         .fill(card.color)
///         .overlay(Text(card.title))
/// }
/// .cardHeight(300)
/// .enable3DEffect()
/// ```
public struct DSCardCarousel<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    // MARK: - Properties

    private let data: Data
    private let id: KeyPath<Data.Element, ID>
    private let content: (Data.Element) -> Content
    private var configuration: DSCardCarouselConfiguration
    private var cardHeight: CGFloat = 280

    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var autoScrollTimer: Timer?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initializers

    /// Creates a card carousel.
    /// - Parameters:
    ///   - data: Collection of card data
    ///   - id: KeyPath to identify each card
    ///   - content: View builder for each card
    public init(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = id
        self.content = content
        self.configuration = DSCardCarouselConfiguration()
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: Spacing.md) {
            GeometryReader { geometry in
                let cardWidth = calculateCardWidth(containerWidth: geometry.size.width)

                ZStack {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        cardView(
                            item: item,
                            index: index,
                            cardWidth: cardWidth,
                            containerWidth: geometry.size.width
                        )
                    }
                }
                .frame(width: geometry.size.width, height: cardHeight)
                .gesture(dragGesture(cardWidth: cardWidth))
            }
            .frame(height: cardHeight)

            if configuration.showIndicators && data.count > 1 {
                DSPageIndicator(
                    currentPage: currentIndex,
                    totalPages: data.count,
                    style: configuration.indicatorStyle,
                    onPageTap: { index in
                        navigateToIndex(index)
                    }
                )
            }
        }
        .onAppear {
            setupAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Card carousel with \(data.count) cards")
        .accessibilityValue("Card \(currentIndex + 1) of \(data.count)")
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

    // MARK: - Card View

    private func cardView(
        item: Data.Element,
        index: Int,
        cardWidth: CGFloat,
        containerWidth: CGFloat
    ) -> some View {
        let offset = calculateCardOffset(index: index, cardWidth: cardWidth, containerWidth: containerWidth)
        let scale = calculateScale(index: index)
        let opacity = calculateOpacity(index: index)
        let rotation = calculateRotation(index: index)
        let zIndex = calculateZIndex(index: index)

        return content(item)
            .frame(width: cardWidth, height: cardHeight - Spacing.xl)
            .scaleEffect(reduceMotion ? 1.0 : scale)
            .opacity(opacity)
            .rotation3DEffect(
                .degrees(reduceMotion ? 0 : rotation),
                axis: (x: 0, y: 1, z: 0),
                perspective: configuration.enable3DEffect ? 0.5 : 0
            )
            .offset(x: offset)
            .zIndex(zIndex)
            .animation(
                reduceMotion ? nil : .spring(response: 0.4, dampingFraction: 0.75),
                value: currentIndex
            )
            .animation(
                reduceMotion ? nil : .interactiveSpring(),
                value: dragOffset
            )
    }

    // MARK: - Calculations

    private func calculateCardWidth(containerWidth: CGFloat) -> CGFloat {
        return containerWidth * 0.75
    }

    private func calculateCardOffset(index: Int, cardWidth: CGFloat, containerWidth: CGFloat) -> CGFloat {
        let centerOffset = (containerWidth - cardWidth) / 2
        let indexDiff = CGFloat(index - currentIndex)
        let baseOffset = indexDiff * (cardWidth + configuration.cardSpacing)
        return centerOffset + baseOffset + dragOffset
    }

    private func calculateScale(index: Int) -> CGFloat {
        let distance = abs(CGFloat(index - currentIndex))
        let dragInfluence = abs(dragOffset) / 200

        if index == currentIndex {
            return 1.0 - dragInfluence * (1.0 - configuration.scaleEffect) * 0.5
        }

        let baseScale = configuration.scaleEffect
        return max(baseScale - distance * 0.1, 0.7)
    }

    private func calculateOpacity(index: Int) -> CGFloat {
        let distance = abs(CGFloat(index - currentIndex))

        if index == currentIndex {
            return 1.0
        }

        return max(configuration.opacityEffect - distance * 0.2, 0.3)
    }

    private func calculateRotation(index: Int) -> Double {
        guard configuration.enable3DEffect else { return 0 }

        let indexDiff = index - currentIndex
        let dragInfluence = dragOffset / 300

        if indexDiff < 0 {
            return configuration.rotationDegrees - dragInfluence * configuration.rotationDegrees
        } else if indexDiff > 0 {
            return -configuration.rotationDegrees - dragInfluence * configuration.rotationDegrees
        }

        return -dragInfluence * configuration.rotationDegrees
    }

    private func calculateZIndex(index: Int) -> Double {
        let distance = abs(index - currentIndex)
        return Double(data.count - distance)
    }

    // MARK: - Gesture Handling

    private func dragGesture(cardWidth: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                dragOffset = value.translation.width

                if configuration.autoScrollInterval != nil {
                    stopAutoScroll()
                }
            }
            .onEnded { value in
                isDragging = false
                let threshold = cardWidth / 3
                let velocity = value.predictedEndTranslation.width - value.translation.width

                if value.translation.width < -threshold || velocity < -500 {
                    navigateToNext()
                } else if value.translation.width > threshold || velocity > 500 {
                    navigateToPrevious()
                }

                dragOffset = 0

                if configuration.autoScrollInterval != nil {
                    setupAutoScroll()
                }
            }
    }

    // MARK: - Navigation

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
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
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

    // MARK: - Auto-scroll

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

extension DSCardCarousel where Data.Element: Identifiable, ID == Data.Element.ID {
    /// Creates a card carousel with identifiable data.
    public init(
        _ data: Data,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.id = \Data.Element.id
        self.content = content
        self.configuration = DSCardCarouselConfiguration()
    }
}

// MARK: - Modifier Methods

extension DSCardCarousel {
    /// Sets the card height.
    public func cardHeight(_ height: CGFloat) -> DSCardCarousel {
        var carousel = self
        carousel.cardHeight = height
        return carousel
    }

    /// Sets the spacing between cards.
    public func cardSpacing(_ spacing: CGFloat) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.cardSpacing = spacing
        return carousel
    }

    /// Sets the scale effect for non-focused cards.
    public func scaleEffect(_ scale: CGFloat) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.scaleEffect = scale
        return carousel
    }

    /// Sets the opacity for non-focused cards.
    public func opacityEffect(_ opacity: CGFloat) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.opacityEffect = opacity
        return carousel
    }

    /// Enables or disables 3D effect.
    public func enable3DEffect(_ enabled: Bool = true) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.enable3DEffect = enabled
        return carousel
    }

    /// Sets the rotation degrees for 3D effect.
    public func rotationDegrees(_ degrees: Double) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.rotationDegrees = degrees
        return carousel
    }

    /// Shows or hides indicators.
    public func showIndicators(_ show: Bool = true) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.showIndicators = show
        return carousel
    }

    /// Sets the indicator style.
    public func indicatorStyle(_ style: DSPageIndicatorStyle) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.indicatorStyle = style
        return carousel
    }

    /// Enables or disables loop scrolling.
    public func loopEnabled(_ enabled: Bool = true) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.isLoopEnabled = enabled
        return carousel
    }

    /// Enables auto-scroll with specified interval.
    public func autoScroll(interval: TimeInterval) -> DSCardCarousel {
        var carousel = self
        carousel.configuration.autoScrollInterval = interval
        return carousel
    }

    /// Applies a custom configuration.
    public func configuration(_ config: DSCardCarouselConfiguration) -> DSCardCarousel {
        var carousel = self
        carousel.configuration = config
        return carousel
    }
}

// MARK: - Preview

#if DEBUG
struct DSCardCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CardCarouselPreviewContainer()
            .previewDisplayName("Card Carousel Examples")
    }
}

private struct CardCarouselPreviewContainer: View {
    let cards = [
        CardPreviewItem(title: "Explore", subtitle: "Discover new places", color: .blue, icon: "map.fill"),
        CardPreviewItem(title: "Connect", subtitle: "Meet new people", color: .purple, icon: "person.2.fill"),
        CardPreviewItem(title: "Create", subtitle: "Share your story", color: .orange, icon: "pencil.circle.fill"),
        CardPreviewItem(title: "Grow", subtitle: "Learn every day", color: .green, icon: "leaf.fill"),
        CardPreviewItem(title: "Achieve", subtitle: "Reach your goals", color: .red, icon: "star.fill")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xxl) {
                Text("3D Card Carousel")
                    .font(.headline)

                DSCardCarousel(cards, id: \.title) { card in
                    cardView(card: card)
                }
                .cardHeight(300)
                .enable3DEffect()

                Divider()
                    .padding(.horizontal)

                Text("Flat Card Carousel")
                    .font(.headline)

                DSCardCarousel(cards, id: \.title) { card in
                    cardView(card: card)
                }
                .cardHeight(250)
                .enable3DEffect(false)
                .scaleEffect(0.9)
                .indicatorStyle(.dots)

                Divider()
                    .padding(.horizontal)

                Text("Auto-scroll Carousel")
                    .font(.headline)

                DSCardCarousel(cards, id: \.title) { card in
                    cardView(card: card)
                }
                .cardHeight(220)
                .autoScroll(interval: 2.5)
                .indicatorStyle(.progress)

                Spacer(minLength: Spacing.xxl)
            }
            .padding(.vertical)
        }
    }

    private func cardView(card: CardPreviewItem) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(card.color.gradient)
            .overlay(
                VStack(spacing: Spacing.md) {
                    Image(systemName: card.icon)
                        .font(.system(size: 48))
                        .foregroundColor(.white)

                    Text(card.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(card.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            )
            .shadow(color: card.color.opacity(0.4), radius: 15, x: 0, y: 10)
    }
}

private struct CardPreviewItem: Hashable {
    let title: String
    let subtitle: String
    let color: Color
    let icon: String
}
#endif
