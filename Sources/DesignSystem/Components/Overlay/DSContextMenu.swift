import SwiftUI

// MARK: - Menu Item Role

/// Role of a menu item affecting its appearance
public enum DSMenuItemRole: Sendable {
    case `default`
    case destructive

    var foregroundColor: Color {
        switch self {
        case .default:
            return Color(UIColor.label)
        case .destructive:
            return DSColors.destructive
        }
    }
}

// MARK: - Menu Item

/// A styled menu item for use in context menus
///
/// Example:
/// ```swift
/// DSMenuItem("Edit", systemImage: "pencil") {
///     // Action
/// }
///
/// DSMenuItem("Delete", systemImage: "trash", role: .destructive) {
///     // Action
/// }
/// ```
public struct DSMenuItem: View {
    // MARK: - Properties

    private let title: String
    private let systemImage: String?
    private let role: DSMenuItemRole
    private let action: () -> Void

    // MARK: - Initialization

    /// Creates a menu item with a system image
    /// - Parameters:
    ///   - title: The menu item title
    ///   - systemImage: SF Symbol name
    ///   - role: The role affecting appearance (default: .default)
    ///   - action: Action to perform when tapped
    public init(
        _ title: String,
        systemImage: String? = nil,
        role: DSMenuItemRole = .default,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            Label {
                Text(title)
            } icon: {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                }
            }
        }
        .foregroundColor(role.foregroundColor)
    }
}

// MARK: - Menu Section

/// A section within a context menu for grouping related items
public struct DSMenuSection<Content: View>: View {
    private let header: String?
    private let content: Content

    /// Creates a menu section with optional header
    /// - Parameters:
    ///   - header: Optional section header text
    ///   - content: The menu items in this section
    public init(
        header: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.content = content()
    }

    public var body: some View {
        Section {
            content
        } header: {
            if let header = header {
                Text(header)
            }
        }
    }
}

// MARK: - Context Menu Modifier

private struct DSContextMenuModifier<MenuContent: View>: ViewModifier {
    let menuContent: () -> MenuContent

    func body(content: Content) -> some View {
        content
            .contextMenu {
                menuContent()
            }
    }
}

// MARK: - Context Menu with Preview Modifier

private struct DSContextMenuWithPreviewModifier<MenuContent: View, PreviewContent: View>: ViewModifier {
    let menuContent: () -> MenuContent
    let previewContent: () -> PreviewContent

    func body(content: Content) -> some View {
        content
            .contextMenu {
                menuContent()
            } preview: {
                previewContent()
            }
    }
}

// MARK: - View Extension

public extension View {
    /// Adds a styled context menu to this view
    /// - Parameter content: The menu content builder
    /// - Returns: Modified view with context menu capability
    ///
    /// Example:
    /// ```swift
    /// Image("photo")
    ///     .dsContextMenu {
    ///         DSMenuItem("Edit", systemImage: "pencil") { }
    ///         DSMenuItem("Share", systemImage: "square.and.arrow.up") { }
    ///         Divider()
    ///         DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
    ///     }
    /// ```
    func dsContextMenu<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(DSContextMenuModifier(menuContent: content))
    }

    /// Adds a styled context menu with custom preview to this view
    /// - Parameters:
    ///   - content: The menu content builder
    ///   - preview: The preview content shown when context menu is activated
    /// - Returns: Modified view with context menu capability
    ///
    /// Example:
    /// ```swift
    /// Image("photo")
    ///     .dsContextMenu {
    ///         DSMenuItem("Edit", systemImage: "pencil") { }
    ///     } preview: {
    ///         Image("photo")
    ///             .resizable()
    ///             .frame(width: 300, height: 300)
    ///     }
    /// ```
    func dsContextMenu<MenuContent: View, PreviewContent: View>(
        @ViewBuilder content: @escaping () -> MenuContent,
        @ViewBuilder preview: @escaping () -> PreviewContent
    ) -> some View {
        modifier(DSContextMenuWithPreviewModifier(
            menuContent: content,
            previewContent: preview
        ))
    }
}

// MARK: - DSContextMenuButton

/// A button that shows a context menu on tap (not long press)
///
/// Useful for "more options" buttons that should show a menu immediately
///
/// Example:
/// ```swift
/// DSContextMenuButton {
///     DSMenuItem("Edit", systemImage: "pencil") { }
///     DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
/// } label: {
///     Image(systemName: "ellipsis.circle")
/// }
/// ```
public struct DSContextMenuButton<Label: View, MenuContent: View>: View {
    private let menuContent: MenuContent
    private let label: Label

    public init(
        @ViewBuilder content: () -> MenuContent,
        @ViewBuilder label: () -> Label
    ) {
        self.menuContent = content()
        self.label = label()
    }

    public var body: some View {
        Menu {
            menuContent
        } label: {
            label
        }
        .menuStyle(.borderlessButton)
        .accessibilityLabel("More options")
        .accessibilityHint("Double tap to show menu")
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContextMenuPreviewWrapper()
                .previewDisplayName("Context Menu")

            ContextMenuButtonPreview()
                .previewDisplayName("Menu Button")

            ContextMenuPreviewWrapper()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}

private struct ContextMenuPreviewWrapper: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Long press on items below")
                .font(.caption)
                .foregroundColor(.secondary)

            // Simple context menu
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 150, height: 100)
                .overlay(
                    Text("Long Press Me")
                        .font(.subheadline)
                )
                .dsContextMenu {
                    DSMenuItem("Edit", systemImage: "pencil") { }
                    DSMenuItem("Duplicate", systemImage: "plus.square.on.square") { }
                    DSMenuItem("Share", systemImage: "square.and.arrow.up") { }
                    Divider()
                    DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
                }

            // Context menu with sections
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.2))
                .frame(width: 150, height: 100)
                .overlay(
                    Text("With Sections")
                        .font(.subheadline)
                )
                .dsContextMenu {
                    DSMenuSection(header: "Actions") {
                        DSMenuItem("Edit", systemImage: "pencil") { }
                        DSMenuItem("Move", systemImage: "folder") { }
                    }

                    DSMenuSection(header: "Share") {
                        DSMenuItem("Copy Link", systemImage: "link") { }
                        DSMenuItem("Share", systemImage: "square.and.arrow.up") { }
                    }

                    DSMenuSection {
                        DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
                    }
                }
        }
        .padding()
    }
}

private struct ContextMenuButtonPreview: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Tap buttons below")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 30) {
                DSContextMenuButton {
                    DSMenuItem("Edit", systemImage: "pencil") { }
                    DSMenuItem("Share", systemImage: "square.and.arrow.up") { }
                    Divider()
                    DSMenuItem("Delete", systemImage: "trash", role: .destructive) { }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                }

                DSContextMenuButton {
                    DSMenuItem("Sort by Name", systemImage: "textformat") { }
                    DSMenuItem("Sort by Date", systemImage: "calendar") { }
                    DSMenuItem("Sort by Size", systemImage: "arrow.up.arrow.down") { }
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
#endif
