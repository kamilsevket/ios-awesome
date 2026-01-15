import SwiftUI

// MARK: - DSWheelPicker

/// An iOS-style wheel picker component for the design system
///
/// DSWheelPicker provides a native wheel-style picker with support for:
/// - Generic type support for any Hashable items
/// - Customizable row height and appearance
/// - Multiple wheel support for multi-column selection
/// - Haptic feedback
/// - Accessibility support
///
/// Example usage:
/// ```swift
/// DSWheelPicker(selection: $selectedItem, items: items) { item in
///     Text(item.name)
/// }
///
/// DSWheelPicker("Select Size", selection: $size, items: sizes) { size in
///     Text(size.displayName)
/// }
/// ```
public struct DSWheelPicker<Item: Hashable, Content: View>: View {
    // MARK: - Properties

    @Binding private var selection: Item
    private let items: [Item]
    private let label: String?
    private let content: (Item) -> Content
    private var size: DSPickerSize
    private var variant: DSPickerVariant
    private var rowHeight: CGFloat?
    private var hapticFeedback: Bool
    private var showsSelectionIndicator: Bool

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a new DSWheelPicker
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
        self.size = .medium
        self.variant = .default
        self.rowHeight = nil
        self.hapticFeedback = true
        self.showsSelectionIndicator = true
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let label = label {
                labelView(label)
            }

            wheelPicker
        }
    }

    // MARK: - Subviews

    private var wheelPicker: some View {
        Picker("", selection: $selection) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .tag(item)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: computedHeight)
        .padding(.horizontal, size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .onChange(of: selection) { _ in
            if hapticFeedback {
                triggerHapticFeedback()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Wheel picker")
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.labelFont)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }

    // MARK: - Computed Properties

    private var computedHeight: CGFloat {
        rowHeight ?? (size.rowHeight * 5)
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if os(iOS)
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
        #endif
    }
}

// MARK: - Modifiers

public extension DSWheelPicker {
    /// Sets the size of the picker
    func pickerSize(_ size: DSPickerSize) -> DSWheelPicker {
        var picker = self
        picker.size = size
        return picker
    }

    /// Sets the visual variant of the picker
    func pickerVariant(_ variant: DSPickerVariant) -> DSWheelPicker {
        var picker = self
        picker.variant = variant
        return picker
    }

    /// Sets a custom row height
    func rowHeight(_ height: CGFloat) -> DSWheelPicker {
        var picker = self
        picker.rowHeight = height
        return picker
    }

    /// Enables or disables haptic feedback
    func hapticFeedback(_ enabled: Bool) -> DSWheelPicker {
        var picker = self
        picker.hapticFeedback = enabled
        return picker
    }

    /// Shows or hides the selection indicator
    func showsSelectionIndicator(_ show: Bool) -> DSWheelPicker {
        var picker = self
        picker.showsSelectionIndicator = show
        return picker
    }
}

// MARK: - Multi-Column Wheel Picker

/// A multi-column wheel picker for selecting multiple values
///
/// Example usage:
/// ```swift
/// DSMultiWheelPicker(
///     selections: [$hour, $minute],
///     columns: [hours, minutes]
/// ) { column, item in
///     Text("\(item)")
/// }
/// ```
public struct DSMultiWheelPicker<Item: Hashable, Content: View>: View {
    // MARK: - Properties

    private let bindings: [Binding<Item>]
    private let columns: [[Item]]
    private let content: (Int, Item) -> Content
    private let label: String?
    private var size: DSPickerSize
    private var variant: DSPickerVariant
    private var hapticFeedback: Bool

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    /// Creates a new DSMultiWheelPicker
    /// - Parameters:
    ///   - label: Optional label text displayed above the picker
    ///   - selections: Array of bindings for each column's selection
    ///   - columns: Array of arrays containing items for each column
    ///   - content: ViewBuilder closure to render each item (receives column index and item)
    public init(
        _ label: String? = nil,
        selections: [Binding<Item>],
        columns: [[Item]],
        @ViewBuilder content: @escaping (Int, Item) -> Content
    ) {
        self.label = label
        self.bindings = selections
        self.columns = columns
        self.content = content
        self.size = .medium
        self.variant = .default
        self.hapticFeedback = true
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xs) {
            if let label = label {
                labelView(label)
            }

            multiWheelContent
        }
    }

    // MARK: - Subviews

    private var multiWheelContent: some View {
        HStack(spacing: 0) {
            ForEach(0..<columns.count, id: \.self) { columnIndex in
                if columnIndex < bindings.count {
                    Picker("", selection: bindings[columnIndex]) {
                        ForEach(columns[columnIndex], id: \.self) { item in
                            content(columnIndex, item)
                                .tag(item)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .onChange(of: bindings[columnIndex].wrappedValue) { _ in
                        if hapticFeedback {
                            triggerHapticFeedback()
                        }
                    }
                }
            }
        }
        .frame(height: size.rowHeight * 5)
        .padding(.horizontal, size.horizontalPadding)
        .background(variant.backgroundColor(for: colorScheme))
        .cornerRadius(size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(variant.borderColor(for: colorScheme), lineWidth: variant.borderWidth)
        )
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(label ?? "Multi-column picker")
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.labelFont)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }

    // MARK: - Haptic Feedback

    private func triggerHapticFeedback() {
        #if os(iOS)
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
        #endif
    }
}

// MARK: - Modifiers for DSMultiWheelPicker

public extension DSMultiWheelPicker {
    /// Sets the size of the picker
    func pickerSize(_ size: DSPickerSize) -> DSMultiWheelPicker {
        var picker = self
        picker.size = size
        return picker
    }

    /// Sets the visual variant of the picker
    func pickerVariant(_ variant: DSPickerVariant) -> DSMultiWheelPicker {
        var picker = self
        picker.variant = variant
        return picker
    }

    /// Enables or disables haptic feedback
    func hapticFeedback(_ enabled: Bool) -> DSMultiWheelPicker {
        var picker = self
        picker.hapticFeedback = enabled
        return picker
    }
}

// MARK: - Preview Provider

#if DEBUG
struct DSWheelPicker_Previews: PreviewProvider {
    static let numbers = Array(1...20)
    static let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
    static let hours = Array(0...23)
    static let minutes = Array(0...59)

    static var previews: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Basic wheel picker
                WheelPickerPreviewSection(title: "Basic Wheel Picker") {
                    WheelStatefulPreview(fruits[0]) { $selection in
                        DSWheelPicker("Select Fruit", selection: $selection, items: fruits) { item in
                            Text(item)
                        }
                    }
                }

                // Variants
                WheelPickerPreviewSection(title: "Variants") {
                    VStack(spacing: 16) {
                        WheelStatefulPreview(numbers[0]) { $selection in
                            DSWheelPicker("Default", selection: $selection, items: numbers) { item in
                                Text("\(item)")
                            }
                            .pickerVariant(.default)
                        }

                        WheelStatefulPreview(numbers[0]) { $selection in
                            DSWheelPicker("Outlined", selection: $selection, items: numbers) { item in
                                Text("\(item)")
                            }
                            .pickerVariant(.outlined)
                        }

                        WheelStatefulPreview(numbers[0]) { $selection in
                            DSWheelPicker("Filled", selection: $selection, items: numbers) { item in
                                Text("\(item)")
                            }
                            .pickerVariant(.filled)
                        }
                    }
                }

                // Multi-wheel picker
                WheelPickerPreviewSection(title: "Multi-Column Picker (Time)") {
                    MultiWheelStatefulPreview(hour: 10, minute: 30) { $hour, $minute in
                        DSMultiWheelPicker(
                            "Select Time",
                            selections: [$hour, $minute],
                            columns: [hours, minutes]
                        ) { column, item in
                            if column == 0 {
                                Text(String(format: "%02d", item))
                            } else {
                                Text(String(format: "%02d", item))
                            }
                        }
                        .pickerVariant(.outlined)
                    }
                }

                // Disabled
                WheelPickerPreviewSection(title: "Disabled") {
                    WheelStatefulPreview(fruits[0]) { $selection in
                        DSWheelPicker("Disabled", selection: $selection, items: fruits) { item in
                            Text(item)
                        }
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
                WheelPickerPreviewSection(title: "Dark Mode") {
                    VStack(spacing: 16) {
                        WheelStatefulPreview(fruits[0]) { $selection in
                            DSWheelPicker("Outlined", selection: $selection, items: fruits) { item in
                                Text(item)
                            }
                            .pickerVariant(.outlined)
                        }

                        WheelStatefulPreview(numbers[0]) { $selection in
                            DSWheelPicker("Filled", selection: $selection, items: numbers) { item in
                                Text("\(item)")
                            }
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

private struct WheelPickerPreviewSection<Content: View>: View {
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

private struct WheelStatefulPreview<Value, Content: View>: View {
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

private struct MultiWheelStatefulPreview<Content: View>: View {
    @State private var hour: Int
    @State private var minute: Int
    let content: (Binding<Int>, Binding<Int>) -> Content

    init(hour: Int, minute: Int, @ViewBuilder content: @escaping (Binding<Int>, Binding<Int>) -> Content) {
        self._hour = State(initialValue: hour)
        self._minute = State(initialValue: minute)
        self.content = content
    }

    var body: some View {
        content($hour, $minute)
    }
}
#endif
