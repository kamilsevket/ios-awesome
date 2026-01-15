import XCTest
@testable import DesignSystem

// MARK: - DSDetent Tests

final class DSDetentTests: XCTestCase {

    // MARK: - Fraction Tests

    func testSmallDetentFraction() {
        XCTAssertEqual(DSDetent.small.fraction, 0.25)
    }

    func testMediumDetentFraction() {
        XCTAssertEqual(DSDetent.medium.fraction, 0.5)
    }

    func testLargeDetentFraction() {
        XCTAssertEqual(DSDetent.large.fraction, 0.9)
    }

    func testCustomDetentFraction() {
        let custom = DSDetent.custom(0.7)
        XCTAssertEqual(custom.fraction, 0.7)
    }

    func testCustomDetentClampedMinimum() {
        let custom = DSDetent.custom(0.05)
        XCTAssertEqual(custom.fraction, 0.1, "Custom fraction should be clamped to minimum 0.1")
    }

    func testCustomDetentClampedMaximum() {
        let custom = DSDetent.custom(1.5)
        XCTAssertEqual(custom.fraction, 1.0, "Custom fraction should be clamped to maximum 1.0")
    }

    // MARK: - Height Calculation Tests

    func testHeightCalculation() {
        let containerHeight: CGFloat = 1000

        XCTAssertEqual(DSDetent.small.height(in: containerHeight), 250)
        XCTAssertEqual(DSDetent.medium.height(in: containerHeight), 500)
        XCTAssertEqual(DSDetent.large.height(in: containerHeight), 900)
        XCTAssertEqual(DSDetent.custom(0.6).height(in: containerHeight), 600)
    }

    // MARK: - Sorting Tests

    func testDetentsSortedByHeight() {
        let unsorted: [DSDetent] = [.large, .small, .medium]
        let sorted = DSDetent.sorted(unsorted)

        XCTAssertEqual(sorted, [.small, .medium, .large])
    }

    func testSortingWithCustomDetents() {
        let unsorted: [DSDetent] = [.custom(0.8), .small, .custom(0.3)]
        let sorted = DSDetent.sorted(unsorted)

        XCTAssertEqual(sorted[0].fraction, 0.25)
        XCTAssertEqual(sorted[1].fraction, 0.3)
        XCTAssertEqual(sorted[2].fraction, 0.8)
    }

    // MARK: - Closest Detent Tests

    func testClosestDetentExactMatch() {
        let detents: [DSDetent] = [.small, .medium, .large]
        let closest = DSDetent.closest(to: 0.5, in: detents)

        XCTAssertEqual(closest, .medium)
    }

    func testClosestDetentBetweenValues() {
        let detents: [DSDetent] = [.small, .medium, .large]

        // 0.35 is closer to small (0.25) than medium (0.5)
        let closerToSmall = DSDetent.closest(to: 0.35, in: detents)
        XCTAssertEqual(closerToSmall, .small)

        // 0.65 is closer to medium (0.5) than large (0.9)
        let closerToMedium = DSDetent.closest(to: 0.65, in: detents)
        XCTAssertEqual(closerToMedium, .medium)
    }

    func testClosestDetentEmptyArray() {
        let closest = DSDetent.closest(to: 0.5, in: [])
        XCTAssertEqual(closest, .medium, "Should return medium as default for empty array")
    }

    // MARK: - Next Detent Tests

    func testNextLargerDetent() {
        let detents: [DSDetent] = [.small, .medium, .large]

        XCTAssertEqual(DSDetent.nextLarger(from: .small, in: detents), .medium)
        XCTAssertEqual(DSDetent.nextLarger(from: .medium, in: detents), .large)
        XCTAssertNil(DSDetent.nextLarger(from: .large, in: detents))
    }

    func testNextSmallerDetent() {
        let detents: [DSDetent] = [.small, .medium, .large]

        XCTAssertNil(DSDetent.nextSmaller(from: .small, in: detents))
        XCTAssertEqual(DSDetent.nextSmaller(from: .medium, in: detents), .small)
        XCTAssertEqual(DSDetent.nextSmaller(from: .large, in: detents), .medium)
    }

    func testNextDetentNotInArray() {
        let detents: [DSDetent] = [.small, .large]

        XCTAssertNil(DSDetent.nextLarger(from: .medium, in: detents))
        XCTAssertNil(DSDetent.nextSmaller(from: .medium, in: detents))
    }

    // MARK: - Hashable Tests

    func testDetentHashable() {
        var set = Set<DSDetent>()
        set.insert(.small)
        set.insert(.medium)
        set.insert(.large)
        set.insert(.custom(0.7))

        XCTAssertEqual(set.count, 4)
    }

    func testDuplicateDetentsInSet() {
        var set = Set<DSDetent>()
        set.insert(.medium)
        set.insert(.medium)

        XCTAssertEqual(set.count, 1)
    }

    func testCustomDetentEquality() {
        let custom1 = DSDetent.custom(0.7)
        let custom2 = DSDetent.custom(0.7)
        let custom3 = DSDetent.custom(0.8)

        XCTAssertEqual(custom1, custom2)
        XCTAssertNotEqual(custom1, custom3)
    }

    // MARK: - Default Detent Sets Tests

    func testStandardDetentSet() {
        XCTAssertEqual(DSDetent.standard, [.medium, .large])
    }

    func testFullRangeDetentSet() {
        XCTAssertEqual(DSDetent.fullRange, [.small, .medium, .large])
    }

    func testMediumOnlyDetentSet() {
        XCTAssertEqual(DSDetent.mediumOnly, [.medium])
    }

    func testLargeOnlyDetentSet() {
        XCTAssertEqual(DSDetent.largeOnly, [.large])
    }
}
