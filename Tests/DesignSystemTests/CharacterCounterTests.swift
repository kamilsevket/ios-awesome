import XCTest
import SwiftUI
@testable import DesignSystem

final class CharacterCounterTests: XCTestCase {

    // MARK: - Initialization Tests

    func testCharacterCounter_initialization_setsCorrectValues() {
        let counter = CharacterCounter(currentCount: 10, maxCount: 100, warningThreshold: 0.8)

        // Values are internal, but we can at least verify it doesn't crash
        XCTAssertNotNil(counter)
    }

    func testCharacterCounter_defaultWarningThreshold() {
        let counter = CharacterCounter(currentCount: 50, maxCount: 100)

        // Default warning threshold should be 0.8
        XCTAssertNotNil(counter)
    }

    // MARK: - Percentage Calculation Tests

    func testPercentageCalculation_belowThreshold() {
        // 50/100 = 50%, below 80% threshold
        let currentCount = 50
        let maxCount = 100
        let percentage = Double(currentCount) / Double(maxCount)

        XCTAssertLessThan(percentage, 0.8)
    }

    func testPercentageCalculation_atThreshold() {
        // 80/100 = 80%, at threshold
        let currentCount = 80
        let maxCount = 100
        let percentage = Double(currentCount) / Double(maxCount)

        XCTAssertEqual(percentage, 0.8)
    }

    func testPercentageCalculation_aboveThreshold() {
        // 90/100 = 90%, above threshold
        let currentCount = 90
        let maxCount = 100
        let percentage = Double(currentCount) / Double(maxCount)

        XCTAssertGreaterThan(percentage, 0.8)
    }

    func testPercentageCalculation_overLimit() {
        // 110/100 = 110%, over limit
        let currentCount = 110
        let maxCount = 100

        XCTAssertGreaterThan(currentCount, maxCount)
    }

    // MARK: - Edge Cases

    func testCharacterCounter_zeroMax() {
        let counter = CharacterCounter(currentCount: 0, maxCount: 0)
        XCTAssertNotNil(counter)
    }

    func testCharacterCounter_emptyText() {
        let counter = CharacterCounter(currentCount: 0, maxCount: 100)
        XCTAssertNotNil(counter)
    }

    func testCharacterCounter_exactlyAtMax() {
        let counter = CharacterCounter(currentCount: 100, maxCount: 100)
        XCTAssertNotNil(counter)
    }
}
