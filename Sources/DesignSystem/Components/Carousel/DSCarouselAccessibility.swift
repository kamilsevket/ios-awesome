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

// MARK: - Reduce Motion Helper

/// Helper for handling reduce motion preference.
public struct DSReduceMotionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let duration: Double
    private let reducedDuration: Double

    public init(duration: Double = 0.3, reducedDuration: Double = 0.0) {
        self.duration = duration
        self.reducedDuration = reducedDuration
    }

    public func body(content: Content) -> some View {
        content
            .animation(
                reduceMotion ? .linear(duration: reducedDuration) : .spring(response: duration),
                value: UUID()
            )
    }
}

extension View {
    /// Applies animation that respects the reduce motion accessibility setting.
    /// - Parameters:
    ///   - duration: Animation duration when reduce motion is off
    ///   - reducedDuration: Animation duration when reduce motion is on (0 for instant)
    public func dsReduceMotionAnimation(
        duration: Double = 0.3,
        reducedDuration: Double = 0.0
    ) -> some View {
        modifier(DSReduceMotionModifier(duration: duration, reducedDuration: reducedDuration))
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

// MARK: - VoiceOver Announcement

extension View {
    /// Announces a message to VoiceOver users.
    /// - Parameter message: The message to announce
    public func dsAnnounce(_ message: String) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIAccessibility.post(notification: .announcement, argument: message)
            }
        }
    }

    /// Announces page change to VoiceOver users.
    /// - Parameters:
    ///   - currentPage: Current page number (0-based)
    ///   - totalPages: Total number of pages
    public func dsAnnouncePageChange(currentPage: Int, totalPages: Int) -> some View {
        self.onChange(of: currentPage) { _, newValue in
            let message = "Page \(newValue + 1) of \(totalPages)"
            UIAccessibility.post(notification: .pageScrolled, argument: message)
        }
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
