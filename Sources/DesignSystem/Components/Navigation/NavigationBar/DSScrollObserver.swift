import SwiftUI

// MARK: - Scroll Offset Preference Key

/// Preference key for tracking scroll offset
public struct ScrollOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = 0

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Scroll Observer

/// A view that observes scroll position and reports offset changes
///
/// Usage:
/// ```swift
/// ScrollView {
///     DSScrollObserver()
///     content
/// }
/// .onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
///     scrollOffset = offset
/// }
/// ```
public struct DSScrollObserver: View {
    private let coordinateSpace: String

    public init(coordinateSpace: String = "scroll") {
        self.coordinateSpace = coordinateSpace
    }

    public var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: -geometry.frame(in: .named(coordinateSpace)).minY
                )
        }
        .frame(height: 0)
    }
}

// MARK: - Observable Scroll View

/// A ScrollView wrapper that provides scroll offset observation
///
/// Usage:
/// ```swift
/// DSObservableScrollView(offset: $scrollOffset) {
///     content
/// }
/// ```
public struct DSObservableScrollView<Content: View>: View {
    @Binding private var offset: CGFloat
    private let showsIndicators: Bool
    private let content: Content

    public init(
        offset: Binding<CGFloat>,
        showsIndicators: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._offset = offset
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public var body: some View {
        ScrollView(showsIndicators: showsIndicators) {
            DSScrollObserver(coordinateSpace: "observableScroll")
            content
        }
        .coordinateSpace(name: "observableScroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

// MARK: - Scroll Collapse Calculator

/// Utility for calculating collapse progress based on scroll offset
public struct DSScrollCollapseCalculator {
    /// The scroll offset at which collapse begins
    public let collapseStartOffset: CGFloat

    /// The scroll offset at which collapse is complete
    public let collapseEndOffset: CGFloat

    public init(
        collapseStartOffset: CGFloat = 0,
        collapseEndOffset: CGFloat = 52
    ) {
        self.collapseStartOffset = collapseStartOffset
        self.collapseEndOffset = collapseEndOffset
    }

    /// Calculate collapse progress (0 = expanded, 1 = collapsed)
    public func progress(for offset: CGFloat) -> CGFloat {
        guard collapseEndOffset > collapseStartOffset else { return 0 }

        let clampedOffset = max(collapseStartOffset, min(offset, collapseEndOffset))
        let range = collapseEndOffset - collapseStartOffset
        return (clampedOffset - collapseStartOffset) / range
    }

    /// Calculate current state based on offset
    public func state(for offset: CGFloat) -> DSNavigationBarCollapseState {
        let progress = self.progress(for: offset)

        if progress <= 0 {
            return .expanded
        } else if progress >= 1 {
            return .collapsed
        } else {
            return .collapsing(progress: progress)
        }
    }

    /// Calculate height based on progress
    public func height(
        expandedHeight: CGFloat,
        collapsedHeight: CGFloat,
        progress: CGFloat
    ) -> CGFloat {
        let range = expandedHeight - collapsedHeight
        return expandedHeight - (range * progress)
    }

    /// Calculate opacity for large title (fades out during collapse)
    public func largeTitleOpacity(for progress: CGFloat) -> CGFloat {
        max(0, 1 - (progress * 2))
    }

    /// Calculate scale for large title
    public func largeTitleScale(for progress: CGFloat) -> CGFloat {
        max(0.7, 1 - (progress * 0.3))
    }
}

// MARK: - Scroll View Extension

extension View {
    /// Tracks scroll offset using a binding
    public func trackScrollOffset(
        _ offset: Binding<CGFloat>,
        coordinateSpace: String = "scrollTracking"
    ) -> some View {
        self
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: -geometry.frame(in: .named(coordinateSpace)).minY
                        )
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                offset.wrappedValue = value
            }
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSScrollObserver_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var scrollOffset: CGFloat = 0
        private let calculator = DSScrollCollapseCalculator()

        var body: some View {
            VStack(spacing: 0) {
                // Header showing scroll info
                VStack(spacing: 4) {
                    Text("Scroll Offset: \(Int(scrollOffset))")
                    Text("Progress: \(String(format: "%.2f", calculator.progress(for: scrollOffset)))")
                    Text("State: \(stateDescription)")
                }
                .font(.caption)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))

                // Scrollable content
                DSObservableScrollView(offset: $scrollOffset) {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<50) { index in
                            Text("Item \(index)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }

        private var stateDescription: String {
            switch calculator.state(for: scrollOffset) {
            case .expanded:
                return "Expanded"
            case .collapsing(let progress):
                return "Collapsing (\(String(format: "%.0f", progress * 100))%)"
            case .collapsed:
                return "Collapsed"
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("Scroll Observer")
    }
}
#endif
