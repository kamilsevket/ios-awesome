import XCTest
import SwiftUI
@testable import IOSComponents

final class CardTests: XCTestCase {

    // MARK: - Card Style Background Color Tests

    func testElevatedStyle_HasSystemBackgroundColor() {
        let style = Card<Text>.CardStyle.elevated
        XCTAssertEqual(style.backgroundColor, Color(.systemBackground))
    }

    func testOutlinedStyle_HasSystemBackgroundColor() {
        let style = Card<Text>.CardStyle.outlined
        XCTAssertEqual(style.backgroundColor, Color(.systemBackground))
    }

    func testFilledStyle_HasGrayBackgroundColor() {
        let style = Card<Text>.CardStyle.filled
        XCTAssertEqual(style.backgroundColor, Color(.systemGray6))
    }

    // MARK: - Card Style Shadow Tests

    func testElevatedStyle_HasShadow() {
        let style = Card<Text>.CardStyle.elevated
        XCTAssertEqual(style.shadowRadius, 4)
    }

    func testOutlinedStyle_HasNoShadow() {
        let style = Card<Text>.CardStyle.outlined
        XCTAssertEqual(style.shadowRadius, 0)
    }

    func testFilledStyle_HasNoShadow() {
        let style = Card<Text>.CardStyle.filled
        XCTAssertEqual(style.shadowRadius, 0)
    }

    // MARK: - Card Style Border Tests

    func testElevatedStyle_HasNoBorder() {
        let style = Card<Text>.CardStyle.elevated
        XCTAssertEqual(style.borderWidth, 0)
    }

    func testOutlinedStyle_HasBorder() {
        let style = Card<Text>.CardStyle.outlined
        XCTAssertEqual(style.borderWidth, 1)
    }

    func testFilledStyle_HasNoBorder() {
        let style = Card<Text>.CardStyle.filled
        XCTAssertEqual(style.borderWidth, 0)
    }

    // MARK: - Card Initialization Tests

    func testCardWithDefaultStyle_CreatesView() {
        let card = Card {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testCardWithElevatedStyle_CreatesView() {
        let card = Card(style: .elevated) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testCardWithOutlinedStyle_CreatesView() {
        let card = Card(style: .outlined) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testCardWithFilledStyle_CreatesView() {
        let card = Card(style: .filled) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    func testCardWithOnTap_CreatesView() {
        var tapped = false
        let card = Card(onTap: { tapped = true }) {
            Text("Content")
        }
        XCTAssertNotNil(card)
    }

    // MARK: - Card Body Tests

    func testCardBody_ReturnsView() {
        let card = Card {
            Text("Content")
        }
        let body = card.body
        XCTAssertNotNil(body)
    }

    func testTappableCardBody_ReturnsView() {
        let card = Card(onTap: {}) {
            Text("Content")
        }
        let body = card.body
        XCTAssertNotNil(body)
    }
}
