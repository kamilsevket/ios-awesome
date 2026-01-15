import SwiftUI

// MARK: - Tooltip Style

/// Style configuration for DSTooltip
public struct DSTooltipStyle: Sendable {
    public let backgroundColor: Color
    public let textColor: Color
    public let font: Font
    public let cornerRadius: CGFloat
    public let arrowSize: CGSize
    public let padding: EdgeInsets
    public let maxWidth: CGFloat

    public static let `default` = DSTooltipStyle(
        backgroundColor: Color(UIColor.label),
        textColor: Color(UIColor.systemBackground),
        font: .footnote,
        cornerRadius: 6,
        arrowSize: CGSize(width: 10, height: 5),
        padding: EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10),
        maxWidth: 250
    )

    public static let info = DSTooltipStyle(
        backgroundColor: DSColors.info,
        textColor: .white,
        font: .footnote,
        cornerRadius: 6,
        arrowSize: CGSize(width: 10, height: 5),
        padding: EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10),
        maxWidth: 250
    )

    public static let warning = DSTooltipStyle(
        backgroundColor: DSColors.warning,
        textColor: .black,
        font: .footnote,
        cornerRadius: 6,
        arrowSize: CGSize(width: 10, height: 5),
        padding: EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10),
        maxWidth: 250
    )

    public static let error = DSTooltipStyle(
        backgroundColor: DSColors.error,
        textColor: .white,
        font: .footnote,
        cornerRadius: 6,
        arrowSize: CGSize(width: 10, height: 5),
        padding: EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10),
        maxWidth: 250
    )

    public init(
        backgroundColor: Color = Color(UIColor.label),
        textColor: Color = Color(UIColor.systemBackground),
        font: Font = .footnote,
        cornerRadius: CGFloat = 6,
        arrowSize: CGSize = CGSize(width: 10, height: 5),
        padding: EdgeInsets = EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10),
        maxWidth: CGFloat = 250
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.arrowSize = arrowSize
        self.padding = padding
        self.maxWidth = maxWidth
    }
}

// MARK: - Tooltip Edge

/// The edge where the tooltip appears relative to the anchor
public enum DSTooltipEdge: Sendable {
    case top
    case bottom
    case leading
    case trailing

    var arrowRotation: Angle {
        switch self {
        case .top: return .degrees(0)
        case .bottom: return .degrees(180)
        case .leading: return .degrees(-90)
        case .trailing: return .degrees(90)
        }
    }
}

// MARK: - Tooltip Arrow Shape

private struct TooltipArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - DSTooltip View

/// A tooltip component for displaying contextual help text
///
/// DSTooltip provides a small floating label with:
/// - Configurable delay before showing
/// - Multiple edge positions (top, bottom, leading, trailing)
/// - Auto-dismiss after duration
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// Button("Help") { }
///     .dsTooltip("Click here for more info", edge: .bottom)
///
/// // With delay
/// Image(systemName: "questionmark.circle")
///     .dsTooltip("Additional help text", delay: 0.5, duration: 3.0)
/// ```
public struct DSTooltip: View {
    // MARK: - Properties

    private let text: String
    private let edge: DSTooltipEdge
    private let style: DSTooltipStyle

    @State private var animationOpacity: Double = 0
    @State private var animationOffset: CGFloat = 5

    // MARK: - Initialization

    /// Creates a DSTooltip
    /// - Parameters:
    ///   - text: The tooltip text to display
    ///   - edge: The edge where the tooltip appears (default: .top)
    ///   - style: Visual style configuration
    public init(
        _ text: String,
        edge: DSTooltipEdge = .top,
        style: DSTooltipStyle = .default
    ) {
        self.text = text
        self.edge = edge
        self.style = style
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 0) {
            if edge == .bottom {
                arrowView
            }

            if edge == .trailing {
                HStack(spacing: 0) {
                    arrowView
                    tooltipBody
                }
            } else if edge == .leading {
                HStack(spacing: 0) {
                    tooltipBody
                    arrowView
                }
            } else {
                tooltipBody
            }

            if edge == .top {
                arrowView
            }
        }
        .opacity(animationOpacity)
        .offset(y: offsetY)
        .offset(x: offsetX)
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                animationOpacity = 1.0
                animationOffset = 0
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isStaticText)
    }

    // MARK: - Subviews

    private var tooltipBody: some View {
        Text(text)
            .font(style.font)
            .foregroundColor(style.textColor)
            .padding(style.padding)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .frame(maxWidth: style.maxWidth)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var arrowView: some View {
        TooltipArrow()
            .fill(style.backgroundColor)
            .frame(width: style.arrowSize.width, height: style.arrowSize.height)
            .rotationEffect(edge.arrowRotation)
    }

    private var offsetY: CGFloat {
        switch edge {
        case .top, .bottom:
            return edge == .top ? -animationOffset : animationOffset
        case .leading, .trailing:
            return 0
        }
    }

    private var offsetX: CGFloat {
        switch edge {
        case .leading:
            return -animationOffset
        case .trailing:
            return animationOffset
        case .top, .bottom:
            return 0
        }
    }
}

// MARK: - Tooltip Modifier

private struct DSTooltipModifier: ViewModifier {
    let text: String
    let edge: DSTooltipEdge
    let style: DSTooltipStyle
    let delay: Double
    let duration: Double?
    let showOnLongPress: Bool

    @State private var isVisible = false
    @State private var delayTask: Task<Void, Never>?
    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isVisible {
                        DSTooltip(text, edge: edge, style: style)
                            .fixedSize()
                            .offset(x: tooltipOffsetX, y: tooltipOffsetY)
                    }
                }
            )
            .onLongPressGesture(minimumDuration: showOnLongPress ? 0.5 : .infinity) {
                showTooltip()
            }
            .onHover { isHovering in
                if isHovering {
                    scheduleShow()
                } else {
                    hide()
                }
            }
    }

    private var tooltipOffsetY: CGFloat {
        switch edge {
        case .top: return -35
        case .bottom: return 35
        case .leading, .trailing: return 0
        }
    }

    private var tooltipOffsetX: CGFloat {
        switch edge {
        case .leading: return -100
        case .trailing: return 100
        case .top, .bottom: return 0
        }
    }

    private func scheduleShow() {
        delayTask?.cancel()
        delayTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            if !Task.isCancelled {
                await MainActor.run {
                    showTooltip()
                }
            }
        }
    }

    private func showTooltip() {
        withAnimation {
            isVisible = true
        }

        if let duration = duration {
            dismissTask?.cancel()
            dismissTask = Task {
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                if !Task.isCancelled {
                    await MainActor.run {
                        hide()
                    }
                }
            }
        }
    }

    private func hide() {
        delayTask?.cancel()
        dismissTask?.cancel()
        withAnimation {
            isVisible = false
        }
    }
}

// MARK: - Manual Tooltip Modifier

private struct DSManualTooltipModifier: ViewModifier {
    @Binding var isPresented: Bool
    let text: String
    let edge: DSTooltipEdge
    let style: DSTooltipStyle

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isPresented {
                        DSTooltip(text, edge: edge, style: style)
                            .fixedSize()
                            .offset(x: tooltipOffsetX, y: tooltipOffsetY)
                    }
                }
            )
    }

    private var tooltipOffsetY: CGFloat {
        switch edge {
        case .top: return -35
        case .bottom: return 35
        case .leading, .trailing: return 0
        }
    }

    private var tooltipOffsetX: CGFloat {
        switch edge {
        case .leading: return -100
        case .trailing: return 100
        case .top, .bottom: return 0
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds a tooltip that appears on hover (macOS) or long press (iOS)
    /// - Parameters:
    ///   - text: The tooltip text
    ///   - edge: The edge where the tooltip appears (default: .top)
    ///   - style: Visual style configuration
    ///   - delay: Delay before showing the tooltip in seconds (default: 0.5)
    ///   - duration: Auto-dismiss duration in seconds (nil = indefinite)
    ///   - showOnLongPress: Whether to show on long press (iOS) (default: true)
    /// - Returns: Modified view with tooltip capability
    func dsTooltip(
        _ text: String,
        edge: DSTooltipEdge = .top,
        style: DSTooltipStyle = .default,
        delay: Double = 0.5,
        duration: Double? = 3.0,
        showOnLongPress: Bool = true
    ) -> some View {
        modifier(DSTooltipModifier(
            text: text,
            edge: edge,
            style: style,
            delay: delay,
            duration: duration,
            showOnLongPress: showOnLongPress
        ))
    }

    /// Adds a tooltip with manual visibility control
    /// - Parameters:
    ///   - isPresented: Binding to control tooltip visibility
    ///   - text: The tooltip text
    ///   - edge: The edge where the tooltip appears
    ///   - style: Visual style configuration
    /// - Returns: Modified view with tooltip capability
    func dsTooltip(
        isPresented: Binding<Bool>,
        _ text: String,
        edge: DSTooltipEdge = .top,
        style: DSTooltipStyle = .default
    ) -> some View {
        modifier(DSManualTooltipModifier(
            isPresented: isPresented,
            text: text,
            edge: edge,
            style: style
        ))
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSTooltip_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TooltipPreviewWrapper()
                .previewDisplayName("All Edges")

            TooltipStylesPreview()
                .previewDisplayName("Styles")

            TooltipPreviewWrapper()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

private struct TooltipPreviewWrapper: View {
    @State private var showTop = true
    @State private var showBottom = true
    @State private var showLeading = true
    @State private var showTrailing = true

    var body: some View {
        VStack(spacing: 60) {
            Button("Top Tooltip") {
                showTop.toggle()
            }
            .dsTooltip(isPresented: $showTop, "This tooltip appears on top", edge: .top)

            HStack(spacing: 100) {
                Button("Leading") {
                    showLeading.toggle()
                }
                .dsTooltip(isPresented: $showLeading, "Leading edge", edge: .leading)

                Button("Trailing") {
                    showTrailing.toggle()
                }
                .dsTooltip(isPresented: $showTrailing, "Trailing edge", edge: .trailing)
            }

            Button("Bottom Tooltip") {
                showBottom.toggle()
            }
            .dsTooltip(isPresented: $showBottom, "This tooltip appears on bottom", edge: .bottom)
        }
        .padding(50)
    }
}

private struct TooltipStylesPreview: View {
    @State private var showDefault = true
    @State private var showInfo = true
    @State private var showWarning = true
    @State private var showError = true

    var body: some View {
        VStack(spacing: 50) {
            Button("Default") { showDefault.toggle() }
                .dsTooltip(isPresented: $showDefault, "Default tooltip style")

            Button("Info") { showInfo.toggle() }
                .dsTooltip(isPresented: $showInfo, "Info tooltip style", style: .info)

            Button("Warning") { showWarning.toggle() }
                .dsTooltip(isPresented: $showWarning, "Warning tooltip style", style: .warning)

            Button("Error") { showError.toggle() }
                .dsTooltip(isPresented: $showError, "Error tooltip style", style: .error)
        }
        .padding(50)
    }
}
#endif
