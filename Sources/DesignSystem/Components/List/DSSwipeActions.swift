import SwiftUI

// MARK: - Swipe Action Role

/// Defines the semantic role of a swipe action
public enum DSSwipeActionRole {
    case destructive
    case cancel
    case none

    var buttonRole: ButtonRole? {
        switch self {
        case .destructive:
            return .destructive
        case .cancel:
            return .cancel
        case .none:
            return nil
        }
    }
}

// MARK: - Swipe Action

/// A single swipe action configuration
public struct DSSwipeAction: Identifiable {
    public let id = UUID()
    public let title: String
    public let icon: Image?
    public let tint: Color
    public let role: DSSwipeActionRole
    public let action: () -> Void

    /// Creates a new swipe action
    /// - Parameters:
    ///   - title: The action's label text
    ///   - icon: Optional SF Symbol or image
    ///   - tint: Background color for the action button
    ///   - role: Semantic role (destructive, cancel, or none)
    ///   - action: Closure executed when action is triggered
    public init(
        title: String,
        icon: Image? = nil,
        tint: Color = DSColors.primary,
        role: DSSwipeActionRole = .none,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.tint = tint
        self.role = role
        self.action = action
    }

    // MARK: - Convenience Factory Methods

    /// Creates a delete action with standard styling
    /// - Parameter action: Closure executed when delete is triggered
    /// - Returns: A configured delete swipe action
    public static func delete(action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: "Delete",
            icon: Image(systemName: "trash"),
            tint: DSColors.destructive,
            role: .destructive,
            action: action
        )
    }

    /// Creates an archive action with standard styling
    /// - Parameter action: Closure executed when archive is triggered
    /// - Returns: A configured archive swipe action
    public static func archive(action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: "Archive",
            icon: Image(systemName: "archivebox"),
            tint: .orange,
            action: action
        )
    }

    /// Creates a pin action with standard styling
    /// - Parameters:
    ///   - isPinned: Whether the item is currently pinned
    ///   - action: Closure executed when pin/unpin is triggered
    /// - Returns: A configured pin swipe action
    public static func pin(isPinned: Bool = false, action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: isPinned ? "Unpin" : "Pin",
            icon: Image(systemName: isPinned ? "pin.slash" : "pin"),
            tint: .yellow,
            action: action
        )
    }

    /// Creates a share action with standard styling
    /// - Parameter action: Closure executed when share is triggered
    /// - Returns: A configured share swipe action
    public static func share(action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: "Share",
            icon: Image(systemName: "square.and.arrow.up"),
            tint: DSColors.primary,
            action: action
        )
    }

    /// Creates a flag action with standard styling
    /// - Parameters:
    ///   - isFlagged: Whether the item is currently flagged
    ///   - action: Closure executed when flag/unflag is triggered
    /// - Returns: A configured flag swipe action
    public static func flag(isFlagged: Bool = false, action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: isFlagged ? "Unflag" : "Flag",
            icon: Image(systemName: isFlagged ? "flag.slash" : "flag"),
            tint: .orange,
            action: action
        )
    }

    /// Creates a read/unread action with standard styling
    /// - Parameters:
    ///   - isRead: Whether the item is currently read
    ///   - action: Closure executed when read/unread is triggered
    /// - Returns: A configured read/unread swipe action
    public static func markAsRead(isRead: Bool = false, action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: isRead ? "Mark Unread" : "Mark Read",
            icon: Image(systemName: isRead ? "envelope.badge" : "envelope.open"),
            tint: DSColors.primary,
            action: action
        )
    }

    /// Creates an edit action with standard styling
    /// - Parameter action: Closure executed when edit is triggered
    /// - Returns: A configured edit swipe action
    public static func edit(action: @escaping () -> Void) -> DSSwipeAction {
        DSSwipeAction(
            title: "Edit",
            icon: Image(systemName: "pencil"),
            tint: DSColors.info,
            action: action
        )
    }
}

// MARK: - Swipe Actions Modifier

/// A view modifier that adds swipe actions to a list row
public struct DSSwipeActionsModifier: ViewModifier {
    let leadingActions: [DSSwipeAction]
    let trailingActions: [DSSwipeAction]
    let allowFullSwipe: Bool

    public init(
        leading: [DSSwipeAction] = [],
        trailing: [DSSwipeAction] = [],
        allowFullSwipe: Bool = true
    ) {
        self.leadingActions = leading
        self.trailingActions = trailing
        self.allowFullSwipe = allowFullSwipe
    }

    public func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading, allowsFullSwipe: allowFullSwipe && !leadingActions.isEmpty) {
                ForEach(leadingActions) { action in
                    Button(role: action.role.buttonRole) {
                        triggerHapticFeedback()
                        action.action()
                    } label: {
                        if let icon = action.icon {
                            Label(action.title, image: "")
                                .labelStyle(IconOnlyLabelStyle())
                                .overlay(
                                    icon.foregroundColor(.white)
                                )
                        } else {
                            Text(action.title)
                        }
                    }
                    .tint(action.tint)
                }
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: allowFullSwipe && !trailingActions.isEmpty) {
                ForEach(trailingActions) { action in
                    Button(role: action.role.buttonRole) {
                        triggerHapticFeedback()
                        action.action()
                    } label: {
                        if let icon = action.icon {
                            Label(action.title, image: "")
                                .labelStyle(IconOnlyLabelStyle())
                                .overlay(
                                    icon.foregroundColor(.white)
                                )
                        } else {
                            Text(action.title)
                        }
                    }
                    .tint(action.tint)
                }
            }
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - View Extension

public extension View {
    /// Adds swipe actions to a list row
    /// - Parameters:
    ///   - leading: Actions shown when swiping from leading edge
    ///   - trailing: Actions shown when swiping from trailing edge
    ///   - allowFullSwipe: Whether full swipe triggers the first action
    /// - Returns: A view with swipe actions applied
    func dsSwipeActions(
        leading: [DSSwipeAction] = [],
        trailing: [DSSwipeAction] = [],
        allowFullSwipe: Bool = true
    ) -> some View {
        modifier(DSSwipeActionsModifier(
            leading: leading,
            trailing: trailing,
            allowFullSwipe: allowFullSwipe
        ))
    }

    /// Adds a delete swipe action to the trailing edge
    /// - Parameter action: Closure executed when delete is triggered
    /// - Returns: A view with delete swipe action
    func dsDeleteAction(_ action: @escaping () -> Void) -> some View {
        dsSwipeActions(trailing: [.delete(action: action)])
    }
}

// MARK: - Preview

#if DEBUG
struct DSSwipeActions_Previews: PreviewProvider {
    static var previews: some View {
        DSSwipeActionsPreviewContainer()
            .previewDisplayName("Light Mode")

        DSSwipeActionsPreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DSSwipeActionsPreviewContainer: View {
    @State private var items = (1...5).map {
        SwipePreviewItem(
            id: $0,
            title: "Item \($0)",
            isRead: $0 % 2 == 0,
            isPinned: $0 == 1
        )
    }

    var body: some View {
        NavigationView {
            List {
                ForEach($items) { $item in
                    HStack {
                        if item.isPinned {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.yellow)
                        }
                        VStack(alignment: .leading, spacing: DSSpacing.xs) {
                            Text(item.title)
                                .font(.body)
                                .fontWeight(item.isRead ? .regular : .semibold)
                            Text(item.isRead ? "Read" : "Unread")
                                .font(.caption)
                                .foregroundColor(DSColors.textSecondary)
                        }
                        Spacer()
                    }
                    .dsSwipeActions(
                        leading: [
                            .pin(isPinned: item.isPinned) {
                                item.isPinned.toggle()
                            },
                            .markAsRead(isRead: item.isRead) {
                                item.isRead.toggle()
                            }
                        ],
                        trailing: [
                            .delete {
                                if let index = items.firstIndex(where: { $0.id == item.id }) {
                                    items.remove(at: index)
                                }
                            },
                            .archive {
                                print("Archive: \(item.title)")
                            }
                        ]
                    )
                }
            }
            .navigationTitle("Swipe Actions")
        }
    }
}

private struct SwipePreviewItem: Identifiable {
    let id: Int
    var title: String
    var isRead: Bool
    var isPinned: Bool
}
#endif
