import XCTest
import SwiftUI
@testable import IOSComponents

final class PrimaryButtonTests: XCTestCase {

    // MARK: - Button Style Tests

    func testFilledStyle_HasCorrectBackgroundColor() {
        let style = PrimaryButton.ButtonStyle.filled
        XCTAssertEqual(style.backgroundColor, .blue)
    }

    func testFilledStyle_HasCorrectForegroundColor() {
        let style = PrimaryButton.ButtonStyle.filled
        XCTAssertEqual(style.foregroundColor, .white)
    }

    func testOutlinedStyle_HasClearBackground() {
        let style = PrimaryButton.ButtonStyle.outlined
        XCTAssertEqual(style.backgroundColor, .clear)
    }

    func testOutlinedStyle_HasBlueForeground() {
        let style = PrimaryButton.ButtonStyle.outlined
        XCTAssertEqual(style.foregroundColor, .blue)
    }

    func testOutlinedStyle_HasBlueBorder() {
        let style = PrimaryButton.ButtonStyle.outlined
        XCTAssertEqual(style.borderColor, .blue)
    }

    func testTextStyle_HasClearBackground() {
        let style = PrimaryButton.ButtonStyle.text
        XCTAssertEqual(style.backgroundColor, .clear)
    }

    func testTextStyle_HasBlueForeground() {
        let style = PrimaryButton.ButtonStyle.text
        XCTAssertEqual(style.foregroundColor, .blue)
    }

    func testTextStyle_HasClearBorder() {
        let style = PrimaryButton.ButtonStyle.text
        XCTAssertEqual(style.borderColor, .clear)
    }

    // MARK: - Button Initialization Tests

    func testButtonInitialization_DefaultValues() {
        var actionCalled = false
        let button = PrimaryButton(title: "Test") {
            actionCalled = true
        }
        XCTAssertNotNil(button)
    }

    func testButtonInitialization_CustomStyle() {
        let button = PrimaryButton(title: "Test", style: .outlined) {}
        XCTAssertNotNil(button)
    }

    func testButtonInitialization_DisabledState() {
        let button = PrimaryButton(title: "Test", isEnabled: false) {}
        XCTAssertNotNil(button)
    }

    func testButtonInitialization_LoadingState() {
        let button = PrimaryButton(title: "Test", isLoading: true) {}
        XCTAssertNotNil(button)
    }

    // MARK: - Button Body Tests

    func testButtonBody_ReturnsView() {
        let button = PrimaryButton(title: "Test") {}
        let body = button.body
        XCTAssertNotNil(body)
    }
}
