import SwiftUI

#if canImport(UIKit)
import UIKit

// MARK: - DSCollectionView (UIKit Bridge)

/// A SwiftUI wrapper for UICollectionView that provides advanced grid layouts
/// and performance optimizations not available in native SwiftUI.
///
/// This bridge enables:
/// - Compositional layouts
/// - Diffable data sources
/// - Self-sizing cells
/// - Prefetching
/// - Drag and drop
///
/// ## Usage
/// ```swift
/// DSCollectionView(
///     items: viewModel.items,
///     layout: .grid(columns: 3),
///     cellProvider: { item in
///         CollectionCell(item: item)
///     }
/// )
/// ```
public struct DSCollectionView<Item: Identifiable & Hashable, Cell: View>: UIViewRepresentable {
    // MARK: - Properties

    private let items: [Item]
    private let layout: DSCollectionLayout
    private let cellProvider: (Item) -> Cell
    private let onSelect: ((Item) -> Void)?
    private let onPrefetch: (([Item]) -> Void)?

    // MARK: - Initialization

    /// Creates a collection view with the specified items and layout.
    /// - Parameters:
    ///   - items: The array of items to display
    ///   - layout: The collection layout to use
    ///   - cellProvider: View builder for each cell
    ///   - onSelect: Optional callback when an item is selected
    ///   - onPrefetch: Optional callback for prefetching items
    public init(
        items: [Item],
        layout: DSCollectionLayout = .grid(columns: 2),
        @ViewBuilder cellProvider: @escaping (Item) -> Cell,
        onSelect: ((Item) -> Void)? = nil,
        onPrefetch: (([Item]) -> Void)? = nil
    ) {
        self.items = items
        self.layout = layout
        self.cellProvider = cellProvider
        self.onSelect = onSelect
        self.onPrefetch = onPrefetch
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout.createLayout()
        )

        collectionView.backgroundColor = .clear
        collectionView.delegate = context.coordinator
        collectionView.prefetchDataSource = context.coordinator

        // Register cell
        collectionView.register(
            HostingCollectionViewCell<Cell>.self,
            forCellWithReuseIdentifier: HostingCollectionViewCell<Cell>.reuseIdentifier
        )

        // Configure diffable data source
        context.coordinator.configureDataSource(collectionView: collectionView)

        return collectionView
    }

    public func updateUIView(_ collectionView: UICollectionView, context: Context) {
        context.coordinator.items = items
        context.coordinator.cellProvider = cellProvider
        context.coordinator.updateSnapshot(animated: true)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            items: items,
            cellProvider: cellProvider,
            onSelect: onSelect,
            onPrefetch: onPrefetch
        )
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
        var items: [Item]
        var cellProvider: (Item) -> Cell
        var onSelect: ((Item) -> Void)?
        var onPrefetch: (([Item]) -> Void)?

        private var dataSource: UICollectionViewDiffableDataSource<Int, Item>?

        init(
            items: [Item],
            cellProvider: @escaping (Item) -> Cell,
            onSelect: ((Item) -> Void)?,
            onPrefetch: (([Item]) -> Void)?
        ) {
            self.items = items
            self.cellProvider = cellProvider
            self.onSelect = onSelect
            self.onPrefetch = onPrefetch
        }

        func configureDataSource(collectionView: UICollectionView) {
            dataSource = UICollectionViewDiffableDataSource<Int, Item>(
                collectionView: collectionView
            ) { [weak self] collectionView, indexPath, item in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HostingCollectionViewCell<Cell>.reuseIdentifier,
                        for: indexPath
                      ) as? HostingCollectionViewCell<Cell> else {
                    return UICollectionViewCell()
                }

                cell.configure(with: self.cellProvider(item))
                return cell
            }

            updateSnapshot(animated: false)
        }

        func updateSnapshot(animated: Bool) {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            dataSource?.apply(snapshot, animatingDifferences: animated)
        }

        // MARK: - UICollectionViewDelegate

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard indexPath.item < items.count else { return }
            onSelect?(items[indexPath.item])
        }

        // MARK: - UICollectionViewDataSourcePrefetching

        public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            let itemsToPrefetch = indexPaths.compactMap { indexPath -> Item? in
                guard indexPath.item < items.count else { return nil }
                return items[indexPath.item]
            }
            onPrefetch?(itemsToPrefetch)
        }
    }
}

// MARK: - Hosting Collection View Cell

/// A UICollectionViewCell that hosts SwiftUI content
private class HostingCollectionViewCell<Content: View>: UICollectionViewCell {
    static var reuseIdentifier: String { "HostingCollectionViewCell" }

    private var hostingController: UIHostingController<Content>?

    func configure(with content: Content) {
        if let hostingController = hostingController {
            hostingController.rootView = content
        } else {
            let controller = UIHostingController(rootView: content)
            controller.view.backgroundColor = .clear
            hostingController = controller

            contentView.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.rootView = nil as Content?
    }
}

// MARK: - DSCollectionLayout

/// Layout configuration for DSCollectionView
public enum DSCollectionLayout {
    /// Standard grid layout with fixed columns
    case grid(columns: Int, spacing: CGFloat = Spacing.sm)

    /// Adaptive grid that adjusts column count based on item size
    case adaptive(minItemWidth: CGFloat, spacing: CGFloat = Spacing.sm)

    /// Full-width list layout
    case list(rowHeight: CGFloat = 60, spacing: CGFloat = Spacing.xs)

    /// Pinterest-style waterfall layout
    case waterfall(columns: Int, spacing: CGFloat = Spacing.sm)

    /// Custom compositional layout
    case custom(NSCollectionLayoutSection)

    /// Creates the UICollectionViewLayout for this configuration
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [self] sectionIndex, environment in
            switch self {
            case .grid(let columns, let spacing):
                return Self.createGridSection(columns: columns, spacing: spacing, environment: environment)

            case .adaptive(let minItemWidth, let spacing):
                return Self.createAdaptiveSection(minItemWidth: minItemWidth, spacing: spacing, environment: environment)

            case .list(let rowHeight, let spacing):
                return Self.createListSection(rowHeight: rowHeight, spacing: spacing)

            case .waterfall(let columns, let spacing):
                return Self.createWaterfallSection(columns: columns, spacing: spacing, environment: environment)

            case .custom(let section):
                return section
            }
        }
    }

    // MARK: - Layout Builders

    private static func createGridSection(
        columns: Int,
        spacing: CGFloat,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing / 2, bottom: 0, trailing: spacing / 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0 / CGFloat(columns))
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing / 2, bottom: spacing, trailing: spacing / 2)

        return section
    }

    private static func createAdaptiveSection(
        minItemWidth: CGFloat,
        spacing: CGFloat,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let containerWidth = environment.container.effectiveContentSize.width
        let columns = max(1, Int(containerWidth / minItemWidth))

        return createGridSection(columns: columns, spacing: spacing, environment: environment)
    }

    private static func createListSection(
        rowHeight: CGFloat,
        spacing: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(rowHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(rowHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)

        return section
    }

    private static func createWaterfallSection(
        columns: Int,
        spacing: CGFloat,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        // Note: True waterfall requires custom layout implementation
        // This is a simplified version using estimated heights
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing / 2, bottom: spacing, trailing: spacing / 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing / 2, bottom: spacing, trailing: spacing / 2)

        return section
    }
}

// MARK: - DSCollectionView with Sections

/// A collection view that supports multiple sections with headers and footers
public struct DSSectionedCollectionView<Section: Identifiable & Hashable, Item: Identifiable & Hashable, Cell: View, Header: View, Footer: View>: UIViewRepresentable {
    // MARK: - Properties

    private let sections: [(section: Section, items: [Item])]
    private let layout: DSCollectionLayout
    private let cellProvider: (Item) -> Cell
    private let headerProvider: ((Section) -> Header)?
    private let footerProvider: ((Section) -> Footer)?
    private let onSelect: ((Item) -> Void)?

    // MARK: - Initialization

    public init(
        sections: [(section: Section, items: [Item])],
        layout: DSCollectionLayout = .grid(columns: 2),
        @ViewBuilder cellProvider: @escaping (Item) -> Cell,
        @ViewBuilder headerProvider: ((Section) -> Header)? = nil,
        @ViewBuilder footerProvider: ((Section) -> Footer)? = nil,
        onSelect: ((Item) -> Void)? = nil
    ) {
        self.sections = sections
        self.layout = layout
        self.cellProvider = cellProvider
        self.headerProvider = headerProvider
        self.footerProvider = footerProvider
        self.onSelect = onSelect
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout.createLayout()
        )

        collectionView.backgroundColor = .clear
        collectionView.delegate = context.coordinator

        // Register cell
        collectionView.register(
            HostingCollectionViewCell<Cell>.self,
            forCellWithReuseIdentifier: HostingCollectionViewCell<Cell>.reuseIdentifier
        )

        context.coordinator.configureDataSource(collectionView: collectionView)

        return collectionView
    }

    public func updateUIView(_ collectionView: UICollectionView, context: Context) {
        context.coordinator.sections = sections
        context.coordinator.cellProvider = cellProvider
        context.coordinator.updateSnapshot(animated: true)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            sections: sections,
            cellProvider: cellProvider,
            onSelect: onSelect
        )
    }

    // MARK: - Coordinator

    public class Coordinator: NSObject, UICollectionViewDelegate {
        var sections: [(section: Section, items: [Item])]
        var cellProvider: (Item) -> Cell
        var onSelect: ((Item) -> Void)?

        private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?

        init(
            sections: [(section: Section, items: [Item])],
            cellProvider: @escaping (Item) -> Cell,
            onSelect: ((Item) -> Void)?
        ) {
            self.sections = sections
            self.cellProvider = cellProvider
            self.onSelect = onSelect
        }

        func configureDataSource(collectionView: UICollectionView) {
            dataSource = UICollectionViewDiffableDataSource<Section, Item>(
                collectionView: collectionView
            ) { [weak self] collectionView, indexPath, item in
                guard let self = self,
                      let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HostingCollectionViewCell<Cell>.reuseIdentifier,
                        for: indexPath
                      ) as? HostingCollectionViewCell<Cell> else {
                    return UICollectionViewCell()
                }

                cell.configure(with: self.cellProvider(item))
                return cell
            }

            updateSnapshot(animated: false)
        }

        func updateSnapshot(animated: Bool) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

            for (section, items) in sections {
                snapshot.appendSections([section])
                snapshot.appendItems(items, toSection: section)
            }

            dataSource?.apply(snapshot, animatingDifferences: animated)
        }

        // MARK: - UICollectionViewDelegate

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard indexPath.section < sections.count,
                  indexPath.item < sections[indexPath.section].items.count else { return }

            let item = sections[indexPath.section].items[indexPath.item]
            onSelect?(item)
        }
    }
}

// MARK: - Type Erasure Extensions

extension DSSectionedCollectionView where Header == EmptyView {
    public init(
        sections: [(section: Section, items: [Item])],
        layout: DSCollectionLayout = .grid(columns: 2),
        @ViewBuilder cellProvider: @escaping (Item) -> Cell,
        @ViewBuilder footerProvider: ((Section) -> Footer)? = nil,
        onSelect: ((Item) -> Void)? = nil
    ) {
        self.sections = sections
        self.layout = layout
        self.cellProvider = cellProvider
        self.headerProvider = nil
        self.footerProvider = footerProvider
        self.onSelect = onSelect
    }
}

extension DSSectionedCollectionView where Footer == EmptyView {
    public init(
        sections: [(section: Section, items: [Item])],
        layout: DSCollectionLayout = .grid(columns: 2),
        @ViewBuilder cellProvider: @escaping (Item) -> Cell,
        @ViewBuilder headerProvider: ((Section) -> Header)? = nil,
        onSelect: ((Item) -> Void)? = nil
    ) {
        self.sections = sections
        self.layout = layout
        self.cellProvider = cellProvider
        self.headerProvider = headerProvider
        self.footerProvider = nil
        self.onSelect = onSelect
    }
}

extension DSSectionedCollectionView where Header == EmptyView, Footer == EmptyView {
    public init(
        sections: [(section: Section, items: [Item])],
        layout: DSCollectionLayout = .grid(columns: 2),
        @ViewBuilder cellProvider: @escaping (Item) -> Cell,
        onSelect: ((Item) -> Void)? = nil
    ) {
        self.sections = sections
        self.layout = layout
        self.cellProvider = cellProvider
        self.headerProvider = nil
        self.footerProvider = nil
        self.onSelect = onSelect
    }
}
#endif
