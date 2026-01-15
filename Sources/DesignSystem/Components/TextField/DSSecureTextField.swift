import SwiftUI

/// A secure text field component for password input with visibility toggle.
///
/// Example usage:
/// ```swift
/// DSSecureTextField("Password", text: $password)
///     .style(.outlined)
///     .validation(.password)
///     .helperText("Minimum 8 characters")
/// ```
public struct DSSecureTextField: View {
    private let label: String
    @Binding private var text: String

    private var placeholder: String = ""
    private var helperText: String?
    private var errorMessage: String?
    private var style: DSTextFieldStyle = .outlined
    private var validation: DSTextFieldValidation = .password
    private var showStrengthIndicator: Bool = false

    @State private var isSecureEntry: Bool = true
    @State private var validationState: ValidationState = .default
    @State private var isFocused: Bool = false
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
            floatingLabel

            // Text field container
            textFieldContainer
                .offset(x: shakeOffset)

            // Password strength indicator
            if showStrengthIndicator && !text.isEmpty {
                strengthIndicator
            }

            // Helper text or error
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
            if validationState == .error || showStrengthIndicator {
                validateInput()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(text.isEmpty ? "Empty" : "Filled, \(text.count) characters")
    }

    // MARK: - Subviews

    @ViewBuilder
    private var floatingLabel: some View {
        Text(label)
            .font(shouldFloatLabel ? .caption : .body)
            .foregroundColor(labelColor)
            .offset(y: shouldFloatLabel ? 0 : 20)
            .scaleEffect(shouldFloatLabel ? 0.85 : 1.0, anchor: .leading)
            .animation(.easeInOut(duration: 0.2), value: shouldFloatLabel)
    }

    @ViewBuilder
    private var textFieldContainer: some View {
        HStack(spacing: 8) {
            // Lock icon
            Image(systemName: "lock.fill")
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)

            // Text field
            Group {
                if isSecureEntry {
                    SecureField(placeholder.isEmpty ? label : placeholder, text: $text)
                } else {
                    TextField(placeholder.isEmpty ? label : placeholder, text: $text)
                }
            }
            .focused($fieldIsFocused)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            // Visibility toggle
            Button(action: { isSecureEntry.toggle() }) {
                Image(systemName: isSecureEntry ? "eye.slash" : "eye")
                    .foregroundColor(.secondary)
            }
            .accessibilityLabel(isSecureEntry ? "Show password" : "Hide password")

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
    private var strengthIndicator: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 4)

                    Rectangle()
                        .fill(strengthColor)
                        .frame(width: geometry.size.width * strengthProgress, height: 4)
                }
                .cornerRadius(2)
            }
            .frame(height: 4)

            Text(strengthText)
                .font(.caption2)
                .foregroundColor(strengthColor)
        }
    }

    @ViewBuilder
    private var bottomRow: some View {
        if let error = errorMessage, validationState == .error {
            Text(error)
                .font(.caption)
                .foregroundColor(.red)
        } else if let helper = helperText {
            Text(helper)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Computed Properties

    private var shouldFloatLabel: Bool {
        isFocused || !text.isEmpty
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

    private var accessibilityLabel: String {
        var result = label
        if validationState == .error, let error = errorMessage {
            result += ", error: \(error)"
        }
        return result
    }

    private var passwordStrength: PasswordStrength {
        PasswordStrength.calculate(for: text)
    }

    private var strengthProgress: CGFloat {
        switch passwordStrength {
        case .weak: return 0.25
        case .fair: return 0.5
        case .good: return 0.75
        case .strong: return 1.0
        }
    }

    private var strengthColor: Color {
        switch passwordStrength {
        case .weak: return .red
        case .fair: return .orange
        case .good: return .yellow
        case .strong: return .green
        }
    }

    private var strengthText: String {
        switch passwordStrength {
        case .weak: return "Weak"
        case .fair: return "Fair"
        case .good: return "Good"
        case .strong: return "Strong"
        }
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
        let duration = 0.05
        withAnimation(.easeInOut(duration: duration)) { shakeOffset = 10 }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation(.easeInOut(duration: duration)) { shakeOffset = -10 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2) {
            withAnimation(.easeInOut(duration: duration)) { shakeOffset = 5 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 3) {
            withAnimation(.easeInOut(duration: duration)) { shakeOffset = 0 }
        }
    }
}

// MARK: - Password Strength

private enum PasswordStrength {
    case weak
    case fair
    case good
    case strong

    static func calculate(for password: String) -> PasswordStrength {
        var score = 0

        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }

        switch score {
        case 0...2: return .weak
        case 3: return .fair
        case 4...5: return .good
        default: return .strong
        }
    }
}

// MARK: - Modifiers

public extension DSSecureTextField {
    /// Sets the text field style.
    func style(_ style: DSTextFieldStyle) -> DSSecureTextField {
        var copy = self
        copy.style = style
        return copy
    }

    /// Sets the validation type.
    func validation(_ validation: DSTextFieldValidation) -> DSSecureTextField {
        var copy = self
        copy.validation = validation
        return copy
    }

    /// Sets the helper text displayed below the field.
    func helperText(_ text: String) -> DSSecureTextField {
        var copy = self
        copy.helperText = text
        return copy
    }

    /// Sets the error message displayed when validation fails.
    func errorMessage(_ message: String) -> DSSecureTextField {
        var copy = self
        copy.errorMessage = message
        return copy
    }

    /// Sets the placeholder text.
    func placeholder(_ text: String) -> DSSecureTextField {
        var copy = self
        copy.placeholder = text
        return copy
    }

    /// Shows or hides the password strength indicator.
    func showStrengthIndicator(_ show: Bool) -> DSSecureTextField {
        var copy = self
        copy.showStrengthIndicator = show
        return copy
    }
}
