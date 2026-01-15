import XCTest

/// UI Tests for component interactions
final class ComponentUITests: UITestCase {

    // MARK: - Button Interaction Tests

    func testPrimaryButton_TapInteraction() {
        // This test demonstrates button tap testing pattern
        // In a real app, the button would be in a hosted view
        launchApp()

        // Example: Testing a button in a test host app
        let button = app.buttons["Continue"]

        if button.waitForExistence(timeout: 5) {
            XCTAssertTrue(button.isEnabled)
            button.tap()
            // Verify the expected result after tap
        }
    }

    func testPrimaryButton_DisabledState() {
        launchApp()

        let disabledButton = app.buttons["Disabled Button"]

        if disabledButton.waitForExistence(timeout: 5) {
            XCTAssertFalse(disabledButton.isEnabled)
        }
    }

    func testPrimaryButton_LoadingState() {
        launchApp()

        let loadingButton = app.buttons["Loading"]

        if loadingButton.waitForExistence(timeout: 5) {
            // Check for activity indicator
            let activityIndicator = app.activityIndicators.firstMatch
            XCTAssertTrue(activityIndicator.exists)
        }
    }

    // MARK: - TextField Interaction Tests

    func testTextField_TextEntry() {
        launchApp()

        let emailField = app.textFields["Email"]

        if emailField.waitForExistence(timeout: 5) {
            emailField.tap()
            emailField.typeText("test@example.com")
            XCTAssertEqual(emailField.value as? String, "test@example.com")
        }
    }

    func testTextField_ClearAndEnter() {
        launchApp()

        let textField = app.textFields["Name"]

        if textField.waitForExistence(timeout: 5) {
            // Enter initial text
            textField.tap()
            textField.typeText("Initial")

            // Clear and enter new text
            textField.clearAndEnterText("New Value")
            XCTAssertEqual(textField.value as? String, "New Value")
        }
    }

    func testSecureTextField_TextEntry() {
        launchApp()

        let passwordField = app.secureTextFields["Password"]

        if passwordField.waitForExistence(timeout: 5) {
            passwordField.tap()
            passwordField.typeText("securePassword123")
            // Secure field value is not readable, just verify it exists
            XCTAssertTrue(passwordField.exists)
        }
    }

    // MARK: - Card Interaction Tests

    func testCard_TapInteraction() {
        launchApp()

        let card = app.otherElements["Card"]

        if card.waitForExistence(timeout: 5) {
            XCTAssertTrue(card.isHittable)
            card.tap()
            // Verify navigation or action result
        }
    }

    // MARK: - Scroll Tests

    func testScrollView_ScrollToElement() {
        launchApp()

        let scrollView = app.scrollViews.firstMatch
        let bottomElement = app.staticTexts["Bottom Element"]

        if scrollView.waitForExistence(timeout: 5) {
            // Scroll until bottom element is visible
            var attempts = 0
            while !bottomElement.isHittable && attempts < 10 {
                scrollView.swipeUp()
                attempts += 1
            }

            XCTAssertTrue(bottomElement.isHittable || attempts < 10)
        }
    }

    // MARK: - Navigation Tests

    func testNavigation_BackButton() {
        launchApp()

        let backButton = app.buttons["Back"]

        if backButton.waitForExistence(timeout: 5) {
            backButton.tap()
            // Verify we navigated back
        }
    }

    // MARK: - Keyboard Tests

    func testKeyboard_Dismiss() {
        launchApp()

        let textField = app.textFields.firstMatch

        if textField.waitForExistence(timeout: 5) {
            textField.tap()

            // Verify keyboard appears
            XCTAssertTrue(app.keyboards.count > 0)

            // Dismiss keyboard
            app.dismissKeyboard()

            // Small delay for keyboard dismissal
            sleep(1)
        }
    }

    // MARK: - Screenshot Tests

    func testTakeScreenshot_AllStates() {
        launchApp()

        // Take screenshots of different states
        addScreenshot(name: "initial_state")

        // Perform some action
        let button = app.buttons.firstMatch
        if button.waitAndTap(timeout: 5) {
            addScreenshot(name: "after_button_tap")
        }
    }
}
