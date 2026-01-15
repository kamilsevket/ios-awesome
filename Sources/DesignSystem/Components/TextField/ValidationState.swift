import Foundation

/// Represents the current validation state of a text field.
public enum ValidationState: Equatable {
    /// Default state with no validation feedback.
    case `default`

    /// Field is currently focused.
    case focused

    /// Validation passed successfully.
    case success

    /// Validation failed with an optional error message.
    case error

    /// Field is disabled and not interactive.
    case disabled
}

/// Defines the type of validation to apply to a text field.
public enum DSTextFieldValidation {
    /// No validation applied.
    case none

    /// Email format validation.
    case email

    /// Password strength validation (minimum 8 characters).
    case password

    /// Phone number format validation.
    case phone

    /// Numeric input validation.
    case numeric

    /// Custom validation with a closure.
    case custom((String) -> Bool)

    /// Required field validation (non-empty).
    case required

    /// Minimum length validation.
    case minLength(Int)

    /// Maximum length validation.
    case maxLength(Int)

    /// Regular expression validation.
    case regex(String)

    /// Validates the given text and returns the validation state.
    /// - Parameter text: The text to validate.
    /// - Returns: The resulting validation state.
    func validate(_ text: String) -> ValidationState {
        // Empty text is valid for optional fields
        if text.isEmpty && self != .required {
            return .default
        }

        switch self {
        case .none:
            return .default

        case .email:
            let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let isValid = text.range(of: emailRegex, options: .regularExpression) != nil
            return isValid ? .success : .error

        case .password:
            // At least 8 characters, one uppercase, one lowercase, one number
            let hasMinLength = text.count >= 8
            let hasUppercase = text.range(of: "[A-Z]", options: .regularExpression) != nil
            let hasLowercase = text.range(of: "[a-z]", options: .regularExpression) != nil
            let hasNumber = text.range(of: "[0-9]", options: .regularExpression) != nil
            let isValid = hasMinLength && hasUppercase && hasLowercase && hasNumber
            return isValid ? .success : .error

        case .phone:
            // Simple phone validation: allows digits, spaces, dashes, parentheses, and plus sign
            let phoneRegex = #"^[\d\s\-\(\)\+]{7,}$"#
            let isValid = text.range(of: phoneRegex, options: .regularExpression) != nil
            return isValid ? .success : .error

        case .numeric:
            let isValid = Double(text) != nil
            return isValid ? .success : .error

        case .custom(let validator):
            return validator(text) ? .success : .error

        case .required:
            return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .error : .success

        case .minLength(let min):
            return text.count >= min ? .success : .error

        case .maxLength(let max):
            return text.count <= max ? .success : .error

        case .regex(let pattern):
            let isValid = text.range(of: pattern, options: .regularExpression) != nil
            return isValid ? .success : .error
        }
    }
}
