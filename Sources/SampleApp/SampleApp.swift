import SwiftUI
import DesignSystem

/// Main entry point for the Sample App showcasing all DesignSystem components.
///
/// This comprehensive sample app demonstrates every component, feature, and utility
/// available in the DesignSystem package.
public struct SampleApp: View {
    public init() {}

    public var body: some View {
        SampleAppRootView()
    }
}

/// Root view containing the main tab navigation for the sample app.
public struct SampleAppRootView: View {
    @State private var selectedTab = 0

    public var body: some View {
        TabView(selection: $selectedTab) {
            // Foundation Tab
            NavigationView {
                FoundationDemoView()
            }
            .tabItem {
                Label("Foundation", systemImage: "paintbrush")
            }
            .tag(0)

            // Components Tab
            NavigationView {
                ComponentsDemoView()
            }
            .tabItem {
                Label("Components", systemImage: "square.grid.2x2")
            }
            .tag(1)

            // Forms Tab
            NavigationView {
                FormsDemoView()
            }
            .tabItem {
                Label("Forms", systemImage: "doc.text")
            }
            .tag(2)

            // Feedback Tab
            NavigationView {
                FeedbackDemoView()
            }
            .tabItem {
                Label("Feedback", systemImage: "bell")
            }
            .tag(3)

            // Utilities Tab
            NavigationView {
                UtilitiesDemoView()
            }
            .tabItem {
                Label("Utilities", systemImage: "gear")
            }
            .tag(4)
        }
    }
}

#if DEBUG
struct SampleApp_Previews: PreviewProvider {
    static var previews: some View {
        SampleApp()
    }
}
#endif
