import SwiftUI

/// Layout orientation for the radio group.
public enum DSRadioGroupAxis: Sendable {
    case horizontal
    case vertical
}

/// A container component that manages a group of radio buttons with single selection.
///
/// Example usage:
/// ```swift
/// enum PaymentMethod: String, CaseIterable {
///     case creditCard = "Credit Card"
///     case paypal = "PayPal"
///     case applePay = "Apple Pay"
/// }
///
/// @State private var selectedMethod: PaymentMethod = .creditCard
///
/// DSRadioGroup(selection: $selectedMethod) {
///     DSRadio(.creditCard, "Credit Card")
///     DSRadio(.paypal, "PayPal")
///     DSRadio(.applePay, "Apple Pay")
/// }
///
/// // Or with automatic generation from CaseIterable
/// DSRadioGroup(
///     selection: $selectedMethod,
///     options: PaymentMethod.allCases
/// ) { option in
///     option.rawValue
/// }
/// ```
public struct DSRadioGroup<Value: Hashable, Content: View>: View {
    // MARK: - Properties

    @Binding private var selection: Value
    private let axis: DSRadioGroupAxis
    private let spacing: CGFloat
    private let content: Content

    // MARK: - Initializers

    /// Creates a radio group with custom content.
    /// - Parameters:
    ///   - selection: Binding to the currently selected value
    ///   - axis: Layout orientation (horizontal or vertical)
    ///   - spacing: Spacing between radio buttons
    ///   - content: ViewBuilder content containing DSRadio items
    public init(
        selection: Binding<Value>,
        axis: DSRadioGroupAxis = .vertical,
        spacing: CGFloat = DSSpacing.sm,
        @ViewBuilder content: () -> Content
    ) {
        self._selection = selection
        self.axis = axis
        self.spacing = spacing
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch axis {
            case .horizontal:
                HStack(alignment: .center, spacing: spacing) {
                    content
                }
            case .vertical:
                VStack(alignment: .leading, spacing: spacing) {
                    content
                }
            }
        }
        .environment(\.radioGroupSelection, RadioGroupSelectionKey.Value(
            selection: selection as AnyHashable,
            setSelection: { newValue in
                if let typedValue = newValue as? Value {
                    selection = typedValue
                }
            }
        ))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Radio group")
    }
}

// MARK: - DSRadioGroup with Options Array

extension DSRadioGroup where Content == ForEach<[Value], Value, DSRadio<Value>> {
    /// Creates a radio group from an array of options.
    /// - Parameters:
    ///   - selection: Binding to the currently selected value
    ///   - options: Array of available options
    ///   - axis: Layout orientation (horizontal or vertical)
    ///   - spacing: Spacing between radio buttons
    ///   - size: Size variant for all radio buttons
    ///   - labelPosition: Position of labels relative to radio buttons
    ///   - labelProvider: Closure that provides the label for each option
    public init(
        selection: Binding<Value>,
        options: [Value],
        axis: DSRadioGroupAxis = .vertical,
        spacing: CGFloat = DSSpacing.sm,
        size: DSRadioButtonSize = .medium,
        labelPosition: DSRadioButtonLabelPosition = .trailing,
        labelProvider: @escaping (Value) -> String
    ) {
        self._selection = selection
        self.axis = axis
        self.spacing = spacing
        self.content = ForEach(options, id: \.self) { option in
            DSRadio(option, labelProvider(option), size: size, labelPosition: labelPosition)
        }
    }
}

// MARK: - DSRadio (Convenience Component for DSRadioGroup)

/// A simplified radio button component designed to work within a DSRadioGroup.
///
/// This component automatically connects to its parent DSRadioGroup's selection.
public struct DSRadio<Value: Hashable>: View {
    // MARK: - Properties

    private let value: Value
    private let label: String
    private let size: DSRadioButtonSize
    private let labelPosition: DSRadioButtonLabelPosition
    private let isDisabled: Bool
    private let selectedColor: Color
    private let unselectedBorderColor: Color

    @Environment(\.radioGroupSelection) private var groupSelection

    private var isSelected: Bool {
        groupSelection?.selection == value as AnyHashable
    }

    // MARK: - Initializers

    /// Creates a radio option for use within a DSRadioGroup.
    /// - Parameters:
    ///   - value: The value this radio represents
    ///   - label: Text label for the radio
    ///   - size: Size variant of the radio button
    ///   - labelPosition: Position of the label relative to the radio button
    ///   - isDisabled: Whether the radio button is disabled
    ///   - selectedColor: Color when selected
    ///   - unselectedBorderColor: Border color when not selected
    public init(
        _ value: Value,
        _ label: String,
        size: DSRadioButtonSize = .medium,
        labelPosition: DSRadioButtonLabelPosition = .trailing,
        isDisabled: Bool = false,
        selectedColor: Color = DSColors.selectionChecked,
        unselectedBorderColor: Color = DSColors.selectionBorder
    ) {
        self.value = value
        self.label = label
        self.size = size
        self.labelPosition = labelPosition
        self.isDisabled = isDisabled
        self.selectedColor = selectedColor
        self.unselectedBorderColor = unselectedBorderColor
    }

    // MARK: - Body

    public var body: some View {
        Button(action: select) {
            HStack(spacing: DSSpacing.sm) {
                if labelPosition == .leading {
                    labelView
                }

                radioButtonView

                if labelPosition == .trailing {
                    labelView
                }
            }
            .frame(minHeight: DSTouchTarget.minimum)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(isSelected ? "selected" : "not selected")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(isDisabled ? "Disabled" : "Double tap to select")
    }

    // MARK: - Subviews

    private var radioButtonView: some View {
        ZStack {
            Circle()
                .fill(DSColors.selectionUnchecked)
                .frame(width: size.outerSize, height: size.outerSize)

            Circle()
                .strokeBorder(
                    isSelected ? selectedColor : unselectedBorderColor,
                    lineWidth: 2
                )
                .frame(width: size.outerSize, height: size.outerSize)

            if isSelected {
                Circle()
                    .fill(selectedColor)
                    .frame(width: size.innerSize, height: size.innerSize)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    private var labelView: some View {
        Text(label)
            .font(size.font)
            .foregroundColor(isDisabled ? DSColors.textDisabled : DSColors.textPrimary)
            .multilineTextAlignment(labelPosition == .leading ? .trailing : .leading)
    }

    // MARK: - Actions

    private func select() {
        withAnimation(.easeInOut(duration: 0.2)) {
            groupSelection?.setSelection(value as AnyHashable)
        }
    }
}

// MARK: - Environment Key for Radio Group Selection

private struct RadioGroupSelectionKey: EnvironmentKey {
    struct Value {
        let selection: AnyHashable
        let setSelection: (AnyHashable) -> Void
    }

    static let defaultValue: Value? = nil
}

extension EnvironmentValues {
    var radioGroupSelection: RadioGroupSelectionKey.Value? {
        get { self[RadioGroupSelectionKey.self] }
        set { self[RadioGroupSelectionKey.self] = newValue }
    }
}

// MARK: - Preview

#if DEBUG
struct DSRadioGroup_Previews: PreviewProvider {
    static var previews: some View {
        RadioGroupPreviewContainer()
            .previewDisplayName("Radio Group")
    }
}

private struct RadioGroupPreviewContainer: View {
    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        case paypal = "PayPal"
        case applePay = "Apple Pay"
        case bankTransfer = "Bank Transfer"
    }

    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }

    @State private var selectedPayment: PaymentMethod = .creditCard
    @State private var selectedGender: Gender = .male

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.xl) {
                Group {
                    Text("Vertical Radio Group (ViewBuilder)")
                        .font(.headline)

                    DSRadioGroup(selection: $selectedPayment) {
                        DSRadio(.creditCard, "Credit Card")
                        DSRadio(.paypal, "PayPal")
                        DSRadio(.applePay, "Apple Pay")
                        DSRadio(.bankTransfer, "Bank Transfer")
                    }

                    Text("Selected: \(selectedPayment.rawValue)")
                        .font(.caption)
                        .foregroundColor(DSColors.textSecondary)
                }

                Divider()

                Group {
                    Text("Horizontal Radio Group")
                        .font(.headline)

                    DSRadioGroup(selection: $selectedGender, axis: .horizontal, spacing: DSSpacing.lg) {
                        DSRadio(.male, "Male")
                        DSRadio(.female, "Female")
                        DSRadio(.other, "Other")
                    }

                    Text("Selected: \(selectedGender.rawValue)")
                        .font(.caption)
                        .foregroundColor(DSColors.textSecondary)
                }

                Divider()

                Group {
                    Text("Radio Group from Array")
                        .font(.headline)

                    DSRadioGroup(
                        selection: $selectedPayment,
                        options: PaymentMethod.allCases,
                        axis: .vertical,
                        size: .small
                    ) { option in
                        option.rawValue
                    }
                }

                Divider()

                Group {
                    Text("With Disabled Options")
                        .font(.headline)

                    DSRadioGroup(selection: $selectedPayment) {
                        DSRadio(.creditCard, "Credit Card")
                        DSRadio(.paypal, "PayPal", isDisabled: true)
                        DSRadio(.applePay, "Apple Pay")
                        DSRadio(.bankTransfer, "Bank Transfer", isDisabled: true)
                    }
                }

                Divider()

                Group {
                    Text("Custom Colors")
                        .font(.headline)

                    DSRadioGroup(selection: $selectedGender) {
                        DSRadio(.male, "Male", selectedColor: DSColors.info)
                        DSRadio(.female, "Female", selectedColor: DSColors.success)
                        DSRadio(.other, "Other", selectedColor: DSColors.warning)
                    }
                }
            }
            .padding()
        }
    }
}
#endif
