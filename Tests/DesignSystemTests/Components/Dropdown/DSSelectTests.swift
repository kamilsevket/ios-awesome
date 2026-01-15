import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSelectTests: XCTestCase {

    // MARK: - DSSelectStringOption Tests

    func testStringOptionInitialization() {
        let option = DSSelectStringOption("Test")

        XCTAssertEqual(option.id, "Test")
        XCTAssertEqual(option.displayText, "Test")
    }

    func testStringOptionWithCustomID() {
        let option = DSSelectStringOption(id: "custom-id", displayText: "Display Text")

        XCTAssertEqual(option.id, "custom-id")
        XCTAssertEqual(option.displayText, "Display Text")
    }

    func testStringOptionEquality() {
        let option1 = DSSelectStringOption(id: "test", displayText: "Test 1")
        let option2 = DSSelectStringOption(id: "test", displayText: "Test 2")
        let option3 = DSSelectStringOption(id: "other", displayText: "Test 1")

        XCTAssertEqual(option1, option2) // Same ID
        XCTAssertNotEqual(option1, option3) // Different ID
    }

    // MARK: - DSSelectStyle Tests

    func testSelectStyleCases() {
        let styles: [DSSelectStyle] = [.standard, .outlined, .filled]

        XCTAssertEqual(styles.count, 3)
    }

    // MARK: - DSSelect Tests

    func testSelectCreation() {
        let options = [
            DSSelectStringOption("Option 1"),
            DSSelectStringOption("Option 2"),
            DSSelectStringOption("Option 3")
        ]

        var selection: DSSelectStringOption?

        let _ = DSSelect(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: options
        )

        XCTAssertNil(selection)
    }

    func testSelectWithStringArray() {
        let options = ["Apple", "Banana", "Cherry"]
        var selection: String?

        let _ = DSSelect(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: options
        )

        XCTAssertNil(selection)
        XCTAssertEqual(options.count, 3)
    }

    // MARK: - Custom Option Tests

    struct Country: DSSelectOption {
        let id: String
        let displayText: String
        let code: String

        init(name: String, code: String) {
            self.id = code
            self.displayText = name
            self.code = code
        }
    }

    func testSelectWithCustomOption() {
        let countries = [
            Country(name: "United States", code: "US"),
            Country(name: "Canada", code: "CA"),
            Country(name: "Mexico", code: "MX")
        ]

        var selection: Country?

        let _ = DSSelect(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: countries
        )

        XCTAssertNil(selection)
        XCTAssertEqual(countries.count, 3)
        XCTAssertEqual(countries[0].displayText, "United States")
        XCTAssertEqual(countries[0].code, "US")
    }

    func testCustomOptionEquality() {
        let country1 = Country(name: "United States", code: "US")
        let country2 = Country(name: "USA", code: "US")
        let country3 = Country(name: "United States", code: "USA")

        XCTAssertEqual(country1, country2) // Same ID (code)
        XCTAssertNotEqual(country1, country3) // Different ID
    }

    // MARK: - Edge Cases

    func testEmptyOptions() {
        let options: [DSSelectStringOption] = []
        var selection: DSSelectStringOption?

        let _ = DSSelect(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: options
        )

        XCTAssertTrue(options.isEmpty)
    }

    func testManyOptions() {
        let options = (0..<1000).map { DSSelectStringOption("Option \($0)") }

        XCTAssertEqual(options.count, 1000)
        XCTAssertEqual(options[500].displayText, "Option 500")
    }

    func testOptionWithSpecialCharacters() {
        let option = DSSelectStringOption("Test @#$%^&*()")

        XCTAssertEqual(option.displayText, "Test @#$%^&*()")
    }

    func testOptionWithEmptyString() {
        let option = DSSelectStringOption("")

        XCTAssertEqual(option.id, "")
        XCTAssertEqual(option.displayText, "")
    }

    func testOptionWithUnicode() {
        let option = DSSelectStringOption("日本語 🇯🇵")

        XCTAssertEqual(option.displayText, "日本語 🇯🇵")
    }
}
