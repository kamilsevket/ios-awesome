import SwiftUI

/// Size variants for linear progress indicator
public enum DSLinearProgressSize: CaseIterable {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 8
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return 1
        case .medium: return 2
        case .large: return 4
        }
    }
}

/// A linear (horizontal bar) progress indicator that supports both determinate and indeterminate modes.
///
/// Use `DSLinearProgress` to show loading state or progress of a task as a horizontal bar.
///
/// Example usage:
/// ```swift
/// // Indeterminate (animating)
/// DSLinearProgress(isAnimating: true)
///
/// // Determinate with progress value
/// DSLinearProgress(value: 0.7)
///
/// // Custom size and color
/// DSLinearProgress(value: 0.5, size: .large, color: .green)
/// ```
public struct DSLinearProgress: View {
    // MARK: - Properties

    /// Progress value from 0.0 to 1.0. Nil for indeterminate mode.
    private let value: Double?

    /// Whether the indeterminate animation is active
    private let isAnimating: Bool

    /// Size of the progress indicator
    private let size: DSLinearProgressSize

    /// Tint color for the progress indicator
    private let color: Color

    /// Track color (background bar)
    private let trackColor: Color

    // MARK: - State

    @State private var animationOffset: CGFloat = -1.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a linear progress indicator with a specific progress value.
    /// - Parameters:
    ///   - value: Progress value from 0.0 to 1.0.
    ///   - size: Size variant of the indicator.
    ///   - color: Tint color for the progress bar.
    ///   - trackColor: Color of the background track.
    public init(
        value: Double,
        size: DSLinearProgressSize = .medium,
        color: Color = DSColors.primary,
        trackColor: Color = DSColors.loadingTrack
    ) {
        self.value = min(max(value, 0), 1)
        self.isAnimating = false
        self.size = size
        self.color = color
        self.trackColor = trackColor
    }

    /// Creates an indeterminate linear progress indicator.
    /// - Parameters:
    ///   - isAnimating: Whether the animation is active.
    ///   - size: Size variant of the indicator.
    ///   - color: Tint color for the progress bar.
    ///   - trackColor: Color of the background track.
    public init(
        isAnimating: Bool = true,
        size: DSLinearProgressSize = .medium,
        color: Color = DSColors.primary,
        trackColor: Color = DSColors.loadingTrack
    ) {
        self.value = nil
        self.isAnimating = isAnimating
        self.size = size
        self.color = color
        self.trackColor = trackColor
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .fill(trackColor)

                // Progress bar
                if let value = value {
                    // Determinate mode
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(color)
                        .frame(width: geometry.size.width * value)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: value)
                } else if isAnimating {
                    // Indeterminate mode
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .fill(color)
                        .frame(width: geometry.size.width * 0.3)
                        .offset(x: animationOffset * geometry.size.width)
                }
            }
        }
        .frame(height: size.height)
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
        guard value == nil && isAnimating else { return }

        let duration = reduceMotion ? 2.0 : 1.5

        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
        ) {
            animationOffset = 0.7
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
        } else if isAnimating {
            return "In progress"
        } else {
            return "Paused"
        }
    }
}

// MARK: - Previews

#if DEBUG
struct DSLinearProgress_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            // Indeterminate modes
            VStack(spacing: 16) {
                Text("Indeterminate").font(.headline)
                DSLinearProgress(isAnimating: true, size: .small)
                DSLinearProgress(isAnimating: true, size: .medium)
                DSLinearProgress(isAnimating: true, size: .large)
            }

            // Determinate modes
            VStack(spacing: 16) {
                Text("Determinate").font(.headline)
                DSLinearProgress(value: 0.25, size: .small)
                DSLinearProgress(value: 0.5, size: .medium)
                DSLinearProgress(value: 0.75, size: .large)
            }

            // Custom colors
            VStack(spacing: 16) {
                Text("Custom Colors").font(.headline)
                DSLinearProgress(value: 0.6, color: DSColors.success)
                DSLinearProgress(value: 0.4, color: DSColors.warning)
                DSLinearProgress(value: 0.8, color: DSColors.error)
            }
        }
        .padding()
        .previewDisplayName("Light Mode")

        VStack(spacing: 32) {
            DSLinearProgress(isAnimating: true, size: .medium)
            DSLinearProgress(value: 0.7, size: .large)
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif
