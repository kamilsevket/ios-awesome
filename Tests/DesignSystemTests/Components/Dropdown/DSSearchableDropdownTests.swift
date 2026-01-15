import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSearchableDropdownTests: XCTestCase {

    // MARK: - Test Helpers

    struct User: DSSelectOption, Hashable {
        let id: String
        let displayText: String
        let email: String

        init(name: String, email: String) {
            self.id = email
            self.displayText = name
            self.email = email
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Basic Tests

    func testSearchableDropdownCreation() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]
        var selection: User?

        let _ = DSSearchableDropdown(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: users
        ) { user in
            Text(user.displayText)
        }

        XCTAssertNil(selection)
        XCTAssertEqual(users.count, 2)
    }

    func testSearchableDropdownWithDefaultContent() {
        let options = [
            DSSelectStringOption("Option 1"),
            DSSelectStringOption("Option 2")
        ]
        var selection: DSSelectStringOption?

        let _ = DSSearchableDropdown(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: options
        )

        XCTAssertNil(selection)
    }

    // MARK: - Search Functionality Tests

    func testSearchFiltering() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com"),
            User(name: "Bob Wilson", email: "bob@example.com")
        ]

        let searchText = "John"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.displayText, "John Doe")
    }

    func testSearchFilteringCaseInsensitive() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "JOHN SMITH", email: "john.smith@example.com")
        ]

        let searchText = "john"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 2)
    }

    func testSearchWithNoResults() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]

        let searchText = "xyz"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertTrue(filtered.isEmpty)
    }

    func testSearchWithEmptyText() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]

        let searchText = ""
        let filtered = searchText.isEmpty ? users : users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 2)
    }

    func testPartialMatch() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Johnson Williams", email: "johnson@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]

        let searchText = "John"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 2)
    }

    // MARK: - Selection Tests

    func testSelectFirstMatch() {
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]

        let searchText = "Jane"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }
        let firstMatch = filtered.first

        XCTAssertNotNil(firstMatch)
        XCTAssertEqual(firstMatch?.displayText, "Jane Smith")
    }

    func testSelectionEquality() {
        let user1 = User(name: "John Doe", email: "john@example.com")
        let user2 = User(name: "John Doe", email: "john@example.com")
        let user3 = User(name: "John Doe", email: "other@example.com")

        XCTAssertEqual(user1, user2) // Same ID (email)
        XCTAssertNotEqual(user1, user3) // Different ID
    }

    // MARK: - Custom User Tests

    func testUserDisplayText() {
        let user = User(name: "John Doe", email: "john@example.com")

        XCTAssertEqual(user.displayText, "John Doe")
        XCTAssertEqual(user.email, "john@example.com")
        XCTAssertEqual(user.id, "john@example.com")
    }

    func testUserHashable() {
        let user1 = User(name: "John", email: "john@example.com")
        let user2 = User(name: "John", email: "john@example.com")

        XCTAssertEqual(user1.hashValue, user2.hashValue)
    }

    // MARK: - Edge Cases

    func testEmptyOptions() {
        let users: [User] = []
        var selection: User?

        let _ = DSSearchableDropdown(
            selection: Binding(
                get: { selection },
                set: { selection = $0 }
            ),
            options: users
        ) { user in
            Text(user.displayText)
        }

        XCTAssertTrue(users.isEmpty)
    }

    func testManyOptions() {
        let users = (0..<1000).map {
            User(name: "User \($0)", email: "user\($0)@example.com")
        }

        XCTAssertEqual(users.count, 1000)
        XCTAssertEqual(users[500].displayText, "User 500")
    }

    func testSearchWithSpecialCharacters() {
        let users = [
            User(name: "John O'Brien", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]

        let searchText = "O'Brien"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 1)
    }

    func testSearchWithUnicode() {
        let users = [
            User(name: "田中太郎", email: "tanaka@example.com"),
            User(name: "John Doe", email: "john@example.com")
        ]

        let searchText = "田中"
        let filtered = users.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.displayText, "田中太郎")
    }

    func testClearSelection() {
        var selection: User? = User(name: "John Doe", email: "john@example.com")

        XCTAssertNotNil(selection)

        selection = nil

        XCTAssertNil(selection)
    }
}
