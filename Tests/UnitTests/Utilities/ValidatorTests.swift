import XCTest
@testable import IOSComponents

final class ValidatorTests: XCTestCase {

    // MARK: - Email Validation Tests

    func testValidEmail_ReturnsValid() {
        let result = Validator.validateEmail("test@example.com")
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
    }

    func testEmailWithSubdomain_ReturnsValid() {
        let result = Validator.validateEmail("user@mail.example.com")
        XCTAssertTrue(result.isValid)
    }

    func testEmailWithPlus_ReturnsValid() {
        let result = Validator.validateEmail("user+tag@example.com")
        XCTAssertTrue(result.isValid)
    }

    func testEmptyEmail_ReturnsInvalid() {
        let result = Validator.validateEmail("")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Email is required")
    }

    func testEmailWithoutAt_ReturnsInvalid() {
        let result = Validator.validateEmail("invalid-email.com")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Please enter a valid email address")
    }

    func testEmailWithoutDomain_ReturnsInvalid() {
        let result = Validator.validateEmail("test@")
        XCTAssertFalse(result.isValid)
    }

    // MARK: - Password Validation Tests

    func testValidPassword_ReturnsValid() {
        let result = Validator.validatePassword("Password123")
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.errorMessage)
    }

    func testEmptyPassword_ReturnsInvalid() {
        let result = Validator.validatePassword("")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Password is required")
    }

    func testShortPassword_ReturnsInvalid() {
        let result = Validator.validatePassword("Pass1")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Password must be at least 8 characters")
    }

    func testPasswordWithoutUppercase_ReturnsInvalid() {
        let result = Validator.validatePassword("password123")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Password must contain at least one uppercase letter")
    }

    func testPasswordWithoutLowercase_ReturnsInvalid() {
        let result = Validator.validatePassword("PASSWORD123")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Password must contain at least one lowercase letter")
    }

    func testPasswordWithoutNumber_ReturnsInvalid() {
        let result = Validator.validatePassword("PasswordABC")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Password must contain at least one number")
    }

    func testPasswordWithCustomMinLength_ReturnsValid() {
        let result = Validator.validatePassword("Pass1", minLength: 5)
        XCTAssertTrue(result.isValid)
    }

    // MARK: - Phone Validation Tests

    func testValidPhone_ReturnsValid() {
        let result = Validator.validatePhone("1234567890")
        XCTAssertTrue(result.isValid)
    }

    func testPhoneWithFormatting_ReturnsValid() {
        let result = Validator.validatePhone("(123) 456-7890")
        XCTAssertTrue(result.isValid)
    }

    func testInternationalPhone_ReturnsValid() {
        let result = Validator.validatePhone("+1 (123) 456-7890")
        XCTAssertTrue(result.isValid)
    }

    func testEmptyPhone_ReturnsInvalid() {
        let result = Validator.validatePhone("")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Phone number is required")
    }

    func testShortPhone_ReturnsInvalid() {
        let result = Validator.validatePhone("12345")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Phone number must have at least 10 digits")
    }

    // MARK: - URL Validation Tests

    func testValidURL_ReturnsValid() {
        let result = Validator.validateURL("https://example.com")
        XCTAssertTrue(result.isValid)
    }

    func testURLWithPath_ReturnsValid() {
        let result = Validator.validateURL("https://example.com/path/to/page")
        XCTAssertTrue(result.isValid)
    }

    func testEmptyURL_ReturnsInvalid() {
        let result = Validator.validateURL("")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "URL is required")
    }

    // MARK: - Required Field Validation Tests

    func testRequiredFieldWithValue_ReturnsValid() {
        let result = Validator.validateRequired("Hello", fieldName: "Name")
        XCTAssertTrue(result.isValid)
    }

    func testRequiredFieldEmpty_ReturnsInvalid() {
        let result = Validator.validateRequired("", fieldName: "Name")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Name is required")
    }

    func testRequiredFieldWithWhitespace_ReturnsInvalid() {
        let result = Validator.validateRequired("   ", fieldName: "Name")
        XCTAssertFalse(result.isValid)
    }

    // MARK: - Length Validation Tests

    func testLengthWithinBounds_ReturnsValid() {
        let result = Validator.validateLength("Hello", min: 3, max: 10, fieldName: "Text")
        XCTAssertTrue(result.isValid)
    }

    func testLengthTooShort_ReturnsInvalid() {
        let result = Validator.validateLength("Hi", min: 3, fieldName: "Text")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Text must be at least 3 characters")
    }

    func testLengthTooLong_ReturnsInvalid() {
        let result = Validator.validateLength("Hello World", max: 5, fieldName: "Text")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Text must be at most 5 characters")
    }

    // MARK: - Combine Validation Tests

    func testCombineAllValid_ReturnsValid() {
        let result = Validator.combine(
            Validator.validateEmail("test@example.com"),
            Validator.validateRequired("John", fieldName: "Name")
        )
        XCTAssertTrue(result.isValid)
    }

    func testCombineFirstInvalid_ReturnsFirstError() {
        let result = Validator.combine(
            Validator.validateEmail("invalid"),
            Validator.validateRequired("", fieldName: "Name")
        )
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Please enter a valid email address")
    }

    func testCombineSecondInvalid_ReturnsSecondError() {
        let result = Validator.combine(
            Validator.validateEmail("test@example.com"),
            Validator.validateRequired("", fieldName: "Name")
        )
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Name is required")
    }
}
