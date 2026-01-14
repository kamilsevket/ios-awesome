import SwiftUI

// MARK: - Shadow Token Preview

@available(iOS 15.0, macOS 12.0, *)
struct ShadowTokenPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                shadowTokenSection
                elevationSection
                materialSection
                darkModeSection
            }
            .padding(24)
        }
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Shadow Tokens Section

    private var shadowTokenSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Shadow Tokens")
                .font(.headline)

            HStack(spacing: 20) {
                ForEach(ShadowToken.allCases, id: \.self) { token in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .frame(width: 60, height: 60)
                            .shadow(token)

                        Text(token.rawValue.isEmpty ? "none" : token.rawValue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Elevation Section

    private var elevationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Elevation Levels")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(ElevationLevel.allCases, id: \.self) { level in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                            .frame(height: 60)
                            .elevation(level)

                        Text("Level \(level.rawValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Material Section

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    private var materialSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Material Backgrounds")
                .font(.headline)

            ZStack {
                // Background gradient for material visibility
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                .cornerRadius(16)

                HStack(spacing: 12) {
                    ForEach(DSMaterialStyle.allCases, id: \.self) { style in
                        VStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(style.material)
                                .frame(width: 50, height: 50)

                            Text(materialName(style))
                                .font(.system(size: 9))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Dark Mode Section

    private var darkModeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dark Mode Adaptation")
                .font(.headline)

            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .frame(width: 80, height: 60)
                        .shadow(.lg)
                        .environment(\.colorScheme, .light)

                    Text("Light")
                        .font(.caption)
                }

                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .frame(width: 80, height: 60)
                        .shadow(.lg)
                        .environment(\.colorScheme, .dark)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(12)

                    Text("Dark")
                        .font(.caption)
                }
            }
        }
    }

    // MARK: - Helpers

    private func materialName(_ style: DSMaterialStyle) -> String {
        switch style {
        case .ultraThin: return "Ultra Thin"
        case .thin: return "Thin"
        case .regular: return "Regular"
        case .thick: return "Thick"
        case .ultraThick: return "Ultra Thick"
        }
    }
}

// MARK: - Preview Provider

@available(iOS 15.0, macOS 12.0, *)
struct ShadowPreviews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ShadowTokenPreview()
                .previewDisplayName("Light Mode")

            ShadowTokenPreview()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

// MARK: - Interactive Shadow Demo

@available(iOS 15.0, macOS 12.0, *)
struct InteractiveShadowDemo: View {
    @State private var selectedToken: ShadowToken = .md
    @State private var selectedElevation: ElevationLevel = .level2

    var body: some View {
        VStack(spacing: 32) {
            // Shadow Token Picker
            VStack(spacing: 12) {
                Text("Shadow Token")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Picker("Shadow", selection: $selectedToken) {
                    ForEach(ShadowToken.allCases, id: \.self) { token in
                        Text(token.rawValue.isEmpty ? "none" : token.rawValue)
                            .tag(token)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Preview Card
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .frame(width: 200, height: 120)
                .shadow(selectedToken)
                .animation(.easeInOut(duration: 0.3), value: selectedToken)

            // Token Details
            VStack(spacing: 4) {
                Text("Blur: \(Int(selectedToken.blur))")
                Text("Y Offset: \(Int(selectedToken.y))")
                Text("Opacity: \(String(format: "%.2f", selectedToken.opacity))")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
    }
}

@available(iOS 15.0, macOS 12.0, *)
struct InteractiveShadowDemo_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveShadowDemo()
    }
}
