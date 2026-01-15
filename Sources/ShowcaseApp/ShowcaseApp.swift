import SwiftUI

/// Component Showcase App - A demonstration application for all design system components
///
/// This app provides:
/// - Live previews of all components
/// - Interactive playground for customization
/// - Code snippets for easy copy-paste
/// - Dark/Light theme toggle
@main
public struct ShowcaseApp: App {
    @StateObject private var themeManager = ThemeManager()

    public init() {}

    public var body: some Scene {
        WindowGroup {
            ShowcaseRootView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}

/// Theme manager for handling Dark/Light mode toggle
public class ThemeManager: ObservableObject {
    @Published public var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    public var colorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }

    public init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }

    public func toggle() {
        isDarkMode.toggle()
    }
}
