import SwiftUI

// MARK: - IconPreview

/// A preview component for browsing all available icons.
///
/// Use this in SwiftUI previews to visualize all SF Symbols and custom icons.
///
/// ## Usage
/// ```swift
/// struct ContentView_Previews: PreviewProvider {
///     static var previews: some View {
///         IconPreview()
///     }
/// }
/// ```
public struct IconPreview: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var selectedSize: IconSize = .lg

    public init() {}

    public var body: some View {
        #if os(iOS)
        NavigationStack {
            contentView
        }
        #else
        NavigationView {
            contentView
        }
        #endif
    }

    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            // Size selector
            sizeSelector

            // Tab picker
            Picker("Icon Type", selection: $selectedTab) {
                Text("SF Symbols").tag(0)
                Text("Custom Icons").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            // Content
            if selectedTab == 0 {
                sfSymbolsGrid
            } else {
                customIconsGrid
            }
        }
        .navigationTitle("Icons")
        #if os(iOS)
        .searchable(text: $searchText, prompt: "Search icons")
        #endif
    }

    // MARK: - Size Selector

    private var sizeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(IconSize.allCases, id: \.rawValue) { size in
                    Button {
                        selectedSize = size
                    } label: {
                        VStack(spacing: 4) {
                            Text(sizeName(size))
                                .font(.caption2)
                            Text("\(Int(size.pointSize))pt")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedSize == size ? Color.accentColor.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        #if os(iOS)
        .background(Color(.secondarySystemBackground))
        #else
        .background(Color.gray.opacity(0.1))
        #endif
    }

    private func sizeName(_ size: IconSize) -> String {
        switch size {
        case .xs: return "XS"
        case .sm: return "SM"
        case .md: return "MD"
        case .lg: return "LG"
        case .xl: return "XL"
        case .xxl: return "XXL"
        }
    }

    // MARK: - SF Symbols Grid

    private var sfSymbolsGrid: some View {
        let filteredSymbols = filteredSFSymbols
        let columns = [GridItem(.adaptive(minimum: 80))]

        return ScrollView {
            if filteredSymbols.isEmpty {
                emptySearchView
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredSymbols, id: \.rawValue) { symbol in
                        sfSymbolCell(symbol)
                    }
                }
                .padding()
            }
        }
    }

    private var filteredSFSymbols: [SFSymbol] {
        if searchText.isEmpty {
            return SFSymbol.allCases
        }
        return SFSymbol.allCases.filter { symbol in
            symbol.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func sfSymbolCell(_ symbol: SFSymbol) -> some View {
        VStack(spacing: 8) {
            Icon.system(symbol, size: selectedSize)
                .foregroundStyle(.primary)
                .frame(height: 40)

            Text(shortName(symbol.rawValue))
                .font(.caption2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        #if os(iOS)
        .background(Color(.tertiarySystemBackground))
        #else
        .background(Color.gray.opacity(0.05))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Custom Icons Grid

    private var customIconsGrid: some View {
        let filteredIcons = filteredCustomIcons
        let columns = [GridItem(.adaptive(minimum: 80))]

        return ScrollView {
            if filteredIcons.isEmpty {
                emptySearchView
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredIcons, id: \.rawValue) { icon in
                        customIconCell(icon)
                    }
                }
                .padding()
            }
        }
    }

    private var filteredCustomIcons: [CustomIcon] {
        if searchText.isEmpty {
            return CustomIcon.allCases
        }
        return CustomIcon.allCases.filter { icon in
            icon.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func customIconCell(_ icon: CustomIcon) -> some View {
        VStack(spacing: 8) {
            Icon.custom(icon, size: selectedSize)
                .foregroundStyle(.primary)
                .frame(height: 40)

            Text(shortName(icon.rawValue))
                .font(.caption2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        #if os(iOS)
        .background(Color(.tertiarySystemBackground))
        #else
        .background(Color.gray.opacity(0.05))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Helpers

    private func shortName(_ name: String) -> String {
        // Remove path prefix and format for display
        let components = name.split(separator: "/")
        let shortName = components.last ?? Substring(name)
        return String(shortName)
            .replacingOccurrences(of: ".", with: "\n")
            .replacingOccurrences(of: "-", with: " ")
    }

    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Icon.system(.magnifyingglass, size: .xxl)
                .foregroundStyle(.secondary)
            Text("No icons found")
                .font(.headline)
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 60)
    }
}

// MARK: - SFSymbol Category Preview

/// A preview component showing SF Symbols organized by category.
public struct SFSymbolCategoryPreview: View {
    public init() {}

    private let categories: [(String, [SFSymbol])] = [
        ("Navigation", [.chevronLeft, .chevronRight, .chevronUp, .chevronDown, .arrowLeft, .arrowRight]),
        ("Actions", [.plus, .minus, .xmark, .checkmark, .trash, .pencil]),
        ("Communication", [.envelope, .phone, .message, .bubble]),
        ("Media", [.play, .pause, .stop, .backward, .forward]),
        ("Objects", [.heart, .star, .bookmark, .flag, .bell, .eye]),
        ("People", [.person, .personCircle, .person2, .person3]),
        ("System", [.gear, .gearshape, .ellipsis, .info, .questionmark]),
        ("Security", [.lock, .lockOpen, .key, .shield, .faceid])
    ]

    public var body: some View {
        #if os(iOS)
        NavigationStack {
            categoryList
        }
        #else
        NavigationView {
            categoryList
        }
        #endif
    }

    @ViewBuilder
    private var categoryList: some View {
        List {
            ForEach(categories, id: \.0) { category, symbols in
                Section(category) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 12) {
                        ForEach(symbols, id: \.rawValue) { symbol in
                            Icon.system(symbol, size: .lg)
                                .foregroundStyle(.primary)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("SF Symbols")
    }
}

// MARK: - Previews

#if DEBUG
struct IconPreview_Previews: PreviewProvider {
    static var previews: some View {
        IconPreview()
            .previewDisplayName("Icon Browser")

        SFSymbolCategoryPreview()
            .previewDisplayName("Categories")
    }
}
#endif
