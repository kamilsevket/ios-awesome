import XCTest
import SwiftUI
@testable import DesignSystem

final class DSCarouselTests: XCTestCase {

    // MARK: - DSCarousel Configuration Tests

    func testDefaultConfiguration() {
        let config = DSCarouselConfiguration()

        XCTAssertEqual(config.itemSpacing, Spacing.md)
        XCTAssertEqual(config.horizontalPadding, Spacing.md)
        XCTAssertTrue(config.showIndicators)
        XCTAssertFalse(config.isLoopEnabled)
        XCTAssertFalse(config.showPeek)
        XCTAssertEqual(config.peekAmount, 20)
        XCTAssertTrue(config.snapEnabled)
        XCTAssertNil(config.autoScrollInterval)
        XCTAssertTrue(config.pauseAutoScrollOnInteraction)
    }

    func testCustomConfiguration() {
        let config = DSCarouselConfiguration(
            itemSpacing: 24,
            horizontalPadding: 32,
            showIndicators: false,
            isLoopEnabled: true,
            showPeek: true,
            peekAmount: 40,
            snapEnabled: false,
            autoScrollInterval: 5.0,
            pauseAutoScrollOnInteraction: false
        )

        XCTAssertEqual(config.itemSpacing, 24)
        XCTAssertEqual(config.horizontalPadding, 32)
        XCTAssertFalse(config.showIndicators)
        XCTAssertTrue(config.isLoopEnabled)
        XCTAssertTrue(config.showPeek)
        XCTAssertEqual(config.peekAmount, 40)
        XCTAssertFalse(config.snapEnabled)
        XCTAssertEqual(config.autoScrollInterval, 5.0)
        XCTAssertFalse(config.pauseAutoScrollOnInteraction)
    }

    // MARK: - DSCarousel View Tests

    func testCarouselInitializationWithIdKeyPath() {
        let items = ["Item 1", "Item 2", "Item 3"]

        let carousel = DSCarousel(items, id: \.self) { item in
            Text(item)
        }

        XCTAssertNotNil(carousel)
    }

    func testCarouselModifierChaining() {
        let items = ["Item 1", "Item 2", "Item 3"]

        let carousel = DSCarousel(items, id: \.self) { item in
            Text(item)
        }
        .showIndicators(true)
        .autoScroll(interval: 3.0)
        .loopEnabled(true)
        .showPeek(30)
        .itemSpacing(20)
        .horizontalPadding(24)
        .snapEnabled(true)
        .pauseAutoScrollOnInteraction(true)

        XCTAssertNotNil(carousel)
    }

    func testCarouselWithIdentifiableData() {
        struct TestItem: Identifiable {
            let id = UUID()
            let title: String
        }

        let items = [
            TestItem(title: "Item 1"),
            TestItem(title: "Item 2"),
            TestItem(title: "Item 3")
        ]

        let carousel = DSCarousel(items) { item in
            Text(item.title)
        }

        XCTAssertNotNil(carousel)
    }

    func testCarouselWithCustomConfiguration() {
        let items = ["Item 1", "Item 2"]

        let config = DSCarouselConfiguration(
            itemSpacing: 12,
            showIndicators: false,
            isLoopEnabled: true
        )

        let carousel = DSCarousel(items, id: \.self) { item in
            Text(item)
        }
        .configuration(config)

        XCTAssertNotNil(carousel)
    }

    func testCarouselWithEmptyData() {
        let items: [String] = []

        let carousel = DSCarousel(items, id: \.self) { item in
            Text(item)
        }

        XCTAssertNotNil(carousel)
    }

    func testCarouselWithSingleItem() {
        let items = ["Only Item"]

        let carousel = DSCarousel(items, id: \.self) { item in
            Text(item)
        }

        XCTAssertNotNil(carousel)
    }
}
