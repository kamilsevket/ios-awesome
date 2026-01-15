import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSTooltipStyle Tests

final class DSTooltipStyleTests: XCTestCase {

    func testDefaultStyleValues() {
        let style = DSTooltipStyle.default

        XCTAssertEqual(style.font, .footnote)
        XCTAssertEqual(style.cornerRadius, 6)
        XCTAssertEqual(style.arrowSize.width, 10)
        XCTAssertEqual(style.arrowSize.height, 5)
        XCTAssertEqual(style.maxWidth, 250)
        XCTAssertEqual(style.padding.top, 6)
        XCTAssertEqual(style.padding.leading, 10)
    }

    func testInfoStyleValues() {
        let style = DSTooltipStyle.info

        XCTAssertEqual(style.backgroundColor, DSColors.info)
        XCTAssertEqual(style.textColor, .white)
    }

    func testWarningStyleValues() {
        let style = DSTooltipStyle.warning

        XCTAssertEqual(style.backgroundColor, DSColors.warning)
        XCTAssertEqual(style.textColor, .black)
    }

    func testErrorStyleValues() {
        let style = DSTooltipStyle.error

        XCTAssertEqual(style.backgroundColor, DSColors.error)
        XCTAssertEqual(style.textColor, .white)
    }

    func testCustomStyleInitialization() {
        let customStyle = DSTooltipStyle(
            backgroundColor: .blue,
            textColor: .white,
            font: .caption,
            cornerRadius: 10,
            maxWidth: 300
        )

        XCTAssertEqual(customStyle.backgroundColor, .blue)
        XCTAssertEqual(customStyle.textColor, .white)
        XCTAssertEqual(customStyle.font, .caption)
        XCTAssertEqual(customStyle.cornerRadius, 10)
        XCTAssertEqual(customStyle.maxWidth, 300)
    }
}

// MARK: - DSTooltipEdge Tests

final class DSTooltipEdgeTests: XCTestCase {

    func testTopEdgeRotation() {
        let edge = DSTooltipEdge.top
        XCTAssertEqual(edge.arrowRotation, .degrees(0))
    }

    func testBottomEdgeRotation() {
        let edge = DSTooltipEdge.bottom
        XCTAssertEqual(edge.arrowRotation, .degrees(180))
    }

    func testLeadingEdgeRotation() {
        let edge = DSTooltipEdge.leading
        XCTAssertEqual(edge.arrowRotation, .degrees(-90))
    }

    func testTrailingEdgeRotation() {
        let edge = DSTooltipEdge.trailing
        XCTAssertEqual(edge.arrowRotation, .degrees(90))
    }
}

// MARK: - DSTooltip Tests

final class DSTooltipTests: XCTestCase {

    func testTooltipInitialization() {
        let tooltip = DSTooltip("Help text")

        XCTAssertNotNil(tooltip)
    }

    func testTooltipWithEdge() {
        let tooltip = DSTooltip("Bottom tooltip", edge: .bottom)

        XCTAssertNotNil(tooltip)
    }

    func testTooltipWithStyle() {
        let tooltip = DSTooltip("Error message", style: .error)

        XCTAssertNotNil(tooltip)
    }

    func testTooltipWithAllEdges() {
        let topTooltip = DSTooltip("Top", edge: .top)
        let bottomTooltip = DSTooltip("Bottom", edge: .bottom)
        let leadingTooltip = DSTooltip("Leading", edge: .leading)
        let trailingTooltip = DSTooltip("Trailing", edge: .trailing)

        XCTAssertNotNil(topTooltip)
        XCTAssertNotNil(bottomTooltip)
        XCTAssertNotNil(leadingTooltip)
        XCTAssertNotNil(trailingTooltip)
    }

    func testTooltipWithAllStyles() {
        let defaultTooltip = DSTooltip("Default", style: .default)
        let infoTooltip = DSTooltip("Info", style: .info)
        let warningTooltip = DSTooltip("Warning", style: .warning)
        let errorTooltip = DSTooltip("Error", style: .error)

        XCTAssertNotNil(defaultTooltip)
        XCTAssertNotNil(infoTooltip)
        XCTAssertNotNil(warningTooltip)
        XCTAssertNotNil(errorTooltip)
    }
}

// MARK: - View Extension Tests

final class TooltipViewExtensionTests: XCTestCase {

    func testDsTooltipModifier() {
        let view = Text("Help")
            .dsTooltip("This is helpful information")

        XCTAssertNotNil(view)
    }

    func testDsTooltipModifierWithDelay() {
        let view = Text("Info")
            .dsTooltip(
                "Information",
                edge: .bottom,
                delay: 1.0,
                duration: 5.0
            )

        XCTAssertNotNil(view)
    }

    func testDsTooltipModifierWithManualControl() {
        var isPresented = true
        let view = Text("Manual")
            .dsTooltip(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                "Manually controlled tooltip"
            )

        XCTAssertNotNil(view)
    }

    func testDsTooltipModifierWithStyle() {
        let view = Text("Warning")
            .dsTooltip(
                "Warning message",
                style: .warning
            )

        XCTAssertNotNil(view)
    }

    func testDsTooltipModifierDisableLongPress() {
        let view = Text("No long press")
            .dsTooltip(
                "Tooltip",
                showOnLongPress: false
            )

        XCTAssertNotNil(view)
    }
}
