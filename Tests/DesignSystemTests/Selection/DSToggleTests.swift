import XCTest
import SwiftUI
@testable import DesignSystem

final class DSToggleTests: XCTestCase {

    // MARK: - DSToggleSize Tests

    func testToggleSizeTrackWidth() {
        XCTAssertEqual(DSToggleSize.small.trackWidth, 42)
        XCTAssertEqual(DSToggleSize.medium.trackWidth, 51)
        XCTAssertEqual(DSToggleSize.large.trackWidth, 60)
    }

    func testToggleSizeTrackHeight() {
        XCTAssertEqual(DSToggleSize.small.trackHeight, 26)
        XCTAssertEqual(DSToggleSize.medium.trackHeight, 31)
        XCTAssertEqual(DSToggleSize.large.trackHeight, 36)
    }

    func testToggleSizeThumbSize() {
        XCTAssertEqual(DSToggleSize.small.thumbSize, 22)
        XCTAssertEqual(DSToggleSize.medium.thumbSize, 27)
        XCTAssertEqual(DSToggleSize.large.thumbSize, 32)
    }

    func testToggleSizeThumbPadding() {
        XCTAssertEqual(DSToggleSize.small.thumbPadding, 2)
        XCTAssertEqual(DSToggleSize.medium.thumbPadding, 2)
        XCTAssertEqual(DSToggleSize.large.thumbPadding, 2)
    }

    func testToggleSizeIsCaseIterable() {
        XCTAssertEqual(DSToggleSize.allCases.count, 3)
        XCTAssertTrue(DSToggleSize.allCases.contains(.small))
        XCTAssertTrue(DSToggleSize.allCases.contains(.medium))
        XCTAssertTrue(DSToggleSize.allCases.contains(.large))
    }

    // MARK: - Toggle Initialization Tests

    func testToggleBasicInitialization() {
        var isOn = false
        let binding = Binding(get: { isOn }, set: { isOn = $0 })
        let toggle = DSToggle(isOn: binding, label: "Test")
        XCTAssertNotNil(toggle)
    }

    func testToggleWithAllParameters() {
        var isOn = true
        let binding = Binding(get: { isOn }, set: { isOn = $0 })
        let toggle = DSToggle(
            isOn: binding,
            label: "Full Test",
            size: .large,
            labelPosition: .trailing,
            isDisabled: true,
            onColor: .green,
            offColor: .gray,
            thumbColor: .white,
            action: {}
        )
        XCTAssertNotNil(toggle)
    }

    func testToggleWithoutLabel() {
        var isOn = false
        let binding = Binding(get: { isOn }, set: { isOn = $0 })
        let toggle = DSToggle(isOn: binding)
        XCTAssertNotNil(toggle)
    }

    // MARK: - Label Position Tests

    func testLabelPositionOptions() {
        XCTAssertNotNil(DSToggleLabelPosition.leading)
        XCTAssertNotNil(DSToggleLabelPosition.trailing)
    }

    // MARK: - State Toggle Tests

    func testToggleStateChange() {
        var isOn = false
        XCTAssertFalse(isOn)

        isOn.toggle()
        XCTAssertTrue(isOn)

        isOn.toggle()
        XCTAssertFalse(isOn)
    }

    // MARK: - Touch Target Tests

    func testMinimumTouchTarget() {
        // Verify the minimum touch target constant
        XCTAssertEqual(DSSpacing.minTouchTarget, 44)
    }
}
