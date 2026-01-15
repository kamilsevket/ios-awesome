import SwiftUI

/// Settings view for app configuration including theme toggle
public struct SettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showAbout = false

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                // Appearance section
                Section {
                    themeToggle
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Toggle between light and dark mode for the showcase app.")
                }

                // About section
                Section("About") {
                    aboutRow(title: "Version", value: "1.0.0")
                    aboutRow(title: "Design System", value: "iOS Components")
                    aboutRow(title: "Platform", value: "iOS 15+")

                    Button {
                        showAbout = true
                    } label: {
                        HStack {
                            Text("About Design System")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                // Resources section
                Section("Resources") {
                    resourceLink(title: "Documentation", icon: "doc.text.fill", url: "https://github.com")
                    resourceLink(title: "GitHub Repository", icon: "link", url: "https://github.com")
                    resourceLink(title: "Report Issue", icon: "exclamationmark.bubble.fill", url: "https://github.com")
                }

                // Component stats section
                Section("Statistics") {
                    statsRow(title: "Total Components", value: "\(totalComponentCount)")
                    statsRow(title: "Categories", value: "\(ComponentCategory.allCases.count)")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
        }
    }

    private var themeToggle: some View {
        Toggle(isOn: $themeManager.isDarkMode) {
            HStack(spacing: 12) {
                Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                    .font(.system(size: 20))
                    .foregroundColor(themeManager.isDarkMode ? .purple : .orange)
                    .frame(width: 28)

                VStack(alignment: .leading) {
                    Text("Dark Mode")
                        .font(.body)
                    Text(themeManager.isDarkMode ? "Currently using dark theme" : "Currently using light theme")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .tint(.accentColor)
    }

    private func aboutRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }

    private func statsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(.accentColor)
        }
    }

    private func resourceLink(title: String, icon: String, url: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 24)

            Text(title)

            Spacer()

            Image(systemName: "arrow.up.right.square")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private var totalComponentCount: Int {
        ComponentCategory.allCases.reduce(0) { $0 + $1.components.count }
    }
}

/// About view showing information about the design system
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo/icon
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.accentColor)
                        .padding(.top, 32)

                    // Title
                    VStack(spacing: 8) {
                        Text("iOS Components")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Design System Showcase")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Description
                    Text("A comprehensive collection of reusable UI components for iOS applications. Built with SwiftUI and designed for accessibility, customization, and ease of use.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)

                    // Features
                    VStack(alignment: .leading, spacing: 16) {
                        FeatureRow(icon: "paintbrush.fill", title: "Customizable", description: "Easily adapt components to your brand")
                        FeatureRow(icon: "accessibility", title: "Accessible", description: "Built with accessibility in mind")
                        FeatureRow(icon: "moon.fill", title: "Dark Mode", description: "Full dark mode support")
                        FeatureRow(icon: "iphone", title: "Native", description: "Built for iOS with SwiftUI")
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.accentColor)
                .frame(width: 40, height: 40)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ThemeManager())
    }
}
#endif
