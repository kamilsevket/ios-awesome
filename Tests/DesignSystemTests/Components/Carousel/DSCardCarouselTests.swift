import XCTest
import SwiftUI
@testable import DesignSystem

final class DSCardCarouselTests: XCTestCase {

    // MARK: - DSCardCarouselConfiguration Tests

    func testDefaultConfiguration() {
        let config = DSCardCarouselConfiguration()

        XCTAssertEqual(config.cardSpacing, -40)
        XCTAssertEqual(config.scaleEffect, 0.85)
        XCTAssertEqual(config.opacityEffect, 0.6)
        XCTAssertEqual(config.rotationDegrees, 15)
        XCTAssertTrue(config.showIndicators)
        XCTAssertTrue(config.isLoopEnabled)
        XCTAssertNil(config.autoScrollInterval)
        XCTAssertTrue(config.enable3DEffect)
    }

    func testCustomConfiguration() {
        let config = DSCardCarouselConfiguration(
            cardSpacing: -60,
            scaleEffect: 0.9,
            opacityEffect: 0.7,
            rotationDegrees: 20,
            showIndicators: false,
            indicatorStyle: .progress,
            isLoopEnabled: false,
            autoScrollInterval: 4.0,
            enable3DEffect: false
        )

        XCTAssertEqual(config.cardSpacing, -60)
        XCTAssertEqual(config.scaleEffect, 0.9)
        XCTAssertEqual(config.opacityEffect, 0.7)
        XCTAssertEqual(config.rotationDegrees, 20)
        XCTAssertFalse(config.showIndicators)
        XCTAssertFalse(config.isLoopEnabled)
        XCTAssertEqual(config.autoScrollInterval, 4.0)
        XCTAssertFalse(config.enable3DEffect)
    }

    // MARK: - DSCardCarousel View Tests

    func testCardCarouselBasicInitialization() {
        let cards = ["Card 1", "Card 2", "Card 3"]

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithIdentifiableData() {
        struct TestCard: Identifiable {
            let id = UUID()
            let title: String
        }

        let cards = [
            TestCard(title: "Card 1"),
            TestCard(title: "Card 2"),
            TestCard(title: "Card 3")
        ]

        let carousel = DSCardCarousel(cards) { card in
            Text(card.title)
        }

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselModifierChaining() {
        let cards = ["Card 1", "Card 2", "Card 3"]

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }
        .cardHeight(300)
        .cardSpacing(-50)
        .scaleEffect(0.85)
        .opacityEffect(0.7)
        .enable3DEffect(true)
        .rotationDegrees(20)
        .showIndicators(true)
        .indicatorStyle(.capsule)
        .loopEnabled(true)
        .autoScroll(interval: 3.0)

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithCustomConfiguration() {
        let cards = ["Card 1", "Card 2"]

        let config = DSCardCarouselConfiguration(
            cardSpacing: -30,
            scaleEffect: 0.9,
            enable3DEffect: false
        )

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }
        .configuration(config)

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithEmptyData() {
        let cards: [String] = []

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithSingleCard() {
        let cards = ["Only Card"]

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWith3DEffectDisabled() {
        let cards = ["Card 1", "Card 2", "Card 3"]

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }
        .enable3DEffect(false)

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithDifferentIndicatorStyles() {
        let cards = ["Card 1", "Card 2", "Card 3"]

        let styles: [DSPageIndicatorStyle] = [.dots, .capsule, .numbered, .progress]

        for style in styles {
            let carousel = DSCardCarousel(cards, id: \.self) { card in
                Text(card)
            }
            .indicatorStyle(style)

            XCTAssertNotNil(carousel)
        }
    }

    func testCardCarouselWithHiddenIndicators() {
        let cards = ["Card 1", "Card 2", "Card 3"]

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }
        .showIndicators(false)

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithAutoScroll() {
        let cards = ["Card 1", "Card 2", "Card 3"]

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }
        .autoScroll(interval: 2.5)
        .loopEnabled(true)

        XCTAssertNotNil(carousel)
    }

    func testCardCarouselWithCustomCardHeight() {
        let cards = ["Card 1", "Card 2"]

        let heights: [CGFloat] = [150, 200, 300, 400]

        for height in heights {
            let carousel = DSCardCarousel(cards, id: \.self) { card in
                Text(card)
            }
            .cardHeight(height)

            XCTAssertNotNil(carousel)
        }
    }

    func testCardCarouselWithManyCards() {
        let cards = Array(1...20).map { "Card \($0)" }

        let carousel = DSCardCarousel(cards, id: \.self) { card in
            Text(card)
        }

        XCTAssertNotNil(carousel)
    }
}
