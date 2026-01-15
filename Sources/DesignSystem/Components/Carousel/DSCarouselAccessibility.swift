import SwiftUI

// MARK: - Carousel Accessibility

/// Accessibility utilities for carousel components.
public enum DSCarouselAccessibility {
    /// Generates an accessibility label for a carousel.
    /// - Parameters:
    ///   - itemCount: Total number of items
    ///   - currentIndex: Current item index (0-based)
    /// - Returns: Formatted accessibility label
    public static func carouselLabel(itemCount: Int, currentIndex: Int) -> String {
        "Carousel with \(itemCount) items, currently showing item \(currentIndex + 1) of \(itemCount)"
    }

    /// Generates an accessibility hint for navigation.
    public static var navigationHint: String {
        "Swipe left or right to navigate between items"
    }

    /// Generates an accessibility label for page indicators.
    /// - Parameters:
    ///   - currentPage: Current page (0-based)
    ///   - totalPages: Total number of pages
    /// - Returns: Formatted accessibility label
    public static func pageIndicatorLabel(currentPage: Int, totalPages: Int) -> String {
        "Page \(currentPage + 1) of \(totalPages)"
    }

    /// Generates an accessibility hint for page indicators.
    public static var pageIndicatorHint: String {
        "Double tap on a dot to navigate to that page"
    }
}

// MARK: - Carousel Accessibility Modifier

/// A view modifier that adds comprehensive accessibility support to carousels.
public struct DSCarouselAccessibilityModifier: ViewModifier {
    let itemCount: Int
    let currentIndex: Int
    let onPrevious: () -> Void
    let onNext: () -> Void

    public init(
        itemCount: Int,
        currentIndex: Int,
        onPrevious: @escaping () -> Void,
        onNext: @escaping () -> Void
    ) {
        self.itemCount = itemCount
        self.currentIndex = currentIndex
        self.onPrevious = onPrevious
        self.onNext = onNext
    }

    public func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .contain)
            .accessibilityLabel(DSCarouselAccessibility.carouselLabel(
                itemCount: itemCount,
                currentIndex: currentIndex
            ))
            .accessibilityHint(DSCarouselAccessibility.navigationHint)
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment:
                    onNext()
                case .decrement:
                    onPrevious()
                @unknown default:
                    break
                }
            }
    }
}

extension View {
    /// Adds carousel-specific accessibility support.
    /// - Parameters:
    ///   - itemCount: Total number of items
    ///   - currentIndex: Current item index
    ///   - onPrevious: Action for navigating to previous item
    ///   - onNext: Action for navigating to next item
    public func dsCarouselAccessibility(
        itemCount: Int,
        currentIndex: Int,
        onPrevious: @escaping () -> Void,
        onNext: @escaping () -> Void
    ) -> some View {
        modifier(DSCarouselAccessibilityModifier(
            itemCount: itemCount,
            currentIndex: currentIndex,
            onPrevious: onPrevious,
            onNext: onNext
        ))
    }
}

// MARK: - Preview

#if DEBUG
struct DSCarouselAccessibility_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityPreviewContainer()
            .previewDisplayName("Accessibility Demo")
    }
}

private struct AccessibilityPreviewContainer: View {
    @State private var currentIndex = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let items = ["First", "Second", "Third"]

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Text("Accessibility Demo")
                .font(.headline)

            Text("Reduce Motion: \(reduceMotion ? "ON" : "OFF")")
                .font(.caption)
                .foregroundColor(.secondary)

            VStack(spacing: Spacing.md) {
                Text(items[currentIndex])
                    .font(.title)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
                    .dsCarouselAccessibility(
                        itemCount: items.count,
                        currentIndex: currentIndex,
                        onPrevious: {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        },
                        onNext: {
                            if currentIndex < items.count - 1 {
                                currentIndex += 1
                            }
                        }
                    )
                    .dsAnnouncePageChange(currentPage: currentIndex, totalPages: items.count)

                DSPageIndicator(
                    currentPage: currentIndex,
                    totalPages: items.count,
                    onPageTap: { currentIndex = $0 }
                )
            }

            HStack(spacing: Spacing.md) {
                Button("Previous") {
                    withAnimation(reduceMotion ? nil : .spring()) {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                }
                .buttonStyle(.bordered)
                .disabled(currentIndex == 0)

                Button("Next") {
                    withAnimation(reduceMotion ? nil : .spring()) {
                        if currentIndex < items.count - 1 {
                            currentIndex += 1
                        }
                    }
                }
                .buttonStyle(.bordered)
                .disabled(currentIndex == items.count - 1)
            }
        }
        .padding()
    }
}
#endif
