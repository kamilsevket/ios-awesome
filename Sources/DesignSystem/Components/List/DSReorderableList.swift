import SwiftUI

// MARK: - Reorder Handle Style

/// Defines the style of the reorder handle
public enum DSReorderHandleStyle {
    case none
    case standard
    case custom(Image)

    var image: Image? {
        switch self {
        case .none:
            return nil
        case .standard:
            return Image(systemName: "line.3.horizontal")
        case .custom(let image):
            return image
        }
    }
}

// MARK: - DSReorderableList

/// A list component that supports drag-to-reorder functionality
///
/// DSReorderableList provides a consistent reorderable list implementation with support for:
/// - Drag and drop reordering
/// - Haptic feedback on drag
/// - Custom reorder handles
/// - Edit mode integration
/// - Smooth animations
///
/// Example usage:
/// ```swift
/// @State var items: [Item] = [...]
///
/// DSReorderableList($items) { item in
///     ItemRow(item)
/// }
/// .handleStyle(.standard)
/// .onReorder { from, to in
///     // Handle reorder event
/// }
/// ```
public struct DSReorderableList<Data: RandomAccessCollection & MutableCollection, RowContent: View>: View
    where Data.Element: Identifiable, Data.Index == Int
{
    // MARK: - Properties

    @Binding private var data: Data
    private let rowContent: (Data.Element) -> RowContent
    private var handleStyle: DSReorderHandleStyle = .standard
    private var showsHandleOnlyInEditMode: Bool = true
    private var onReorder: ((IndexSet, Int) -> Void)?
    private var backgroundColor: Color = DSColors.backgroundPrimary
    private var separatorStyle: DSSeparatorStyle = .singleLine

    @State private var draggedItem: Data.Element?
    @State private var hasChangedPosition: Bool = false

    // MARK: - Initialization

    /// Creates a new DSReorderableList
    /// - Parameters:
    ///   - data: Binding to the collection of identifiable data
    ///   - rowContent: A view builder that creates the row content for each item
    public init(
        _ data: Binding<Data>,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) {
        self._data = data
        self.rowContent = rowContent
    }

    // MARK: - Body

    public var body: some View {
        List {
            ForEach(data) { item in
                HStack(spacing: DSSpacing.md) {
                    if let handleImage = handleStyle.image {
                        handleView(handleImage)
                    }

                    rowContent(item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .listRowBackground(backgroundColor)
                .listRowSeparator(separatorStyle.visibility)
                .listRowInsets(EdgeInsets(
                    top: DSSpacing.sm,
                    leading: DSSpacing.lg,
                    bottom: DSSpacing.sm,
                    trailing: DSSpacing.lg
                ))
            }
            .onMove(perform: handleMove)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(backgroundColor)
    }

    // MARK: - Private Views

    private func handleView(_ image: Image) -> some View {
        image
            .foregroundColor(DSColors.textTertiary)
            .font(.body)
            .frame(width: 24, height: 24)
            .accessibilityLabel("Reorder handle")
            .accessibilityHint("Drag to reorder this item")
    }

    // MARK: - Private Methods

    private func handleMove(from source: IndexSet, to destination: Int) {
        triggerHapticFeedback()
        onReorder?(source, destination)
    }

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Modifiers

public extension DSReorderableList {
    /// Sets the handle style
    /// - Parameter style: The reorder handle style
    /// - Returns: A modified list with the specified handle style
    func handleStyle(_ style: DSReorderHandleStyle) -> Self {
        var copy = self
        copy.handleStyle = style
        return copy
    }

    /// Sets whether handles are shown only in edit mode
    /// - Parameter editModeOnly: Whether to show handles only in edit mode
    /// - Returns: A modified list
    func showsHandleOnlyInEditMode(_ editModeOnly: Bool) -> Self {
        var copy = self
        copy.showsHandleOnlyInEditMode = editModeOnly
        return copy
    }

    /// Adds a reorder callback
    /// - Parameter action: The action to perform when items are reordered
    /// - Returns: A modified list with reorder callback
    func onReorder(_ action: @escaping (IndexSet, Int) -> Void) -> Self {
        var copy = self
        copy.onReorder = action
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

    /// Sets the separator style
    /// - Parameter style: The separator style to use
    /// - Returns: A modified list with the specified separator style
    func separatorStyle(_ style: DSSeparatorStyle) -> Self {
        var copy = self
        copy.separatorStyle = style
        return copy
    }
}

// MARK: - Preview

#if DEBUG
struct DSReorderableList_Previews: PreviewProvider {
    static var previews: some View {
        DSReorderableListPreviewContainer()
            .previewDisplayName("Light Mode")

        DSReorderableListPreviewContainer()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

private struct DSReorderableListPreviewContainer: View {
    @State private var items = (1...8).map { ReorderPreviewItem(id: $0, title: "Item \($0)", color: colors[$0 % colors.count]) }
    @State private var editMode: EditMode = .active

    private static let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow, .cyan]

    var body: some View {
        NavigationView {
            DSReorderableList($items) { item in
                HStack(spacing: DSSpacing.md) {
                    Circle()
                        .fill(item.color)
                        .frame(width: 32, height: 32)

                    Text(item.title)
                        .font(.body)
                        .foregroundColor(DSColors.textPrimary)
                }
            }
            .handleStyle(.standard)
            .onReorder { from, to in
                items.move(fromOffsets: from, toOffset: to)
            }
            .environment(\.editMode, $editMode)
            .navigationTitle("Reorderable List")
            .toolbar {
                EditButton()
            }
        }
    }
}

private struct ReorderPreviewItem: Identifiable {
    let id: Int
    let title: String
    let color: Color
}
#endif
