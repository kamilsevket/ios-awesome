import SwiftUI
import DesignSystem

/// Demo view showcasing all Foundation elements: Colors, Typography, Spacing, Icons, and Shadows.
public struct FoundationDemoView: View {
    public init() {}

    public var body: some View {
        List {
            NavigationLink("Colors", destination: ColorsDemoView())
            NavigationLink("Typography", destination: TypographyDemoView())
            NavigationLink("Spacing", destination: SpacingDemoView())
            NavigationLink("Shadows & Elevation", destination: ShadowsDemoView())
        }
        .navigationTitle("Foundation")
    }
}

// MARK: - Colors Demo

struct ColorsDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                // Semantic Colors
                sectionHeader("Semantic Colors")
                colorRow("Primary", DSColors.primary)
                colorRow("Success", DSColors.success)
                colorRow("Warning", DSColors.warning)
                colorRow("Error", DSColors.error)
                colorRow("Info", DSColors.info)

                Divider()

                // Text Colors
                sectionHeader("Text Colors")
                colorRow("Text Primary", DSColors.textPrimary)
                colorRow("Text Secondary", DSColors.textSecondary)
                colorRow("Text Tertiary", DSColors.textTertiary)
                colorRow("Text Disabled", DSColors.textDisabled)

                Divider()

                // Status Colors
                sectionHeader("Status Colors")
                colorRow("Online", DSColors.statusOnline)
                colorRow("Offline", DSColors.statusOffline)
                colorRow("Busy", DSColors.statusBusy)
                colorRow("Away", DSColors.statusAway)

                Divider()

                // Background Colors
                sectionHeader("Background Colors")
                colorRow("Background Primary", DSColors.backgroundPrimary)
                colorRow("Background Secondary", DSColors.backgroundSecondary)
                colorRow("Background Tertiary", DSColors.backgroundTertiary)

                Divider()

                // Border Colors
                sectionHeader("Border Colors")
                colorRow("Border", DSColors.border)
                colorRow("Border Focused", DSColors.borderFocused)
                colorRow("Border Disabled", DSColors.borderDisabled)

                Divider()

                // Selection Colors
                sectionHeader("Selection Control Colors")
                colorRow("Selection Checked", DSColors.selectionChecked)
                colorRow("Selection Border", DSColors.selectionBorder)
                colorRow("Toggle Track On", DSColors.toggleTrackOn)
                colorRow("Toggle Track Off", DSColors.toggleTrackOff)
            }
            .padding()
        }
        .navigationTitle("Colors")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(DSColors.textPrimary)
    }

    private func colorRow(_ name: String, _ color: Color) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 48, height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DSColors.border, lineWidth: 1)
                )

            Text(name)
                .font(.body)
                .foregroundColor(DSColors.textPrimary)

            Spacer()
        }
    }
}

// MARK: - Typography Demo

struct TypographyDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                // Display Fonts
                sectionHeader("Display Fonts")
                Text("Large Title").font(.largeTitle)
                Text("Title 1").font(.title)
                Text("Title 2").font(.title2)
                Text("Title 3").font(.title3)

                Divider()

                // Content Fonts
                sectionHeader("Content Fonts")
                Text("Headline").font(.headline)
                Text("Body").font(.body)
                Text("Callout").font(.callout)
                Text("Subheadline").font(.subheadline)

                Divider()

                // Supporting Fonts
                sectionHeader("Supporting Fonts")
                Text("Footnote").font(.footnote)
                Text("Caption").font(.caption)
                Text("Caption 2").font(.caption2)

                Divider()

                // Font Weights
                sectionHeader("Font Weights")
                Text("Ultralight").fontWeight(.ultraLight)
                Text("Light").fontWeight(.light)
                Text("Regular").fontWeight(.regular)
                Text("Medium").fontWeight(.medium)
                Text("Semibold").fontWeight(.semibold)
                Text("Bold").fontWeight(.bold)
                Text("Heavy").fontWeight(.heavy)
                Text("Black").fontWeight(.black)
            }
            .padding()
        }
        .navigationTitle("Typography")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(DSColors.textSecondary)
            .padding(.top, DSSpacing.sm)
    }
}

// MARK: - Spacing Demo

struct SpacingDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                Text("Spacing tokens provide consistent spacing throughout the design system.")
                    .font(.body)
                    .foregroundColor(DSColors.textSecondary)

                Divider()

                spacingRow("xxs", DSSpacing.xxs)
                spacingRow("xs", DSSpacing.xs)
                spacingRow("sm", DSSpacing.sm)
                spacingRow("md", DSSpacing.md)
                spacingRow("lg", DSSpacing.lg)
                spacingRow("xl", DSSpacing.xl)
                spacingRow("xxl", DSSpacing.xxl)

                Divider()

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    Text("Min Touch Target")
                        .font(.headline)

                    HStack {
                        Rectangle()
                            .fill(DSColors.primary)
                            .frame(width: DSSpacing.minTouchTarget, height: DSSpacing.minTouchTarget)

                        Text("\(Int(DSSpacing.minTouchTarget))pt - Apple HIG minimum")
                            .font(.body)
                            .foregroundColor(DSColors.textSecondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Spacing")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
        HStack {
            Rectangle()
                .fill(DSColors.primary)
                .frame(width: value, height: 24)

            Text("\(name): \(Int(value))pt")
                .font(.body)

            Spacer()
        }
    }
}

// MARK: - Shadows Demo

struct ShadowsDemoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.xl) {
                Text("Shadows and elevation provide depth and visual hierarchy.")
                    .font(.body)
                    .foregroundColor(DSColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Elevation levels
                elevationCard("No Elevation", elevation: 0)
                elevationCard("Low Elevation", elevation: 2)
                elevationCard("Medium Elevation", elevation: 4)
                elevationCard("High Elevation", elevation: 8)
                elevationCard("Highest Elevation", elevation: 16)
            }
            .padding()
        }
        .navigationTitle("Shadows & Elevation")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func elevationCard(_ title: String, elevation: CGFloat) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            Text("Elevation: \(Int(elevation))")
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(DSColors.backgroundPrimary)
        .cornerRadius(12)
        .shadow(
            color: .black.opacity(0.1),
            radius: elevation,
            x: 0,
            y: elevation / 2
        )
    }
}

#if DEBUG
struct FoundationDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FoundationDemoView()
        }
    }
}
#endif
