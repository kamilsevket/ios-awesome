import XCTest

/// Extension for common UI test utilities
extension XCUIApplication {

    /// Launches the app with common test configurations
    func launchForTesting(
        arguments: [String] = [],
        environment: [String: String] = [:]
    ) {
        launchArguments = ["--uitesting"] + arguments
        launchEnvironment = [
            "DISABLE_ANIMATIONS": "1",
            "UI_TESTING": "1"
        ].merging(environment) { _, new in new }
        launch()
    }

    /// Waits for an element to exist with a timeout
    func waitForElement(
        _ element: XCUIElement,
        timeout: TimeInterval = 10
    ) -> Bool {
        element.waitForExistence(timeout: timeout)
    }

    /// Dismisses the keyboard if visible
    func dismissKeyboard() {
        if keyboards.count > 0 {
            keyboards.buttons["Return"].tap()
        }
    }

    /// Takes a screenshot with a name
    func takeScreenshot(name: String, lifetime: XCTAttachment.Lifetime = .keepAlways) -> XCTAttachment {
        let screenshot = screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = lifetime
        return attachment
    }
}

/// Extension for XCUIElement utilities
extension XCUIElement {

    /// Clears any existing text and enters new text
    func clearAndEnterText(_ text: String) {
        guard let stringValue = value as? String else {
            tap()
            typeText(text)
            return
        }

        tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
        typeText(text)
    }

    /// Scrolls to make the element visible
    func scrollToVisible(in scrollView: XCUIElement) {
        while !isHittable {
            scrollView.swipeUp()
        }
    }

    /// Waits for element and taps it
    func waitAndTap(timeout: TimeInterval = 5) -> Bool {
        guard waitForExistence(timeout: timeout) else { return false }
        tap()
        return true
    }

    /// Checks if element is visible on screen
    var isVisibleOnScreen: Bool {
        guard exists && !frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
}

/// Base class for UI tests with common setup
class UITestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    /// Launches the app for testing
    func launchApp(
        arguments: [String] = [],
        environment: [String: String] = [:]
    ) {
        app.launchForTesting(arguments: arguments, environment: environment)
    }

    /// Adds a screenshot attachment
    func addScreenshot(name: String) {
        let attachment = app.takeScreenshot(name: name)
        add(attachment)
    }

    /// Waits for condition with timeout
    func waitFor(
        _ condition: @autoclosure @escaping () -> Bool,
        timeout: TimeInterval = 10,
        message: String = "Condition not met"
    ) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in condition() },
            object: nil
        )
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, message)
    }
}

/// Protocol for page object pattern
protocol Page {
    var app: XCUIApplication { get }
    func verify() -> Bool
}

/// Common accessibility identifiers for testing
enum AccessibilityIdentifiers {
    enum Button: String {
        case primary = "primary_button"
        case secondary = "secondary_button"
        case back = "back_button"
        case close = "close_button"
        case submit = "submit_button"
    }

    enum TextField: String {
        case email = "email_field"
        case password = "password_field"
        case search = "search_field"
        case name = "name_field"
    }

    enum View: String {
        case loadingIndicator = "loading_indicator"
        case errorMessage = "error_message"
        case successMessage = "success_message"
        case card = "card_view"
        case avatar = "avatar_view"
    }
}
