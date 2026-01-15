import XCTest
import SwiftUI
@testable import DesignSystemTypography

final class DSFontWeightTests: XCTestCase {
    // MARK: - Numeric Value Tests

    func testNumericValues() {
        XCTAssertEqual(DSFontWeight.ultraLight.numericValue, 100)
        XCTAssertEqual(DSFontWeight.thin.numericValue, 200)
        XCTAssertEqual(DSFontWeight.light.numericValue, 300)
        XCTAssertEqual(DSFontWeight.regular.numericValue, 400)
        XCTAssertEqual(DSFontWeight.medium.numericValue, 500)
        XCTAssertEqual(DSFontWeight.semibold.numericValue, 600)
        XCTAssertEqual(DSFontWeight.bold.numericValue, 700)
        XCTAssertEqual(DSFontWeight.heavy.numericValue, 800)
        XCTAssertEqual(DSFontWeight.black.numericValue, 900)
    }

    func testNumericValuesAreIncreasing() {
        let weights = DSFontWeight.allCases
        for i in 0..<(weights.count - 1) {
            XCTAssertLessThan(weights[i].numericValue, weights[i + 1].numericValue,
                             "\(weights[i].rawValue) should be lighter than \(weights[i + 1].rawValue)")
        }
    }

    // MARK: - Initialization from Numeric Value Tests

    func testInitFromNumericValue() {
        XCTAssertEqual(DSFontWeight(numericValue: 100), .ultraLight)
        XCTAssertEqual(DSFontWeight(numericValue: 200), .thin)
        XCTAssertEqual(DSFontWeight(numericValue: 400), .regular)
        XCTAssertEqual(DSFontWeight(numericValue: 700), .bold)
        XCTAssertEqual(DSFontWeight(numericValue: 900), .black)
    }

    func testInitFromNumericValueEdgeCases() {
        // Very low value
        XCTAssertEqual(DSFontWeight(numericValue: 50), .ultraLight)

        // Very high value
        XCTAssertEqual(DSFontWeight(numericValue: 1000), .black)

        // Mid-range values should round to nearest
        XCTAssertEqual(DSFontWeight(numericValue: 350), .light)
        XCTAssertEqual(DSFontWeight(numericValue: 450), .regular)
        XCTAssertEqual(DSFontWeight(numericValue: 550), .medium)
    }

    // MARK: - SwiftUI Weight Conversion Tests

    func testSwiftUIWeightConversion() {
        XCTAssertEqual(DSFontWeight.ultraLight.swiftUIWeight, Font.Weight.ultraLight)
        XCTAssertEqual(DSFontWeight.regular.swiftUIWeight, Font.Weight.regular)
        XCTAssertEqual(DSFontWeight.bold.swiftUIWeight, Font.Weight.bold)
        XCTAssertEqual(DSFontWeight.black.swiftUIWeight, Font.Weight.black)
    }

    // MARK: - All Cases Tests

    func testAllCasesCount() {
        XCTAssertEqual(DSFontWeight.allCases.count, 9)
    }

    func testAllCasesHaveUniqueRawValues() {
        let rawValues = DSFontWeight.allCases.map { $0.rawValue }
        let uniqueRawValues = Set(rawValues)
        XCTAssertEqual(rawValues.count, uniqueRawValues.count)
    }
}
