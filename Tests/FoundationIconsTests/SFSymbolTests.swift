import XCTest
import SwiftUI
@testable import FoundationIcons

final class SFSymbolTests: XCTestCase {

    // MARK: - Raw Value Tests

    func testNavigationSymbolsHaveValidRawValues() {
        XCTAssertEqual(SFSymbol.chevronLeft.rawValue, "chevron.left")
        XCTAssertEqual(SFSymbol.chevronRight.rawValue, "chevron.right")
        XCTAssertEqual(SFSymbol.chevronUp.rawValue, "chevron.up")
        XCTAssertEqual(SFSymbol.chevronDown.rawValue, "chevron.down")
        XCTAssertEqual(SFSymbol.arrowLeft.rawValue, "arrow.left")
        XCTAssertEqual(SFSymbol.arrowRight.rawValue, "arrow.right")
    }

    func testActionSymbolsHaveValidRawValues() {
        XCTAssertEqual(SFSymbol.plus.rawValue, "plus")
        XCTAssertEqual(SFSymbol.minus.rawValue, "minus")
        XCTAssertEqual(SFSymbol.xmark.rawValue, "xmark")
        XCTAssertEqual(SFSymbol.checkmark.rawValue, "checkmark")
        XCTAssertEqual(SFSymbol.trash.rawValue, "trash")
        XCTAssertEqual(SFSymbol.pencil.rawValue, "pencil")
    }

    func testObjectSymbolsHaveValidRawValues() {
        XCTAssertEqual(SFSymbol.heart.rawValue, "heart")
        XCTAssertEqual(SFSymbol.heartFill.rawValue, "heart.fill")
        XCTAssertEqual(SFSymbol.star.rawValue, "star")
        XCTAssertEqual(SFSymbol.starFill.rawValue, "star.fill")
        XCTAssertEqual(SFSymbol.bookmark.rawValue, "bookmark")
        XCTAssertEqual(SFSymbol.bell.rawValue, "bell")
    }

    func testSystemSymbolsHaveValidRawValues() {
        XCTAssertEqual(SFSymbol.gear.rawValue, "gear")
        XCTAssertEqual(SFSymbol.gearshape.rawValue, "gearshape")
        XCTAssertEqual(SFSymbol.ellipsis.rawValue, "ellipsis")
        XCTAssertEqual(SFSymbol.info.rawValue, "info")
        XCTAssertEqual(SFSymbol.questionmark.rawValue, "questionmark")
    }

    // MARK: - System Name Tests

    func testSystemNameMatchesRawValue() {
        for symbol in SFSymbol.allCases {
            XCTAssertEqual(symbol.systemName, symbol.rawValue)
        }
    }

    // MARK: - All Cases Tests

    func testAllCasesIsNotEmpty() {
        XCTAssertFalse(SFSymbol.allCases.isEmpty)
    }

    func testAllCasesHasExpectedCount() {
        // We have a large number of symbols defined
        XCTAssertGreaterThan(SFSymbol.allCases.count, 200)
    }

    // MARK: - Uniqueness Tests

    func testAllRawValuesAreUnique() {
        let rawValues = SFSymbol.allCases.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        XCTAssertEqual(rawValues.count, uniqueValues.count, "Duplicate raw values found")
    }

    // MARK: - Image Creation Tests

    func testImageInitializerCreatesImage() {
        let image = Image(sfSymbol: .heart)
        XCTAssertNotNil(image)
    }

    // MARK: - Category Coverage Tests

    func testNavigationCategoryExists() {
        let navigationSymbols: [SFSymbol] = [
            .chevronLeft, .chevronRight, .chevronUp, .chevronDown,
            .arrowLeft, .arrowRight, .arrowUp, .arrowDown
        ]
        for symbol in navigationSymbols {
            XCTAssertTrue(SFSymbol.allCases.contains(symbol))
        }
    }

    func testMediaCategoryExists() {
        let mediaSymbols: [SFSymbol] = [
            .play, .playFill, .pause, .pauseFill,
            .stop, .backward, .forward
        ]
        for symbol in mediaSymbols {
            XCTAssertTrue(SFSymbol.allCases.contains(symbol))
        }
    }

    func testSecurityCategoryExists() {
        let securitySymbols: [SFSymbol] = [
            .lock, .lockFill, .lockOpen, .key,
            .shield, .faceid, .touchid
        ]
        for symbol in securitySymbols {
            XCTAssertTrue(SFSymbol.allCases.contains(symbol))
        }
    }
}
