import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSectionTests: XCTestCase {

    // MARK: - DSSectionHeaderStyle Tests

    func testPlainStyleFont() {
        let style = DSSectionHeaderStyle.plain
        XCTAssertEqual(style.font, .subheadline)
        XCTAssertEqual(style.textColor, DSColors.textPrimary)
        XCTAssertEqual(style.textTransform, .none)
    }

    func testProminentStyleFont() {
        let style = DSSectionHeaderStyle.prominent
        XCTAssertEqual(style.font, .headline)
        XCTAssertEqual(style.textColor, DSColors.textPrimary)
        XCTAssertEqual(style.textTransform, .none)
    }

    func testUppercaseStyleFont() {
        let style = DSSectionHeaderStyle.uppercase
        XCTAssertEqual(style.font, .caption)
        XCTAssertEqual(style.textColor, DSColors.textSecondary)
        XCTAssertEqual(style.textTransform, .uppercase)
    }

    // MARK: - TextTransform Tests

    func testNoneTransform() {
        let transform = TextTransform.none
        XCTAssertEqual(transform.apply(to: "Hello World"), "Hello World")
    }

    func testUppercaseTransform() {
        let transform = TextTransform.uppercase
        XCTAssertEqual(transform.apply(to: "Hello World"), "HELLO WORLD")
    }

    func testLowercaseTransform() {
        let transform = TextTransform.lowercase
        XCTAssertEqual(transform.apply(to: "Hello World"), "hello world")
    }

    func testCapitalizedTransform() {
        let transform = TextTransform.capitalized
        XCTAssertEqual(transform.apply(to: "hello world"), "Hello World")
    }

    // MARK: - DSSection Initialization Tests

    func testSectionWithTextHeader() {
        let section = DSSection(header: "Test Header") {
            Text("Content")
        }
        XCTAssertNotNil(section)
    }

    func testSectionWithTextHeaderAndFooter() {
        let section = DSSection(header: "Header", footer: "Footer") {
            Text("Content")
        }
        XCTAssertNotNil(section)
    }

    func testSectionWithCustomHeaderAndFooter() {
        let section = DSSection {
            Text("Custom Header")
        } footer: {
            Text("Custom Footer")
        } content: {
            Text("Content")
        }
        XCTAssertNotNil(section)
    }

    func testSectionWithEmptyHeaderAndFooter() {
        let section = DSSection {
            Text("Content")
        }
        XCTAssertNotNil(section)
    }

    func testSectionWithOnlyHeader() {
        let section = DSSection {
            Text("Header")
        } content: {
            Text("Content")
        }
        XCTAssertNotNil(section)
    }

    func testSectionWithOnlyFooter() {
        let section = DSSection {
            Text("Footer")
        } content: {
            Text("Content")
        }
        XCTAssertNotNil(section)
    }

    // MARK: - DSSection Modifier Tests

    func testHeaderStyleModifier() {
        let section = DSSection(header: "Test") {
            Text("Content")
        }
        .headerStyle(.prominent)

        XCTAssertNotNil(section)
    }

    func testCollapsibleModifier() {
        let section = DSSection(header: "Test") {
            Text("Content")
        }
        .collapsible()

        XCTAssertNotNil(section)
    }

    func testExpandedModifier() {
        let section = DSSection(header: "Test") {
            Text("Content")
        }
        .collapsible()
        .expanded(false)

        XCTAssertNotNil(section)
    }

    func testBackgroundColorModifier() {
        let section = DSSection(header: "Test") {
            Text("Content")
        }
        .backgroundColor(.blue)

        XCTAssertNotNil(section)
    }

    func testCombinedModifiers() {
        let section = DSSection(header: "Test") {
            Text("Content")
        }
        .headerStyle(.uppercase)
        .collapsible(true)
        .expanded(true)
        .backgroundColor(.white)

        XCTAssertNotNil(section)
    }

    // MARK: - DSSectionHeader Tests

    func testSectionHeaderInitialization() {
        let header = DSSectionHeader("Test Title")
        XCTAssertNotNil(header)
    }

    func testSectionHeaderWithStyle() {
        let header = DSSectionHeader("Test Title", style: .prominent)
        XCTAssertNotNil(header)
    }

    func testSectionHeaderWithTrailingContent() {
        let header = DSSectionHeader("Test Title")
            .trailing {
                Button("Action") { }
            }
        XCTAssertNotNil(header)
    }

    // MARK: - DSSectionFooter Tests

    func testSectionFooterInitialization() {
        let footer = DSSectionFooter("Footer text")
        XCTAssertNotNil(footer)
    }
}
