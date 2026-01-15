import XCTest
import SwiftUI
@testable import DesignSystem

final class LoadingOverlayTests: XCTestCase {

    // MARK: - Style Tests

    func testCircularStyle() {
        let style = DSLoadingOverlayStyle.circular
        XCTAssertNotNil(style)
    }

    func testLinearStyle() {
        let style = DSLoadingOverlayStyle.linear
        XCTAssertNotNil(style)
    }

    func testCustomStyle() {
        let style = DSLoadingOverlayStyle.custom
        XCTAssertNotNil(style)
    }

    // MARK: - Modifier Tests

    func testLoadingOverlayModifierInitialization() {
        let modifier = LoadingOverlayModifier(isLoading: true)
        XCTAssertNotNil(modifier)
    }

    func testLoadingOverlayWithProgress() {
        let modifier = LoadingOverlayModifier(isLoading: true, progress: 0.5)
        XCTAssertNotNil(modifier)
    }

    func testLoadingOverlayWithMessage() {
        let modifier = LoadingOverlayModifier(
            isLoading: true,
            message: "Loading..."
        )
        XCTAssertNotNil(modifier)
    }

    func testLoadingOverlayWithAllParameters() {
        let modifier = LoadingOverlayModifier(
            isLoading: true,
            style: .linear,
            progress: 0.75,
            dimColor: .black.opacity(0.5),
            tintColor: DSColors.success,
            blocksInteraction: true,
            message: "Please wait..."
        )
        XCTAssertNotNil(modifier)
    }

    // MARK: - View Extension Tests

    func testLoadingOverlayOnView() {
        let view = Rectangle()
            .loadingOverlay(true)
        XCTAssertNotNil(view)
    }

    func testLoadingOverlayWithStyle() {
        let view = Rectangle()
            .loadingOverlay(true, style: .linear)
        XCTAssertNotNil(view)
    }

    func testLoadingOverlayWithProgressAndMessage() {
        let view = Rectangle()
            .loadingOverlay(true, progress: 0.6, message: "Uploading...")
        XCTAssertNotNil(view)
    }

    func testLoadingOverlayDisabled() {
        let view = Rectangle()
            .loadingOverlay(false)
        XCTAssertNotNil(view)
    }
}
