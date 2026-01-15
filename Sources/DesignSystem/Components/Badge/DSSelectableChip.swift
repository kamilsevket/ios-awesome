import SwiftUI

/// A selectable chip component for multi-selection scenarios
///
/// Use `DSSelectableChip` when users can select multiple options.
///
/// ```swift
/// DSSelectableChip("Swift", isSelected: $swiftSelected)
/// DSSelectableChip("iOS", isSelected: $iosSelected, onDismiss: { })
/// ```
public struct DSSelectableChip: View {
    // MARK: - Properties

    private let text: String
    private let icon: Image?
    private let size: DSChipSize
    private let onDismiss: (() -> Void)?

    @Binding private var isSelected: Bool
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a selectable chip
    /// - Parameters:
    ///   - text: The text to display
    ///   - icon: Optional leading icon
    ///   - size: The size variant (default: .md)
    ///   - isSelected: Binding to the selection state
    ///   - onDismiss: Optional closure called when dismiss button is tapped
    public init(
        _ text: String,
        icon: Image? = nil,
        size: DSChipSize = .md,
        isSelected: Binding<Bool>,
        onDismiss: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.size = size
        self._isSelected = isSelected
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    public var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isSelected.toggle()
            }
        } label: {
            HStack(spacing: DSSpacing.xs) {
                selectionIndicator

                if let icon = icon {
                    icon
                        .font(size.iconFont)
                        .foregroundColor(foregroundColor)
                }

                Text(text)
                    .font(size.font)
                    .fontWeight(.medium)
                    .foregroundColor(foregroundColor)
                    .lineLimit(1)

                if let onDismiss = onDismiss {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(foregroundColor.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Remove \(text)")
                }
            }
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .frame(minHeight: DSSpacing.minTouchTarget)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
            .overlay(
                Capsule()
                    .strokeBorder(borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityLabel("\(text), \(isSelected ? "selected" : "not selected")")
    }

    // MARK: - Private Views

    @ViewBuilder
    private var selectionIndicator: some View {
        ZStack {
            Circle()
                .strokeBorder(isSelected ? DSColors.primary : borderColor, lineWidth: isSelected ? 0 : 1.5)
                .frame(width: 18, height: 18)

            if isSelected {
                Circle()
                    .fill(DSColors.primary)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    // MARK: - Computed Properties

    private var backgroundColor: Color {
        if isSelected {
            return DSColors.primary.opacity(0.08)
        }
        return colorScheme == .dark ? DSColors.chipBackgroundDark : DSColors.chipBackground
    }

    private var foregroundColor: Color {
        if isSelected {
            return DSColors.primary
        }
        return colorScheme == .dark ? DSColors.chipTextDark : DSColors.chipText
    }

    private var borderColor: Color {
        if isSelected {
            return DSColors.primary.opacity(0.3)
        }
        return Color.primary.opacity(0.15)
    }
}

// MARK: - Multi-Select Helper

/// A container for managing multiple selectable chips
public struct DSSelectableChipGroup<Item: Hashable>: View {
    private let items: [Item]
    private let labelKeyPath: KeyPath<Item, String>
    @Binding private var selection: Set<Item>

    public init(
        items: [Item],
        labelKeyPath: KeyPath<Item, String>,
        selection: Binding<Set<Item>>
    ) {
        self.items = items
        self.labelKeyPath = labelKeyPath
        self._selection = selection
    }

    public var body: some View {
        FlowLayout(spacing: DSSpacing.sm) {
            ForEach(items, id: \.self) { item in
                DSSelectableChip(
                    item[keyPath: labelKeyPath],
                    isSelected: Binding(
                        get: { selection.contains(item) },
                        set: { isSelected in
                            if isSelected {
                                selection.insert(item)
                            } else {
                                selection.remove(item)
                            }
                        }
                    )
                )
            }
        }
    }
}

// MARK: - Flow Layout

/// A simple flow layout that wraps items to the next line
public struct FlowLayout: Layout {
    var spacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)

        for (index, subview) in subviews.enumerated() {
            let point = result.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)

            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }

            positions.append(CGPoint(x: currentX, y: currentY))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
            totalWidth = max(totalWidth, currentX - spacing)
            totalHeight = currentY + lineHeight
        }

        return (CGSize(width: totalWidth, height: totalHeight), positions)
    }
}

// MARK: - Preview

#if DEBUG
struct DSSelectableChip_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selections: [String: Bool] = [
            "Swift": true,
            "Objective-C": false,
            "Python": true,
            "JavaScript": false,
            "Rust": false,
            "Go": false
        ]

        var body: some View {
            VStack(spacing: 24) {
                Group {
                    Text("Multi Selection")
                        .font(.headline)
                    FlowLayout(spacing: 8) {
                        ForEach(Array(selections.keys.sorted()), id: \.self) { key in
                            DSSelectableChip(key, isSelected: binding(for: key))
                        }
                    }
                }

                Group {
                    Text("With Icons")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSSelectableChip("Photos", icon: Image(systemName: "photo"), isSelected: .constant(true))
                        DSSelectableChip("Videos", icon: Image(systemName: "video"), isSelected: .constant(false))
                    }
                }

                Group {
                    Text("With Dismiss")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSSelectableChip("Removable", isSelected: .constant(true)) { }
                        DSSelectableChip("Also Removable", isSelected: .constant(false)) { }
                    }
                }

                Group {
                    Text("Size Variants")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSSelectableChip("Small", size: .sm, isSelected: .constant(true))
                        DSSelectableChip("Medium", size: .md, isSelected: .constant(true))
                    }
                }

                Group {
                    Text("Disabled State")
                        .font(.headline)
                    HStack(spacing: 8) {
                        DSSelectableChip("Disabled", isSelected: .constant(false))
                            .disabled(true)
                        DSSelectableChip("Disabled Selected", isSelected: .constant(true))
                            .disabled(true)
                    }
                }
            }
            .padding()
        }

        private func binding(for key: String) -> Binding<Bool> {
            Binding(
                get: { selections[key] ?? false },
                set: { selections[key] = $0 }
            )
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .previewDisplayName("DSSelectableChip")
    }
}
#endif
