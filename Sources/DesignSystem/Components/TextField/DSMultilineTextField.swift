import SwiftUI

/// A multiline text field component using TextEditor.
///
/// Example usage:
/// ```swift
/// DSMultilineTextField("Description", text: $description)
///     .minHeight(100)
///     .maxCharacters(500)
///     .placeholder("Enter your description...")
/// ```
public struct DSMultilineTextField: View {
    private let label: String
    @Binding private var text: String

    private var placeholder: String = ""
    private var helperText: String?
    private var errorMessage: String?
    private var maxCharacters: Int?
    private var minHeight: CGFloat = 100
    private var maxHeight: CGFloat = 300
    private var style: DSTextFieldStyle = .outlined
    private var validation: DSTextFieldValidation = .none
    private var isDisabled: Bool = false

    @State private var validationState: ValidationState = .default
    @State private var isFocused: Bool = false
    @State private var textEditorHeight: CGFloat = 100

    @FocusState private var fieldIsFocused: Bool

    // MARK: - Initialization

    public init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label
            labelView

            // TextEditor container
            textEditorContainer

            // Bottom row: helper text and character counter
            bottomRow
        }
        .animation(.easeInOut(duration: 0.2), value: validationState)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .onChange(of: fieldIsFocused) { newValue in
            withAnimation(.easeInOut(duration: 0.2)) {
                isFocused = newValue
            }
            if !newValue {
                validateInput()
            }
        }
        .onChange(of: text) { _ in
            if validationState == .error {
                validateInput()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(text)
        .accessibilityHint(helperText ?? "")
    }

    // MARK: - Subviews

    @ViewBuilder
    private var labelView: some View {
        Text(label)
            .font(.caption)
            .foregroundColor(labelColor)
    }

    @ViewBuilder
    private var textEditorContainer: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
                    .allowsHitTesting(false)
            }

            // TextEditor
            TextEditor(text: $text)
                .focused($fieldIsFocused)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight, maxHeight: maxHeight)
                .padding(4)
        }
        .background(backgroundView)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .standard:
            VStack {
                Spacer()
                Rectangle()
                    .fill(borderColor)
                    .frame(height: isFocused ? 2 : 1)
            }
        case .outlined:
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: isFocused ? 2 : 1)
        case .search:
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        }
    }

    @ViewBuilder
    private var bottomRow: some View {
        HStack {
            // Helper text or error message
            if let error = errorMessage, validationState == .error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            } else if let helper = helperText {
                Text(helper)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Character counter
            if let max = maxCharacters {
                Text("\(text.count)/\(max)")
                    .font(.caption)
                    .foregroundColor(text.count > max ? .red : .secondary)
            }
        }
    }

    // MARK: - Computed Properties

    private var labelColor: Color {
        if validationState == .error {
            return .red
        } else if isFocused {
            return .accentColor
        }
        return .secondary
    }

    private var borderColor: Color {
        switch validationState {
        case .error:
            return .red
        case .success:
            return .green
        default:
            return isFocused ? .accentColor : Color(.systemGray4)
        }
    }

    // MARK: - Validation

    private func validateInput() {
        var result = validation.validate(text)

        // Check max characters
        if let max = maxCharacters, text.count > max {
            result = .error
        }

        withAnimation(.easeInOut(duration: 0.2)) {
            validationState = result
        }
    }
}

// MARK: - Modifiers

public extension DSMultilineTextField {
    /// Sets the text field style.
    func style(_ style: DSTextFieldStyle) -> DSMultilineTextField {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the validation type.
    func validation(_ validation: DSTextFieldValidation) -> DSMultilineTextField {
        var copy = self
        copy.validation = validation
        return copy
    }

    /// Sets the helper text displayed below the field.
    func helperText(_ text: String) -> DSMultilineTextField {
        var copy = self
        copy.helperText = text
        return copy
    }

    /// Sets the error message displayed when validation fails.
    func errorMessage(_ message: String) -> DSMultilineTextField {
        var copy = self
        copy.errorMessage = message
        return copy
    }

    /// Sets the placeholder text.
    func placeholder(_ text: String) -> DSMultilineTextField {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Sets the maximum character limit.
    func maxCharacters(_ limit: Int) -> DSMultilineTextField {
        var copy = self
        copy.maxCharacters = limit
        return copy
    }

    /// Sets the minimum height of the text editor.
    func minHeight(_ height: CGFloat) -> DSMultilineTextField {
        var copy = self
        copy.minHeight = height
        return copy
    }

    /// Sets the maximum height of the text editor.
    func maxHeight(_ height: CGFloat) -> DSMultilineTextField {
        var copy = self
        copy.maxHeight = height
        return copy
    }

    /// Disables the text field.
    func disabled(_ disabled: Bool) -> DSMultilineTextField {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }
}
