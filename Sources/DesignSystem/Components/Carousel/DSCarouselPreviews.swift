import SwiftUI

#if DEBUG

// MARK: - Combined Preview

struct DSCarouselPreviews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CarouselShowcase()
                .navigationTitle("Carousel Components")
        }
        .previewDisplayName("Carousel Showcase")
    }
}

// MARK: - Showcase View

private struct CarouselShowcase: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            BasicCarouselDemo()
                .tabItem {
                    Label("Carousel", systemImage: "rectangle.stack")
                }
                .tag(0)

            PageViewDemo()
                .tabItem {
                    Label("PageView", systemImage: "book")
                }
                .tag(1)

            CardCarouselDemo()
                .tabItem {
                    Label("3D Cards", systemImage: "rectangle.3.group.fill")
                }
                .tag(2)

            IndicatorDemo()
                .tabItem {
                    Label("Indicators", systemImage: "circle.grid.2x2")
                }
                .tag(3)
        }
    }
}

// MARK: - Basic Carousel Demo

private struct BasicCarouselDemo: View {
    let items = Array(1...6).map { "Item \($0)" }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xxl) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Basic Carousel")
                        .font(.headline)
                        .padding(.horizontal)

                    DSCarousel(items, id: \.self) { item in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.gradient)
                            .frame(height: 180)
                            .overlay(
                                Text(item)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                    .frame(height: 220)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Peek Carousel")
                        .font(.headline)
                        .padding(.horizontal)

                    DSCarousel(items, id: \.self) { item in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.purple.gradient)
                            .frame(height: 150)
                            .overlay(
                                Text(item)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }
                    .showPeek(40)
                    .frame(height: 190)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Auto-scroll Carousel")
                        .font(.headline)
                        .padding(.horizontal)

                    DSCarousel(items, id: \.self) { item in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.orange.gradient)
                            .frame(height: 140)
                            .overlay(
                                Text(item)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            )
                    }
                    .autoScroll(interval: 3)
                    .loopEnabled()
                    .frame(height: 180)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("No Indicators")
                        .font(.headline)
                        .padding(.horizontal)

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
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Page View Demo

private struct PageViewDemo: View {
    @State private var currentPage = 0

    let pages = [
        OnboardingPage(title: "Welcome", subtitle: "Get started with our app", icon: "star.fill", color: .blue),
        OnboardingPage(title: "Discover", subtitle: "Explore amazing features", icon: "magnifyingglass", color: .purple),
        OnboardingPage(title: "Connect", subtitle: "Join our community", icon: "person.2.fill", color: .green),
        OnboardingPage(title: "Create", subtitle: "Build something great", icon: "hammer.fill", color: .orange)
    ]

    var body: some View {
        VStack(spacing: 0) {
            DSPageView(pages, id: \.title, currentPage: $currentPage) { page in
                VStack(spacing: Spacing.lg) {
                    Spacer()

                    Image(systemName: page.icon)
                        .font(.system(size: 80))
                        .foregroundColor(page.color)

                    Text(page.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(page.subtitle)
                        .font(.body)
                        .foregroundColor(.secondary)

                    Spacer()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .indicatorStyle(.capsule)

            HStack(spacing: Spacing.md) {
                if currentPage > 0 {
                    Button("Back") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                if currentPage < pages.count - 1 {
                    Button("Next") {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Button("Get Started") {
                        // Action
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}

private struct OnboardingPage: Hashable {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

// MARK: - Card Carousel Demo

private struct CardCarouselDemo: View {
    let cards = [
        FeatureCard(title: "Analytics", subtitle: "Track your progress", icon: "chart.bar.fill", color: .blue),
        FeatureCard(title: "Security", subtitle: "Keep data safe", icon: "lock.shield.fill", color: .green),
        FeatureCard(title: "Speed", subtitle: "Lightning fast", icon: "bolt.fill", color: .yellow),
        FeatureCard(title: "Support", subtitle: "24/7 assistance", icon: "headphones", color: .purple),
        FeatureCard(title: "Updates", subtitle: "Always improving", icon: "arrow.triangle.2.circlepath", color: .orange)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xxl) {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("3D Card Carousel")
                        .font(.headline)
                        .padding(.horizontal)

                    DSCardCarousel(cards, id: \.title) { card in
                        RoundedRectangle(cornerRadius: 24)
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
                    .cardHeight(300)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Flat Cards")
                        .font(.headline)
                        .padding(.horizontal)

                    DSCardCarousel(cards, id: \.title) { card in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .overlay(
                                VStack(spacing: Spacing.sm) {
                                    Circle()
                                        .fill(card.color.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Image(systemName: card.icon)
                                                .font(.system(size: 24))
                                                .foregroundColor(card.color)
                                        )

                                    Text(card.title)
                                        .font(.headline)

                                    Text(card.subtitle)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            )
                    }
                    .cardHeight(200)
                    .enable3DEffect(false)
                    .scaleEffect(0.9)
                    .indicatorStyle(.dots)
                }

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Auto-scroll Cards")
                        .font(.headline)
                        .padding(.horizontal)

                    DSCardCarousel(cards, id: \.title) { card in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(card.color.gradient)
                            .overlay(
                                HStack {
                                    Image(systemName: card.icon)
                                        .font(.title)
                                        .foregroundColor(.white)

                                    VStack(alignment: .leading) {
                                        Text(card.title)
                                            .font(.headline)
                                            .foregroundColor(.white)

                                        Text(card.subtitle)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }

                                    Spacer()
                                }
                                .padding()
                            )
                    }
                    .cardHeight(100)
                    .enable3DEffect(false)
                    .autoScroll(interval: 2.5)
                    .indicatorStyle(.progress)
                }
            }
            .padding(.vertical)
        }
    }
}

private struct FeatureCard: Hashable {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

// MARK: - Indicator Demo

private struct IndicatorDemo: View {
    @State private var currentPage = 2

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xxl) {
                VStack(spacing: Spacing.lg) {
                    Text("Indicator Styles")
                        .font(.headline)

                    Group {
                        Text("Dots")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .dots,
                            onPageTap: { currentPage = $0 }
                        )
                    }

                    Group {
                        Text("Capsule")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .capsule,
                            onPageTap: { currentPage = $0 }
                        )
                    }

                    Group {
                        Text("Numbered")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .numbered
                        )
                    }

                    Group {
                        Text("Progress")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .progress
                        )
                        .frame(width: 150)
                    }
                }

                Divider()

                VStack(spacing: Spacing.lg) {
                    Text("Indicator Sizes")
                        .font(.headline)

                    HStack(spacing: Spacing.xl) {
                        VStack {
                            Text("Small")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            DSPageIndicator(
                                currentPage: currentPage,
                                totalPages: 5,
                                style: .dots,
                                size: .small
                            )
                        }

                        VStack {
                            Text("Medium")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            DSPageIndicator(
                                currentPage: currentPage,
                                totalPages: 5,
                                style: .dots,
                                size: .medium
                            )
                        }

                        VStack {
                            Text("Large")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            DSPageIndicator(
                                currentPage: currentPage,
                                totalPages: 5,
                                style: .dots,
                                size: .large
                            )
                        }
                    }
                }

                Divider()

                VStack(spacing: Spacing.lg) {
                    Text("Custom Colors")
                        .font(.headline)

                    HStack(spacing: Spacing.xl) {
                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .capsule,
                            activeColor: .purple,
                            inactiveColor: .purple.opacity(0.3)
                        )

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .capsule,
                            activeColor: .green,
                            inactiveColor: .green.opacity(0.3)
                        )

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .capsule,
                            activeColor: .orange,
                            inactiveColor: .orange.opacity(0.3)
                        )
                    }
                }

                Divider()

                VStack(spacing: Spacing.md) {
                    Text("Interactive Demo")
                        .font(.headline)

                    HStack(spacing: Spacing.md) {
                        Button(action: {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        .buttonStyle(.bordered)
                        .disabled(currentPage == 0)

                        Spacer()

                        Text("Page \(currentPage + 1) of 5")
                            .font(.headline)

                        Spacer()

                        Button(action: {
                            if currentPage < 4 {
                                currentPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        .buttonStyle(.bordered)
                        .disabled(currentPage == 4)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

#endif
