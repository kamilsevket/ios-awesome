import SwiftUI

// MARK: - DSCustomPicker

/// A generic picker component for the design system
///
/// DSCustomPicker provides a consistent picker implementation for custom item selection with support for:
/// - Generic type support for any Hashable, Identifiable items
/// - Multiple display modes (menu, navigation link, inline)
/// - Custom item rendering
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSCustomPicker("Select Option", selection: $selectedItem, items: items) { item in
///     Text(item.name)
/// }
///
/// DSCustomPicker(selection: $selectedItem, items: items) { item in
///     HStack {
///         Image(systemName: item.icon)
///         Text(item.name)
///     }
/// }
/// ```
public struct DSCustomPicker<Item: Hashable & Identifiable, Content: View>: View {
    // MARK: - Properties

    @Binding private var selection: Item
    private let items: [Item]
    private let label: String?
    private let content: (Item) -> Content
    private var displayMode: CustomPickerDisplayMode
    private var size: DSPickerSize
    private var variant: DSPickerVariant
    private var placeholder: String

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a new DSCustomPicker
    /// - Parameters:
    ///   - label: Optional label text displayed above the picker
    ///   - selection: Binding to the selected item
    ///   - items: Array of items to choose from
    ///   - content: ViewBuilder closure to render each item
    public init(
        _ label: String? = nil,
        selection: Binding<Item>,
        items: [Item],
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.label = label
        self._selection = selection
        self.items = items
        self.content = content
        self.displayMode = .menu
        self.size = .medium
        self.variant = .default
        self.placeholder = "Select..."
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let label = label {
                labelView(label)
            }

            pickerContent
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var pickerContent: some View {
        Group {
            switch displayMode {
            case .menu:
                menuPicker
            case .segmented:
                segmentedPicker
            case .inline:
                inlinePicker
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }

    private var menuPicker: some View {
        Menu {
            ForEach(items) { item in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = item
                    }
                } label: {
                    HStack {
                        content(item)
                        if item == selection {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                content(selection)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            .font(size.font)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .background(variant.backgroundColor(for: colorScheme))
            .cornerRadius(size.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
            )
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? "Picker")
        .accessibilityHint("Double tap to select an option")
    }

    private var segmentedPicker: some View {
        Picker("", selection: $selection) {
            ForEach(items) { item in
                content(item)
                    .tag(item)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel(label ?? "Segmented picker")
    }

    private var inlinePicker: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = item
                        triggerHapticFeedback()
                    }
                } label: {
                    HStack {
                        content(item)
                        Spacer()
                        if item == selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(DSColors.primary)
                                .font(.body.weight(.semibold))
                        }
                    }
                    .font(size.font)
                    .padding(.vertical, size.verticalPadding)
                    .padding(.horizontal, size.horizontalPadding)
                    .background(item == selection ? DSColors.primary.opacity(0.1) : Color.clear)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                if index < items.count - 1 {
                    Divider()
                        .padding(.leading, size.horizontalPadding)
                }
            }
        }
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Inline picker")
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.labelFont)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if os(iOS)
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        #endif
    }
}

// MARK: - Custom Picker Display Mode

/// Display modes for custom picker
public enum CustomPickerDisplayMode {
    /// Menu-style dropdown picker
    case menu
    /// Segmented control style
    case segmented
    /// Inline list style
    case inline
}

// MARK: - Modifiers

public extension DSCustomPicker {
    /// Sets the display mode for the picker
    func displayMode(_ mode: CustomPickerDisplayMode) -> DSCustomPicker {
        var picker = self
        picker.displayMode = mode
        return picker
    }

    /// Sets the size of the picker
    func pickerSize(_ size: DSPickerSize) -> DSCustomPicker {
        var picker = self
        picker.size = size
        return picker
    }

    /// Sets the visual variant of the picker
    func pickerVariant(_ variant: DSPickerVariant) -> DSCustomPicker {
        var picker = self
        picker.variant = variant
        return picker
    }

    /// Sets the placeholder text for the picker
    func placeholder(_ text: String) -> DSCustomPicker {
        var picker = self
        picker.placeholder = text
        return picker
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSCustomPicker_Previews: PreviewProvider {
    // Sample data
    struct SampleItem: Hashable, Identifiable {
        let id: String
        let name: String
        let icon: String
    }

    static let sampleItems = [
        SampleItem(id: "1", name: "Option 1", icon: "star"),
        SampleItem(id: "2", name: "Option 2", icon: "heart"),
        SampleItem(id: "3", name: "Option 3", icon: "moon"),
        SampleItem(id: "4", name: "Option 4", icon: "sun.max"),
    ]

    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Menu mode
                CustomPickerPreviewSection(title: "Menu Mode") {
                    StatefulPreview(sampleItems[0]) { $selection in
                        DSCustomPicker("Select Option", selection: $selection, items: sampleItems) { item in
                            HStack {
                                Image(systemName: item.icon)
                                Text(item.name)
                            }
                        }
                        .displayMode(.menu)
                        .pickerVariant(.outlined)
                    }
                }

                // Segmented mode
                CustomPickerPreviewSection(title: "Segmented Mode") {
                    StatefulPreview(sampleItems[0]) { $selection in
                        DSCustomPicker("Select Option", selection: $selection, items: sampleItems) { item in
                            Text(item.name)
                        }
                        .displayMode(.segmented)
                    }
                }

                // Inline mode
                CustomPickerPreviewSection(title: "Inline Mode") {
                    StatefulPreview(sampleItems[0]) { $selection in
                        DSCustomPicker("Select Option", selection: $selection, items: sampleItems) { item in
                            HStack {
                                Image(systemName: item.icon)
                                    .foregroundColor(DSColors.primary)
                                Text(item.name)
                            }
                        }
                        .displayMode(.inline)
                        .pickerVariant(.outlined)
                    }
                }

                // Variants
                CustomPickerPreviewSection(title: "Variants") {
                    VStack(spacing: 16) {
                        StatefulPreview(sampleItems[0]) { $selection in
                            DSCustomPicker("Default", selection: $selection, items: sampleItems) { item in
                                Text(item.name)
                            }
                            .displayMode(.menu)
                            .pickerVariant(.default)
                        }

                        StatefulPreview(sampleItems[0]) { $selection in
                            DSCustomPicker("Outlined", selection: $selection, items: sampleItems) { item in
                                Text(item.name)
                            }
                            .displayMode(.menu)
                            .pickerVariant(.outlined)
                        }

                        StatefulPreview(sampleItems[0]) { $selection in
                            DSCustomPicker("Filled", selection: $selection, items: sampleItems) { item in
                                Text(item.name)
                            }
                            .displayMode(.menu)
                            .pickerVariant(.filled)
                        }
                    }
                }

                // Disabled
                CustomPickerPreviewSection(title: "Disabled") {
                    StatefulPreview(sampleItems[0]) { $selection in
                        DSCustomPicker("Disabled", selection: $selection, items: sampleItems) { item in
                            Text(item.name)
                        }
                        .displayMode(.menu)
                        .pickerVariant(.outlined)
                        .disabled(true)
                    }
                }
            }
            .padding()
        }
        .previewDisplayName("Light Mode")

        ScrollView {
            VStack(spacing: 32) {
                CustomPickerPreviewSection(title: "Dark Mode") {
                    VStack(spacing: 16) {
                        StatefulPreview(sampleItems[0]) { $selection in
                            DSCustomPicker("Menu", selection: $selection, items: sampleItems) { item in
                                Text(item.name)
                            }
                            .displayMode(.menu)
                            .pickerVariant(.outlined)
                        }

                        StatefulPreview(sampleItems[0]) { $selection in
                            DSCustomPicker("Inline", selection: $selection, items: sampleItems) { item in
                                HStack {
                                    Image(systemName: item.icon)
                                    Text(item.name)
                                }
                            }
                            .displayMode(.inline)
                            .pickerVariant(.filled)
                        }
                    }
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}

private struct CustomPickerPreviewSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct StatefulPreview<Value, Content: View>: View {
    @State private var value: Value
    let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
#endif
