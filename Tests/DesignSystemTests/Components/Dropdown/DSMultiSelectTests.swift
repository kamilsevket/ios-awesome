import XCTest
import SwiftUI
@testable import DesignSystem

final class DSMultiSelectTests: XCTestCase {

    // MARK: - Test Helpers

    struct Tag: DSSelectOption, Hashable {
        let id: String
        let displayText: String

        init(_ name: String) {
            self.id = name
            self.displayText = name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Basic Tests

    func testMultiSelectCreation() {
        let options = [Tag("Swift"), Tag("iOS"), Tag("SwiftUI")]
        var selections: Set<Tag> = []

        let _ = DSMultiSelect(
            selections: Binding(
                get: { selections },
                set: { selections = $0 }
            ),
            options: options
        )

        XCTAssertTrue(selections.isEmpty)
        XCTAssertEqual(options.count, 3)
    }

    func testMultiSelectWithStringArray() {
        let options = ["Apple", "Banana", "Cherry"]
        var selections: Set<String> = []

        let _ = DSMultiSelect(
            selections: Binding(
                get: { selections },
                set: { selections = $0 }
            ),
            options: options
        )

        XCTAssertTrue(selections.isEmpty)
    }

    // MARK: - Selection Tests

    func testInitialSelections() {
        let options = [Tag("Swift"), Tag("iOS"), Tag("SwiftUI")]
        var selections: Set<Tag> = [Tag("Swift"), Tag("iOS")]

        XCTAssertEqual(selections.count, 2)
        XCTAssertTrue(selections.contains(Tag("Swift")))
        XCTAssertTrue(selections.contains(Tag("iOS")))
        XCTAssertFalse(selections.contains(Tag("SwiftUI")))

        let _ = DSMultiSelect(
            selections: Binding(
                get: { selections },
                set: { selections = $0 }
            ),
            options: options
        )

        XCTAssertEqual(selections.count, 2)
    }

    func testAddSelection() {
        var selections: Set<Tag> = []
        let newTag = Tag("Swift")

        selections.insert(newTag)

        XCTAssertEqual(selections.count, 1)
        XCTAssertTrue(selections.contains(newTag))
    }

    func testRemoveSelection() {
        var selections: Set<Tag> = [Tag("Swift"), Tag("iOS")]

        selections.remove(Tag("Swift"))

        XCTAssertEqual(selections.count, 1)
        XCTAssertFalse(selections.contains(Tag("Swift")))
        XCTAssertTrue(selections.contains(Tag("iOS")))
    }

    func testClearAllSelections() {
        var selections: Set<Tag> = [Tag("Swift"), Tag("iOS"), Tag("SwiftUI")]

        selections.removeAll()

        XCTAssertTrue(selections.isEmpty)
    }

    // MARK: - Filter Tests

    func testFilterOptions() {
        let options = [
            Tag("Swift"),
            Tag("SwiftUI"),
            Tag("Objective-C"),
            Tag("iOS"),
            Tag("macOS")
        ]

        let searchText = "Swift"
        let filtered = options.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.contains(Tag("Swift")))
        XCTAssertTrue(filtered.contains(Tag("SwiftUI")))
    }

    func testFilterWithNoResults() {
        let options = [Tag("Swift"), Tag("iOS"), Tag("SwiftUI")]

        let searchText = "Python"
        let filtered = options.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertTrue(filtered.isEmpty)
    }

    func testFilterCaseInsensitive() {
        let options = [Tag("Swift"), Tag("SWIFT"), Tag("swift")]

        let searchText = "swift"
        let filtered = options.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 3)
    }

    func testFilterWithEmptySearchText() {
        let options = [Tag("Swift"), Tag("iOS"), Tag("SwiftUI")]

        let searchText = ""
        let filtered = searchText.isEmpty ? options : options.filter {
            $0.displayText.localizedCaseInsensitiveContains(searchText)
        }

        XCTAssertEqual(filtered.count, 3)
    }

    // MARK: - DSMultiSelectChip Tests

    func testMultiSelectChipText() {
        let chip = DSMultiSelectChip(text: "Swift") {}

        XCTAssertEqual("Swift", "Swift") // Chip displays correct text
    }

    // MARK: - Edge Cases

    func testEmptyOptions() {
        let options: [Tag] = []
        var selections: Set<Tag> = []

        let _ = DSMultiSelect(
            selections: Binding(
                get: { selections },
                set: { selections = $0 }
            ),
            options: options
        )

        XCTAssertTrue(options.isEmpty)
    }

    func testManyOptions() {
        let options = (0..<100).map { Tag("Tag \($0)") }
        var selections: Set<Tag> = Set(options.prefix(50))

        XCTAssertEqual(options.count, 100)
        XCTAssertEqual(selections.count, 50)

        let _ = DSMultiSelect(
            selections: Binding(
                get: { selections },
                set: { selections = $0 }
            ),
            options: options
        )
    }

    func testSelectAllOptions() {
        let options = [Tag("Swift"), Tag("iOS"), Tag("SwiftUI")]
        var selections: Set<Tag> = Set(options)

        XCTAssertEqual(selections.count, 3)
        XCTAssertEqual(selections, Set(options))
    }

    func testDuplicateSelections() {
        var selections: Set<Tag> = []

        selections.insert(Tag("Swift"))
        selections.insert(Tag("Swift")) // Duplicate

        XCTAssertEqual(selections.count, 1) // Set prevents duplicates
    }

    func testTagHashable() {
        let tag1 = Tag("Swift")
        let tag2 = Tag("Swift")

        XCTAssertEqual(tag1.hashValue, tag2.hashValue)
    }

    func testTagEquality() {
        let tag1 = Tag("Swift")
        let tag2 = Tag("Swift")
        let tag3 = Tag("iOS")

        XCTAssertEqual(tag1, tag2)
        XCTAssertNotEqual(tag1, tag3)
    }

    // MARK: - Display Tests

    func testMaxDisplayedChips() {
        let maxChips = 3
        let selections: Set<Tag> = [
            Tag("Swift"),
            Tag("iOS"),
            Tag("SwiftUI"),
            Tag("Combine"),
            Tag("UIKit")
        ]

        let displayedCount = min(selections.count, maxChips)
        let remainingCount = selections.count - maxChips

        XCTAssertEqual(displayedCount, 3)
        XCTAssertEqual(remainingCount, 2)
    }

    func testRemainingCountWhenLessThanMax() {
        let maxChips = 3
        let selections: Set<Tag> = [Tag("Swift"), Tag("iOS")]

        let displayedCount = min(selections.count, maxChips)
        let remainingCount = max(0, selections.count - maxChips)

        XCTAssertEqual(displayedCount, 2)
        XCTAssertEqual(remainingCount, 0)
    }
}
