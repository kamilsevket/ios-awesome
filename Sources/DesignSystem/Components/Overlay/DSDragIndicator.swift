import SwiftUI

// MARK: - DSDragIndicator

/// A visual drag handle indicator for sheets and draggable views
///
/// DSDragIndicator provides a pill-shaped handle that indicates
/// a view can be dragged. Commonly used at the top of bottom sheets.
///
/// Example usage:
/// ```swift
/// VStack {
///     DSDragIndicator()
///     // Sheet content
/// }
/// ```
public struct DSDragIndicator: View {
    // MARK: - Properties

    private let style: Style
    private let width: CGFloat
    private let height: CGFloat

    // MARK: - Initialization

    /// Creates a drag indicator with the specified style
    /// - Parameters:
    ///   - style: The visual style of the indicator (default: .standard)
    ///   - width: The width of the indicator (default: 36)
    ///   - height: The height of the indicator (default: 5)
    public init(
        style: Style = .standard,
        width: CGFloat = 36,
        height: CGFloat = 5
    ) {
        self.style = style
        self.width = width
        self.height = height
    }

    // MARK: - Body

    public var body: some View {
        Capsule()
            .fill(style.color)
            .frame(width: width, height: height)
            .padding(.top, DSSpacing.sm)
            .padding(.bottom, DSSpacing.xs)
            .accessibilityHidden(true)
    }
}

// MARK: - Style

public extension DSDragIndicator {
    /// Visual styles for the drag indicator
    enum Style: Sendable {
        /// Standard gray indicator
        case standard
        /// Light indicator for dark backgrounds
        case light
        /// Dark indicator for light backgrounds
        case dark
        /// Custom color indicator
        case custom(Color)

        var color: Color {
            switch self {
            case .standard:
                return Color(UIColor.systemGray3)
            case .light:
                return Color.white.opacity(0.6)
            case .dark:
                return Color.black.opacity(0.3)
            case .custom(let color):
                return color
            }
        }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSDragIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 32) {
            // Standard style
            previewCard(title: "Standard") {
                DSDragIndicator(style: .standard)
            }

            // Light style
            previewCard(title: "Light", background: .black) {
                DSDragIndicator(style: .light)
            }

            // Dark style
            previewCard(title: "Dark") {
                DSDragIndicator(style: .dark)
            }

            // Custom style
            previewCard(title: "Custom") {
                DSDragIndicator(style: .custom(.blue))
            }

            // Custom size
            previewCard(title: "Custom Size") {
                DSDragIndicator(width: 60, height: 8)
            }
        }
        .padding()
        .previewDisplayName("Drag Indicator Styles")
    }

    static func previewCard<Content: View>(
        title: String,
        background: Color = Color(UIColor.secondarySystemBackground),
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            VStack {
                content()
                Text("Sheet Content")
                    .foregroundColor(background == .black ? .white : .primary)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(background)
            .cornerRadius(12)
        }
    }
}
#endif
