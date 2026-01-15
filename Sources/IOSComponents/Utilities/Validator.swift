import Foundation

/// A utility class for common validation operations
public enum Validator {
    /// Validation result
    public struct ValidationResult {
        public let isValid: Bool
        public let errorMessage: String?

        public init(isValid: Bool, errorMessage: String? = nil) {
            self.isValid = isValid
            self.errorMessage = errorMessage
        }

        public static let valid = ValidationResult(isValid: true)

        public static func invalid(_ message: String) -> ValidationResult {
            ValidationResult(isValid: false, errorMessage: message)
        }
    }

    /// Validates an email address format
    public static func validateEmail(_ email: String) -> ValidationResult {
        guard !email.isEmpty else {
            return .invalid("Email is required")
        }

        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isValid = email.range(of: emailRegex, options: .regularExpression) != nil

        return isValid ? .valid : .invalid("Please enter a valid email address")
    }

    /// Validates a password meets minimum requirements
    public static func validatePassword(_ password: String, minLength: Int = 8) -> ValidationResult {
        guard !password.isEmpty else {
            return .invalid("Password is required")
        }

        guard password.count >= minLength else {
            return .invalid("Password must be at least \(minLength) characters")
        }

        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil

        if !hasUppercase {
            return .invalid("Password must contain at least one uppercase letter")
        }
        if !hasLowercase {
            return .invalid("Password must contain at least one lowercase letter")
        }
        if !hasNumber {
            return .invalid("Password must contain at least one number")
        }

        return .valid
    }

    /// Validates a phone number format
    public static func validatePhone(_ phone: String) -> ValidationResult {
        guard !phone.isEmpty else {
            return .invalid("Phone number is required")
        }

        let digitsOnly = phone.filter { $0.isNumber }
        guard digitsOnly.count >= 10 else {
            return .invalid("Phone number must have at least 10 digits")
        }

        return .valid
    }

    /// Validates a URL format
    public static func validateURL(_ urlString: String) -> ValidationResult {
        guard !urlString.isEmpty else {
            return .invalid("URL is required")
        }

        guard URL(string: urlString) != nil else {
            return .invalid("Please enter a valid URL")
        }

        return .valid
    }

    /// Validates a string is not empty
    public static func validateRequired(_ value: String, fieldName: String = "Field") -> ValidationResult {
        guard !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalid("\(fieldName) is required")
        }
        return .valid
    }

    /// Validates a string length is within bounds
    public static func validateLength(
        _ value: String,
        min: Int? = nil,
        max: Int? = nil,
        fieldName: String = "Field"
    ) -> ValidationResult {
        if let min = min, value.count < min {
            return .invalid("\(fieldName) must be at least \(min) characters")
        }
        if let max = max, value.count > max {
            return .invalid("\(fieldName) must be at most \(max) characters")
        }
        return .valid
    }

    /// Combines multiple validation results
    public static func combine(_ results: ValidationResult...) -> ValidationResult {
        for result in results {
            if !result.isValid {
                return result
            }
        }
        return .valid
    }
}
