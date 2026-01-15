import SwiftUI

// MARK: - Section Header Style

/// Defines the style of section headers
public enum DSSectionHeaderStyle {
    case plain
    case prominent
    case uppercase

    var font: Font {
        switch self {
        case .plain:
            return .subheadline
        case .prominent:
            return .headline
        case .uppercase:
            return .caption
        }
    }

    var textColor: Color {
        switch self {
        case .plain:
            return DSColors.textPrimary
        case .prominent:
            return DSColors.textPrimary
        case .uppercase:
            return DSColors.textSecondary
        }
    }

    var textTransform: TextTransform {
        switch self {
        case .uppercase:
            return .uppercase
        default:
            return .none
        }
    }
}

// MARK: - Text Transform

public enum TextTransform {
    case none
    case uppercase
    case lowercase
    case capitalized

    func apply(to text: String) -> String {
        switch self {
        case .none:
            return text
        case .uppercase:
            return text.uppercased()
        case .lowercase:
            return text.lowercased()
        case .capitalized:
            return text.capitalized
        }
    }
}

// MARK: - DSSection

/// A customizable section component for lists
///
/// DSSection provides a consistent section implementation with support for:
/// - Custom headers and footers
/// - Multiple header styles (plain, prominent, uppercase)
/// - Collapsible sections
/// - Separator customization
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// List {
///     DSSection(header: "Settings") {
///         SettingsRow(title: "Notifications")
///         SettingsRow(title: "Privacy")
///     }
///
///     DSSection(
///         header: "Account",
///         footer: "Sign out to protect your data"
///     ) {
///         AccountRow()
///     }
/// }
/// ```
public struct DSSection<Content: View, Header: View, Footer: View>: View {
    // MARK: - Properties

    private let content: Content
    private let header: Header
    private let footer: Footer
    private var headerStyle: DSSectionHeaderStyle = .plain
    private var isCollapsible: Bool = false
    private var backgroundColor: Color = DSColors.backgroundPrimary

    @State private var isExpanded: Bool = true

    // MARK: - Initialization

    /// Creates a section with custom header and footer views
    /// - Parameters:
    ///   - header: The header view
    ///   - footer: The footer view
    ///   - content: The section content
    public init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.footer = footer()
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        Section {
            if !isCollapsible || isExpanded {
                content
            }
        } header: {
            headerView
        } footer: {
            footer
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
        }
        .listRowBackground(backgroundColor)
    }

    // MARK: - Private Views

    @ViewBuilder
    private var headerView: some View {
        if isCollapsible {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
                triggerHapticFeedback()
            }) {
                HStack {
                    header
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(DSColors.textTertiary)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isExpanded ? "Collapse section" : "Expand section")
            .accessibilityHint("Double tap to \(isExpanded ? "collapse" : "expand")")
        } else {
            header
        }
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Convenience Initializers

public extension DSSection where Header == Text, Footer == EmptyView {
    /// Creates a section with a text header and no footer
    /// - Parameters:
    ///   - header: The header text
    ///   - content: The section content
    init(
        header: String,
        @ViewBuilder content: () -> Content
    ) {
        self.header = Text(header)
        self.footer = EmptyView()
        self.content = content()
    }
}

public extension DSSection where Header == Text, Footer == Text {
    /// Creates a section with text header and footer
    /// - Parameters:
    ///   - header: The header text
    ///   - footer: The footer text
    ///   - content: The section content
    init(
        header: String,
        footer: String,
        @ViewBuilder content: () -> Content
    ) {
        self.header = Text(header)
        self.footer = Text(footer)
        self.content = content()
    }
}

public extension DSSection where Header == EmptyView, Footer == EmptyView {
    /// Creates a section with no header or footer
    /// - Parameter content: The section content
    init(@ViewBuilder content: () -> Content) {
        self.header = EmptyView()
        self.footer = EmptyView()
        self.content = content()
    }
}

public extension DSSection where Header == EmptyView {
    /// Creates a section with only a footer
    /// - Parameters:
    ///   - footer: The footer view
    ///   - content: The section content
    init(
        @ViewBuilder footer: () -> Footer,
        @ViewBuilder content: () -> Content
    ) {
        self.header = EmptyView()
        self.footer = footer()
        self.content = content()
    }
}

public extension DSSection where Footer == EmptyView {
    /// Creates a section with only a header
    /// - Parameters:
    ///   - header: The header view
    ///   - content: The section content
    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.footer = EmptyView()
        self.content = content()
    }
}

// MARK: - Modifiers

public extension DSSection {
    /// Sets the header style
    /// - Parameter style: The header style to use
    /// - Returns: A modified section with the specified header style
    func headerStyle(_ style: DSSectionHeaderStyle) -> Self {
        var copy = self
        copy.headerStyle = style
        return copy
    }

    /// Makes the section collapsible
    /// - Parameter collapsible: Whether the section can be collapsed
    /// - Returns: A modified section with collapsibility
    func collapsible(_ collapsible: Bool = true) -> Self {
        var copy = self
        copy.isCollapsible = collapsible
        return copy
    }

    /// Sets the initial expansion state
    /// - Parameter expanded: Whether the section starts expanded
    /// - Returns: A modified section with the specified expansion state
    func expanded(_ expanded: Bool) -> Self {
        var copy = self
        copy._isExpanded = State(initialValue: expanded)
        return copy
    }

    /// Sets the background color
    /// - Parameter color: The background color
    /// - Returns: A modified section with the specified background color
    func backgroundColor(_ color: Color) -> Self {
        var copy = self
        copy.backgroundColor = color
        return copy
    }
}

// MARK: - DSSectionHeader

/// A styled section header component
public struct DSSectionHeader: View {
    private let title: String
    private var style: DSSectionHeaderStyle
    private var trailingContent: AnyView?

    public init(_ title: String, style: DSSectionHeaderStyle = .plain) {
        self.title = title
        self.style = style
    }

    public var body: some View {
        HStack {
            Text(style.textTransform.apply(to: title))
                .font(style.font)
                .foregroundColor(style.textColor)
                .fontWeight(style == .prominent ? .semibold : .regular)

            Spacer()

            if let trailing = trailingContent {
                trailing
            }
        }
        .padding(.vertical, DSSpacing.xs)
        .accessibilityAddTraits(.isHeader)
    }

    /// Adds trailing content to the header
    /// - Parameter content: The trailing content view
    /// - Returns: A modified header with trailing content
    public func trailing<Content: View>(@ViewBuilder _ content: () -> Content) -> Self {
        var copy = self
        copy.trailingContent = AnyView(content())
        return copy
    }
}

// MARK: - DSSectionFooter

/// A styled section footer component
public struct DSSectionFooter: View {
    private let text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(DSColors.textSecondary)
            .padding(.vertical, DSSpacing.xs)
    }
}

// MARK: - Preview

#if DEBUG
struct DSSection_Previews: PreviewProvider {
    static var previews: some View {
        DSSectionPreviewContainer()
            .previewDisplayName("Light Mode")

        DSSectionPreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DSSectionPreviewContainer: View {
    var body: some View {
        NavigationView {
            List {
                // Plain header section
                DSSection(header: "Account") {
                    SectionPreviewRow(title: "Profile", icon: "person")
                    SectionPreviewRow(title: "Settings", icon: "gear")
                }

                // Prominent header section
                DSSection {
                    DSSectionHeader("Notifications", style: .prominent)
                } footer: {
                    DSSectionFooter("Manage how you receive notifications")
                } content: {
                    SectionPreviewRow(title: "Push Notifications", icon: "bell")
                    SectionPreviewRow(title: "Email", icon: "envelope")
                }

                // Uppercase header section
                DSSection {
                    DSSectionHeader("Privacy", style: .uppercase)
                } content: {
                    SectionPreviewRow(title: "Password", icon: "lock")
                    SectionPreviewRow(title: "Two-Factor Auth", icon: "shield")
                }

                // Collapsible section
                DSSection(header: "Advanced")
                    .collapsible()
                {
                    SectionPreviewRow(title: "Developer Options", icon: "hammer")
                    SectionPreviewRow(title: "Debug Mode", icon: "ant")
                }

                // Header with trailing content
                DSSection {
                    DSSectionHeader("Help", style: .plain)
                        .trailing {
                            Button("See All") { }
                                .font(.caption)
                        }
                } content: {
                    SectionPreviewRow(title: "FAQ", icon: "questionmark.circle")
                    SectionPreviewRow(title: "Contact Us", icon: "message")
                }
            }
            .navigationTitle("Sections Demo")
        }
    }
}

private struct SectionPreviewRow: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: DSSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(DSColors.primary)
                .frame(width: 24)

            Text(title)
                .foregroundColor(DSColors.textPrimary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(DSColors.textTertiary)
        }
    }
}
#endif
