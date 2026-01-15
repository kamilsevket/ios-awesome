import SwiftUI

/// A preview view that displays all color tokens in both light and dark modes.
/// Use this view in Xcode previews to visualize the entire color system.
public struct ColorPreview: View {

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                primarySection
                secondarySection
                tertiarySection
                semanticSection
                uiSection
            }
            .padding()
        }
        .background(Color.ui.background)
    }

    // MARK: - Primary Section

    private var primarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Primary")
                .font(.headline)
                .foregroundColor(Color.ui.textPrimary)

            HStack(spacing: 4) {
                colorSwatch(.primary50, label: "50")
                colorSwatch(.primary100, label: "100")
                colorSwatch(.primary200, label: "200")
                colorSwatch(.primary300, label: "300")
                colorSwatch(.primary400, label: "400")
                colorSwatch(.primary500, label: "500")
                colorSwatch(.primary600, label: "600")
                colorSwatch(.primary700, label: "700")
                colorSwatch(.primary800, label: "800")
                colorSwatch(.primary900, label: "900")
            }
        }
    }

    // MARK: - Secondary Section

    private var secondarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Secondary")
                .font(.headline)
                .foregroundColor(Color.ui.textPrimary)

            HStack(spacing: 4) {
                colorSwatch(.secondary50, label: "50")
                colorSwatch(.secondary100, label: "100")
                colorSwatch(.secondary200, label: "200")
                colorSwatch(.secondary300, label: "300")
                colorSwatch(.secondary400, label: "400")
                colorSwatch(.secondary500, label: "500")
                colorSwatch(.secondary600, label: "600")
                colorSwatch(.secondary700, label: "700")
                colorSwatch(.secondary800, label: "800")
                colorSwatch(.secondary900, label: "900")
            }
        }
    }

    // MARK: - Tertiary Section

    private var tertiarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tertiary")
                .font(.headline)
                .foregroundColor(Color.ui.textPrimary)

            HStack(spacing: 4) {
                colorSwatch(.tertiary50, label: "50")
                colorSwatch(.tertiary100, label: "100")
                colorSwatch(.tertiary200, label: "200")
                colorSwatch(.tertiary300, label: "300")
                colorSwatch(.tertiary400, label: "400")
                colorSwatch(.tertiary500, label: "500")
                colorSwatch(.tertiary600, label: "600")
                colorSwatch(.tertiary700, label: "700")
                colorSwatch(.tertiary800, label: "800")
                colorSwatch(.tertiary900, label: "900")
            }
        }
    }

    // MARK: - Semantic Section

    private var semanticSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Semantic")
                .font(.headline)
                .foregroundColor(Color.ui.textPrimary)

            HStack(spacing: 8) {
                VStack(spacing: 4) {
                    colorSwatch(Color.semantic.success, label: "Success")
                    colorSwatch(Color.semantic.successLight, label: "Light")
                }
                VStack(spacing: 4) {
                    colorSwatch(Color.semantic.warning, label: "Warning")
                    colorSwatch(Color.semantic.warningLight, label: "Light")
                }
                VStack(spacing: 4) {
                    colorSwatch(Color.semantic.error, label: "Error")
                    colorSwatch(Color.semantic.errorLight, label: "Light")
                }
                VStack(spacing: 4) {
                    colorSwatch(Color.semantic.info, label: "Info")
                    colorSwatch(Color.semantic.infoLight, label: "Light")
                }
            }
        }
    }

    // MARK: - UI Section

    private var uiSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("UI Colors")
                .font(.headline)
                .foregroundColor(Color.ui.textPrimary)

            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    colorSwatch(Color.ui.background, label: "Background")
                    colorSwatch(Color.ui.backgroundSecondary, label: "Bg Secondary")
                    colorSwatch(Color.ui.surface, label: "Surface")
                    colorSwatch(Color.ui.surfaceElevated, label: "Elevated")
                }
                HStack(spacing: 4) {
                    colorSwatch(Color.ui.textPrimary, label: "Text Primary")
                    colorSwatch(Color.ui.textSecondary, label: "Text Secondary")
                    colorSwatch(Color.ui.textTertiary, label: "Text Tertiary")
                    colorSwatch(Color.ui.textInverse, label: "Text Inverse")
                }
                HStack(spacing: 4) {
                    colorSwatch(Color.ui.border, label: "Border")
                    colorSwatch(Color.ui.divider, label: "Divider")
                    Spacer()
                    Spacer()
                }
            }
        }
    }

    // MARK: - Helper

    private func colorSwatch(_ color: Color, label: String) -> some View {
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.ui.border, lineWidth: 0.5)
                )

            Text(label)
                .font(.system(size: 8))
                .foregroundColor(Color.ui.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview Provider

struct ColorPreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ColorPreview()
                .previewDisplayName("Light Mode")
                .preferredColorScheme(.light)

            ColorPreview()
                .previewDisplayName("Dark Mode")
                .preferredColorScheme(.dark)
        }
    }
}
