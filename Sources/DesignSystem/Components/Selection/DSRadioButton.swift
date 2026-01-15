import SwiftUI

/// Size variants for the radio button component.
public enum DSRadioButtonSize: CaseIterable, Sendable {
    case small
    case medium
    case large

    var outerSize: CGFloat {
        switch self {
        case .small: return 18
        case .medium: return 22
        case .large: return 26
        }
    }

    var innerSize: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 10
        case .large: return 12
        }
    }

    var font: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .body
        case .large: return .headline
        }
    }
}

/// Position of the label relative to the radio button.
public enum DSRadioButtonLabelPosition: Sendable {
    case leading
    case trailing
}

/// A customizable radio button component for single selection from a set of options.
///
/// Example usage:
/// ```swift
/// enum Gender: String, CaseIterable {
///     case male, female, other
/// }
///
/// @State private var selectedGender: Gender? = nil
///
/// DSRadioButton(
///     value: .male,
///     selection: $selectedGender,
///     label: "Male"
/// )
/// ```
public struct DSRadioButton<Value: Hashable>: View {
    // MARK: - Properties

    private let value: Value
    @Binding private var selection: Value?
    private let label: String?
    private let size: DSRadioButtonSize
    private let labelPosition: DSRadioButtonLabelPosition
    private let isDisabled: Bool
    private let selectedColor: Color
    private let unselectedBorderColor: Color
    private let action: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    private var isSelected: Bool {
        selection == value
    }

    // MARK: - Initializers

    /// Creates a radio button with a value and selection binding.
    /// - Parameters:
    ///   - value: The value this radio button represents
    ///   - selection: Binding to the currently selected value
    ///   - label: Optional text label
    ///   - size: Size variant of the radio button
    ///   - labelPosition: Position of the label relative to the radio button
    ///   - isDisabled: Whether the radio button is disabled
    ///   - selectedColor: Color when selected
    ///   - unselectedBorderColor: Border color when not selected
    ///   - action: Optional action to perform on selection
    public init(
        value: Value,
        selection: Binding<Value?>,
        label: String? = nil,
        size: DSRadioButtonSize = .medium,
        labelPosition: DSRadioButtonLabelPosition = .trailing,
        isDisabled: Bool = false,
        selectedColor: Color = DSColors.selectionChecked,
        unselectedBorderColor: Color = DSColors.selectionBorder,
        action: (() -> Void)? = nil
    ) {
        self.value = value
        self._selection = selection
        self.label = label
        self.size = size
        self.labelPosition = labelPosition
        self.isDisabled = isDisabled
        self.selectedColor = selectedColor
        self.unselectedBorderColor = unselectedBorderColor
        self.action = action
    }

    /// Creates a radio button with a non-optional selection binding.
    /// - Parameters:
    ///   - value: The value this radio button represents
    ///   - selection: Binding to the currently selected value
    ///   - label: Optional text label
    ///   - size: Size variant of the radio button
    ///   - labelPosition: Position of the label relative to the radio button
    ///   - isDisabled: Whether the radio button is disabled
    ///   - selectedColor: Color when selected
    ///   - unselectedBorderColor: Border color when not selected
    ///   - action: Optional action to perform on selection
    public init(
        value: Value,
        selection: Binding<Value>,
        label: String? = nil,
        size: DSRadioButtonSize = .medium,
        labelPosition: DSRadioButtonLabelPosition = .trailing,
        isDisabled: Bool = false,
        selectedColor: Color = DSColors.selectionChecked,
        unselectedBorderColor: Color = DSColors.selectionBorder,
        action: (() -> Void)? = nil
    ) {
        self.value = value
        self._selection = Binding(
            get: { selection.wrappedValue },
            set: { if let newValue = $0 { selection.wrappedValue = newValue } }
        )
        self.label = label
        self.size = size
        self.labelPosition = labelPosition
        self.isDisabled = isDisabled
        self.selectedColor = selectedColor
        self.unselectedBorderColor = unselectedBorderColor
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: select) {
            HStack(spacing: DSSpacing.sm) {
                if labelPosition == .leading, let label {
                    labelView(label)
                }

                radioButtonView

                if labelPosition == .trailing, let label {
                    labelView(label)
                }
            }
            .frame(minHeight: DSTouchTarget.minimum)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(isSelected ? "selected" : "not selected")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(isDisabled ? "Disabled" : "Double tap to select")
    }

    // MARK: - Subviews

    private var radioButtonView: some View {
        ZStack {
            // Outer circle
            Circle()
                .fill(DSColors.selectionUnchecked)
                .frame(width: size.outerSize, height: size.outerSize)

            Circle()
                .strokeBorder(
                    isSelected ? selectedColor : unselectedBorderColor,
                    lineWidth: 2
                )
                .frame(width: size.outerSize, height: size.outerSize)

            // Inner circle (when selected)
            if isSelected {
                Circle()
                    .fill(selectedColor)
                    .frame(width: size.innerSize, height: size.innerSize)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.font)
            .foregroundColor(isDisabled ? DSColors.textDisabled : DSColors.textPrimary)
            .multilineTextAlignment(labelPosition == .leading ? .trailing : .leading)
    }

    // MARK: - Computed Properties

    private var accessibilityLabel: String {
        if let label {
            return label
        }
        return "Radio button"
    }

    // MARK: - Actions

    private func select() {
        withAnimation(.easeInOut(duration: 0.2)) {
            selection = value
        }
        action?()
    }
}

// MARK: - Preview

#if DEBUG
struct DSRadioButton_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonPreviewContainer()
            .previewDisplayName("Radio Button States")
    }
}

private struct RadioButtonPreviewContainer: View {
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }

    @State private var selectedGender: Gender? = .male
    @State private var selectedSize: DSRadioButtonSize? = .medium

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                Group {
                    Text("Basic Radio Buttons")
                        .font(.headline)

                    ForEach(Gender.allCases, id: \.self) { gender in
                        DSRadioButton(
                            value: gender,
                            selection: $selectedGender,
                            label: gender.rawValue
                        )
                    }
                }

                Divider()

                Group {
                    Text("Sizes")
                        .font(.headline)

                    DSRadioButton(
                        value: DSRadioButtonSize.small,
                        selection: $selectedSize,
                        label: "Small",
                        size: .small
                    )
                    DSRadioButton(
                        value: DSRadioButtonSize.medium,
                        selection: $selectedSize,
                        label: "Medium",
                        size: .medium
                    )
                    DSRadioButton(
                        value: DSRadioButtonSize.large,
                        selection: $selectedSize,
                        label: "Large",
                        size: .large
                    )
                }

                Divider()

                Group {
                    Text("Label Position")
                        .font(.headline)

                    DSRadioButton(
                        value: "leading",
                        selection: .constant("leading"),
                        label: "Leading label",
                        labelPosition: .leading
                    )
                    DSRadioButton(
                        value: "trailing",
                        selection: .constant("trailing"),
                        label: "Trailing label",
                        labelPosition: .trailing
                    )
                }

                Divider()

                Group {
                    Text("Disabled State")
                        .font(.headline)

                    DSRadioButton(
                        value: "disabled1",
                        selection: .constant(nil as String?),
                        label: "Disabled unselected",
                        isDisabled: true
                    )
                    DSRadioButton(
                        value: "disabled2",
                        selection: .constant("disabled2"),
                        label: "Disabled selected",
                        isDisabled: true
                    )
                }

                Divider()

                Group {
                    Text("Custom Colors")
                        .font(.headline)

                    DSRadioButton(
                        value: "success",
                        selection: .constant("success"),
                        label: "Success color",
                        selectedColor: DSColors.success
                    )
                    DSRadioButton(
                        value: "error",
                        selection: .constant("error"),
                        label: "Error color",
                        selectedColor: DSColors.error
                    )
                    DSRadioButton(
                        value: "warning",
                        selection: .constant("warning"),
                        label: "Warning color",
                        selectedColor: DSColors.warning
                    )
                }
            }
            .padding()
        }
    }
}
#endif
