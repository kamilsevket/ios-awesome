import XCTest
@testable import DesignSystem

final class ValidationTests: XCTestCase {

    // MARK: - Email Validation

    func testEmailValidation_validEmail_returnsSuccess() {
        let validation = DSTextFieldValidation.email
        XCTAssertEqual(validation.validate("test@example.com"), .success)
        XCTAssertEqual(validation.validate("user.name@domain.co.uk"), .success)
        XCTAssertEqual(validation.validate("user+tag@example.org"), .success)
    }

    func testEmailValidation_invalidEmail_returnsError() {
        let validation = DSTextFieldValidation.email
        XCTAssertEqual(validation.validate("invalid"), .error)
        XCTAssertEqual(validation.validate("missing@domain"), .error)
        XCTAssertEqual(validation.validate("@nodomain.com"), .error)
        XCTAssertEqual(validation.validate("spaces in@email.com"), .error)
    }

    func testEmailValidation_emptyString_returnsDefault() {
        let validation = DSTextFieldValidation.email
        XCTAssertEqual(validation.validate(""), .default)
    }

    // MARK: - Password Validation

    func testPasswordValidation_strongPassword_returnsSuccess() {
        let validation = DSTextFieldValidation.password
        XCTAssertEqual(validation.validate("Password1"), .success)
        XCTAssertEqual(validation.validate("SecurePass123"), .success)
        XCTAssertEqual(validation.validate("MyP@ssw0rd"), .success)
    }

    func testPasswordValidation_weakPassword_returnsError() {
        let validation = DSTextFieldValidation.password
        XCTAssertEqual(validation.validate("pass"), .error) // Too short
        XCTAssertEqual(validation.validate("password"), .error) // No uppercase/number
        XCTAssertEqual(validation.validate("PASSWORD"), .error) // No lowercase/number
        XCTAssertEqual(validation.validate("12345678"), .error) // No letters
    }

    // MARK: - Phone Validation

    func testPhoneValidation_validPhone_returnsSuccess() {
        let validation = DSTextFieldValidation.phone
        XCTAssertEqual(validation.validate("1234567890"), .success)
        XCTAssertEqual(validation.validate("+1 (555) 123-4567"), .success)
        XCTAssertEqual(validation.validate("555-123-4567"), .success)
    }

    func testPhoneValidation_invalidPhone_returnsError() {
        let validation = DSTextFieldValidation.phone
        XCTAssertEqual(validation.validate("123"), .error) // Too short
        XCTAssertEqual(validation.validate("abc"), .error) // Letters
    }

    // MARK: - Numeric Validation

    func testNumericValidation_validNumbers_returnsSuccess() {
        let validation = DSTextFieldValidation.numeric
        XCTAssertEqual(validation.validate("123"), .success)
        XCTAssertEqual(validation.validate("0"), .success)
        XCTAssertEqual(validation.validate("3.14159"), .success)
        XCTAssertEqual(validation.validate("-42"), .success)
    }

    func testNumericValidation_invalidNumbers_returnsError() {
        let validation = DSTextFieldValidation.numeric
        XCTAssertEqual(validation.validate("abc"), .error)
        XCTAssertEqual(validation.validate("12a34"), .error)
    }

    // MARK: - Required Validation

    func testRequiredValidation_nonEmpty_returnsSuccess() {
        let validation = DSTextFieldValidation.required
        XCTAssertEqual(validation.validate("text"), .success)
        XCTAssertEqual(validation.validate("a"), .success)
    }

    func testRequiredValidation_empty_returnsError() {
        let validation = DSTextFieldValidation.required
        XCTAssertEqual(validation.validate(""), .error)
        XCTAssertEqual(validation.validate("   "), .error) // Whitespace only
    }

    // MARK: - Min Length Validation

    func testMinLengthValidation_meetsMinimum_returnsSuccess() {
        let validation = DSTextFieldValidation.minLength(5)
        XCTAssertEqual(validation.validate("12345"), .success)
        XCTAssertEqual(validation.validate("123456789"), .success)
    }

    func testMinLengthValidation_belowMinimum_returnsError() {
        let validation = DSTextFieldValidation.minLength(5)
        XCTAssertEqual(validation.validate("1234"), .error)
        XCTAssertEqual(validation.validate("a"), .error)
    }

    // MARK: - Max Length Validation

    func testMaxLengthValidation_belowMaximum_returnsSuccess() {
        let validation = DSTextFieldValidation.maxLength(10)
        XCTAssertEqual(validation.validate("12345"), .success)
        XCTAssertEqual(validation.validate("1234567890"), .success)
    }

    func testMaxLengthValidation_aboveMaximum_returnsError() {
        let validation = DSTextFieldValidation.maxLength(5)
        XCTAssertEqual(validation.validate("123456"), .error)
        XCTAssertEqual(validation.validate("this is too long"), .error)
    }

    // MARK: - Regex Validation

    func testRegexValidation_matchesPattern_returnsSuccess() {
        let validation = DSTextFieldValidation.regex("^[A-Z]{3}$")
        XCTAssertEqual(validation.validate("ABC"), .success)
        XCTAssertEqual(validation.validate("XYZ"), .success)
    }

    func testRegexValidation_noMatch_returnsError() {
        let validation = DSTextFieldValidation.regex("^[A-Z]{3}$")
        XCTAssertEqual(validation.validate("AB"), .error)
        XCTAssertEqual(validation.validate("ABCD"), .error)
        XCTAssertEqual(validation.validate("abc"), .error)
    }

    // MARK: - Custom Validation

    func testCustomValidation_passingCondition_returnsSuccess() {
        let validation = DSTextFieldValidation.custom { $0.contains("@") }
        XCTAssertEqual(validation.validate("test@"), .success)
    }

    func testCustomValidation_failingCondition_returnsError() {
        let validation = DSTextFieldValidation.custom { $0.contains("@") }
        XCTAssertEqual(validation.validate("test"), .error)
    }

    // MARK: - None Validation

    func testNoneValidation_anyInput_returnsDefault() {
        let validation = DSTextFieldValidation.none
        XCTAssertEqual(validation.validate("anything"), .default)
        XCTAssertEqual(validation.validate(""), .default)
    }
}
