import XCTest
import SwiftUI
@testable import DesignSystem

final class DSFocusManagementTests: XCTestCase {

    // MARK: - DSFocusOrderModifier Tests

    func testFocusOrderModifierCreation() {
        let modifier = DSFocusOrderModifier(priority: 100)

        XCTAssertNotNil(modifier)
    }

    func testDsFocusOrderNumeric() {
        let view = Text("Test")
            .dsFocusOrder(50)

        XCTAssertNotNil(view)
    }

    func testDsFocusOrderLevel() {
        let view = Text("Test")
            .dsFocusOrder(.high)

        XCTAssertNotNil(view)
    }

    // MARK: - DSFocusLevel Tests

    func testFocusLevelCritical() {
        XCTAssertEqual(DSFocusLevel.critical.priority, 1000)
    }

    func testFocusLevelHigh() {
        XCTAssertEqual(DSFocusLevel.high.priority, 100)
    }

    func testFocusLevelNormal() {
        XCTAssertEqual(DSFocusLevel.normal.priority, 0)
    }

    func testFocusLevelLow() {
        XCTAssertEqual(DSFocusLevel.low.priority, -100)
    }

    func testFocusLevelLast() {
        XCTAssertEqual(DSFocusLevel.last.priority, -1000)
    }

    // MARK: - Focus Level Ordering Tests

    func testFocusLevelOrdering() {
        XCTAssertGreaterThan(DSFocusLevel.critical.priority, DSFocusLevel.high.priority)
        XCTAssertGreaterThan(DSFocusLevel.high.priority, DSFocusLevel.normal.priority)
        XCTAssertGreaterThan(DSFocusLevel.normal.priority, DSFocusLevel.low.priority)
        XCTAssertGreaterThan(DSFocusLevel.low.priority, DSFocusLevel.last.priority)
    }

    // MARK: - DSSkipLink Tests

    func testSkipLinkDefault() {
        let skipLink = DSSkipLink {
            // Action
        }

        XCTAssertNotNil(skipLink)
    }

    func testSkipLinkCustomLabel() {
        let skipLink = DSSkipLink(label: "Skip navigation") {
            // Action
        }

        XCTAssertNotNil(skipLink)
    }

    // MARK: - DSFocusRingModifier Tests

    func testFocusRingModifierCreation() {
        let modifier = DSFocusRingModifier(
            isFocused: true,
            color: .blue,
            width: 2
        )

        XCTAssertNotNil(modifier)
    }

    func testDsFocusRing() {
        let view = TextField("Name", text: .constant(""))
            .dsFocusRing(true)

        XCTAssertNotNil(view)
    }

    func testDsFocusRingCustomValues() {
        let view = TextField("Name", text: .constant(""))
            .dsFocusRing(false, color: .red, width: 3)

        XCTAssertNotNil(view)
    }

    // MARK: - DSFocusManagement Namespace Tests

    func testFocusManagementNamespaceExists() {
        // Just verify the type exists
        _ = DSFocusManagement.self
    }

    // MARK: - iOS 15+ Feature Tests

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testFocusTrapModifier() {
        let modifier = DSFocusTrapModifier(isActive: true)

        XCTAssertNotNil(modifier)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testDsFocusTrap() {
        let view = VStack {
            Text("Modal Content")
        }
        .dsFocusTrap(true)

        XCTAssertNotNil(view)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testFocusContainerCreation() {
        struct TestView: View {
            @State private var currentFocus: String? = nil

            var body: some View {
                DSFocusContainer(focus: $currentFocus) { focusBinding in
                    VStack {
                        Text("Content")
                    }
                }
            }
        }

        let view = TestView()
        XCTAssertNotNil(view)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testFocusRequestModifier() {
        let modifier = DSFocusRequestModifier<Int>(
            shouldFocus: true,
            onFocusChange: nil
        )

        XCTAssertNotNil(modifier)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testDsAccessibilityFocusRequest() {
        let view = Text("Test")
            .dsAccessibilityFocusRequest(true)

        XCTAssertNotNil(view)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func testDsAccessibilityFocusRequestWithCallback() {
        var focusChanged = false

        let view = Text("Test")
            .dsAccessibilityFocusRequest(false) { isFocused in
                focusChanged = true
            }

        XCTAssertNotNil(view)
    }
}

// MARK: - DSFirstResponder Tests

#if os(iOS)
final class DSFirstResponderTests: XCTestCase {

    func testFirstResponderResign() {
        // Verify the method exists and doesn't crash
        DSFirstResponder.resign()
    }
}
#endif
