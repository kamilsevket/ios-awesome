import XCTest

/// Page object for components showcase screen
struct ComponentsPage: Page {
    let app: XCUIApplication

    // MARK: - Elements

    var primaryButton: XCUIElement {
        app.buttons[AccessibilityIdentifiers.Button.primary.rawValue]
    }

    var secondaryButton: XCUIElement {
        app.buttons[AccessibilityIdentifiers.Button.secondary.rawValue]
    }

    var emailTextField: XCUIElement {
        app.textFields[AccessibilityIdentifiers.TextField.email.rawValue]
    }

    var passwordTextField: XCUIElement {
        app.secureTextFields[AccessibilityIdentifiers.TextField.password.rawValue]
    }

    var searchTextField: XCUIElement {
        app.textFields[AccessibilityIdentifiers.TextField.search.rawValue]
    }

    var loadingIndicator: XCUIElement {
        app.activityIndicators[AccessibilityIdentifiers.View.loadingIndicator.rawValue]
    }

    var errorMessage: XCUIElement {
        app.staticTexts[AccessibilityIdentifiers.View.errorMessage.rawValue]
    }

    var successMessage: XCUIElement {
        app.staticTexts[AccessibilityIdentifiers.View.successMessage.rawValue]
    }

    var cardView: XCUIElement {
        app.otherElements[AccessibilityIdentifiers.View.card.rawValue]
    }

    var avatarView: XCUIElement {
        app.images[AccessibilityIdentifiers.View.avatar.rawValue]
    }

    // MARK: - Verification

    func verify() -> Bool {
        primaryButton.waitForExistence(timeout: 5)
    }

    // MARK: - Actions

    @discardableResult
    func tapPrimaryButton() -> Self {
        primaryButton.tap()
        return self
    }

    @discardableResult
    func tapSecondaryButton() -> Self {
        secondaryButton.tap()
        return self
    }

    @discardableResult
    func enterEmail(_ email: String) -> Self {
        emailTextField.tap()
        emailTextField.typeText(email)
        return self
    }

    @discardableResult
    func enterPassword(_ password: String) -> Self {
        passwordTextField.tap()
        passwordTextField.typeText(password)
        return self
    }

    @discardableResult
    func search(_ query: String) -> Self {
        searchTextField.tap()
        searchTextField.typeText(query)
        return self
    }

    @discardableResult
    func clearSearch() -> Self {
        searchTextField.clearAndEnterText("")
        return self
    }

    @discardableResult
    func tapCard() -> Self {
        cardView.tap()
        return self
    }

    // MARK: - Assertions

    func assertPrimaryButtonEnabled() -> Self {
        XCTAssertTrue(primaryButton.isEnabled, "Primary button should be enabled")
        return self
    }

    func assertPrimaryButtonDisabled() -> Self {
        XCTAssertFalse(primaryButton.isEnabled, "Primary button should be disabled")
        return self
    }

    func assertLoadingVisible() -> Self {
        XCTAssertTrue(loadingIndicator.exists, "Loading indicator should be visible")
        return self
    }

    func assertLoadingHidden() -> Self {
        XCTAssertFalse(loadingIndicator.exists, "Loading indicator should be hidden")
        return self
    }

    func assertErrorMessageVisible() -> Self {
        XCTAssertTrue(errorMessage.exists, "Error message should be visible")
        return self
    }

    func assertErrorMessageHidden() -> Self {
        XCTAssertFalse(errorMessage.exists, "Error message should be hidden")
        return self
    }

    func assertSuccessMessageVisible() -> Self {
        XCTAssertTrue(successMessage.exists, "Success message should be visible")
        return self
    }

    func assertEmailFieldValue(_ value: String) -> Self {
        XCTAssertEqual(emailTextField.value as? String, value, "Email field value mismatch")
        return self
    }
}

// MARK: - Usage Example

/*
 Example usage in tests:

 func testLoginFlow() {
     let page = ComponentsPage(app: app)

     XCTAssertTrue(page.verify())

     page
         .enterEmail("test@example.com")
         .enterPassword("password123")
         .assertPrimaryButtonEnabled()
         .tapPrimaryButton()
         .assertLoadingVisible()

     // Wait for loading to complete
     page.loadingIndicator.waitForNonExistence(timeout: 10)

     page
         .assertLoadingHidden()
         .assertSuccessMessageVisible()
 }
 */
