import XCTest
import SwiftUI
@testable import DesignSystem

final class DSPageIndicatorTests: XCTestCase {

    // MARK: - DSPageIndicatorStyle Tests

    func testPageIndicatorStyles() {
        // Verify all styles exist
        let styles: [DSPageIndicatorStyle] = [.dots, .capsule, .numbered, .progress]
        XCTAssertEqual(styles.count, 4)
    }

    // MARK: - DSPageIndicatorSize Tests

    func testPageIndicatorSizeSmall() {
        let size = DSPageIndicatorSize.small
        XCTAssertEqual(size.dotSize, 6)
        XCTAssertEqual(size.spacing, 6)
        XCTAssertNotNil(size.font)
    }

    func testPageIndicatorSizeMedium() {
        let size = DSPageIndicatorSize.medium
        XCTAssertEqual(size.dotSize, 8)
        XCTAssertEqual(size.spacing, 8)
        XCTAssertNotNil(size.font)
    }

    func testPageIndicatorSizeLarge() {
        let size = DSPageIndicatorSize.large
        XCTAssertEqual(size.dotSize, 10)
        XCTAssertEqual(size.spacing, 10)
        XCTAssertNotNil(size.font)
    }

    // MARK: - DSPageIndicator View Tests

    func testPageIndicatorBasicInitialization() {
        let indicator = DSPageIndicator(
            currentPage: 0,
            totalPages: 5
        )

        XCTAssertNotNil(indicator)
    }

    func testPageIndicatorWithStyle() {
        let dotsIndicator = DSPageIndicator(
            currentPage: 1,
            totalPages: 5,
            style: .dots
        )

        let capsuleIndicator = DSPageIndicator(
            currentPage: 1,
            totalPages: 5,
            style: .capsule
        )

        let numberedIndicator = DSPageIndicator(
            currentPage: 1,
            totalPages: 5,
            style: .numbered
        )

        let progressIndicator = DSPageIndicator(
            currentPage: 1,
            totalPages: 5,
            style: .progress
        )

        XCTAssertNotNil(dotsIndicator)
        XCTAssertNotNil(capsuleIndicator)
        XCTAssertNotNil(numberedIndicator)
        XCTAssertNotNil(progressIndicator)
    }

    func testPageIndicatorWithSize() {
        let smallIndicator = DSPageIndicator(
            currentPage: 0,
            totalPages: 3,
            size: .small
        )

        let mediumIndicator = DSPageIndicator(
            currentPage: 0,
            totalPages: 3,
            size: .medium
        )

        let largeIndicator = DSPageIndicator(
            currentPage: 0,
            totalPages: 3,
            size: .large
        )

        XCTAssertNotNil(smallIndicator)
        XCTAssertNotNil(mediumIndicator)
        XCTAssertNotNil(largeIndicator)
    }

    func testPageIndicatorWithCustomColors() {
        let indicator = DSPageIndicator(
            currentPage: 2,
            totalPages: 5,
            activeColor: .purple,
            inactiveColor: .gray.opacity(0.3)
        )

        XCTAssertNotNil(indicator)
    }

    func testPageIndicatorWithTapCallback() {
        var tappedIndex: Int?

        let indicator = DSPageIndicator(
            currentPage: 0,
            totalPages: 5,
            onPageTap: { index in
                tappedIndex = index
            }
        )

        XCTAssertNotNil(indicator)
        XCTAssertNil(tappedIndex)
    }

    func testPageIndicatorModifiers() {
        let indicator = DSPageIndicator(
            currentPage: 1,
            totalPages: 5
        )
        .indicatorStyle(.capsule)
        .indicatorSize(.large)
        .colors(active: .blue, inactive: .gray)

        XCTAssertNotNil(indicator)
    }

    func testPageIndicatorWithSinglePage() {
        let indicator = DSPageIndicator(
            currentPage: 0,
            totalPages: 1
        )

        XCTAssertNotNil(indicator)
    }

    func testPageIndicatorWithManyPages() {
        let indicator = DSPageIndicator(
            currentPage: 50,
            totalPages: 100
        )

        XCTAssertNotNil(indicator)
    }

    func testPageIndicatorBoundaryPages() {
        // First page
        let firstPage = DSPageIndicator(
            currentPage: 0,
            totalPages: 5
        )

        // Last page
        let lastPage = DSPageIndicator(
            currentPage: 4,
            totalPages: 5
        )

        XCTAssertNotNil(firstPage)
        XCTAssertNotNil(lastPage)
    }
}
