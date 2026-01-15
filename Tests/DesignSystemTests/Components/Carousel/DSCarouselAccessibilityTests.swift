import XCTest
import SwiftUI
@testable import DesignSystem

final class DSCarouselAccessibilityTests: XCTestCase {

    // MARK: - DSCarouselAccessibility Label Tests

    func testCarouselLabel() {
        let label = DSCarouselAccessibility.carouselLabel(itemCount: 5, currentIndex: 2)
        XCTAssertEqual(label, "Carousel with 5 items, currently showing item 3 of 5")
    }

    func testCarouselLabelFirstItem() {
        let label = DSCarouselAccessibility.carouselLabel(itemCount: 10, currentIndex: 0)
        XCTAssertEqual(label, "Carousel with 10 items, currently showing item 1 of 10")
    }

    func testCarouselLabelLastItem() {
        let label = DSCarouselAccessibility.carouselLabel(itemCount: 5, currentIndex: 4)
        XCTAssertEqual(label, "Carousel with 5 items, currently showing item 5 of 5")
    }

    func testCarouselLabelSingleItem() {
        let label = DSCarouselAccessibility.carouselLabel(itemCount: 1, currentIndex: 0)
        XCTAssertEqual(label, "Carousel with 1 items, currently showing item 1 of 1")
    }

    // MARK: - Navigation Hint Tests

    func testNavigationHint() {
        let hint = DSCarouselAccessibility.navigationHint
        XCTAssertFalse(hint.isEmpty)
        XCTAssertTrue(hint.contains("Swipe"))
    }

    // MARK: - Page Indicator Label Tests

    func testPageIndicatorLabel() {
        let label = DSCarouselAccessibility.pageIndicatorLabel(currentPage: 1, totalPages: 5)
        XCTAssertEqual(label, "Page 2 of 5")
    }

    func testPageIndicatorLabelFirstPage() {
        let label = DSCarouselAccessibility.pageIndicatorLabel(currentPage: 0, totalPages: 10)
        XCTAssertEqual(label, "Page 1 of 10")
    }

    func testPageIndicatorLabelLastPage() {
        let label = DSCarouselAccessibility.pageIndicatorLabel(currentPage: 4, totalPages: 5)
        XCTAssertEqual(label, "Page 5 of 5")
    }

    // MARK: - Page Indicator Hint Tests

    func testPageIndicatorHint() {
        let hint = DSCarouselAccessibility.pageIndicatorHint
        XCTAssertFalse(hint.isEmpty)
        XCTAssertTrue(hint.contains("tap"))
    }

    // MARK: - View Modifier Tests

    func testCarouselAccessibilityModifier() {
        var previousCalled = false
        var nextCalled = false

        let view = Text("Test")
            .dsCarouselAccessibility(
                itemCount: 5,
                currentIndex: 2,
                onPrevious: { previousCalled = true },
                onNext: { nextCalled = true }
            )

        XCTAssertNotNil(view)
        XCTAssertFalse(previousCalled)
        XCTAssertFalse(nextCalled)
    }

    func testReduceMotionModifier() {
        let view = Text("Test")
            .dsReduceMotionAnimation(duration: 0.5, reducedDuration: 0.0)

        XCTAssertNotNil(view)
    }

    func testReduceMotionModifierDefaultValues() {
        let view = Text("Test")
            .dsReduceMotionAnimation()

        XCTAssertNotNil(view)
    }

    func testAnnounceModifier() {
        let view = Text("Test")
            .dsAnnounce("Test announcement")

        XCTAssertNotNil(view)
    }

    func testAnnouncePageChangeModifier() {
        let view = Text("Test")
            .dsAnnouncePageChange(currentPage: 2, totalPages: 5)

        XCTAssertNotNil(view)
    }
}
