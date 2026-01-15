import SwiftUI

/// A customizable text field component with validation support
public struct CustomTextField: View {
    @Binding private var text: String
    private let placeholder: String
    private let label: String?
    private let errorMessage: String?
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let validator: ((String) -> Bool)?

    @State private var isValid: Bool = true
    @State private var isFocused: Bool = false

    public init(
        text: Binding<String>,
        placeholder: String,
        label: String? = nil,
        errorMessage: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        validator: ((String) -> Bool)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.errorMessage = errorMessage
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.validator = validator
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = label {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .keyboardType(keyboardType)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 1)
            )
            .onChange(of: text) { newValue in
                if let validator = validator {
                    isValid = validator(newValue)
                }
            }
            .accessibilityLabel(label ?? placeholder)
            .accessibilityValue(text)
            .accessibilityHint(errorMessage != nil && !isValid ? errorMessage! : "")

            if let errorMessage = errorMessage, !isValid && !text.isEmpty {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .accessibilityLabel("Error: \(errorMessage)")
            }
        }
    }

    private var borderColor: Color {
        if !isValid && !text.isEmpty {
            return .red
        }
        return isFocused ? .blue : .clear
    }
}

#if DEBUG
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            CustomTextField(
                text: .constant(""),
                placeholder: "Enter email",
                label: "Email"
            )
            CustomTextField(
                text: .constant("invalid"),
                placeholder: "Enter email",
                label: "Email",
                errorMessage: "Please enter a valid email",
                validator: { $0.contains("@") }
            )
            CustomTextField(
                text: .constant(""),
                placeholder: "Password",
                label: "Password",
                isSecure: true
            )
        }
        .padding()
    }
}
#endif
