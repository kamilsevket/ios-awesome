import SwiftUI

/// A multi-select component that allows selecting multiple options with chip display
///
/// Example usage:
/// ```swift
/// @State private var selectedTags: Set<String> = []
///
/// DSMultiSelect(
///     selections: $selectedTags,
///     options: ["Swift", "iOS", "SwiftUI", "Combine"]
/// )
/// .searchable()
/// .placeholder("Select tags")
/// ```
public struct DSMultiSelect<Option: DSSelectOption>: View {
    // MARK: - Properties

    @Binding private var selections: Set<Option>
    private let options: [Option]
    private var placeholder: String = "Select options"
    private var label: String?
    private var helperText: String?
    private var errorMessage: String?
    private var isSearchable: Bool = false
    private var isDisabled: Bool = false
    private var maxDisplayedChips: Int = 3

    @State private var isExpanded = false
    @State private var searchText = ""
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    /// Creates a multi-select component
    /// - Parameters:
    ///   - selections: Binding to the set of selected options
    ///   - options: Array of available options
    public init(
        selections: Binding<Set<Option>>,
        options: [Option]
    ) {
        self._selections = selections
        self.options = options
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            // Label
            if let label = label {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(labelColor)
            }

            // Multi-select field
            VStack(spacing: 0) {
                selectFieldButton

                if isExpanded {
                    dropdownContent
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            // Helper/Error text
            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(DSColors.error)
            } else if let helper = helperText {
                Text(helper)
                    .font(.caption)
                    .foregroundColor(DSColors.textSecondary)
            }
        }
        .opacity(isDisabled ? 0.6 : 1.0)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Subviews

    private var selectFieldButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            selectFieldContent
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    private var selectFieldContent: some View {
        HStack(spacing: Spacing.sm) {
            if selections.isEmpty {
                Text(placeholder)
                    .foregroundColor(DSColors.textTertiary)
            } else {
                chipsDisplay
            }

            Spacer(minLength: Spacing.xs)

            if !selections.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selections.removeAll()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(DSColors.textTertiary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear all selections")
            }

            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(.caption)
                .foregroundColor(DSColors.textSecondary)
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .frame(minHeight: DSSpacing.minTouchTarget)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var chipsDisplay: some View {
        let displayedSelections = Array(selections.prefix(maxDisplayedChips))
        let remainingCount = selections.count - maxDisplayedChips

        FlowLayout(spacing: Spacing.xs) {
            ForEach(displayedSelections) { option in
                DSMultiSelectChip(
                    text: option.displayText,
                    onRemove: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selections.remove(option)
                        }
                    }
                )
            }

            if remainingCount > 0 {
                Text("+\(remainingCount)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(DSColors.textSecondary)
                    .padding(.horizontal, Spacing.sm)
                    .padding(.vertical, Spacing.xs)
                    .background(
                        Capsule()
                            .fill(DSColors.backgroundSecondary)
                    )
            }
        }
    }

    private var dropdownContent: some View {
        VStack(spacing: 0) {
            // Search field
            if isSearchable {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(DSColors.textTertiary)
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal, Spacing.md)
                .padding(.vertical, Spacing.sm)
                .background(DSColors.backgroundSecondary)

                Divider()
            }

            // Options list
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredOptions) { option in
                        optionRow(for: option)

                        if option.id != filteredOptions.last?.id {
                            Divider()
                                .padding(.horizontal, Spacing.sm)
                        }
                    }
                }
            }
            .frame(maxHeight: 250)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark ? DSColors.backgroundSecondary : DSColors.backgroundPrimary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(DSColors.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    private func optionRow(for option: Option) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                if selections.contains(option) {
                    selections.remove(option)
                } else {
                    selections.insert(option)
                }
            }
        } label: {
            HStack {
                // Checkbox indicator
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            selections.contains(option) ? DSColors.primary : DSColors.border,
                            lineWidth: selections.contains(option) ? 0 : 1.5
                        )
                        .frame(width: 20, height: 20)

                    if selections.contains(option) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(DSColors.primary)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                }

                Text(option.displayText)
                    .foregroundColor(DSColors.textPrimary)

                Spacer()
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selections.contains(option) ? [.isSelected] : [])
        .accessibilityLabel("\(option.displayText), \(selections.contains(option) ? "selected" : "not selected")")
    }

    // MARK: - Computed Properties

    private var filteredOptions: [Option] {
        if searchText.isEmpty {
            return options
        }
        return options.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var labelColor: Color {
        if errorMessage != nil {
            return DSColors.error
        }
        return DSColors.textSecondary
    }

    private var borderColor: Color {
        if errorMessage != nil {
            return DSColors.error
        }
        if isExpanded {
            return DSColors.primary
        }
        return DSColors.border
    }

    private var accessibilityLabel: String {
        var result = label ?? "Multi-select"
        if !selections.isEmpty {
            result += ", \(selections.count) selected"
        }
        if let error = errorMessage {
            result += ", error: \(error)"
        }
        return result
    }
}

// MARK: - Multi-Select Chip

/// A small chip for displaying selected items in multi-select
public struct DSMultiSelectChip: View {
    let text: String
    let onRemove: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        HStack(spacing: Spacing.xs) {
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(DSColors.primary)
                .lineLimit(1)

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(DSColors.primary.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(
            Capsule()
                .fill(DSColors.primary.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(text)
        .accessibilityHint("Double tap to remove")
    }
}

// MARK: - Modifiers

public extension DSMultiSelect {
    /// Sets the placeholder text
    func placeholder(_ text: String) -> DSMultiSelect {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Sets the label text
    func label(_ text: String) -> DSMultiSelect {
        var copy = self
        copy.label = text
        return copy
    }

    /// Sets the helper text
    func helperText(_ text: String) -> DSMultiSelect {
        var copy = self
        copy.helperText = text
        return copy
    }

    /// Sets the error message
    func errorMessage(_ message: String?) -> DSMultiSelect {
        var copy = self
        copy.errorMessage = message
        return copy
    }

    /// Enables search functionality
    func searchable(_ searchable: Bool = true) -> DSMultiSelect {
        var copy = self
        copy.isSearchable = searchable
        return copy
    }

    /// Sets whether the component is disabled
    func disabled(_ disabled: Bool) -> DSMultiSelect {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }

    /// Sets the maximum number of chips to display
    func maxDisplayedChips(_ count: Int) -> DSMultiSelect {
        var copy = self
        copy.maxDisplayedChips = count
        return copy
    }
}

// MARK: - String Array Convenience

public extension DSMultiSelect where Option == DSSelectStringOption {
    /// Creates a multi-select with string options
    init(
        selections: Binding<Set<String>>,
        options: [String]
    ) {
        let stringOptions = options.map { DSSelectStringOption($0) }
        let optionBinding = Binding<Set<DSSelectStringOption>>(
            get: {
                Set(selections.wrappedValue.map { DSSelectStringOption($0) })
            },
            set: { newValue in
                selections.wrappedValue = Set(newValue.map { $0.displayText })
            }
        )
        self.init(selections: optionBinding, options: stringOptions)
    }
}

// MARK: - Preview

#if DEBUG
struct DSMultiSelect_Previews: PreviewProvider {
    struct Tag: DSSelectOption, Hashable {
        let id: String
        let displayText: String

        init(_ name: String) {
            self.id = name
            self.displayText = name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    struct PreviewWrapper: View {
        @State private var selectedTags: Set<Tag> = [Tag("Swift"), Tag("iOS")]
        @State private var selectedStrings: Set<String> = ["Apple", "Banana"]
        @State private var emptySelection: Set<String> = []

        let tags = [
            Tag("Swift"), Tag("iOS"), Tag("SwiftUI"), Tag("Combine"),
            Tag("UIKit"), Tag("Foundation"), Tag("CoreData"), Tag("CloudKit")
        ]
        let fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"]

        var body: some View {
            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Group {
                        Text("Basic Multi-Select")
                            .font(.headline)

                        DSMultiSelect(selections: $selectedStrings, options: fruits)
                            .placeholder("Select fruits")
                            .label("Favorite Fruits")
                    }

                    Divider()

                    Group {
                        Text("Searchable Multi-Select")
                            .font(.headline)

                        DSMultiSelect(selections: $selectedTags, options: tags)
                            .placeholder("Select tags")
                            .label("Tags")
                            .searchable()
                            .helperText("Search and select multiple tags")
                    }

                    Divider()

                    Group {
                        Text("Empty State")
                            .font(.headline)

                        DSMultiSelect(selections: $emptySelection, options: fruits)
                            .placeholder("No items selected")
                            .label("Empty Select")
                    }

                    Divider()

                    Group {
                        Text("With Error")
                            .font(.headline)

                        DSMultiSelect(selections: $emptySelection, options: fruits)
                            .placeholder("Select at least one")
                            .label("Required Field")
                            .errorMessage("At least one selection is required")
                    }

                    Divider()

                    Group {
                        Text("Disabled State")
                            .font(.headline)

                        DSMultiSelect(selections: $selectedStrings, options: fruits)
                            .placeholder("Disabled")
                            .disabled(true)
                    }

                    Divider()

                    Group {
                        Text("Many Selections")
                            .font(.headline)

                        DSMultiSelect(
                            selections: .constant(Set(fruits.map { $0 })),
                            options: fruits
                        )
                        .placeholder("All selected")
                        .maxDisplayedChips(2)
                    }
                }
                .padding()
            }
        }
    }

    static var previews: some View {
        PreviewWrapper()
            .previewDisplayName("DSMultiSelect")
    }
}
#endif
