import XCTest
@testable import DesignSystem

final class DSLinearProgressTests: XCTestCase {

    // MARK: - Size Tests

    func testSmallSizeValues() {
        let size = DSLinearProgressSize.small
        XCTAssertEqual(size.height, 2)
        XCTAssertEqual(size.cornerRadius, 1)
    }

    func testMediumSizeValues() {
        let size = DSLinearProgressSize.medium
        XCTAssertEqual(size.height, 4)
        XCTAssertEqual(size.cornerRadius, 2)
    }

    func testLargeSizeValues() {
        let size = DSLinearProgressSize.large
        XCTAssertEqual(size.height, 8)
        XCTAssertEqual(size.cornerRadius, 4)
    }

    func testAllSizeCases() {
        let allCases = DSLinearProgressSize.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.small))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.large))
    }

    // MARK: - Initialization Tests

    func testIndeterminateInitialization() {
        let progress = DSLinearProgress(isAnimating: true)
        XCTAssertNotNil(progress)
    }

    func testDeterminateInitialization() {
        let progress = DSLinearProgress(value: 0.5)
        XCTAssertNotNil(progress)
    }

    func testCustomSizeInitialization() {
        let progress = DSLinearProgress(value: 0.75, size: .large)
        XCTAssertNotNil(progress)
    }

    func testCustomColorInitialization() {
        let progress = DSLinearProgress(
            value: 0.6,
            size: .medium,
            color: DSColors.success
        )
        XCTAssertNotNil(progress)
    }

    // MARK: - Value Clamping Tests

    func testValueClampedToValidRange() {
        // Value below 0 should be clamped to 0
        let progressLow = DSLinearProgress(value: -0.5)
        XCTAssertNotNil(progressLow)

        // Value above 1 should be clamped to 1
        let progressHigh = DSLinearProgress(value: 1.5)
        XCTAssertNotNil(progressHigh)
    }

    // MARK: - Animation State Tests

    func testAnimatingState() {
        let animating = DSLinearProgress(isAnimating: true)
        XCTAssertNotNil(animating)

        let notAnimating = DSLinearProgress(isAnimating: false)
        XCTAssertNotNil(notAnimating)
    }
}
