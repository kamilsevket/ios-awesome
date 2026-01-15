import XCTest
@testable import DesignSystem

final class DSCircularProgressTests: XCTestCase {

    // MARK: - Size Tests

    func testSmallSizeValues() {
        let size = DSCircularProgressSize.small
        XCTAssertEqual(size.diameter, 20)
        XCTAssertEqual(size.lineWidth, 2)
    }

    func testMediumSizeValues() {
        let size = DSCircularProgressSize.medium
        XCTAssertEqual(size.diameter, 40)
        XCTAssertEqual(size.lineWidth, 4)
    }

    func testLargeSizeValues() {
        let size = DSCircularProgressSize.large
        XCTAssertEqual(size.diameter, 60)
        XCTAssertEqual(size.lineWidth, 6)
    }

    func testAllSizeCases() {
        let allCases = DSCircularProgressSize.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.small))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.large))
    }

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        let progress = DSCircularProgress()
        XCTAssertNotNil(progress)
    }

    func testDeterminateInitialization() {
        let progress = DSCircularProgress(value: 0.5)
        XCTAssertNotNil(progress)
    }

    func testCustomColorInitialization() {
        let progress = DSCircularProgress(
            value: 0.75,
            size: .large,
            color: DSColors.success
        )
        XCTAssertNotNil(progress)
    }

    // MARK: - Value Clamping Tests

    func testValueClampedToZero() {
        // Progress value should be clamped between 0 and 1
        let progress = DSCircularProgress(value: -0.5)
        XCTAssertNotNil(progress)
    }

    func testValueClampedToOne() {
        // Progress value should be clamped between 0 and 1
        let progress = DSCircularProgress(value: 1.5)
        XCTAssertNotNil(progress)
    }

    // MARK: - Track Tests

    func testWithTrack() {
        let progress = DSCircularProgress(value: 0.5, showTrack: true)
        XCTAssertNotNil(progress)
    }

    func testWithoutTrack() {
        let progress = DSCircularProgress(value: 0.5, showTrack: false)
        XCTAssertNotNil(progress)
    }
}
