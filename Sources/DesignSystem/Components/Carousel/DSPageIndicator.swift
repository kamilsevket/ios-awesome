import SwiftUI

// MARK: - Indicator Style

/// Style options for the page indicator dots.
public enum DSPageIndicatorStyle: Sendable {
    /// Standard circular dots
    case dots
    /// Capsule/pill shaped indicator for current page
    case capsule
    /// Numbered indicator showing current/total
    case numbered
    /// Progress bar style
    case progress
}

/// Size options for the page indicator.
public enum DSPageIndicatorSize: Sendable {
    case small
    case medium
    case large

    var dotSize: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }

    var spacing: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 10
        }
    }

    var font: Font {
        switch self {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .footnote
        }
    }
}

// MARK: - DSPageIndicator

/// A page indicator component that displays the current page position.
///
/// Example usage:
/// ```swift
/// DSPageIndicator(
///     currentPage: selectedIndex,
///     totalPages: 5
/// )
///
/// // With capsule style
/// DSPageIndicator(
///     currentPage: selectedIndex,
///     totalPages: 5,
///     style: .capsule
/// )
/// ```
public struct DSPageIndicator: View {
    // MARK: - Properties

    private let currentPage: Int
    private let totalPages: Int
    private let style: DSPageIndicatorStyle
    private let size: DSPageIndicatorSize
    private let activeColor: Color
    private let inactiveColor: Color
    private let onPageTap: ((Int) -> Void)?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Initializers

    /// Creates a page indicator.
    /// - Parameters:
    ///   - currentPage: The currently selected page index
    ///   - totalPages: Total number of pages
    ///   - style: Visual style of the indicator
    ///   - size: Size of the indicator
    ///   - activeColor: Color for the active indicator
    ///   - inactiveColor: Color for inactive indicators
    ///   - onPageTap: Optional callback when a page indicator is tapped
    public init(
        currentPage: Int,
        totalPages: Int,
        style: DSPageIndicatorStyle = .dots,
        size: DSPageIndicatorSize = .medium,
        activeColor: Color = DSColors.primary,
        inactiveColor: Color = DSColors.textTertiary.opacity(0.4),
        onPageTap: ((Int) -> Void)? = nil
    ) {
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.style = style
        self.size = size
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.onPageTap = onPageTap
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch style {
            case .dots:
                dotsIndicator
            case .capsule:
                capsuleIndicator
            case .numbered:
                numberedIndicator
            case .progress:
                progressIndicator
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(currentPage + 1) of \(totalPages)")
        .accessibilityHint("Swipe left or right to change page")
    }

    // MARK: - Indicator Views

    private var dotsIndicator: some View {
        HStack(spacing: size.spacing) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: size.dotSize, height: size.dotSize)
                    .scaleEffect(index == currentPage ? 1.0 : 0.85)
                    .animation(reduceMotion ? nil : .spring(response: 0.3), value: currentPage)
                    .onTapGesture {
                        onPageTap?(index)
                    }
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    private var capsuleIndicator: some View {
        HStack(spacing: size.spacing) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(
                        width: index == currentPage ? size.dotSize * 2.5 : size.dotSize,
                        height: size.dotSize
                    )
                    .animation(reduceMotion ? nil : .spring(response: 0.3), value: currentPage)
                    .onTapGesture {
                        onPageTap?(index)
                    }
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    private var numberedIndicator: some View {
        Text("\(currentPage + 1) / \(totalPages)")
            .font(size.font)
            .fontWeight(.medium)
            .foregroundColor(DSColors.textSecondary)
            .monospacedDigit()
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(
                Capsule()
                    .fill(DSColors.backgroundSecondary)
            )
    }

    private var progressIndicator: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(inactiveColor)
                    .frame(height: size.dotSize / 2)

                Capsule()
                    .fill(activeColor)
                    .frame(
                        width: geometry.size.width * progressWidth,
                        height: size.dotSize / 2
                    )
                    .animation(reduceMotion ? nil : .spring(response: 0.3), value: currentPage)
            }
        }
        .frame(height: size.dotSize)
        .frame(maxWidth: 120)
        .padding(.vertical, Spacing.xs)
    }

    // MARK: - Computed Properties

    private var progressWidth: CGFloat {
        guard totalPages > 1 else { return 1.0 }
        return CGFloat(currentPage + 1) / CGFloat(totalPages)
    }
}

// MARK: - Modifier Methods

extension DSPageIndicator {
    /// Sets the indicator style.
    public func indicatorStyle(_ style: DSPageIndicatorStyle) -> DSPageIndicator {
        DSPageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            style: style,
            size: size,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onPageTap: onPageTap
        )
    }

    /// Sets the indicator size.
    public func indicatorSize(_ size: DSPageIndicatorSize) -> DSPageIndicator {
        DSPageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            style: style,
            size: size,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            onPageTap: onPageTap
        )
    }

    /// Sets custom colors for the indicator.
    public func colors(active: Color, inactive: Color) -> DSPageIndicator {
        DSPageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            style: style,
            size: size,
            activeColor: active,
            inactiveColor: inactive,
            onPageTap: onPageTap
        )
    }
}

// MARK: - Preview

#if DEBUG
struct DSPageIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PageIndicatorPreviewContainer()
            .previewDisplayName("Page Indicators")
    }
}

private struct PageIndicatorPreviewContainer: View {
    @State private var currentPage = 2

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                Group {
                    Text("Dots Style")
                        .font(.headline)

                    DSPageIndicator(
                        currentPage: currentPage,
                        totalPages: 5
                    )

                    HStack(spacing: Spacing.lg) {
                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            size: .small
                        )

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            size: .large
                        )
                    }
                }

                Divider()

                Group {
                    Text("Capsule Style")
                        .font(.headline)

                    DSPageIndicator(
                        currentPage: currentPage,
                        totalPages: 5,
                        style: .capsule
                    )

                    DSPageIndicator(
                        currentPage: currentPage,
                        totalPages: 5,
                        style: .capsule,
                        activeColor: .purple
                    )
                }

                Divider()

                Group {
                    Text("Numbered Style")
                        .font(.headline)

                    HStack(spacing: Spacing.lg) {
                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .numbered,
                            size: .small
                        )

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .numbered,
                            size: .medium
                        )

                        DSPageIndicator(
                            currentPage: currentPage,
                            totalPages: 5,
                            style: .numbered,
                            size: .large
                        )
                    }
                }

                Divider()

                Group {
                    Text("Progress Style")
                        .font(.headline)

                    DSPageIndicator(
                        currentPage: currentPage,
                        totalPages: 5,
                        style: .progress
                    )

                    DSPageIndicator(
                        currentPage: currentPage,
                        totalPages: 5,
                        style: .progress,
                        activeColor: .green
                    )
                }

                Divider()

                Text("Interactive Demo")
                    .font(.headline)

                HStack(spacing: Spacing.lg) {
                    Button("Previous") {
                        if currentPage > 0 {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(.bordered)

                    Button("Next") {
                        if currentPage < 4 {
                            currentPage += 1
                        }
                    }
                    .buttonStyle(.bordered)
                }

                DSPageIndicator(
                    currentPage: currentPage,
                    totalPages: 5,
                    onPageTap: { index in
                        currentPage = index
                    }
                )
            }
            .padding()
        }
    }
}
#endif
