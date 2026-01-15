import SwiftUI
import DesignSystem

// MARK: - Lists Demo

struct ListsDemoView: View {
    @State private var items = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    @State private var selectedItem: String?

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic List
                sectionHeader("Basic List")
                DSList(style: .insetGrouped) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                }
                .frame(height: 200)

                Divider()

                // List with Sections
                sectionHeader("List with Sections")
                DSList(style: .insetGrouped) {
                    DSSection(header: "Fruits") {
                        Text("Apple")
                        Text("Banana")
                        Text("Cherry")
                    }

                    DSSection(header: "Vegetables") {
                        Text("Carrot")
                        Text("Broccoli")
                        Text("Spinach")
                    }
                }
                .frame(height: 300)

                Divider()

                // Reorderable List
                sectionHeader("Reorderable List")
                DSReorderableList(items: $items, handleStyle: .standard) { item in
                    HStack {
                        Text(item)
                        Spacer()
                    }
                    .padding(.vertical, DSSpacing.sm)
                }
                .frame(height: 250)

                Divider()

                // List with Swipe Actions
                sectionHeader("Swipe Actions")
                DSList(style: .plain) {
                    ForEach(["Item 1", "Item 2", "Item 3"], id: \.self) { item in
                        DSSwipeActions(
                            leadingActions: [
                                DSSwipeActions.Action(
                                    title: "Pin",
                                    icon: Image(systemName: "pin"),
                                    color: DSColors.primary
                                ) {
                                    print("Pin \(item)")
                                }
                            ],
                            trailingActions: [
                                DSSwipeActions.Action(
                                    title: "Delete",
                                    icon: Image(systemName: "trash"),
                                    color: DSColors.destructive,
                                    role: .destructive
                                ) {
                                    print("Delete \(item)")
                                }
                            ]
                        ) {
                            HStack {
                                Text(item)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(DSColors.textTertiary)
                            }
                            .padding()
                            .background(DSColors.backgroundPrimary)
                        }
                    }
                }
                .frame(height: 180)

                Divider()

                // Sticky Header
                sectionHeader("Sticky Header")
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) {
                        Section {
                            ForEach(1...5, id: \.self) { index in
                                Text("Row \(index)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                        } header: {
                            DSStickyHeader(title: "Section Header", style: .blurred)
                        }
                    }
                }
                .frame(height: 200)
                .background(DSColors.backgroundSecondary)
                .cornerRadius(8)

                Divider()

                // Pagination
                sectionHeader("Pagination")
                DSPagination(
                    state: .loaded,
                    onLoadMore: {
                        print("Load more triggered")
                    }
                ) {
                    ForEach(1...10, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(DSColors.backgroundSecondary)
                            .cornerRadius(8)
                    }
                }
                .frame(height: 300)
            }
            .padding()
        }
        .navigationTitle("Lists")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Grids Demo

struct GridsDemoView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .cyan]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Grid
                sectionHeader("Basic Grid (2 columns)")
                DSGrid(columns: 2, spacing: DSSpacing.md) {
                    ForEach(0..<6, id: \.self) { index in
                        gridItem(index)
                    }
                }

                Divider()

                // Adaptive Grid
                sectionHeader("Adaptive Grid")
                DSAdaptiveGrid(minItemWidth: 100, spacing: DSSpacing.md) {
                    ForEach(0..<8, id: \.self) { index in
                        gridItem(index)
                    }
                }

                Divider()

                // Masonry Grid
                sectionHeader("Masonry Grid")
                DSMasonryGrid(columns: 2, spacing: DSSpacing.md) {
                    ForEach(0..<8, id: \.self) { index in
                        masonryItem(index)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Grids")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func gridItem(_ index: Int) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(colors[index % colors.count].opacity(0.7))
            .frame(height: 100)
            .overlay(
                Text("\(index + 1)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
    }

    private func masonryItem(_ index: Int) -> some View {
        let heights: [CGFloat] = [100, 150, 120, 180, 140, 160, 110, 130]
        return RoundedRectangle(cornerRadius: 8)
            .fill(colors[index % colors.count].opacity(0.7))
            .frame(height: heights[index % heights.count])
            .overlay(
                Text("\(index + 1)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
    }
}

// MARK: - Carousel Demo

struct CarouselDemoView: View {
    @State private var currentPage = 0
    let carouselItems = ["Feature 1", "Feature 2", "Feature 3", "Feature 4"]

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Carousel
                sectionHeader("Basic Carousel")
                DSCarousel(
                    items: carouselItems,
                    currentIndex: $currentPage
                ) { item in
                    carouselCard(item, color: DSColors.primary)
                }
                .frame(height: 200)

                DSPageIndicator(
                    numberOfPages: carouselItems.count,
                    currentPage: $currentPage
                )

                Divider()

                // Card Carousel
                sectionHeader("Card Carousel")
                DSCardCarousel(
                    items: ["Card A", "Card B", "Card C", "Card D"],
                    cardWidth: 280,
                    spacing: DSSpacing.lg
                ) { item in
                    VStack(alignment: .leading, spacing: DSSpacing.md) {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [DSColors.info, DSColors.primary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 120)
                            .cornerRadius(8)

                        Text(item)
                            .font(.headline)

                        Text("This is a card in the carousel with additional content.")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                            .lineLimit(2)
                    }
                    .padding()
                    .background(DSColors.backgroundPrimary)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
                }
                .frame(height: 280)

                Divider()

                // Auto-scrolling Carousel
                sectionHeader("Auto-scrolling Carousel")
                DSCarousel(
                    items: ["Slide 1", "Slide 2", "Slide 3"],
                    currentIndex: .constant(0),
                    autoScroll: DSAutoScroll(interval: 3.0, isEnabled: true)
                ) { item in
                    carouselCard(item, color: DSColors.success)
                }
                .frame(height: 180)

                Divider()

                // Page View
                sectionHeader("Page View")
                DSPageView(
                    pages: [
                        AnyView(pageContent("Page 1", icon: "1.circle.fill", color: DSColors.primary)),
                        AnyView(pageContent("Page 2", icon: "2.circle.fill", color: DSColors.success)),
                        AnyView(pageContent("Page 3", icon: "3.circle.fill", color: DSColors.warning))
                    ],
                    currentPage: $currentPage
                )
                .frame(height: 200)
            }
            .padding()
        }
        .navigationTitle("Carousel")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func carouselCard(_ title: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(color.opacity(0.8))
            .overlay(
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            )
    }

    private func pageContent(_ title: String, icon: String, color: Color) -> some View {
        VStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(color)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text("Swipe left or right to navigate")
                .font(.body)
                .foregroundColor(DSColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DSColors.backgroundSecondary)
        .cornerRadius(12)
    }
}

#if DEBUG
struct DataDisplayDemoViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListsDemoView()
        }
    }
}
#endif
