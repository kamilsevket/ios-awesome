import SwiftUI

// MARK: - Preview Data

/// Sample item for grid previews
struct PreviewGridItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let color: Color
    let height: CGFloat

    static let samples: [PreviewGridItem] = [
        PreviewGridItem(id: 1, title: "Item 1", color: .blue, height: 100),
        PreviewGridItem(id: 2, title: "Item 2", color: .green, height: 150),
        PreviewGridItem(id: 3, title: "Item 3", color: .orange, height: 80),
        PreviewGridItem(id: 4, title: "Item 4", color: .purple, height: 120),
        PreviewGridItem(id: 5, title: "Item 5", color: .red, height: 90),
        PreviewGridItem(id: 6, title: "Item 6", color: .pink, height: 140),
        PreviewGridItem(id: 7, title: "Item 7", color: .cyan, height: 110),
        PreviewGridItem(id: 8, title: "Item 8", color: .indigo, height: 130),
        PreviewGridItem(id: 9, title: "Item 9", color: .mint, height: 85),
        PreviewGridItem(id: 10, title: "Item 10", color: .teal, height: 95),
        PreviewGridItem(id: 11, title: "Item 11", color: .yellow, height: 125),
        PreviewGridItem(id: 12, title: "Item 12", color: .gray, height: 105)
    ]
}

// MARK: - Preview Card View

struct PreviewGridCard: View {
    let item: PreviewGridItem
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: Spacing.xs) {
            RoundedRectangle(cornerRadius: 8)
                .fill(item.color.opacity(0.3))
                .frame(height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .font(.title)
                        .foregroundColor(item.color)
                )

            Text(item.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(DSColors.textPrimary)
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? DSColors.primary : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - Preview Masonry Card

struct PreviewMasonryCard: View {
    let item: PreviewGridItem
    var isSelected: Bool = false

    var body: some View {
        VStack(spacing: Spacing.xs) {
            RoundedRectangle(cornerRadius: 8)
                .fill(item.color.opacity(0.3))
                .frame(height: item.height)
                .overlay(
                    Image(systemName: "photo")
                        .font(.title)
                        .foregroundColor(item.color)
                )

            Text(item.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(DSColors.textPrimary)
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? DSColors.primary : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - DSGrid Previews

#Preview("DSGrid - Fixed 3 Columns") {
    ScrollView {
        DSGrid(PreviewGridItem.samples, columns: .fixed(3)) { item in
            PreviewGridCard(item: item)
        }
        .padding()
    }
}

#Preview("DSGrid - Fixed 2 Columns") {
    ScrollView {
        DSGrid(PreviewGridItem.samples, columns: .fixed(2), spacing: .md) { item in
            PreviewGridCard(item: item)
        }
        .padding()
    }
}

#Preview("DSGrid - Adaptive") {
    ScrollView {
        DSGrid(PreviewGridItem.samples, columns: .adaptive(minimum: 150)) { item in
            PreviewGridCard(item: item)
        }
        .padding()
    }
}

#Preview("DSGrid - With Selection") {
    GridSelectionPreview()
}

private struct GridSelectionPreview: View {
    @State private var selection: Set<Int> = []

    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Selected: \(selection.count) items")
                .font(.headline)

            ScrollView {
                DSGrid(
                    PreviewGridItem.samples,
                    columns: .fixed(3),
                    selection: $selection,
                    selectionMode: .multiple
                ) { item in
                    PreviewGridCard(item: item, isSelected: selection.contains(item.id))
                }
                .padding()
            }
        }
    }
}

// MARK: - DSAdaptiveGrid Previews

#Preview("DSAdaptiveGrid") {
    ScrollView {
        DSAdaptiveGrid(PreviewGridItem.samples, minimumItemWidth: 150) { item in
            PreviewGridCard(item: item)
        }
        .padding()
    }
}

#Preview("DSResponsiveGrid") {
    ScrollView {
        DSResponsiveGrid(
            PreviewGridItem.samples,
            compactColumns: 2,
            regularColumns: 4
        ) { item in
            PreviewGridCard(item: item)
        }
        .padding()
    }
}

// MARK: - DSMasonryGrid Previews

#Preview("DSMasonryGrid - 2 Columns") {
    ScrollView {
        DSMasonryGrid(PreviewGridItem.samples, columns: 2) { item in
            PreviewMasonryCard(item: item)
        }
        .padding()
    }
}

#Preview("DSMasonryGrid - 3 Columns") {
    ScrollView {
        DSMasonryGrid(PreviewGridItem.samples, columns: 3) { item in
            PreviewMasonryCard(item: item)
        }
        .padding()
    }
}

#Preview("DSMasonryGrid - With Selection") {
    MasonrySelectionPreview()
}

private struct MasonrySelectionPreview: View {
    @State private var selection: Set<Int> = []

    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Selected: \(selection.count) items")
                .font(.headline)

            ScrollView {
                DSMasonryGrid(
                    PreviewGridItem.samples,
                    columns: 2,
                    selection: $selection,
                    selectionMode: .multiple
                ) { item in
                    PreviewMasonryCard(item: item, isSelected: selection.contains(item.id))
                }
                .padding()
            }
        }
    }
}

#Preview("DSAdaptiveMasonryGrid") {
    ScrollView {
        DSAdaptiveMasonryGrid(
            PreviewGridItem.samples,
            minColumnWidth: 150,
            maxColumns: 4
        ) { item in
            PreviewMasonryCard(item: item)
        }
        .padding()
    }
}

// MARK: - DSScrollableGrid Previews

#Preview("DSScrollableGrid") {
    DSScrollableGrid(PreviewGridItem.samples, columns: .fixed(3)) { item in
        PreviewGridCard(item: item)
    }
}

#Preview("DSScrollableGrid - Selectable") {
    ScrollableGridSelectionPreview()
}

private struct ScrollableGridSelectionPreview: View {
    @State private var selection: Set<Int> = []

    var body: some View {
        VStack(spacing: Spacing.md) {
            Text("Selected: \(selection.count) items")
                .font(.headline)
                .padding(.top)

            DSScrollableGrid(
                PreviewGridItem.samples,
                columns: .fixed(3),
                selection: $selection,
                selectionMode: .multiple(max: 5)
            ) { item in
                PreviewGridCard(item: item, isSelected: selection.contains(item.id))
            }
        }
    }
}

// MARK: - Dark Mode Previews

#Preview("DSGrid - Dark Mode") {
    ScrollView {
        DSGrid(PreviewGridItem.samples, columns: .fixed(3)) { item in
            PreviewGridCard(item: item)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}

#Preview("DSMasonryGrid - Dark Mode") {
    ScrollView {
        DSMasonryGrid(PreviewGridItem.samples, columns: 2) { item in
            PreviewMasonryCard(item: item)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}

// MARK: - Spacing Variants Previews

#Preview("Grid Spacing Variants") {
    ScrollView {
        VStack(alignment: .leading, spacing: Spacing.lg) {
            Text("No Spacing")
                .font(.headline)
            DSGrid(PreviewGridItem.samples.prefix(6).map { $0 }, columns: .fixed(3), spacing: .none) { item in
                PreviewGridCard(item: item)
            }

            Text("Extra Small Spacing")
                .font(.headline)
            DSGrid(PreviewGridItem.samples.prefix(6).map { $0 }, columns: .fixed(3), spacing: .xs) { item in
                PreviewGridCard(item: item)
            }

            Text("Medium Spacing")
                .font(.headline)
            DSGrid(PreviewGridItem.samples.prefix(6).map { $0 }, columns: .fixed(3), spacing: .md) { item in
                PreviewGridCard(item: item)
            }

            Text("Large Spacing")
                .font(.headline)
            DSGrid(PreviewGridItem.samples.prefix(6).map { $0 }, columns: .fixed(3), spacing: .lg) { item in
                PreviewGridCard(item: item)
            }
        }
        .padding()
    }
}

// MARK: - UICollectionView Bridge Preview

#Preview("DSCollectionView Bridge") {
    DSCollectionView(
        items: PreviewGridItem.samples,
        layout: .grid(columns: 3)
    ) { item in
        PreviewGridCard(item: item)
    } onSelect: { item in
        print("Selected: \(item.title)")
    }
    .edgesIgnoringSafeArea(.all)
}

#Preview("DSCollectionView - Adaptive") {
    DSCollectionView(
        items: PreviewGridItem.samples,
        layout: .adaptive(minItemWidth: 150)
    ) { item in
        PreviewGridCard(item: item)
    }
    .edgesIgnoringSafeArea(.all)
}

#Preview("DSCollectionView - List") {
    DSCollectionView(
        items: PreviewGridItem.samples,
        layout: .list(rowHeight: 80)
    ) { item in
        HStack(spacing: Spacing.md) {
            RoundedRectangle(cornerRadius: 8)
                .fill(item.color.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(item.color)
                )

            Text(item.title)
                .font(.headline)

            Spacer()
        }
        .padding(.horizontal, Spacing.md)
    }
    .edgesIgnoringSafeArea(.all)
}
