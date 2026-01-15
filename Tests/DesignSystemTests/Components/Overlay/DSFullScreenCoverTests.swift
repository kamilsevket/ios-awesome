import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSFullScreenCover Tests

final class DSFullScreenCoverTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    func testInitializationWithAllOptions() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            transition: .slideUp,
            showCloseButton: true,
            closeButtonPosition: .topTrailing,
            backgroundColor: .blue
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    // MARK: - Transition Tests

    func testSlideUpTransition() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            transition: .slideUp
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    func testFadeTransition() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            transition: .fade
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    func testScaleTransition() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            transition: .scale
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    // MARK: - Close Button Tests

    func testWithCloseButton() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            showCloseButton: true
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    func testWithoutCloseButton() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            showCloseButton: false
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    func testCloseButtonTopLeading() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            showCloseButton: true,
            closeButtonPosition: .topLeading
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    func testCloseButtonTopTrailing() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            showCloseButton: true,
            closeButtonPosition: .topTrailing
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    // MARK: - Background Color Tests

    func testCustomBackgroundColor() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            backgroundColor: .black
        ) {
            Text("Content")
        }

        XCTAssertNotNil(cover)
    }

    // MARK: - Content Tests

    func testWithNavigationContent() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            NavigationView {
                List {
                    Text("Item 1")
                    Text("Item 2")
                }
                .navigationTitle("Full Screen")
            }
        }

        XCTAssertNotNil(cover)
    }

    func testWithScrollableContent() {
        var isPresented = true
        let cover = DSFullScreenCover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            ScrollView {
                VStack {
                    ForEach(0..<20) { index in
                        Text("Item \(index)")
                    }
                }
            }
        }

        XCTAssertNotNil(cover)
    }
}

// MARK: - Transition Enum Tests

final class DSFullScreenCoverTransitionTests: XCTestCase {

    func testAllTransitionCases() {
        let transitions: [DSFullScreenCover<Text>.Transition] = [
            .slideUp,
            .fade,
            .scale
        ]

        XCTAssertEqual(transitions.count, 3)
    }
}

// MARK: - Close Button Position Tests

final class DSFullScreenCoverCloseButtonPositionTests: XCTestCase {

    func testAllPositionCases() {
        let positions: [DSFullScreenCover<Text>.CloseButtonPosition] = [
            .topLeading,
            .topTrailing
        ]

        XCTAssertEqual(positions.count, 2)
    }
}

// MARK: - View Extension Tests

final class DSFullScreenCoverViewExtensionTests: XCTestCase {

    func testDsFullScreenCoverModifier() {
        var isPresented = false
        let view = Text("Test")
            .dsFullScreenCover(isPresented: .init(get: { isPresented }, set: { isPresented = $0 })) {
                Text("Cover Content")
            }

        XCTAssertNotNil(view)
    }

    func testDsFullScreenCoverModifierWithAllOptions() {
        var isPresented = false
        let view = Text("Test")
            .dsFullScreenCover(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                transition: .fade,
                showCloseButton: true,
                closeButtonPosition: .topLeading,
                backgroundColor: .gray
            ) {
                Text("Cover Content")
            }

        XCTAssertNotNil(view)
    }
}
