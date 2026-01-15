import XCTest
import SwiftUI
@testable import DesignSystem

final class ShimmerModifierTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        let modifier = ShimmerModifier()
        XCTAssertNotNil(modifier)
    }

    func testCustomDurationInitialization() {
        let modifier = ShimmerModifier(duration: 2.0)
        XCTAssertNotNil(modifier)
    }

    func testInactiveInitialization() {
        let modifier = ShimmerModifier(isActive: false)
        XCTAssertNotNil(modifier)
    }

    func testCustomHighlightColorInitialization() {
        let modifier = ShimmerModifier(highlightColor: .white)
        XCTAssertNotNil(modifier)
    }

    // MARK: - View Extension Tests

    func testShimmerModifierOnView() {
        let view = Rectangle()
            .shimmer()
        XCTAssertNotNil(view)
    }

    func testShimmerModifierWithCustomParameters() {
        let view = Rectangle()
            .shimmer(isActive: true, duration: 2.0, highlightColor: .white)
        XCTAssertNotNil(view)
    }

    func testShimmerOnSkeleton() {
        let view = DSSkeleton()
            .shimmer()
        XCTAssertNotNil(view)
    }
}
