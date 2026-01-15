import XCTest
import SwiftUI
@testable import DesignSystem

final class DSPullToRefreshTests: XCTestCase {

    // MARK: - Pull Indicator Tests

    func testPullIndicatorInitialization() {
        let indicator = DSPullIndicator(progress: 0.5)
        XCTAssertNotNil(indicator)
    }

    func testPullIndicatorRefreshing() {
        let indicator = DSPullIndicator(progress: 1.0, isRefreshing: true)
        XCTAssertNotNil(indicator)
    }

    func testPullIndicatorCustomColor() {
        let indicator = DSPullIndicator(
            progress: 0.75,
            isRefreshing: false,
            color: DSColors.success
        )
        XCTAssertNotNil(indicator)
    }

    // MARK: - Progress Values

    func testPullIndicatorZeroProgress() {
        let indicator = DSPullIndicator(progress: 0)
        XCTAssertNotNil(indicator)
    }

    func testPullIndicatorFullProgress() {
        let indicator = DSPullIndicator(progress: 1.0)
        XCTAssertNotNil(indicator)
    }
}
