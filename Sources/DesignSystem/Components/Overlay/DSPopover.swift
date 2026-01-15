import SwiftUI

// MARK: - Popover Edge

/// The edge where the popover arrow points to the anchor
public enum DSPopoverEdge: Sendable {
    case top
    case bottom
    case leading
    case trailing

    /// The opposite edge (where the popover content appears)
    var opposite: Edge {
        switch self {
        case .top: return .bottom
        case .bottom: return .top
        case .leading: return .trailing
        case .trailing: return .leading
        }
    }

    /// Arrow rotation angle
    var arrowRotation: Angle {
        switch self {
        case .top: return .degrees(180)
        case .bottom: return .degrees(0)
        case .leading: return .degrees(90)
        case .trailing: return .degrees(-90)
        }
    }
}

// MARK: - Popover Style

/// Style configuration for DSPopover
public struct DSPopoverStyle: Sendable {
    public let backgroundColor: Color
    public let cornerRadius: CGFloat
    public let shadowToken: ShadowToken
    public let arrowSize: CGSize
    public let padding: EdgeInsets

    public static let `default` = DSPopoverStyle(
        backgroundColor: Color(UIColor.systemBackground),
        cornerRadius: 12,
        shadowToken: .lg,
        arrowSize: CGSize(width: 16, height: 8),
        padding: EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    )

    public static let compact = DSPopoverStyle(
        backgroundColor: Color(UIColor.systemBackground),
        cornerRadius: 8,
        shadowToken: .md,
        arrowSize: CGSize(width: 12, height: 6),
        padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    )

    public static let menu = DSPopoverStyle(
        backgroundColor: Color(UIColor.secondarySystemBackground),
        cornerRadius: 14,
        shadowToken: .xl,
        arrowSize: CGSize(width: 16, height: 8),
        padding: EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
    )

    public init(
        backgroundColor: Color = Color(UIColor.systemBackground),
        cornerRadius: CGFloat = 12,
        shadowToken: ShadowToken = .lg,
        arrowSize: CGSize = CGSize(width: 16, height: 8),
        padding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowToken = shadowToken
        self.arrowSize = arrowSize
        self.padding = padding
    }
}

// MARK: - Arrow Shape

/// Triangle shape for popover arrow
private struct PopoverArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Popover Anchor Preference

private struct PopoverAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

// MARK: - DSPopover View

/// A styled popover component with arrow positioning
///
/// DSPopover provides a floating panel that appears near an anchor view with:
/// - Customizable arrow positioning (top, bottom, leading, trailing)
/// - Auto-dismiss on tap outside
/// - Smooth spring animations
/// - Dark mode support
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// Button("Show Popover") {
///     showPopover = true
/// }
/// .dsPopover(isPresented: $showPopover, edge: .bottom) {
///     VStack {
///         Text("Popover Content")
///         Button("Action") { }
///     }
/// }
/// ```
public struct DSPopover<Content: View>: View {
    // MARK: - Properties

    @Binding private var isPresented: Bool
    private let edge: DSPopoverEdge
    private let style: DSPopoverStyle
    private let dismissOnTapOutside: Bool
    private let content: Content

    @State private var animationScale: CGFloat = 0.8
    @State private var animationOpacity: Double = 0
    @State private var anchorRect: CGRect = .zero

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a DSPopover
    /// - Parameters:
    ///   - isPresented: Binding to control popover visibility
    ///   - edge: The edge where the arrow points (default: .top)
    ///   - style: Visual style configuration
    ///   - dismissOnTapOutside: Whether tapping outside dismisses the popover (default: true)
    ///   - content: The popover content builder
    public init(
        isPresented: Binding<Bool>,
        edge: DSPopoverEdge = .top,
        style: DSPopoverStyle = .default,
        dismissOnTapOutside: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.edge = edge
        self.style = style
        self.dismissOnTapOutside = dismissOnTapOutside
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Backdrop for tap-outside-to-dismiss
            if dismissOnTapOutside {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismiss()
                    }
                    .accessibilityHidden(true)
            }

            // Popover content
            popoverContent
                .scaleEffect(animationScale)
                .opacity(animationOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                animationScale = 1.0
                animationOpacity = 1.0
            }
        }
    }

    // MARK: - Subviews

    private var popoverContent: some View {
        VStack(spacing: 0) {
            if edge == .bottom {
                arrowView
            }

            if edge == .trailing {
                HStack(spacing: 0) {
                    arrowView
                    contentBody
                }
            } else if edge == .leading {
                HStack(spacing: 0) {
                    contentBody
                    arrowView
                }
            } else {
                contentBody
            }

            if edge == .top {
                arrowView
            }
        }
        .shadow(
            color: shadowColor,
            radius: style.shadowToken.blur,
            x: style.shadowToken.x,
            y: style.shadowToken.y
        )
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
        .accessibilityLabel("Popover")
    }

    private var contentBody: some View {
        content
            .padding(style.padding)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
    }

    private var arrowView: some View {
        PopoverArrow()
            .fill(style.backgroundColor)
            .frame(width: style.arrowSize.width, height: style.arrowSize.height)
            .rotationEffect(edge.arrowRotation)
    }

    private var shadowColor: Color {
        colorScheme == .dark
            ? style.shadowToken.darkModeColor
            : style.shadowToken.color
    }

    // MARK: - Actions

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.15)) {
            animationScale = 0.8
            animationOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            isPresented = false
        }
    }
}

// MARK: - Popover Modifier

private struct DSPopoverModifier<PopoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let edge: DSPopoverEdge
    let style: DSPopoverStyle
    let dismissOnTapOutside: Bool
    let popoverContent: () -> PopoverContent

    @State private var anchorFrame: CGRect = .zero

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(
                            key: PopoverAnchorPreferenceKey.self,
                            value: geometry.frame(in: .global)
                        )
                }
            )
            .onPreferenceChange(PopoverAnchorPreferenceKey.self) { frame in
                anchorFrame = frame
            }
            .overlay(
                Group {
                    if isPresented {
                        DSPopover(
                            isPresented: $isPresented,
                            edge: edge,
                            style: style,
                            dismissOnTapOutside: dismissOnTapOutside,
                            content: popoverContent
                        )
                        .fixedSize()
                        .offset(x: offsetX, y: offsetY)
                    }
                }
            )
    }

    private var offsetX: CGFloat {
        switch edge {
        case .top, .bottom:
            return 0
        case .leading:
            return -anchorFrame.width / 2 - 20
        case .trailing:
            return anchorFrame.width / 2 + 20
        }
    }

    private var offsetY: CGFloat {
        switch edge {
        case .top:
            return -anchorFrame.height / 2 - 20
        case .bottom:
            return anchorFrame.height / 2 + 20
        case .leading, .trailing:
            return 0
        }
    }
}

// MARK: - View Extension

public extension View {
    /// Presents a design system popover attached to this view
    /// - Parameters:
    ///   - isPresented: Binding to control popover visibility
    ///   - edge: The edge where the popover appears relative to the anchor
    ///   - style: Visual style configuration
    ///   - dismissOnTapOutside: Whether tapping outside dismisses the popover
    ///   - content: The popover content builder
    /// - Returns: Modified view with popover capability
    func dsPopover<Content: View>(
        isPresented: Binding<Bool>,
        edge: DSPopoverEdge = .top,
        style: DSPopoverStyle = .default,
        dismissOnTapOutside: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DSPopoverModifier(
            isPresented: isPresented,
            edge: edge,
            style: style,
            dismissOnTapOutside: dismissOnTapOutside,
            popoverContent: content
        ))
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSPopover_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PopoverPreviewWrapper(edge: .bottom)
                .previewDisplayName("Bottom Edge")

            PopoverPreviewWrapper(edge: .top)
                .previewDisplayName("Top Edge")

            PopoverPreviewWrapper(edge: .leading)
                .previewDisplayName("Leading Edge")

            PopoverPreviewWrapper(edge: .trailing)
                .previewDisplayName("Trailing Edge")

            PopoverPreviewWrapper(edge: .bottom)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")

            PopoverMenuPreview()
                .previewDisplayName("Menu Style")
        }
    }
}

private struct PopoverPreviewWrapper: View {
    let edge: DSPopoverEdge
    @State private var showPopover = true

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            Button("Show Popover") {
                showPopover = true
            }
            .dsPopover(isPresented: $showPopover, edge: edge) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Popover Title")
                        .font(.headline)
                    Text("This is some popover content that explains something useful.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: 200)
            }
        }
    }
}

private struct PopoverMenuPreview: View {
    @State private var showPopover = true

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            Button("Show Menu") {
                showPopover = true
            }
            .dsPopover(isPresented: $showPopover, edge: .bottom, style: .menu) {
                VStack(spacing: 0) {
                    ForEach(["Edit", "Duplicate", "Share", "Delete"], id: \.self) { item in
                        Button {
                            showPopover = false
                        } label: {
                            HStack {
                                Text(item)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.plain)

                        if item != "Delete" {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .frame(width: 200)
            }
        }
    }
}
#endif
