import SwiftUI

// MARK: - Sticky Header Style

/// Defines the style of sticky headers
public enum DSStickyHeaderStyle {
    case standard
    case blurred
    case solid

    var backgroundOpacity: Double {
        switch self {
        case .standard:
            return 0.95
        case .blurred:
            return 0.7
        case .solid:
            return 1.0
        }
    }

    var hasBlur: Bool {
        self == .blurred
    }
}

// MARK: - DSStickyHeader

/// A sticky header component that remains visible during scroll
///
/// DSStickyHeader provides a header that sticks to the top of a scrollable container.
/// It supports:
/// - Multiple visual styles (standard, blurred, solid)
/// - Shadow on scroll
/// - Custom content
/// - Animation on pin/unpin
///
/// Example usage:
/// ```swift
/// ScrollView {
///     LazyVStack(pinnedViews: [.sectionHeaders]) {
///         Section {
///             ForEach(items) { item in
///                 ItemRow(item)
///             }
///         } header: {
///             DSStickyHeader("Section Title")
///         }
///     }
/// }
/// ```
public struct DSStickyHeader<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private var style: DSStickyHeaderStyle = .standard
    private var backgroundColor: Color = DSColors.backgroundPrimary
    private var showsShadowOnPin: Bool = true
    private var minHeight: CGFloat = 44

    // MARK: - Initialization

    /// Creates a sticky header with custom content
    /// - Parameter content: The header content
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            let isPinned = geometry.frame(in: .named("scroll")).minY <= 0

            headerContent
                .background(
                    headerBackground
                        .shadow(
                            color: showsShadowOnPin && isPinned ? Color.black.opacity(0.1) : Color.clear,
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                )
                .animation(.easeInOut(duration: 0.15), value: isPinned)
        }
        .frame(minHeight: minHeight)
        .accessibilityAddTraits(.isHeader)
    }

    // MARK: - Private Views

    private var headerContent: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, DSSpacing.lg)
            .padding(.vertical, DSSpacing.sm)
    }

    @ViewBuilder
    private var headerBackground: some View {
        if style.hasBlur {
            ZStack {
                backgroundColor.opacity(style.backgroundOpacity)
                BlurView(style: .systemUltraThinMaterial)
            }
        } else {
            backgroundColor.opacity(style.backgroundOpacity)
        }
    }
}

// MARK: - Convenience Initializer

public extension DSStickyHeader where Content == Text {
    /// Creates a sticky header with text content
    /// - Parameter title: The header title
    init(_ title: String) {
        self.content = Text(title)
            .font(.headline)
            .foregroundColor(DSColors.textPrimary)
    }
}

// MARK: - Modifiers

public extension DSStickyHeader {
    /// Sets the header style
    /// - Parameter style: The sticky header style
    /// - Returns: A modified header with the specified style
    func style(_ style: DSStickyHeaderStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the background color
    /// - Parameter color: The background color
    /// - Returns: A modified header with the specified background color
    func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }

    /// Sets whether to show shadow when pinned
    /// - Parameter shows: Whether to show shadow
    /// - Returns: A modified header with shadow configuration
    func showsShadowOnPin(_ shows: Bool) -> Self {
        var copy = self
        copy.showsShadowOnPin = shows
        return copy
    }

    /// Sets the minimum height
    /// - Parameter height: The minimum height
    /// - Returns: A modified header with the specified minimum height
    func minHeight(_ height: CGFloat) -> Self {
        var copy = self
        copy.minHeight = height
        return copy
    }
}

// MARK: - Blur View

#if os(iOS)
private struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#else
private struct BlurView: View {
    let style: Any

    init(style: Any) {
        self.style = style
    }

    var body: some View {
        Color.clear
            .background(.ultraThinMaterial)
    }
}
#endif

// MARK: - Sticky Header List

/// A list component with built-in sticky header support
public struct DSStickyHeaderList<Data: RandomAccessCollection, SectionContent: View, HeaderContent: View>: View
    where Data.Element: Identifiable
{
    // MARK: - Properties

    private let data: Data
    private let sectionContent: (Data.Element) -> SectionContent
    private let headerContent: (Data.Element) -> HeaderContent
    private var headerStyle: DSStickyHeaderStyle = .standard
    private var backgroundColor: Color = DSColors.backgroundPrimary

    // MARK: - Initialization

    /// Creates a sticky header list
    /// - Parameters:
    ///   - data: The collection of section data
    ///   - headerContent: A view builder for section headers
    ///   - sectionContent: A view builder for section content
    public init(
        _ data: Data,
        @ViewBuilder headerContent: @escaping (Data.Element) -> HeaderContent,
        @ViewBuilder sectionContent: @escaping (Data.Element) -> SectionContent
    ) {
        self.data = data
        self.headerContent = headerContent
        self.sectionContent = sectionContent
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(data) { item in
                    Section {
                        sectionContent(item)
                    } header: {
                        DSStickyHeader {
                            headerContent(item)
                        }
                        .style(headerStyle)
                        .backgroundColor(backgroundColor)
                    }
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .background(backgroundColor)
    }
}

// MARK: - Modifiers for DSStickyHeaderList

public extension DSStickyHeaderList {
    /// Sets the header style
    /// - Parameter style: The sticky header style
    /// - Returns: A modified list with the specified header style
    func headerStyle(_ style: DSStickyHeaderStyle) -> Self {
        var copy = self
        copy.headerStyle = style
        return copy
    }

    /// Sets the background color
    /// - Parameter color: The background color
    /// - Returns: A modified list with the specified background color
    func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }
}

// MARK: - Preview

#if DEBUG
struct DSStickyHeader_Previews: PreviewProvider {
    static var previews: some View {
        DSStickyHeaderPreviewContainer()
            .previewDisplayName("Light Mode")

        DSStickyHeaderPreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DSStickyHeaderPreviewContainer: View {
    private let sections = [
        StickyPreviewSection(id: 1, title: "Today", items: (1...5).map { "Task \($0)" }),
        StickyPreviewSection(id: 2, title: "Tomorrow", items: (1...4).map { "Task \($0 + 5)" }),
        StickyPreviewSection(id: 3, title: "This Week", items: (1...8).map { "Task \($0 + 9)" }),
        StickyPreviewSection(id: 4, title: "Later", items: (1...6).map { "Task \($0 + 17)" })
    ]

    var body: some View {
        NavigationView {
            DSStickyHeaderList(sections) { section in
                HStack {
                    Text(section.title)
                        .font(.headline)
                        .foregroundColor(DSColors.textPrimary)
                    Spacer()
                    Text("\(section.items.count)")
                        .font(.caption)
                        .foregroundColor(DSColors.textSecondary)
                        .padding(.horizontal, DSSpacing.sm)
                        .padding(.vertical, DSSpacing.xxs)
                        .background(DSColors.backgroundSecondary)
                        .cornerRadius(DSSpacing.xs)
                }
            } sectionContent: { section in
                ForEach(section.items, id: \.self) { item in
                    HStack {
                        Image(systemName: "circle")
                            .foregroundColor(DSColors.textTertiary)
                        Text(item)
                            .foregroundColor(DSColors.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, DSSpacing.lg)
                    .padding(.vertical, DSSpacing.md)
                    .background(DSColors.backgroundPrimary)
                }
            }
            .headerStyle(.blurred)
            .navigationTitle("Sticky Headers")
        }
    }
}

private struct StickyPreviewSection: Identifiable {
    let id: Int
    let title: String
    let items: [String]
}
#endif
