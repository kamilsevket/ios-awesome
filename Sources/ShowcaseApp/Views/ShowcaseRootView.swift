import SwiftUI

/// Root view of the Showcase app with tab-based navigation
public struct ShowcaseRootView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedTab: Tab = .components
    @State private var searchText = ""

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            ComponentsListView(searchText: $searchText)
                .tabItem {
                    Label("Components", systemImage: "square.grid.2x2.fill")
                }
                .tag(Tab.components)

            PlaygroundView()
                .tabItem {
                    Label("Playground", systemImage: "hammer.fill")
                }
                .tag(Tab.playground)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(.accentColor)
    }

    enum Tab: Hashable {
        case components
        case playground
        case settings
    }
}

#if DEBUG
struct ShowcaseRootView_Previews: PreviewProvider {
    static var previews: some View {
        ShowcaseRootView()
            .environmentObject(ThemeManager())
    }
}
#endif
