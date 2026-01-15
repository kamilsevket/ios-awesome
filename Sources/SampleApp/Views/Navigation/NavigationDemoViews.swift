import SwiftUI
import DesignSystem

// MARK: - Tab Bar Demo

struct TabBarDemoView: View {
    @State private var selectedTab = 0
    @State private var scrollableSelectedTab = 0

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Tab Bar
                sectionHeader("Basic Tab Bar")
                DSTabBar(
                    selection: $selectedTab,
                    tabs: [
                        DSTabBarItem(title: "Home", icon: Image(systemName: "house")),
                        DSTabBarItem(title: "Search", icon: Image(systemName: "magnifyingglass")),
                        DSTabBarItem(title: "Profile", icon: Image(systemName: "person"))
                    ]
                )

                Text("Selected: Tab \(selectedTab + 1)")
                    .font(.body)
                    .foregroundColor(DSColors.textSecondary)

                Divider()

                // Tab Bar with Badges
                sectionHeader("Tab Bar with Badges")
                DSTabBar(
                    selection: $selectedTab,
                    tabs: [
                        DSTabBarItem(title: "Inbox", icon: Image(systemName: "tray"), badge: 5),
                        DSTabBarItem(title: "Messages", icon: Image(systemName: "message"), badge: 12),
                        DSTabBarItem(title: "Settings", icon: Image(systemName: "gear"))
                    ]
                )

                Divider()

                // Scrollable Tab Bar
                sectionHeader("Scrollable Tab Bar")
                DSScrollableTabBar(
                    selection: $scrollableSelectedTab,
                    tabs: [
                        DSTab(title: "All"),
                        DSTab(title: "Design"),
                        DSTab(title: "Development"),
                        DSTab(title: "Marketing"),
                        DSTab(title: "Sales"),
                        DSTab(title: "Support")
                    ]
                )

                Text("Selected: \(["All", "Design", "Development", "Marketing", "Sales", "Support"][scrollableSelectedTab])")
                    .font(.body)
                    .foregroundColor(DSColors.textSecondary)
            }
            .padding()
        }
        .navigationTitle("Tab Bar")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Navigation Bar Demo

struct NavigationBarDemoView: View {
    @State private var searchText = ""

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Navigation Bar
                sectionHeader("Basic Navigation Bar")
                DSNavigationBar(title: "Page Title")
                    .frame(height: 56)
                    .background(DSColors.backgroundSecondary)
                    .cornerRadius(8)

                Divider()

                // Navigation Bar with Back Button
                sectionHeader("With Back Button")
                DSNavigationBar(
                    title: "Details",
                    showBackButton: true,
                    onBack: { print("Back tapped") }
                )
                .frame(height: 56)
                .background(DSColors.backgroundSecondary)
                .cornerRadius(8)

                Divider()

                // Navigation Bar with Subtitle
                sectionHeader("With Subtitle")
                DSNavigationBar(
                    title: "Messages",
                    subtitle: "3 unread"
                )
                .frame(height: 56)
                .background(DSColors.backgroundSecondary)
                .cornerRadius(8)

                Divider()

                // Navigation Bar with Actions
                sectionHeader("With Actions")
                DSNavigationBar(
                    title: "Photos",
                    leadingAction: DSNavigationBar.Action(
                        icon: Image(systemName: "sidebar.left"),
                        action: { print("Menu tapped") }
                    ),
                    trailingActions: [
                        DSNavigationBar.Action(
                            icon: Image(systemName: "magnifyingglass"),
                            action: { print("Search tapped") }
                        ),
                        DSNavigationBar.Action(
                            icon: Image(systemName: "ellipsis"),
                            action: { print("More tapped") }
                        )
                    ]
                )
                .frame(height: 56)
                .background(DSColors.backgroundSecondary)
                .cornerRadius(8)

                Divider()

                // Navigation Bar with Search
                sectionHeader("With Search Field")
                VStack(spacing: 0) {
                    DSNavigationBar(title: "Search Demo")
                    DSNavigationBarSearchField(text: $searchText)
                        .padding(.horizontal)
                }
                .background(DSColors.backgroundSecondary)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Navigation Bar")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Segmented Control Demo

struct SegmentedControlDemoView: View {
    @State private var selectedSegment = 0
    @State private var selectedStyle = 0
    @State private var selectedSize = 1

    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                // Basic Segmented Control
                sectionHeader("Basic Segmented Control")
                DSSegmentedControl(
                    selection: $selectedSegment,
                    segments: [
                        DSSegment(title: "Day"),
                        DSSegment(title: "Week"),
                        DSSegment(title: "Month")
                    ]
                )

                Text("Selected: \(["Day", "Week", "Month"][selectedSegment])")
                    .font(.body)
                    .foregroundColor(DSColors.textSecondary)

                Divider()

                // With Icons
                sectionHeader("With Icons")
                DSSegmentedControl(
                    selection: $selectedStyle,
                    segments: [
                        DSSegment(title: "List", icon: Image(systemName: "list.bullet")),
                        DSSegment(title: "Grid", icon: Image(systemName: "square.grid.2x2")),
                        DSSegment(title: "Gallery", icon: Image(systemName: "photo.on.rectangle"))
                    ]
                )

                Divider()

                // Pill Style
                sectionHeader("Pill Style")
                DSSegmentedControl(
                    selection: $selectedSize,
                    segments: [
                        DSSegment(title: "S"),
                        DSSegment(title: "M"),
                        DSSegment(title: "L"),
                        DSSegment(title: "XL")
                    ],
                    style: .pill
                )

                Divider()

                // Underline Style
                sectionHeader("Underline Style")
                DSSegmentedControl(
                    selection: $selectedSegment,
                    segments: [
                        DSSegment(title: "Overview"),
                        DSSegment(title: "Analytics"),
                        DSSegment(title: "Reports")
                    ],
                    style: .underline
                )
            }
            .padding()
        }
        .navigationTitle("Segmented Control")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
struct NavigationDemoViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TabBarDemoView()
        }
    }
}
#endif
