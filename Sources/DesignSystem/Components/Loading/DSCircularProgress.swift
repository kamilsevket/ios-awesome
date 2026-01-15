import SwiftUI

/// Size variants for circular progress indicator
public enum DSCircularProgressSize: CaseIterable {
    case small
    case medium
    case large

    var diameter: CGFloat {
        switch self {
        case .small: return 20
        case .medium: return 40
        case .large: return 60
        }
    }

    var lineWidth: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }
}

/// A circular progress indicator that supports both determinate and indeterminate modes.
///
/// Use `DSCircularProgress` to show loading state or progress of a task.
///
/// Example usage:
/// ```swift
/// // Indeterminate (spinning)
/// DSCircularProgress()
///
/// // Determinate with progress value
/// DSCircularProgress(value: 0.7)
///
/// // Custom size and color
/// DSCircularProgress(value: 0.5, size: .large, color: .green)
/// ```
public struct DSCircularProgress: View {
    // MARK: - Properties

    /// Progress value from 0.0 to 1.0. Nil for indeterminate mode.
    private let value: Double?

    /// Size of the progress indicator
    private let size: DSCircularProgressSize

    /// Tint color for the progress indicator
    private let color: Color

    /// Track color (background circle)
    private let trackColor: Color

    /// Whether to show the track circle
    private let showTrack: Bool

    // MARK: - State

    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a circular progress indicator.
    /// - Parameters:
    ///   - value: Progress value from 0.0 to 1.0. Pass nil for indeterminate mode.
    ///   - size: Size variant of the indicator.
    ///   - color: Tint color for the progress arc.
    ///   - trackColor: Color of the background track circle.
    ///   - showTrack: Whether to show the track circle.
    public init(
        value: Double? = nil,
        size: DSCircularProgressSize = .medium,
        color: Color = DSColors.primary,
        trackColor: Color = DSColors.loadingTrack,
        showTrack: Bool = true
    ) {
        self.value = value.map { min(max($0, 0), 1) }
        self.size = size
        self.color = color
        self.trackColor = trackColor
        self.showTrack = showTrack
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Track circle
            if showTrack {
                Circle()
                    .stroke(trackColor, lineWidth: size.lineWidth)
            }

            // Progress arc
            if let value = value {
                // Determinate mode
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: size.lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: value)
            } else {
                // Indeterminate mode
                Circle()
                    .trim(from: 0.1, to: 0.9)
                    .stroke(
                        color,
                        style: StrokeStyle(
                            lineWidth: size.lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
            }
        }
        .frame(width: size.diameter, height: size.diameter)
        .onAppear {
            startAnimationIfNeeded()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityAddTraits(.updatesFrequently)
    }

    // MARK: - Private Methods

    private func startAnimationIfNeeded() {
        guard value == nil else { return }

        if reduceMotion {
            // For reduced motion, use a slower, gentler animation
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        } else {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        if value != nil {
            return "Progress indicator"
        } else {
            return "Loading"
        }
    }

    private var accessibilityValue: String {
        if let value = value {
            return "\(Int(value * 100)) percent"
        } else {
            return "In progress"
        }
    }
}

// MARK: - Previews

#if DEBUG
struct DSCircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            // Indeterminate modes
            HStack(spacing: 24) {
                DSCircularProgress(size: .small)
                DSCircularProgress(size: .medium)
                DSCircularProgress(size: .large)
            }

            // Determinate modes
            HStack(spacing: 24) {
                DSCircularProgress(value: 0.25, size: .small)
                DSCircularProgress(value: 0.5, size: .medium)
                DSCircularProgress(value: 0.75, size: .large)
            }

            // Custom colors
            HStack(spacing: 24) {
                DSCircularProgress(value: 0.6, color: DSColors.success)
                DSCircularProgress(value: 0.4, color: DSColors.warning)
                DSCircularProgress(value: 0.8, color: DSColors.error)
            }

            // Without track
            DSCircularProgress(value: 0.6, showTrack: false)
        }
        .padding()
        .previewDisplayName("Light Mode")

        VStack(spacing: 32) {
            DSCircularProgress(size: .medium)
            DSCircularProgress(value: 0.7, size: .large)
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif
