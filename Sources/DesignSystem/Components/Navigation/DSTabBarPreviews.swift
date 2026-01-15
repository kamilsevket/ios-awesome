#if DEBUG
import SwiftUI

// MARK: - Preview Types

enum PreviewTab: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case favorites = "Favorites"
    case notifications = "Notifications"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .favorites: return "heart"
        case .notifications: return "bell"
        case .profile: return "person"
        }
    }
}

// MARK: - All Styles Preview

struct DSTabBar_AllStyles_Previews: PreviewProvider {
    struct AllStylesPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            ScrollView {
                VStack(spacing: 40) {
                    styleSection("Standard Style", style: .standard)
                    styleSection("Pill Style", style: .pill)
                    styleSection("Underline Style", style: .underline)
                    styleSection("Floating Style", style: .floating)
                }
                .padding(.vertical, 20)
            }
        }

        func styleSection(_ title: String, style: DSTabBarStyle) -> some View {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                DSTabBar(selection: $selectedTab, style: style, safeAreaAware: false) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                    DSTabBarItem(.favorites, title: "Favorites", icon: "heart", badge: .count(3))
                    DSTabBarItem(.profile, title: "Profile", icon: "person", badge: .dot)
                }
            }
        }
    }

    static var previews: some View {
        AllStylesPreview()
            .previewDisplayName("All Tab Bar Styles")
    }
}

// MARK: - Sizes Preview

struct DSTabBar_Sizes_Previews: PreviewProvider {
    struct SizesPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            ScrollView {
                VStack(spacing: 40) {
                    sizeSection("Compact Size", size: .compact)
                    sizeSection("Standard Size", size: .standard)
                    sizeSection("Large Size", size: .large)
                }
                .padding(.vertical, 20)
            }
        }

        func sizeSection(_ title: String, size: DSTabBarSize) -> some View {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                DSTabBar(selection: $selectedTab, size: size, safeAreaAware: false) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                    DSTabBarItem(.favorites, title: "Favorites", icon: "heart")
                    DSTabBarItem(.profile, title: "Profile", icon: "person")
                }
            }
        }
    }

    static var previews: some View {
        SizesPreview()
            .previewDisplayName("Tab Bar Sizes")
    }
}

// MARK: - Display Modes Preview

struct DSTabBar_DisplayModes_Previews: PreviewProvider {
    struct DisplayModesPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            ScrollView {
                VStack(spacing: 40) {
                    modeSection("Icon + Title", mode: .iconAndTitle)
                    modeSection("Icon Only", mode: .iconOnly)
                    modeSection("Title Only", mode: .titleOnly)
                }
                .padding(.vertical, 20)
            }
        }

        func modeSection(_ title: String, mode: DSTabDisplayMode) -> some View {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                DSTabBar(selection: $selectedTab, displayMode: mode, safeAreaAware: false) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                    DSTabBarItem(.favorites, title: "Favorites", icon: "heart")
                    DSTabBarItem(.profile, title: "Profile", icon: "person")
                }
            }
        }
    }

    static var previews: some View {
        DisplayModesPreview()
            .previewDisplayName("Display Modes")
    }
}

// MARK: - Badges Preview

struct DSTabBar_Badges_Previews: PreviewProvider {
    struct BadgesPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            VStack(spacing: 40) {
                Text("Badge Types")
                    .font(.headline)

                DSTabBar(selection: $selectedTab, safeAreaAware: false) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass", badge: .count(5))
                    DSTabBarItem(.favorites, title: "Favorites", icon: "heart", badge: .count(99))
                    DSTabBarItem(.notifications, title: "Alerts", icon: "bell", badge: .count(100))
                    DSTabBarItem(.profile, title: "Profile", icon: "person", badge: .dot)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Badge Samples:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    HStack(spacing: 16) {
                        badgeSample(".count(5)", badge: .count(5))
                        badgeSample(".count(99)", badge: .count(99))
                        badgeSample(".count(100)", badge: .count(100))
                        badgeSample(".dot", badge: .dot)
                    }
                }
                .padding()

                Spacer()
            }
            .padding(.top, 40)
        }

        func badgeSample(_ label: String, badge: DSTabBadge) -> some View {
            VStack(spacing: 4) {
                DSTabBadgeView(badge: badge)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    static var previews: some View {
        BadgesPreview()
            .previewDisplayName("Badge Types")
    }
}

// MARK: - Scrollable Tab Bar Preview

struct DSScrollableTabBar_AllStyles_Previews: PreviewProvider {
    enum Category: String, CaseIterable {
        case all = "All"
        case trending = "Trending"
        case technology = "Technology"
        case sports = "Sports"
        case entertainment = "Entertainment"
        case business = "Business"
        case health = "Health"
        case science = "Science"

        var icon: String {
            switch self {
            case .all: return "square.grid.2x2"
            case .trending: return "flame"
            case .technology: return "laptopcomputer"
            case .sports: return "sportscourt"
            case .entertainment: return "film"
            case .business: return "briefcase"
            case .health: return "heart"
            case .science: return "atom"
            }
        }
    }

    struct AllScrollableStylesPreview: View {
        @State private var selected: Category = .all

        var body: some View {
            ScrollView {
                VStack(spacing: 40) {
                    styleSection("Underline Style", style: .underline)
                    styleSection("Pill Style", style: .pill)
                    styleSection("Chip Style", style: .chip)
                    styleSection("Text Only Style", style: .text)
                }
                .padding(.vertical, 20)
            }
        }

        func styleSection(_ title: String, style: DSScrollableTabBarStyle) -> some View {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                DSScrollableTabBar(
                    selection: $selected,
                    items: Category.allCases.map { category in
                        DSTabBarItem(
                            category,
                            title: category.rawValue,
                            icon: category.icon,
                            badge: category == .trending ? .count(12) : nil
                        )
                    },
                    style: style
                )
            }
        }
    }

    static var previews: some View {
        AllScrollableStylesPreview()
            .previewDisplayName("Scrollable Tab Bar Styles")
    }
}

// MARK: - Dark Mode Preview

struct DSTabBar_DarkMode_Previews: PreviewProvider {
    struct DarkModePreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    Text("Dark Mode Support")
                        .font(.title2)
                        .bold()

                    Text("Selected: \(selectedTab.rawValue)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                DSTabBar(selection: $selectedTab, tintColor: .cyan) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                    DSTabBarItem(.favorites, title: "Favorites", icon: "heart", badge: .count(7))
                    DSTabBarItem(.profile, title: "Profile", icon: "person")
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    static var previews: some View {
        Group {
            DarkModePreview()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")

            DarkModePreview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

// MARK: - Full Screen Integration Preview

struct DSTabBar_FullScreen_Previews: PreviewProvider {
    struct FullScreenPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            ZStack {
                // Content
                VStack {
                    switch selectedTab {
                    case .home:
                        homeContent
                    case .search:
                        searchContent
                    case .favorites:
                        favoritesContent
                    case .notifications:
                        notificationsContent
                    case .profile:
                        profileContent
                    }
                }

                // Tab bar
                VStack {
                    Spacer()

                    DSTabBar(selection: $selectedTab, tintColor: .blue) {
                        DSTabBarItem(.home, title: "Home", icon: "house")
                        DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                        DSTabBarItem(.favorites, title: "Favorites", icon: "heart", badge: .count(3))
                        DSTabBarItem(.notifications, title: "Alerts", icon: "bell", badge: .dot)
                        DSTabBarItem(.profile, title: "Profile", icon: "person")
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }

        var homeContent: some View {
            NavigationView {
                List {
                    ForEach(1..<20) { i in
                        Text("Home Item \(i)")
                    }
                }
                .navigationTitle("Home")
            }
        }

        var searchContent: some View {
            NavigationView {
                VStack {
                    Text("Search Content")
                        .font(.largeTitle)
                }
                .navigationTitle("Search")
            }
        }

        var favoritesContent: some View {
            NavigationView {
                VStack {
                    Text("Favorites Content")
                        .font(.largeTitle)
                }
                .navigationTitle("Favorites")
            }
        }

        var notificationsContent: some View {
            NavigationView {
                VStack {
                    Text("Notifications Content")
                        .font(.largeTitle)
                }
                .navigationTitle("Notifications")
            }
        }

        var profileContent: some View {
            NavigationView {
                VStack {
                    Text("Profile Content")
                        .font(.largeTitle)
                }
                .navigationTitle("Profile")
            }
        }
    }

    static var previews: some View {
        FullScreenPreview()
            .previewDisplayName("Full Screen Integration")
    }
}

// MARK: - Floating Style Preview

struct DSTabBar_Floating_Previews: PreviewProvider {
    struct FloatingPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            ZStack {
                // Background content
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    Text("Floating Tab Bar")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    Text("Selected: \(selectedTab.rawValue)")
                        .foregroundColor(.white.opacity(0.8))
                }

                // Floating tab bar
                VStack {
                    Spacer()

                    DSTabBar(
                        selection: $selectedTab,
                        style: .floating,
                        displayMode: .iconOnly,
                        tintColor: .blue,
                        safeAreaAware: true
                    ) {
                        DSTabBarItem(.home, title: "Home", icon: "house")
                        DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                        DSTabBarItem(.favorites, title: "Favorites", icon: "heart", badge: .count(2))
                        DSTabBarItem(.profile, title: "Profile", icon: "person")
                    }
                    .padding(.bottom, 16)
                }
            }
        }
    }

    static var previews: some View {
        FloatingPreview()
            .previewDisplayName("Floating Tab Bar")
    }
}

// MARK: - Custom Colors Preview

struct DSTabBar_CustomColors_Previews: PreviewProvider {
    struct CustomColorsPreview: View {
        @State private var selectedTab: PreviewTab = .home

        var body: some View {
            ScrollView {
                VStack(spacing: 40) {
                    colorSection("Blue Tint", tint: .blue)
                    colorSection("Orange Tint", tint: .orange)
                    colorSection("Green Tint", tint: .green)
                    colorSection("Purple Tint", tint: .purple)
                    colorSection("Pink Tint", tint: .pink)
                }
                .padding(.vertical, 20)
            }
        }

        func colorSection(_ title: String, tint: Color) -> some View {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                DSTabBar(selection: $selectedTab, tintColor: tint, safeAreaAware: false) {
                    DSTabBarItem(.home, title: "Home", icon: "house")
                    DSTabBarItem(.search, title: "Search", icon: "magnifyingglass")
                    DSTabBarItem(.favorites, title: "Favorites", icon: "heart")
                    DSTabBarItem(.profile, title: "Profile", icon: "person")
                }
            }
        }
    }

    static var previews: some View {
        CustomColorsPreview()
            .previewDisplayName("Custom Tint Colors")
    }
}
#endif
