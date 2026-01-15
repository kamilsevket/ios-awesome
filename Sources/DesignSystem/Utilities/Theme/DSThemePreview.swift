import SwiftUI

// MARK: - Theme Preview Provider

/// A preview wrapper that shows content in multiple theme modes.
///
/// Usage:
/// ```swift
/// struct MyView_Previews: PreviewProvider {
///     static var previews: some View {
///         DSThemePreview {
///             MyView()
///         }
///     }
/// }
/// ```
public struct DSThemePreview<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        Group {
            DSThemeProvider(mode: .light) {
                content
            }
            .previewDisplayName("Light Mode")

            DSThemeProvider(mode: .dark) {
                content
            }
            .previewDisplayName("Dark Mode")
        }
    }
}

// MARK: - Theme Color Swatch Preview

/// A view that displays all theme colors for visual inspection.
public struct DSThemeColorSwatchView: View {
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Theme Name
                Text(theme.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(theme.textPrimary)

                // Primary Colors
                colorSection(title: "Primary") {
                    colorRow("Primary", theme.primary)
                    colorRow("Primary Variant", theme.primaryVariant)
                    colorRow("On Primary", theme.onPrimary)
                }

                // Secondary Colors
                colorSection(title: "Secondary") {
                    colorRow("Secondary", theme.secondary)
                    colorRow("Secondary Variant", theme.secondaryVariant)
                    colorRow("On Secondary", theme.onSecondary)
                }

                // Background Colors
                colorSection(title: "Background") {
                    colorRow("Background", theme.background)
                    colorRow("Background Secondary", theme.backgroundSecondary)
                    colorRow("On Background", theme.onBackground)
                }

                // Surface Colors
                colorSection(title: "Surface") {
                    colorRow("Surface", theme.surface)
                    colorRow("Surface Elevated", theme.surfaceElevated)
                    colorRow("On Surface", theme.onSurface)
                }

                // Semantic Colors
                colorSection(title: "Semantic") {
                    colorRow("Success", theme.success)
                    colorRow("Warning", theme.warning)
                    colorRow("Error", theme.error)
                    colorRow("Info", theme.info)
                }

                // Text Colors
                colorSection(title: "Text") {
                    colorRow("Text Primary", theme.textPrimary)
                    colorRow("Text Secondary", theme.textSecondary)
                    colorRow("Text Tertiary", theme.textTertiary)
                }

                // Border & Divider
                colorSection(title: "Border & Divider") {
                    colorRow("Border", theme.border)
                    colorRow("Divider", theme.divider)
                }
            }
            .padding()
        }
        .background(theme.background)
    }

    @ViewBuilder
    private func colorSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)

            content()
        }
    }

    @ViewBuilder
    private func colorRow(_ name: String, _ color: Color) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(theme.border, lineWidth: 1)
                )

            Text(name)
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)

            Spacer()
        }
    }
}

// MARK: - Theme Switcher Preview

/// A demo view showing theme switching functionality.
public struct DSThemeSwitcherDemoView: View {
    @ObservedObject private var manager = DSThemeManager.shared
    @Environment(\.dsTheme) private var theme

    public init() {}

    public var body: some View {
        VStack(spacing: 24) {
            // Theme Mode Buttons
            VStack(spacing: 12) {
                Text("Theme Mode")
                    .font(.headline)
                    .foregroundColor(theme.textPrimary)

                HStack(spacing: 12) {
                    ForEach(DSThemeMode.allCases, id: \.self) { mode in
                        Button {
                            manager.setThemeMode(mode)
                        } label: {
                            Text(mode.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(manager.themeMode == mode ? .bold : .regular)
                                .foregroundColor(manager.themeMode == mode ? theme.onPrimary : theme.textPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(manager.themeMode == mode ? theme.primary : theme.surface)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(theme.border, lineWidth: 1)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // Sample Content
            VStack(spacing: 16) {
                Text("Sample Content")
                    .font(.headline)
                    .foregroundColor(theme.textPrimary)

                VStack(spacing: 12) {
                    sampleCard(title: "Primary", color: theme.primary, textColor: theme.onPrimary)
                    sampleCard(title: "Secondary", color: theme.secondary, textColor: theme.onSecondary)
                    sampleCard(title: "Surface", color: theme.surface, textColor: theme.onSurface)
                }
            }

            // Semantic Colors
            HStack(spacing: 8) {
                semanticBadge("Success", color: theme.success)
                semanticBadge("Warning", color: theme.warning)
                semanticBadge("Error", color: theme.error)
                semanticBadge("Info", color: theme.info)
            }

            Spacer()
        }
        .padding()
        .background(theme.background)
    }

    @ViewBuilder
    private func sampleCard(title: String, color: Color, textColor: Color) -> some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(textColor)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
        )
    }

    @ViewBuilder
    private func semanticBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

// MARK: - Previews

#if DEBUG
struct DSThemeColorSwatchView_Previews: PreviewProvider {
    static var previews: some View {
        DSThemePreview {
            DSThemeColorSwatchView()
        }
    }
}

struct DSThemeSwitcherDemoView_Previews: PreviewProvider {
    static var previews: some View {
        DSThemeSwitcherDemoView()
            .dsThemeManaged()
    }
}
#endif
