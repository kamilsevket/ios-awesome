import SwiftUI

/// Configuration for dropdown menu items
public struct DSDropdownMenuItem: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let icon: Image?
    public let subtitle: String?
    public let isDestructive: Bool
    public let isDisabled: Bool

    public init(
        id: String = UUID().uuidString,
        title: String,
        icon: Image? = nil,
        subtitle: String? = nil,
        isDestructive: Bool = false,
        isDisabled: Bool = false
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.isDisabled = isDisabled
    }

    public static func == (lhs: DSDropdownMenuItem, rhs: DSDropdownMenuItem) -> Bool {
        lhs.id == rhs.id
    }
}

/// A dropdown menu component that displays a list of actions
///
/// Example usage:
/// ```swift
/// DSDropdownMenu(
///     items: [
///         DSDropdownMenuItem(title: "Edit", icon: Image(systemName: "pencil")),
///         DSDropdownMenuItem(title: "Delete", icon: Image(systemName: "trash"), isDestructive: true)
///     ],
///     onSelect: { item in
///         print("Selected: \(item.title)")
///     }
/// ) {
///     Image(systemName: "ellipsis")
/// }
/// ```
public struct DSDropdownMenu<Label: View>: View {
    // MARK: - Properties

    private let items: [DSDropdownMenuItem]
    private let label: Label
    private let onSelect: (DSDropdownMenuItem) -> Void

    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a dropdown menu with items
    /// - Parameters:
    ///   - items: The menu items to display
    ///   - onSelect: Callback when an item is selected
    ///   - label: The view that triggers the dropdown
    public init(
        items: [DSDropdownMenuItem],
        onSelect: @escaping (DSDropdownMenuItem) -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.items = items
        self.onSelect = onSelect
        self.label = label()
    }

    // MARK: - Body

    public var body: some View {
        Menu {
            ForEach(items) { item in
                Button(role: item.isDestructive ? .destructive : nil) {
                    onSelect(item)
                } label: {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.title)
                            if let subtitle = item.subtitle {
                                Text(subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } icon: {
                        if let icon = item.icon {
                            icon
                        }
                    }
                }
                .disabled(item.isDisabled)
            }
        } label: {
            label
        }
        .accessibilityLabel("Dropdown menu")
        .accessibilityHint("Double tap to show menu options")
    }
}

// MARK: - Convenience Initializers

public extension DSDropdownMenu where Label == Image {
    /// Creates a dropdown menu with a default ellipsis icon
    init(
        items: [DSDropdownMenuItem],
        onSelect: @escaping (DSDropdownMenuItem) -> Void
    ) {
        self.init(items: items, onSelect: onSelect) {
            Image(systemName: "ellipsis.circle")
                .font(.title2)
                .foregroundColor(DSColors.textPrimary)
        }
    }
}

// MARK: - Custom Dropdown (Non-Menu based)

/// A custom dropdown menu with more styling control
public struct DSCustomDropdownMenu<Label: View, Item: Identifiable & Equatable>: View {
    // MARK: - Properties

    private let items: [Item]
    private let label: Label
    private let itemLabel: (Item) -> AnyView
    private let onSelect: (Item) -> Void

    @State private var isExpanded = false
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    public init(
        items: [Item],
        onSelect: @escaping (Item) -> Void,
        @ViewBuilder itemLabel: @escaping (Item) -> some View,
        @ViewBuilder label: () -> Label
    ) {
        self.items = items
        self.onSelect = onSelect
        self.itemLabel = { AnyView(itemLabel($0)) }
        self.label = label()
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                label
            }
            .buttonStyle(.plain)

            if isExpanded {
                dropdownContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Dropdown menu")
        .accessibilityValue(isExpanded ? "expanded" : "collapsed")
        .accessibilityHint("Double tap to \(isExpanded ? "collapse" : "expand")")
    }

    // MARK: - Subviews

    private var dropdownContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(items) { item in
                Button {
                    onSelect(item)
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded = false
                    }
                } label: {
                    itemLabel(item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.sm)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if item.id as AnyHashable != items.last?.id as AnyHashable {
                    Divider()
                        .padding(.horizontal, Spacing.sm)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? DSColors.backgroundSecondary : DSColors.backgroundPrimary)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(DSColors.border, lineWidth: 1)
        )
        .padding(.top, Spacing.xs)
    }
}

// MARK: - Preview

#if DEBUG
struct DSDropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            // Standard Menu
            DSDropdownMenu(
                items: [
                    DSDropdownMenuItem(title: "Edit", icon: Image(systemName: "pencil")),
                    DSDropdownMenuItem(title: "Duplicate", icon: Image(systemName: "doc.on.doc")),
                    DSDropdownMenuItem(title: "Share", icon: Image(systemName: "square.and.arrow.up")),
                    DSDropdownMenuItem(title: "Delete", icon: Image(systemName: "trash"), isDestructive: true)
                ],
                onSelect: { item in
                    print("Selected: \(item.title)")
                }
            ) {
                HStack {
                    Text("Actions")
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(DSColors.backgroundSecondary)
                )
            }

            // Default icon style
            DSDropdownMenu(
                items: [
                    DSDropdownMenuItem(title: "Profile", icon: Image(systemName: "person")),
                    DSDropdownMenuItem(title: "Settings", icon: Image(systemName: "gear")),
                    DSDropdownMenuItem(title: "Help", icon: Image(systemName: "questionmark.circle")),
                    DSDropdownMenuItem(title: "Logout", icon: Image(systemName: "rectangle.portrait.and.arrow.right"), isDestructive: true)
                ],
                onSelect: { _ in }
            )

            // With subtitles
            DSDropdownMenu(
                items: [
                    DSDropdownMenuItem(title: "Download", icon: Image(systemName: "arrow.down.circle"), subtitle: "Save to device"),
                    DSDropdownMenuItem(title: "Share", icon: Image(systemName: "square.and.arrow.up"), subtitle: "Send to others"),
                    DSDropdownMenuItem(title: "Print", icon: Image(systemName: "printer"), subtitle: "Print document")
                ],
                onSelect: { _ in }
            ) {
                Image(systemName: "ellipsis")
                    .padding()
                    .background(Circle().fill(DSColors.backgroundSecondary))
            }
        }
        .padding()
        .previewDisplayName("DSDropdownMenu")
    }
}
#endif
