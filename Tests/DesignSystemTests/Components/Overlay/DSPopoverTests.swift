import XCTest
import SwiftUI
@testable import DesignSystem

// MARK: - DSPopoverEdge Tests

final class DSPopoverEdgeTests: XCTestCase {

    func testTopEdgeOpposite() {
        let edge = DSPopoverEdge.top
        XCTAssertEqual(edge.opposite, .bottom)
    }

    func testBottomEdgeOpposite() {
        let edge = DSPopoverEdge.bottom
        XCTAssertEqual(edge.opposite, .top)
    }

    func testLeadingEdgeOpposite() {
        let edge = DSPopoverEdge.leading
        XCTAssertEqual(edge.opposite, .trailing)
    }

    func testTrailingEdgeOpposite() {
        let edge = DSPopoverEdge.trailing
        XCTAssertEqual(edge.opposite, .leading)
    }

    func testTopEdgeArrowRotation() {
        let edge = DSPopoverEdge.top
        XCTAssertEqual(edge.arrowRotation, .degrees(180))
    }

    func testBottomEdgeArrowRotation() {
        let edge = DSPopoverEdge.bottom
        XCTAssertEqual(edge.arrowRotation, .degrees(0))
    }

    func testLeadingEdgeArrowRotation() {
        let edge = DSPopoverEdge.leading
        XCTAssertEqual(edge.arrowRotation, .degrees(90))
    }

    func testTrailingEdgeArrowRotation() {
        let edge = DSPopoverEdge.trailing
        XCTAssertEqual(edge.arrowRotation, .degrees(-90))
    }
}

// MARK: - DSPopoverStyle Tests

final class DSPopoverStyleTests: XCTestCase {

    func testDefaultStyleValues() {
        let style = DSPopoverStyle.default

        XCTAssertEqual(style.cornerRadius, 12)
        XCTAssertEqual(style.shadowToken, .lg)
        XCTAssertEqual(style.arrowSize.width, 16)
        XCTAssertEqual(style.arrowSize.height, 8)
        XCTAssertEqual(style.padding.top, 12)
        XCTAssertEqual(style.padding.leading, 16)
        XCTAssertEqual(style.padding.bottom, 12)
        XCTAssertEqual(style.padding.trailing, 16)
    }

    func testCompactStyleValues() {
        let style = DSPopoverStyle.compact

        XCTAssertEqual(style.cornerRadius, 8)
        XCTAssertEqual(style.shadowToken, .md)
        XCTAssertEqual(style.arrowSize.width, 12)
        XCTAssertEqual(style.arrowSize.height, 6)
        XCTAssertEqual(style.padding.top, 8)
        XCTAssertEqual(style.padding.leading, 12)
    }

    func testMenuStyleValues() {
        let style = DSPopoverStyle.menu

        XCTAssertEqual(style.cornerRadius, 14)
        XCTAssertEqual(style.shadowToken, .xl)
        XCTAssertEqual(style.padding.leading, 0)
        XCTAssertEqual(style.padding.trailing, 0)
    }

    func testCustomStyleInitialization() {
        let customStyle = DSPopoverStyle(
            cornerRadius: 20,
            shadowToken: .sm,
            arrowSize: CGSize(width: 20, height: 10),
            padding: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        )

        XCTAssertEqual(customStyle.cornerRadius, 20)
        XCTAssertEqual(customStyle.shadowToken, .sm)
        XCTAssertEqual(customStyle.arrowSize.width, 20)
        XCTAssertEqual(customStyle.arrowSize.height, 10)
        XCTAssertEqual(customStyle.padding.top, 20)
    }
}

// MARK: - DSPopover Tests

final class DSPopoverTests: XCTestCase {

    func testPopoverInitialization() {
        var isPresented = true
        let popover = DSPopover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            edge: .bottom
        ) {
            Text("Content")
        }

        XCTAssertNotNil(popover)
    }

    func testPopoverWithAllEdges() {
        var isPresented = true
        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })

        let topPopover = DSPopover(isPresented: binding, edge: .top) { Text("Top") }
        let bottomPopover = DSPopover(isPresented: binding, edge: .bottom) { Text("Bottom") }
        let leadingPopover = DSPopover(isPresented: binding, edge: .leading) { Text("Leading") }
        let trailingPopover = DSPopover(isPresented: binding, edge: .trailing) { Text("Trailing") }

        XCTAssertNotNil(topPopover)
        XCTAssertNotNil(bottomPopover)
        XCTAssertNotNil(leadingPopover)
        XCTAssertNotNil(trailingPopover)
    }

    func testPopoverWithCustomStyle() {
        var isPresented = true
        let popover = DSPopover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            edge: .bottom,
            style: .menu
        ) {
            Text("Menu Content")
        }

        XCTAssertNotNil(popover)
    }

    func testPopoverDismissOnTapOutsideOption() {
        var isPresented = true
        let popover = DSPopover(
            isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
            dismissOnTapOutside: false
        ) {
            Text("Non-dismissable")
        }

        XCTAssertNotNil(popover)
    }
}

// MARK: - View Extension Tests

final class PopoverViewExtensionTests: XCTestCase {

    func testDsPopoverModifier() {
        var isPresented = true
        let view = Text("Anchor")
            .dsPopover(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                edge: .bottom
            ) {
                Text("Popover content")
            }

        XCTAssertNotNil(view)
    }

    func testDsPopoverModifierWithAllParameters() {
        var isPresented = true
        let view = Text("Anchor")
            .dsPopover(
                isPresented: .init(get: { isPresented }, set: { isPresented = $0 }),
                edge: .top,
                style: .compact,
                dismissOnTapOutside: false
            ) {
                VStack {
                    Text("Title")
                    Text("Description")
                }
            }

        XCTAssertNotNil(view)
    }
}
