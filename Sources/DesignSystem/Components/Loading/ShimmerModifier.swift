import SwiftUI

/// A view modifier that adds a shimmer (shine) animation effect to any view.
///
/// The shimmer effect creates a diagonal gradient that moves across the view,
/// creating a "loading" appearance commonly used with skeleton placeholders.
public struct ShimmerModifier: ViewModifier {
    // MARK: - Properties

    /// Whether the shimmer animation is active
    private let isActive: Bool

    /// Duration of one shimmer animation cycle
    private let duration: Double

    /// Color of the shimmer highlight
    private let highlightColor: Color

    // MARK: - State

    @State private var phase: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initialization

    /// Creates a shimmer modifier.
    /// - Parameters:
    ///   - isActive: Whether the shimmer animation is active. Defaults to true.
    ///   - duration: Duration of one animation cycle in seconds. Defaults to 1.5.
    ///   - highlightColor: Color of the shimmer highlight.
    public init(
        isActive: Bool = true,
        duration: Double = 1.5,
        highlightColor: Color = DSColors.shimmerHighlight
    ) {
        self.isActive = isActive
        self.duration = duration
        self.highlightColor = highlightColor
    }

    // MARK: - Body

    public func body(content: Content) -> some View {
        content
            .overlay(
                shimmerOverlay
                    .opacity(isActive ? 1 : 0)
            )
            .onAppear {
                startAnimation()
            }
    }

    // MARK: - Private Views

    private var shimmerOverlay: some View {
        GeometryReader { geometry in
            let gradient = LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: highlightColor.opacity(0.6), location: 0.3),
                    .init(color: highlightColor, location: 0.5),
                    .init(color: highlightColor.opacity(0.6), location: 0.7),
                    .init(color: .clear, location: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            gradient
                .frame(width: geometry.size.width * 2)
                .offset(x: -geometry.size.width + (phase * geometry.size.width * 2))
                .mask(content)
        }
        .clipped()
    }

    // MARK: - Private Methods

    private func startAnimation() {
        guard isActive else { return }

        // Respect reduce motion preference
        let animationDuration = reduceMotion ? duration * 2 : duration

        withAnimation(
            .linear(duration: animationDuration)
            .repeatForever(autoreverses: false)
        ) {
            phase = 1
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Applies a shimmer effect to the view.
    /// - Parameters:
    ///   - isActive: Whether the shimmer animation is active. Defaults to true.
    ///   - duration: Duration of one animation cycle in seconds. Defaults to 1.5.
    ///   - highlightColor: Color of the shimmer highlight.
    /// - Returns: The view with shimmer effect applied.
    func shimmer(
        isActive: Bool = true,
        duration: Double = 1.5,
        highlightColor: Color = DSColors.shimmerHighlight
    ) -> some View {
        modifier(
            ShimmerModifier(
                isActive: isActive,
                duration: duration,
                highlightColor: highlightColor
            )
        )
    }
}

// MARK: - Previews

#if DEBUG
struct ShimmerModifier_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            // Basic shimmer on shape
            RoundedRectangle(cornerRadius: 8)
                .fill(DSColors.shimmerBase)
                .frame(height: 40)
                .shimmer()

            // Shimmer on skeleton
            DSSkeleton(shape: .roundedRectangle)
                .frame(height: 20)
                .shimmer()

            // Shimmer on skeleton group
            DSSkeletonGroup(preset: .avatarWithText)
                .shimmer()

            // Shimmer on card
            DSSkeletonGroup(preset: .card)
                .shimmer()

            // Custom duration
            DSSkeleton(shape: .roundedRectangle)
                .frame(height: 20)
                .shimmer(duration: 2.5)

            // Inactive shimmer
            DSSkeleton(shape: .roundedRectangle)
                .frame(height: 20)
                .shimmer(isActive: false)
        }
        .padding()
        .previewDisplayName("Light Mode")

        VStack(spacing: 16) {
            DSSkeletonGroup(preset: .avatarWithText)
                .shimmer()

            DSSkeletonGroup(preset: .listItem)
                .shimmer()
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif
