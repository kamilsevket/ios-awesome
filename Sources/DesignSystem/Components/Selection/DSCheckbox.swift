import SwiftUI

/// The state of a checkbox, supporting checked, unchecked, and indeterminate states.
public enum DSCheckboxState: Equatable, Sendable {
    case unchecked
    case checked
    case indeterminate
}

/// Size variants for the checkbox component.
public enum DSCheckboxSize: CaseIterable, Sendable {
    case small
    case medium
    case large

    var boxSize: CGFloat {
        switch self {
        case .small: return 18
        case .medium: return 22
        case .large: return 26
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 14
        case .large: return 18
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 5
        case .large: return 6
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

/// Position of the label relative to the checkbox.
public enum DSCheckboxLabelPosition: Sendable {
    case leading
    case trailing
}

/// A customizable checkbox component with support for checked, unchecked, and indeterminate states.
///
/// Example usage:
/// ```swift
/// @State private var isChecked = false
///
/// DSCheckbox(isChecked: $isChecked, label: "I agree to the terms")
///
/// // With indeterminate state
/// @State private var state: DSCheckboxState = .indeterminate
///
/// DSCheckbox(state: $state, label: "Select all")
/// ```
public struct DSCheckbox: View {
    // MARK: - Properties

    @Binding private var state: DSCheckboxState
    private let label: String?
    private let size: DSCheckboxSize
    private let labelPosition: DSCheckboxLabelPosition
    private let isDisabled: Bool
    private let checkedColor: Color
    private let uncheckedBorderColor: Color
    private let action: (() -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initializers

    /// Creates a checkbox with a boolean binding (checked/unchecked only).
    /// - Parameters:
    ///   - isChecked: Binding to the checked state
    ///   - label: Optional text label
    ///   - size: Size variant of the checkbox
    ///   - labelPosition: Position of the label relative to the checkbox
    ///   - isDisabled: Whether the checkbox is disabled
    ///   - checkedColor: Color when checked
    ///   - uncheckedBorderColor: Border color when unchecked
    ///   - action: Optional action to perform on state change
    public init(
        isChecked: Binding<Bool>,
        label: String? = nil,
        size: DSCheckboxSize = .medium,
        labelPosition: DSCheckboxLabelPosition = .trailing,
        isDisabled: Bool = false,
        checkedColor: Color = DSColors.selectionChecked,
        uncheckedBorderColor: Color = DSColors.selectionBorder,
        action: (() -> Void)? = nil
    ) {
        self._state = Binding(
            get: { isChecked.wrappedValue ? .checked : .unchecked },
            set: { isChecked.wrappedValue = $0 == .checked }
        )
        self.label = label
        self.size = size
        self.labelPosition = labelPosition
        self.isDisabled = isDisabled
        self.checkedColor = checkedColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.action = action
    }

    /// Creates a checkbox with a tri-state binding (checked/unchecked/indeterminate).
    /// - Parameters:
    ///   - state: Binding to the checkbox state
    ///   - label: Optional text label
    ///   - size: Size variant of the checkbox
    ///   - labelPosition: Position of the label relative to the checkbox
    ///   - isDisabled: Whether the checkbox is disabled
    ///   - checkedColor: Color when checked or indeterminate
    ///   - uncheckedBorderColor: Border color when unchecked
    ///   - action: Optional action to perform on state change
    public init(
        state: Binding<DSCheckboxState>,
        label: String? = nil,
        size: DSCheckboxSize = .medium,
        labelPosition: DSCheckboxLabelPosition = .trailing,
        isDisabled: Bool = false,
        checkedColor: Color = DSColors.selectionChecked,
        uncheckedBorderColor: Color = DSColors.selectionBorder,
        action: (() -> Void)? = nil
    ) {
        self._state = state
        self.label = label
        self.size = size
        self.labelPosition = labelPosition
        self.isDisabled = isDisabled
        self.checkedColor = checkedColor
        self.uncheckedBorderColor = uncheckedBorderColor
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: toggle) {
            HStack(spacing: DSSpacing.sm) {
                if labelPosition == .leading, let label {
                    labelView(label)
                }

                checkboxView

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
        .accessibilityValue(accessibilityValue)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(isDisabled ? "Disabled" : "Double tap to toggle")
    }

    // MARK: - Subviews

    private var checkboxView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(checkboxBackgroundColor)
                .frame(width: size.boxSize, height: size.boxSize)

            RoundedRectangle(cornerRadius: size.cornerRadius)
                .strokeBorder(checkboxBorderColor, lineWidth: state == .unchecked ? 2 : 0)
                .frame(width: size.boxSize, height: size.boxSize)

            checkmarkView
        }
        .animation(.easeInOut(duration: 0.2), value: state)
    }

    @ViewBuilder
    private var checkmarkView: some View {
        switch state {
        case .checked:
            Image(systemName: "checkmark")
                .font(.system(size: size.iconSize, weight: .bold))
                .foregroundColor(.white)
                .transition(.scale.combined(with: .opacity))

        case .indeterminate:
            RoundedRectangle(cornerRadius: 1)
                .fill(Color.white)
                .frame(width: size.iconSize, height: 2)
                .transition(.scale.combined(with: .opacity))

        case .unchecked:
            EmptyView()
        }
    }

    private func labelView(_ text: String) -> some View {
        Text(text)
            .font(size.font)
            .foregroundColor(isDisabled ? DSColors.textDisabled : DSColors.textPrimary)
            .multilineTextAlignment(labelPosition == .leading ? .trailing : .leading)
    }

    // MARK: - Computed Properties

    private var checkboxBackgroundColor: Color {
        switch state {
        case .unchecked:
            return DSColors.selectionUnchecked
        case .checked, .indeterminate:
            return checkedColor
        }
    }

    private var checkboxBorderColor: Color {
        state == .unchecked ? uncheckedBorderColor : .clear
    }

    private var accessibilityLabel: String {
        if let label {
            return label
        }
        return "Checkbox"
    }

    private var accessibilityValue: String {
        switch state {
        case .unchecked:
            return "unchecked"
        case .checked:
            return "checked"
        case .indeterminate:
            return "mixed"
        }
    }

    // MARK: - Actions

    private func toggle() {
        withAnimation(.easeInOut(duration: 0.2)) {
            switch state {
            case .unchecked, .indeterminate:
                state = .checked
            case .checked:
                state = .unchecked
            }
        }
        action?()
    }
}

// MARK: - Preview

#if DEBUG
struct DSCheckbox_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxPreviewContainer()
            .previewDisplayName("Checkbox States")
    }
}

private struct CheckboxPreviewContainer: View {
    @State private var isChecked1 = false
    @State private var isChecked2 = true
    @State private var state1: DSCheckboxState = .unchecked
    @State private var state2: DSCheckboxState = .checked
    @State private var state3: DSCheckboxState = .indeterminate

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                Group {
                    Text("Basic Checkbox")
                        .font(.headline)

                    DSCheckbox(isChecked: $isChecked1, label: "Unchecked checkbox")
                    DSCheckbox(isChecked: $isChecked2, label: "Checked checkbox")
                }

                Divider()

                Group {
                    Text("Tri-State Checkbox")
                        .font(.headline)

                    DSCheckbox(state: $state1, label: "Unchecked")
                    DSCheckbox(state: $state2, label: "Checked")
                    DSCheckbox(state: $state3, label: "Indeterminate")
                }

                Divider()

                Group {
                    Text("Sizes")
                        .font(.headline)

                    DSCheckbox(isChecked: .constant(true), label: "Small", size: .small)
                    DSCheckbox(isChecked: .constant(true), label: "Medium", size: .medium)
                    DSCheckbox(isChecked: .constant(true), label: "Large", size: .large)
                }

                Divider()

                Group {
                    Text("Label Position")
                        .font(.headline)

                    DSCheckbox(isChecked: .constant(true), label: "Leading label", labelPosition: .leading)
                    DSCheckbox(isChecked: .constant(true), label: "Trailing label", labelPosition: .trailing)
                }

                Divider()

                Group {
                    Text("Disabled State")
                        .font(.headline)

                    DSCheckbox(isChecked: .constant(false), label: "Disabled unchecked", isDisabled: true)
                    DSCheckbox(isChecked: .constant(true), label: "Disabled checked", isDisabled: true)
                }

                Divider()

                Group {
                    Text("Custom Colors")
                        .font(.headline)

                    DSCheckbox(
                        isChecked: .constant(true),
                        label: "Success color",
                        checkedColor: DSColors.success
                    )
                    DSCheckbox(
                        isChecked: .constant(true),
                        label: "Error color",
                        checkedColor: DSColors.error
                    )
                    DSCheckbox(
                        isChecked: .constant(true),
                        label: "Warning color",
                        checkedColor: DSColors.warning
                    )
                }
            }
            .padding()
        }
    }
}
#endif
