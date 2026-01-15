import XCTest
import SwiftUI
@testable import DesignSystem

final class DSPageViewTests: XCTestCase {

    // MARK: - DSPageViewConfiguration Tests

    func testDefaultConfiguration() {
        let config = DSPageViewConfiguration()

        XCTAssertTrue(config.showIndicators)
        XCTAssertTrue(config.swipeEnabled)
        XCTAssertTrue(config.programmaticNavigation)
        XCTAssertEqual(config.animationDuration, 0.3)
    }

    func testCustomConfiguration() {
        let config = DSPageViewConfiguration(
            showIndicators: false,
            indicatorStyle: .capsule,
            indicatorPosition: .overlay,
            swipeEnabled: false,
            programmaticNavigation: false,
            animationDuration: 0.5
        )

        XCTAssertFalse(config.showIndicators)
        XCTAssertFalse(config.swipeEnabled)
        XCTAssertFalse(config.programmaticNavigation)
        XCTAssertEqual(config.animationDuration, 0.5)
    }

    // MARK: - DSPageIndicatorPosition Tests

    func testIndicatorPositions() {
        let positions: [DSPageIndicatorPosition] = [.top, .bottom, .overlay]
        XCTAssertEqual(positions.count, 3)
    }

    // MARK: - DSPageView View Tests

    func testPageViewInitializationWithBinding() {
        let pages = ["Page 1", "Page 2", "Page 3"]
        var currentPage = 0

        let pageView = DSPageView(
            pages,
            id: \.self,
            currentPage: .init(get: { currentPage }, set: { currentPage = $0 })
        ) { page in
            Text(page)
        }

        XCTAssertNotNil(pageView)
    }

    func testPageViewInitializationWithInternalState() {
        let pages = ["Page 1", "Page 2", "Page 3"]

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }

        XCTAssertNotNil(pageView)
    }

    func testPageViewModifierChaining() {
        let pages = ["Page 1", "Page 2", "Page 3"]

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }
        .indicatorStyle(.capsule)
        .indicatorPosition(.overlay)
        .showIndicators(true)
        .swipeEnabled(true)
        .animationDuration(0.4)

        XCTAssertNotNil(pageView)
    }

    func testPageViewWithIdentifiableData() {
        struct TestPage: Identifiable {
            let id = UUID()
            let title: String
        }

        let pages = [
            TestPage(title: "Page 1"),
            TestPage(title: "Page 2"),
            TestPage(title: "Page 3")
        ]

        let pageView = DSPageView(
            pages: pages,
            currentPage: .constant(0)
        ) { page in
            Text(page.title)
        }

        XCTAssertNotNil(pageView)
    }

    func testPageViewWithCustomConfiguration() {
        let pages = ["Page 1", "Page 2"]

        let config = DSPageViewConfiguration(
            showIndicators: true,
            indicatorStyle: .numbered,
            indicatorPosition: .top
        )

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }
        .configuration(config)

        XCTAssertNotNil(pageView)
    }

    func testPageViewWithEmptyData() {
        let pages: [String] = []

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }

        XCTAssertNotNil(pageView)
    }

    func testPageViewWithSinglePage() {
        let pages = ["Only Page"]

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }

        XCTAssertNotNil(pageView)
    }

    func testPageViewIndicatorStyles() {
        let pages = ["Page 1", "Page 2", "Page 3"]

        let styles: [DSPageIndicatorStyle] = [.dots, .capsule, .numbered, .progress]

        for style in styles {
            let pageView = DSPageView(pages, id: \.self) { page in
                Text(page)
            }
            .indicatorStyle(style)

            XCTAssertNotNil(pageView)
        }
    }

    func testPageViewIndicatorPositions() {
        let pages = ["Page 1", "Page 2", "Page 3"]

        let positions: [DSPageIndicatorPosition] = [.top, .bottom, .overlay]

        for position in positions {
            let pageView = DSPageView(pages, id: \.self) { page in
                Text(page)
            }
            .indicatorPosition(position)

            XCTAssertNotNil(pageView)
        }
    }

    func testPageViewWithDisabledSwipe() {
        let pages = ["Page 1", "Page 2", "Page 3"]

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }
        .swipeEnabled(false)

        XCTAssertNotNil(pageView)
    }

    func testPageViewWithHiddenIndicators() {
        let pages = ["Page 1", "Page 2", "Page 3"]

        let pageView = DSPageView(pages, id: \.self) { page in
            Text(page)
        }
        .showIndicators(false)

        XCTAssertNotNil(pageView)
    }
}
