import SwiftUI

// MARK: - Overlay Component Previews

#if DEBUG

/// Combined preview for all overlay components
struct DSOverlayPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            // All overlay components showcase
            OverlayShowcase()
                .previewDisplayName("Overlay Showcase")

            // Interactive demo
            InteractiveOverlayDemo()
                .previewDisplayName("Interactive Demo")
        }
    }
}

// MARK: - Overlay Showcase

private struct OverlayShowcase: View {
    @State private var showSheet = false
    @State private var showModal = false
    @State private var showFullScreen = false

    var body: some View {
        NavigationView {
            List {
                Section("Bottom Sheets") {
                    Button("Standard Sheet (Medium/Large)") {
                        showSheet = true
                    }
                }

                Section("Modals") {
                    Button("Center Modal") {
                        showModal = true
                    }
                }

                Section("Full Screen") {
                    Button("Full Screen Cover") {
                        showFullScreen = true
                    }
                }

                Section("Drag Indicator Styles") {
                    VStack(spacing: 16) {
                        indicatorRow("Standard", style: .standard)
                        indicatorRow("Light", style: .light, background: .black)
                        indicatorRow("Dark", style: .dark)
                        indicatorRow("Custom", style: .custom(.blue))
                    }
                    .padding(.vertical, 8)
                }

                Section("Detent Options") {
                    VStack(alignment: .leading, spacing: 8) {
                        detentRow(".small", fraction: DSDetent.small.fraction)
                        detentRow(".medium", fraction: DSDetent.medium.fraction)
                        detentRow(".large", fraction: DSDetent.large.fraction)
                        detentRow(".custom(0.7)", fraction: DSDetent.custom(0.7).fraction)
                    }
                }
            }
            .navigationTitle("Overlay Components")
        }
        .dsSheet(isPresented: $showSheet, detents: [.medium, .large]) {
            sheetContent
        }
        .dsModal(isPresented: $showModal, showCloseButton: true) {
            modalContent
        }
        .dsFullScreenCover(isPresented: $showFullScreen) {
            fullScreenContent
        }
    }

    private func indicatorRow(_ title: String, style: DSDragIndicator.Style, background: Color = Color(UIColor.secondarySystemBackground)) -> some View {
        HStack {
            Text(title)
                .font(.caption)
                .frame(width: 80, alignment: .leading)

            Spacer()

            VStack {
                DSDragIndicator(style: style)
            }
            .frame(width: 80, height: 30)
            .background(background)
            .cornerRadius(8)
        }
    }

    private func detentRow(_ name: String, fraction: CGFloat) -> some View {
        HStack {
            Text(name)
                .font(.system(.caption, design: .monospaced))

            Spacer()

            Text("\(Int(fraction * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)

            Rectangle()
                .fill(Color.accentColor.opacity(0.3))
                .frame(width: 100 * fraction, height: 20)
                .cornerRadius(4)
        }
    }

    private var sheetContent: some View {
        VStack(spacing: 16) {
            Text("Bottom Sheet")
                .font(.headline)

            Text("Drag to resize or dismiss")
                .font(.caption)
                .foregroundColor(.secondary)

            ForEach(0..<8) { index in
                HStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 40, height: 40)

                    VStack(alignment: .leading) {
                        Text("Item \(index + 1)")
                            .font(.headline)
                        Text("Description text")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
    }

    private var modalContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)

            Text("Enable Notifications?")
                .font(.headline)

            Text("Stay updated with the latest news and updates.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button("Enable") { }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                Button("Not Now") { }
                    .foregroundColor(.secondary)
            }
            .padding(.top, 8)
        }
        .padding(24)
    }

    private var fullScreenContent: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundColor(.yellow)

            Text("Welcome!")
                .font(.largeTitle)
                .bold()

            Text("This is a full screen cover that can display onboarding, media, or any full-screen content.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button("Get Started") { }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom, 60)
        }
    }
}

// MARK: - Interactive Demo

private struct InteractiveOverlayDemo: View {
    @State private var showSheet = false
    @State private var selectedDetent: DSDetent = .medium
    @State private var detents: [DSDetent] = [.small, .medium, .large]
    @State private var showDragIndicator = true
    @State private var dismissOnBackdropTap = true

    var body: some View {
        NavigationView {
            Form {
                Section("Configuration") {
                    Toggle("Show Drag Indicator", isOn: $showDragIndicator)
                    Toggle("Dismiss on Backdrop Tap", isOn: $dismissOnBackdropTap)

                    Picker("Available Detents", selection: $detents) {
                        Text("Small, Medium, Large").tag([DSDetent.small, .medium, .large])
                        Text("Medium, Large").tag([DSDetent.medium, .large])
                        Text("Medium Only").tag([DSDetent.medium])
                        Text("Large Only").tag([DSDetent.large])
                    }
                }

                Section("Current State") {
                    HStack {
                        Text("Selected Detent")
                        Spacer()
                        Text(detentName(selectedDetent))
                            .foregroundColor(.secondary)
                    }
                }

                Section {
                    Button("Show Sheet") {
                        showSheet = true
                    }
                }
            }
            .navigationTitle("Interactive Demo")
        }
        .dsSheet(
            isPresented: $showSheet,
            detents: detents,
            selectedDetent: $selectedDetent,
            showDragIndicator: showDragIndicator,
            dismissOnBackdropTap: dismissOnBackdropTap
        ) {
            VStack(spacing: 16) {
                Text("Interactive Sheet")
                    .font(.headline)

                Text("Current: \(detentName(selectedDetent))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(8)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(0..<15) { index in
                            HStack {
                                Text("Row \(index + 1)")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top)
        }
    }

    private func detentName(_ detent: DSDetent) -> String {
        switch detent {
        case .small: return "Small (25%)"
        case .medium: return "Medium (50%)"
        case .large: return "Large (90%)"
        case .custom(let value): return "Custom (\(Int(value * 100))%)"
        }
    }
}

// MARK: - Hashable Extension for Preview

extension [DSDetent]: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        for detent in self {
            hasher.combine(detent)
        }
    }
}

#endif
