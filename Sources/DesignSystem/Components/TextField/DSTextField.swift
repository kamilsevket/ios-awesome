import SwiftUI

/// A customizable text field component for the design system.
///
/// Example usage:
/// ```swift
/// DSTextField("Email", text: $email)
///     .style(.outlined)
///     .validation(.email)
///     .helperText("Enter your email")
/// ```
public struct DSTextField: View {
    // MARK: - Properties

    private let label: String
    @Binding private var text: String

    private var placeholder: String = ""
    private var helperText: String?
    private var errorMessage: String?
    private var maxCharacters: Int?
    private var leadingIcon: Image?
    private var trailingIcon: Image?
    private var showsClearButton: Bool = false
    private var style: DSTextFieldStyle = .standard
    private var validation: DSTextFieldValidation = .none
    private var keyboardType: UIKeyboardType = .default
    private var returnKeyType: UIReturnKeyType = .default
    private var isSecure: Bool = false
    private var isDisabled: Bool = false

    @State private var validationState: ValidationState = .default
    @State private var isFocused: Bool = false
    @State private var showSecureText: Bool = false
    @State private var shakeOffset: CGFloat = 0

    @FocusState private var fieldIsFocused: Bool

    // MARK: - Initialization

    public init(_ label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Floating label
            if style != .search {
                floatingLabel
            }

            // Text field container
            textFieldContainer
                .offset(x: shakeOffset)

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
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(text)
        .accessibilityHint(helperText ?? "")
    }

    // MARK: - Subviews

    @ViewBuilder
    private var floatingLabel: some View {
        Text(label)
            .font(labelFont)
            .foregroundColor(labelColor)
            .offset(y: shouldFloatLabel ? 0 : 20)
            .scaleEffect(shouldFloatLabel ? 0.85 : 1.0, anchor: .leading)
            .animation(.easeInOut(duration: 0.2), value: shouldFloatLabel)
    }

    @ViewBuilder
    private var textFieldContainer: some View {
        HStack(spacing: 8) {
            // Leading icon
            if let icon = leadingIcon {
                icon
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
            }

            // Text field
            textFieldView

            // Clear button
            if showsClearButton && !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel("Clear text")
            }

            // Secure toggle for password fields
            if isSecure {
                Button(action: { showSecureText.toggle() }) {
                    Image(systemName: showSecureText ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
                .accessibilityLabel(showSecureText ? "Hide password" : "Show password")
            }

            // Trailing icon
            if let icon = trailingIcon {
                icon
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
            }

            // Validation state icon
            if validationState == .success {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if validationState == .error {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(backgroundView)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }

    @ViewBuilder
    private var textFieldView: some View {
        Group {
            if isSecure && !showSecureText {
                SecureField(placeholder.isEmpty ? label : placeholder, text: $text)
            } else {
                TextField(placeholder.isEmpty ? label : placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .focused($fieldIsFocused)
        .submitLabel(submitLabel)
        .textInputAutocapitalization(autocapitalization)
        .autocorrectionDisabled(validation == .email || validation == .password)
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

    private var shouldFloatLabel: Bool {
        isFocused || !text.isEmpty
    }

    private var labelFont: Font {
        shouldFloatLabel ? .caption : .body
    }

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

    private var iconColor: Color {
        isFocused ? .accentColor : .secondary
    }

    private var submitLabel: SubmitLabel {
        switch returnKeyType {
        case .done: return .done
        case .go: return .go
        case .next: return .next
        case .search: return .search
        case .send: return .send
        case .continue: return .continue
        case .join: return .join
        case .route: return .route
        default: return .return
        }
    }

    private var autocapitalization: TextInputAutocapitalization {
        switch validation {
        case .email, .password:
            return .never
        default:
            return .sentences
        }
    }

    private var accessibilityLabel: String {
        var result = label
        if validationState == .error, let error = errorMessage {
            result += ", error: \(error)"
        }
        return result
    }

    // MARK: - Validation

    private func validateInput() {
        let result = validation.validate(text)

        withAnimation(.easeInOut(duration: 0.2)) {
            validationState = result
        }

        if result == .error {
            triggerShakeAnimation()
        }
    }

    private func triggerShakeAnimation() {
        withAnimation(.easeInOut(duration: 0.05)) {
            shakeOffset = 10
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            withAnimation(.easeInOut(duration: 0.05)) {
                shakeOffset = -10
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.05)) {
                shakeOffset = 5
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeInOut(duration: 0.05)) {
                shakeOffset = 0
            }
        }
    }
}

// MARK: - Modifiers

public extension DSTextField {
    /// Sets the text field style.
    func style(_ style: DSTextFieldStyle) -> DSTextField {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the validation type.
    func validation(_ validation: DSTextFieldValidation) -> DSTextField {
        var copy = self
        copy.validation = validation
        if validation == .email {
            copy.keyboardType = .emailAddress
        } else if validation == .phone {
            copy.keyboardType = .phonePad
        }
        return copy
    }

    /// Sets the helper text displayed below the field.
    func helperText(_ text: String) -> DSTextField {
        var copy = self
        copy.helperText = text
        return copy
    }

    /// Sets the error message displayed when validation fails.
    func errorMessage(_ message: String) -> DSTextField {
        var copy = self
        copy.errorMessage = message
        return copy
    }

    /// Sets the placeholder text.
    func placeholder(_ text: String) -> DSTextField {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Sets the maximum character limit.
    func maxCharacters(_ limit: Int) -> DSTextField {
        var copy = self
        copy.maxCharacters = limit
        return copy
    }

    /// Sets the leading icon.
    func leadingIcon(_ icon: Image) -> DSTextField {
        var copy = self
        copy.leadingIcon = icon
        return copy
    }

    /// Sets the trailing icon.
    func trailingIcon(_ icon: Image) -> DSTextField {
        var copy = self
        copy.trailingIcon = icon
        return copy
    }

    /// Shows or hides the clear button.
    func showsClearButton(_ show: Bool) -> DSTextField {
        var copy = self
        copy.showsClearButton = show
        return copy
    }

    /// Sets the keyboard type.
    func keyboardType(_ type: UIKeyboardType) -> DSTextField {
        var copy = self
        copy.keyboardType = type
        return copy
    }

    /// Sets the return key type.
    func returnKeyType(_ type: UIReturnKeyType) -> DSTextField {
        var copy = self
        copy.returnKeyType = type
        return copy
    }

    /// Configures the field as a secure text entry (password).
    func secure(_ isSecure: Bool = true) -> DSTextField {
        var copy = self
        copy.isSecure = isSecure
        return copy
    }

    /// Disables the text field.
    func disabled(_ disabled: Bool) -> DSTextField {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }
}
