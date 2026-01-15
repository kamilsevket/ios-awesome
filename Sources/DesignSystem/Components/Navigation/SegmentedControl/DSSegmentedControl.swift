import SwiftUI

// MARK: - Segmented Control

/// A customizable segmented control component with animated selection indicator
///
/// Usage:
/// ```swift
/// DSSegmentedControl(selection: $filter) {
///     DSSegment(.all, "All")
///     DSSegment(.active, "Active", icon: .checkmark)
///     DSSegment(.completed, "Done")
/// }
/// .style(.pill)
/// ```
public struct DSSegmentedControl<Tag: Hashable>: View {

    // MARK: - Properties

    @Binding private var selection: Tag
    private let segments: [DSSegment<Tag>]
    private var style: DSSegmentedControlStyle = .standard
    private var size: DSSegmentedControlSize = .standard
    private var widthMode: DSSegmentWidthMode = .equal
    private var tintColor: Color = .blue
    private var selectedTextColor: Color?
    private var unselectedTextColor: Color?
    private var backgroundColor: Color?

    @Namespace private var indicatorNamespace
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a segmented control with the given segments
    /// - Parameters:
    ///   - selection: Binding to the currently selected segment tag
    ///   - segments: Array of segment configurations
    public init(
        selection: Binding<Tag>,
        segments: [DSSegment<Tag>]
    ) {
        self._selection = selection
        self.segments = segments
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            containerView(geometry: geometry)
        }
        .frame(height: size.height)
    }

    // MARK: - Container View

    @ViewBuilder
    private func containerView(geometry: GeometryProxy) -> some View {
        let containerWidth = geometry.size.width

        ZStack(alignment: .leading) {
            // Background
            if style.hasContainerBackground {
                containerBackground
            }

            // Selection indicator
            selectionIndicator(containerWidth: containerWidth)

            // Segments
            segmentsView(containerWidth: containerWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: style.containerCornerRadius))
    }

    // MARK: - Container Background

    @ViewBuilder
    private var containerBackground: some View {
        RoundedRectangle(cornerRadius: style.containerCornerRadius)
            .fill(resolvedBackgroundColor)
    }

    private var resolvedBackgroundColor: Color {
        if let backgroundColor = backgroundColor {
            return backgroundColor
        }
        return colorScheme == .dark
            ? Color(white: 0.15)
            : Color(white: 0.93)
    }

    // MARK: - Selection Indicator

    @ViewBuilder
    private func selectionIndicator(containerWidth: CGFloat) -> some View {
        let selectedIndex = selectedSegmentIndex
        let segmentWidth = calculateSegmentWidth(containerWidth: containerWidth, index: selectedIndex)
        let offset = calculateIndicatorOffset(containerWidth: containerWidth)

        switch style {
        case .standard, .pill:
            RoundedRectangle(cornerRadius: style.segmentCornerRadius)
                .fill(indicatorColor)
                .shadow(color: indicatorShadowColor, radius: 1, x: 0, y: 1)
                .padding(DSSegmentedControlConstants.containerPadding)
                .frame(width: segmentWidth)
                .offset(x: offset)
                .animation(
                    .spring(
                        response: DSSegmentedControlConstants.springResponse,
                        dampingFraction: DSSegmentedControlConstants.springDamping
                    ),
                    value: selection
                )

        case .underline:
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: DSSegmentedControlConstants.underlineHeight / 2)
                    .fill(tintColor)
                    .frame(
                        width: segmentWidth - DSSegmentedControlConstants.underlineInset * 2,
                        height: DSSegmentedControlConstants.underlineHeight
                    )
                    .offset(x: offset + DSSegmentedControlConstants.underlineInset)
                    .animation(
                        .spring(
                            response: DSSegmentedControlConstants.springResponse,
                            dampingFraction: DSSegmentedControlConstants.springDamping
                        ),
                        value: selection
                    )
            }
        }
    }

    private var indicatorColor: Color {
        colorScheme == .dark
            ? Color(white: 0.28)
            : .white
    }

    private var indicatorShadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.08)
    }

    // MARK: - Segments View

    @ViewBuilder
    private func segmentsView(containerWidth: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                DSSegmentView(
                    segment: segment,
                    isSelected: selection == segment.id,
                    style: style,
                    size: size,
                    selectedColor: resolvedSelectedTextColor,
                    unselectedColor: resolvedUnselectedTextColor,
                    widthMode: widthMode,
                    action: { selectSegment(segment.id) }
                )
            }
        }
        .padding(DSSegmentedControlConstants.containerPadding)
    }

    private var resolvedSelectedTextColor: Color {
        if let selectedTextColor = selectedTextColor {
            return selectedTextColor
        }
        switch style {
        case .standard, .pill:
            return .primary
        case .underline:
            return tintColor
        }
    }

    private var resolvedUnselectedTextColor: Color {
        unselectedTextColor ?? .secondary
    }

    // MARK: - Calculations

    private var selectedSegmentIndex: Int {
        segments.firstIndex { $0.id == selection } ?? 0
    }

    private func calculateSegmentWidth(containerWidth: CGFloat, index: Int) -> CGFloat {
        switch widthMode {
        case .equal:
            return containerWidth / CGFloat(segments.count)
        case .dynamic:
            // For dynamic, we use equal width for the indicator
            return containerWidth / CGFloat(segments.count)
        case .fixed(let width):
            return width
        }
    }

    private func calculateIndicatorOffset(containerWidth: CGFloat) -> CGFloat {
        let segmentWidth = containerWidth / CGFloat(segments.count)
        return segmentWidth * CGFloat(selectedSegmentIndex)
    }

    // MARK: - Actions

    private func selectSegment(_ tag: Tag) {
        guard let segment = segments.first(where: { $0.id == tag }),
              !segment.isDisabled else {
            return
        }

        selection = tag
        triggerHapticFeedback()
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
}

// MARK: - Modifiers

extension DSSegmentedControl {
    /// Sets the visual style of the segmented control
    public func style(_ style: DSSegmentedControlStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the size of the segmented control
    public func controlSize(_ size: DSSegmentedControlSize) -> Self {
        var copy = self
        copy.size = size
        return copy
    }

    /// Sets the width mode for segments
    public func widthMode(_ mode: DSSegmentWidthMode) -> Self {
        var copy = self
        copy.widthMode = mode
        return copy
    }

    /// Sets the tint color for the selection indicator
    public func tintColor(_ color: Color) -> Self {
        var copy = self
        copy.tintColor = color
        return copy
    }

    /// Sets the text color for selected segments
    public func selectedTextColor(_ color: Color) -> Self {
        var copy = self
        copy.selectedTextColor = color
        return copy
    }

    /// Sets the text color for unselected segments
    public func unselectedTextColor(_ color: Color) -> Self {
        var copy = self
        copy.unselectedTextColor = color
        return copy
    }

    /// Sets the background color of the container
    public func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }
}

// MARK: - Result Builder

/// Result builder for declarative segment creation
@resultBuilder
public struct DSSegmentBuilder<Tag: Hashable> {
    public static func buildBlock(_ components: DSSegment<Tag>...) -> [DSSegment<Tag>] {
        components
    }

    public static func buildArray(_ components: [[DSSegment<Tag>]]) -> [DSSegment<Tag>] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [DSSegment<Tag>]?) -> [DSSegment<Tag>] {
        component ?? []
    }

    public static func buildEither(first component: [DSSegment<Tag>]) -> [DSSegment<Tag>] {
        component
    }

    public static func buildEither(second component: [DSSegment<Tag>]) -> [DSSegment<Tag>] {
        component
    }
}

// MARK: - Convenience Initializer with Result Builder

extension DSSegmentedControl {
    /// Creates a segmented control using result builder syntax
    /// ```swift
    /// DSSegmentedControl(selection: $filter) {
    ///     DSSegment(.all, "All")
    ///     DSSegment(.active, "Active")
    ///     DSSegment(.completed, "Done")
    /// }
    /// ```
    public init(
        selection: Binding<Tag>,
        @DSSegmentBuilder<Tag> segments: () -> [DSSegment<Tag>]
    ) {
        self.init(selection: selection, segments: segments())
    }
}

// MARK: - View Extension

extension View {
    /// Adds a segmented control with standard configuration
    public func dsSegmentedControl<Tag: Hashable>(
        selection: Binding<Tag>,
        segments: [DSSegment<Tag>],
        style: DSSegmentedControlStyle = .standard
    ) -> some View {
        VStack(spacing: 12) {
            DSSegmentedControl(selection: selection, segments: segments)
                .style(style)
            self
        }
    }
}
