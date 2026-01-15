import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSModal Tests

final class DSModalTests: XCTestCase {

    // MARK: - Initialization Tests

    func testDefaultInitialization() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    func testInitializationWithAllOptions() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            dismissOnBackdropTap: true,
            maxWidth: 400,
            maxHeight: 500,
            cornerRadius: 20,
            showCloseButton: true
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    // MARK: - Configuration Tests

    func testNonDismissableModal() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            dismissOnBackdropTap: false
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    func testModalWithCloseButton() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            showCloseButton: true
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    func testCustomMaxWidth() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            maxWidth: 500
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    func testCustomMaxHeight() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            maxHeight: 600
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    func testCustomCornerRadius() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            cornerRadius: 24
        ) {
            Text("Content")
        }

        XCTAssertNotNil(modal)
    }

    // MARK: - Content Tests

    func testWithComplexContent() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle")
                Text("Success")
                Button("Continue") { }
            }
            .padding()
        }

        XCTAssertNotNil(modal)
    }

    func testWithFormContent() {
        var isPresented = true
        let modal = DSModal(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 })
        ) {
            VStack {
                TextField("Name", text: .constant(""))
                TextField("Email", text: .constant(""))
                Button("Submit") { }
            }
            .padding()
        }

        XCTAssertNotNil(modal)
    }
}

// MARK: - View Extension Tests

final class DSModalViewExtensionTests: XCTestCase {

    func testDsModalModifier() {
        var isPresented = false
        let view = Text("Test")
            .dsModal(isPresented: .init(get: { isPresented }, set: { isPresented = $0 })) {
                Text("Modal Content")
            }

        XCTAssertNotNil(view)
    }

    func testDsModalModifierWithAllOptions() {
        var isPresented = false
        let view = Text("Test")
            .dsModal(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                dismissOnBackdropTap: true,
                maxWidth: 400,
                maxHeight: 500,
                cornerRadius: 20,
                showCloseButton: true
            ) {
                Text("Modal Content")
            }

        XCTAssertNotNil(view)
    }
}
