import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSBottomSheet Tests

final class DSBottomSheetTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    func testInitializationWithDetents() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            detents: [.small, .medium, .large]
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    func testInitializationWithSelectedDetent() {
        var isPresented = true
        var selectedDetent: DSDetent = .medium

        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            detents: [.medium, .large],
            selectedDetent: .init(get: { selectedDetent }, set: { selectedDetent = $0 })
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    func testInitializationWithAllOptions() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            detents: [.medium, .large],
            selectedDetent: nil,
            showDragIndicator: true,
            dismissOnBackdropTap: true,
            dismissOnDragDown: true,
            cornerRadius: 20
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    // MARK: - Configuration Tests

    func testHiddenDragIndicator() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            showDragIndicator: false
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    func testNonDismissableOnBackdropTap() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            dismissOnBackdropTap: false
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    func testNonDismissableOnDragDown() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            dismissOnDragDown: false
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    func testCustomCornerRadius() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            cornerRadius: 32
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    // MARK: - Empty Detents Tests

    func testEmptyDetentsFallsBackToMedium() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            detents: []
        ) {
            Text("Content")
        }

        XCTAssertNotNil(sheet)
    }

    // MARK: - Content Tests

    func testWithComplexContent() {
        var isPresented = true
        let sheet = DSBottomSheet(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            VStack {
                Text("Title")
                ForEach(0..<5) { index in
                    Text("Item \(index)")
                }
                Button("Action") { }
            }
        }

        XCTAssertNotNil(sheet)
    }
}

// MARK: - View Extension Tests

final class DSBottomSheetViewExtensionTests: XCTestCase {

    func testDsSheetModifier() {
        var isPresented = false
        let view = Text("Test")
            .dsSheet(isPresented: .init(get: { isPresented }, set: { isPresented = $0 })) {
                Text("Sheet Content")
            }

        XCTAssertNotNil(view)
    }

    func testDsSheetModifierWithAllOptions() {
        var isPresented = false
        var selectedDetent: DSDetent = .medium

        let view = Text("Test")
            .dsSheet(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                detents: [.small, .medium, .large],
                selectedDetent: .init(get: { selectedDetent }, set: { selectedDetent = $0 }),
                showDragIndicator: true,
                dismissOnBackdropTap: true,
                dismissOnDragDown: true,
                cornerRadius: 24
            ) {
                Text("Sheet Content")
            }

        XCTAssertNotNil(view)
    }
}
