import SwiftUI

/// Style variants for loading overlay
public enum DSLoadingOverlayStyle {
    /// Circular progress indicator
    case circular
    /// Linear progress indicator
    case linear
    /// Custom view
    case custom
}

/// A view modifier that displays a loading overlay on top of content.
///
/// The loading overlay dims the underlying content and shows a loading indicator.
public struct LoadingOverlayModifier: ViewModifier {
    // MARK: - Properties

    /// Whether the loading overlay is visible
    private let isLoading: Bool

    /// Style of the loading indicator
    private let style: DSLoadingOverlayStyle

    /// Optional progress value (0-1) for determinate mode
    private let progress: Double?

    /// Background dim color
    private let dimColor: Color

    /// Tint color for the loading indicator
    private let tintColor: Color

    /// Whether to block interaction with underlying content
    private let blocksInteraction: Bool

    /// Optional loading message
    private let message: String?

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a loading overlay modifier.
    /// - Parameters:
    ///   - isLoading: Whether the loading overlay is visible.
    ///   - style: Style of the loading indicator.
    ///   - progress: Optional progress value (0-1) for determinate mode.
    ///   - dimColor: Background dim color. Defaults to semi-transparent black.
    ///   - tintColor: Tint color for the loading indicator.
    ///   - blocksInteraction: Whether to block interaction with underlying content.
    ///   - message: Optional loading message to display.
    public init(
        isLoading: Bool,
        style: DSLoadingOverlayStyle = .circular,
        progress: Double? = nil,
        dimColor: Color = Color.black.opacity(0.4),
        tintColor: Color = DSColors.primary,
        blocksInteraction: Bool = true,
        message: String? = nil
    ) {
        self.isLoading = isLoading
        self.style = style
        self.progress = progress
        self.dimColor = dimColor
        self.tintColor = tintColor
        self.blocksInteraction = blocksInteraction
        self.message = message
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading && blocksInteraction)

            if isLoading {
                overlayView
                    .transition(.opacity)
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.25), value: isLoading)
    }

    // MARK: - Private Views

    private var overlayView: some View {
        ZStack {
            // Dim background
            dimColor
                .ignoresSafeArea()

            // Loading indicator container
            VStack(spacing: DSSpacing.md) {
                loadingIndicator

                if let message = message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(textColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(DSSpacing.lg)
            .background(containerBackground)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.updatesFrequently)
    }

    @ViewBuilder
    private var loadingIndicator: some View {
        switch style {
        case .circular:
            if let progress = progress {
                DSCircularProgress(value: progress, size: .large, color: tintColor)
            } else {
                DSCircularProgress(size: .large, color: tintColor)
            }
        case .linear:
            if let progress = progress {
                DSLinearProgress(value: progress, size: .large, color: tintColor)
                    .frame(width: 200)
            } else {
                DSLinearProgress(isAnimating: true, size: .large, color: tintColor)
                    .frame(width: 200)
            }
        case .custom:
            DSCircularProgress(size: .large, color: tintColor)
        }
    }

    private var containerBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(colorScheme == .dark
                  ? Color(UIColor.secondarySystemBackground)
                  : Color(UIColor.systemBackground))
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : Color(UIColor.label)
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        if let message = message {
            return "Loading: \(message)"
        }
        return "Loading"
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a loading overlay to the view.
    /// - Parameters:
    ///   - isLoading: Whether the loading overlay is visible.
    ///   - style: Style of the loading indicator.
    ///   - progress: Optional progress value (0-1) for determinate mode.
    ///   - message: Optional loading message to display.
    /// - Returns: The view with loading overlay applied.
    func loadingOverlay(
        _ isLoading: Bool,
        style: DSLoadingOverlayStyle = .circular,
        progress: Double? = nil,
        message: String? = nil
    ) -> some View {
        modifier(
            LoadingOverlayModifier(
                isLoading: isLoading,
                style: style,
                progress: progress,
                message: message
            )
        )
    }

    /// Applies a loading overlay with custom configuration.
    /// - Parameters:
    ///   - isLoading: Whether the loading overlay is visible.
    ///   - style: Style of the loading indicator.
    ///   - progress: Optional progress value (0-1) for determinate mode.
    ///   - dimColor: Background dim color.
    ///   - tintColor: Tint color for the loading indicator.
    ///   - blocksInteraction: Whether to block interaction with underlying content.
    ///   - message: Optional loading message to display.
    /// - Returns: The view with loading overlay applied.
    func loadingOverlay(
        _ isLoading: Bool,
        style: DSLoadingOverlayStyle = .circular,
        progress: Double? = nil,
        dimColor: Color = Color.black.opacity(0.4),
        tintColor: Color = DSColors.primary,
        blocksInteraction: Bool = true,
        message: String? = nil
    ) -> some View {
        modifier(
            LoadingOverlayModifier(
                isLoading: isLoading,
                style: style,
                progress: progress,
                dimColor: dimColor,
                tintColor: tintColor,
                blocksInteraction: blocksInteraction,
                message: message
            )
        )
    }
}

// MARK: - Previews

#if DEBUG
struct LoadingOverlayModifier_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlayPreviewWrapper()
            .previewDisplayName("Light Mode")

        LoadingOverlayPreviewWrapper()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct LoadingOverlayPreviewWrapper: View {
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Content goes here")
                    .font(.title)

                Text("This content is dimmed when loading")
                    .foregroundColor(.secondary)

                Button("Toggle Loading") {
                    isLoading.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Loading Overlay")
        }
        .loadingOverlay(isLoading, message: "Please wait...")
    }
}
#endif
