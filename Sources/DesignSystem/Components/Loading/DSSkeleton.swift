import SwiftUI

/// Shape variants for skeleton placeholders
public enum DSSkeletonShape: CaseIterable {
    case rectangle
    case roundedRectangle
    case circle
    case capsule

    public static var allCases: [DSSkeletonShape] {
        [.rectangle, .roundedRectangle, .circle, .capsule]
    }
}

/// A skeleton placeholder view that displays a loading placeholder shape.
///
/// Use `DSSkeleton` to show placeholder content while data is loading.
/// Combine with `.shimmer()` modifier for animated effect.
///
/// Example usage:
/// ```swift
/// // Basic rectangle skeleton
/// DSSkeleton(shape: .rectangle)
///     .frame(height: 100)
///
/// // Circle avatar placeholder
/// DSSkeleton(shape: .circle)
///     .frame(width: 48, height: 48)
///
/// // With shimmer animation
/// DSSkeleton(shape: .roundedRectangle)
///     .frame(height: 20)
///     .shimmer()
/// ```
public struct DSSkeleton: View {
    // MARK: - Properties

    /// Shape of the skeleton
    private let shape: DSSkeletonShape

    /// Corner radius for rounded rectangle shape
    private let cornerRadius: CGFloat

    /// Base color of the skeleton
    private let color: Color

    // MARK: - Initialization

    /// Creates a skeleton placeholder.
    /// - Parameters:
    ///   - shape: Shape of the skeleton placeholder.
    ///   - cornerRadius: Corner radius for rounded rectangle shape. Defaults to 8.
    ///   - color: Base color of the skeleton. Defaults to system gray.
    public init(
        shape: DSSkeletonShape = .roundedRectangle,
        cornerRadius: CGFloat = 8,
        color: Color = DSColors.shimmerBase
    ) {
        self.shape = shape
        self.cornerRadius = cornerRadius
        self.color = color
    }

    // MARK: - Body

    public var body: some View {
        shapeView
            .foregroundColor(color)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Loading placeholder")
            .accessibilityAddTraits(.isImage)
    }

    // MARK: - Private Views

    @ViewBuilder
    private var shapeView: some View {
        switch shape {
        case .rectangle:
            Rectangle()
        case .roundedRectangle:
            RoundedRectangle(cornerRadius: cornerRadius)
        case .circle:
            Circle()
        case .capsule:
            Capsule()
        }
    }
}

// MARK: - Skeleton Group

/// A group of skeleton placeholders for common UI patterns
public struct DSSkeletonGroup: View {
    // MARK: - Preset Types

    public enum Preset {
        /// Text lines skeleton
        case textLines(count: Int)
        /// Avatar with text skeleton
        case avatarWithText
        /// Card skeleton
        case card
        /// List item skeleton
        case listItem
    }

    private let preset: Preset

    // MARK: - Initialization

    public init(preset: Preset) {
        self.preset = preset
    }

    // MARK: - Body

    public var body: some View {
        switch preset {
        case .textLines(let count):
            textLinesView(count: count)
        case .avatarWithText:
            avatarWithTextView
        case .card:
            cardView
        case .listItem:
            listItemView
        }
    }

    // MARK: - Private Views

    private func textLinesView(count: Int) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
            ForEach(0..<count, id: \.self) { index in
                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(height: 16)
                    .frame(maxWidth: index == count - 1 ? .infinity : nil)
                    .frame(width: index == count - 1 ? nil : nil)
                    .modifier(LastLineWidthModifier(isLast: index == count - 1))
            }
        }
    }

    private var avatarWithTextView: some View {
        HStack(spacing: DSSpacing.md) {
            DSSkeleton(shape: .circle)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(width: 120, height: 16)

                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(width: 80, height: 12)
            }
        }
    }

    private var cardView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSSkeleton(shape: .roundedRectangle, cornerRadius: 8)
                .frame(height: 160)

            VStack(alignment: .leading, spacing: DSSpacing.sm) {
                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(height: 20)

                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(height: 14)
                    .frame(maxWidth: .infinity)

                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(width: 100, height: 14)
            }
        }
        .padding(DSSpacing.md)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var listItemView: some View {
        HStack(spacing: DSSpacing.md) {
            DSSkeleton(shape: .roundedRectangle, cornerRadius: 8)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(height: 16)

                DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                    .frame(width: 150, height: 12)
            }

            Spacer()

            DSSkeleton(shape: .roundedRectangle, cornerRadius: 4)
                .frame(width: 40, height: 12)
        }
    }
}

// MARK: - Helper Modifier

private struct LastLineWidthModifier: ViewModifier {
    let isLast: Bool

    func body(content: Content) -> some View {
        if isLast {
            content.frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
        } else {
            content
        }
    }
}

// MARK: - Previews

#if DEBUG
struct DSSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Basic shapes
                VStack(alignment: .leading, spacing: 16) {
                    Text("Basic Shapes").font(.headline)

                    DSSkeleton(shape: .rectangle)
                        .frame(height: 40)

                    DSSkeleton(shape: .roundedRectangle)
                        .frame(height: 40)

                    HStack(spacing: 16) {
                        DSSkeleton(shape: .circle)
                            .frame(width: 48, height: 48)

                        DSSkeleton(shape: .capsule)
                            .frame(width: 100, height: 32)
                    }
                }

                Divider()

                // Preset groups
                VStack(alignment: .leading, spacing: 16) {
                    Text("Presets").font(.headline)

                    DSSkeletonGroup(preset: .textLines(count: 3))

                    DSSkeletonGroup(preset: .avatarWithText)

                    DSSkeletonGroup(preset: .listItem)

                    DSSkeletonGroup(preset: .card)
                }

                // With shimmer
                VStack(alignment: .leading, spacing: 16) {
                    Text("With Shimmer").font(.headline)

                    DSSkeletonGroup(preset: .avatarWithText)
                        .shimmer()

                    DSSkeletonGroup(preset: .card)
                        .shimmer()
                }
            }
            .padding()
        }
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
