import XCTest
import SwiftUI
@testable import DesignSystem

final class DSStickyHeaderTests: XCTestCase {

    // MARK: - DSStickyHeaderStyle Tests

    func testStandardStyleBackgroundOpacity() {
        let style = DSStickyHeaderStyle.standard
        XCTAssertEqual(style.backgroundOpacity, 0.95)
        XCTAssertFalse(style.hasBlur)
    }

    func testBlurredStyleBackgroundOpacity() {
        let style = DSStickyHeaderStyle.blurred
        XCTAssertEqual(style.backgroundOpacity, 0.7)
        XCTAssertTrue(style.hasBlur)
    }

    func testSolidStyleBackgroundOpacity() {
        let style = DSStickyHeaderStyle.solid
        XCTAssertEqual(style.backgroundOpacity, 1.0)
        XCTAssertFalse(style.hasBlur)
    }

    // MARK: - DSStickyHeader Initialization Tests

    func testStickyHeaderWithTextContent() {
        let header = DSStickyHeader("Test Title")
        XCTAssertNotNil(header)
    }

    func testStickyHeaderWithCustomContent() {
        let header = DSStickyHeader {
            HStack {
                Text("Custom Header")
                Spacer()
                Image(systemName: "chevron.down")
            }
        }
        XCTAssertNotNil(header)
    }

    // MARK: - DSStickyHeader Modifier Tests

    func testStyleModifier() {
        let header = DSStickyHeader("Test")
            .style(.blurred)
        XCTAssertNotNil(header)
    }

    func testBackgroundColorModifier() {
        let header = DSStickyHeader("Test")
            .backgroundColor(.blue)
        XCTAssertNotNil(header)
    }

    func testShowsShadowOnPinModifier() {
        let header = DSStickyHeader("Test")
            .showsShadowOnPin(false)
        XCTAssertNotNil(header)
    }

    func testMinHeightModifier() {
        let header = DSStickyHeader("Test")
            .minHeight(60)
        XCTAssertNotNil(header)
    }

    func testCombinedModifiers() {
        let header = DSStickyHeader("Test")
            .style(.solid)
            .backgroundColor(.white)
            .showsShadowOnPin(true)
            .minHeight(50)
        XCTAssertNotNil(header)
    }

    // MARK: - DSStickyHeaderList Tests

    func testStickyHeaderListInitialization() {
        let sections = [
            TestStickySection(id: 1, title: "Section 1", items: ["A", "B"]),
            TestStickySection(id: 2, title: "Section 2", items: ["C", "D"])
        ]

        let list = DSStickyHeaderList(sections) { section in
            Text(section.title)
        } sectionContent: { section in
            ForEach(section.items, id: \.self) { item in
                Text(item)
            }
        }
        XCTAssertNotNil(list)
    }

    func testStickyHeaderListWithEmptyData() {
        let sections: [TestStickySection] = []

        let list = DSStickyHeaderList(sections) { section in
            Text(section.title)
        } sectionContent: { section in
            ForEach(section.items, id: \.self) { item in
                Text(item)
            }
        }
        XCTAssertNotNil(list)
    }

    func testStickyHeaderListHeaderStyleModifier() {
        let sections = [TestStickySection(id: 1, title: "Test", items: ["A"])]

        let list = DSStickyHeaderList(sections) { section in
            Text(section.title)
        } sectionContent: { section in
            ForEach(section.items, id: \.self) { item in
                Text(item)
            }
        }
        .headerStyle(.blurred)

        XCTAssertNotNil(list)
    }

    func testStickyHeaderListBackgroundColorModifier() {
        let sections = [TestStickySection(id: 1, title: "Test", items: ["A"])]

        let list = DSStickyHeaderList(sections) { section in
            Text(section.title)
        } sectionContent: { section in
            ForEach(section.items, id: \.self) { item in
                Text(item)
            }
        }
        .backgroundColor(.gray)

        XCTAssertNotNil(list)
    }
}

// MARK: - Test Helper

private struct TestStickySection: Identifiable {
    let id: Int
    let title: String
    let items: [String]
}
