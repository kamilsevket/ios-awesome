import XCTest
import SwiftUI
@testable import DesignSystem

final class DSChipTests: XCTestCase {

    // MARK: - DSFilterChip Tests

    func testFilterChipCreation() {
        let chip = DSFilterChip("All", isSelected: .constant(false))
        XCTAssertNotNil(chip)
    }

    func testFilterChipSelected() {
        let chip = DSFilterChip("Selected", isSelected: .constant(true))
        XCTAssertNotNil(chip)
    }

    func testFilterChipWithIcon() {
        let chip = DSFilterChip("Recent", icon: Image(systemName: "clock"), isSelected: .constant(false))
        XCTAssertNotNil(chip)
    }

    func testFilterChipSizeVariants() {
        let smallChip = DSFilterChip("Small", size: .sm, isSelected: .constant(false))
        let mediumChip = DSFilterChip("Medium", size: .md, isSelected: .constant(false))
        XCTAssertNotNil(smallChip)
        XCTAssertNotNil(mediumChip)
    }

    // MARK: - DSSelectableChip Tests

    func testSelectableChipCreation() {
        let chip = DSSelectableChip("Swift", isSelected: .constant(false))
        XCTAssertNotNil(chip)
    }

    func testSelectableChipSelected() {
        let chip = DSSelectableChip("Selected", isSelected: .constant(true))
        XCTAssertNotNil(chip)
    }

    func testSelectableChipWithIcon() {
        let chip = DSSelectableChip("Photos", icon: Image(systemName: "photo"), isSelected: .constant(false))
        XCTAssertNotNil(chip)
    }

    func testSelectableChipWithDismiss() {
        var dismissed = false
        let chip = DSSelectableChip("Dismissible", isSelected: .constant(true)) { dismissed = true }
        XCTAssertNotNil(chip)
        XCTAssertFalse(dismissed)
    }

    func testSelectableChipSizeVariants() {
        let smallChip = DSSelectableChip("Small", size: .sm, isSelected: .constant(false))
        let mediumChip = DSSelectableChip("Medium", size: .md, isSelected: .constant(false))
        XCTAssertNotNil(smallChip)
        XCTAssertNotNil(mediumChip)
    }

    // MARK: - DSChipSize Tests

    func testChipSizeSmallValues() {
        let size = DSChipSize.sm
        XCTAssertEqual(size.horizontalPadding, DSSpacing.md)
        XCTAssertEqual(size.verticalPadding, DSSpacing.sm)
    }

    func testChipSizeMediumValues() {
        let size = DSChipSize.md
        XCTAssertEqual(size.horizontalPadding, DSSpacing.lg)
        XCTAssertEqual(size.verticalPadding, DSSpacing.md)
    }

    // MARK: - FlowLayout Tests

    func testFlowLayoutCreation() {
        let layout = FlowLayout(spacing: 8)
        XCTAssertEqual(layout.spacing, 8)
    }

    func testFlowLayoutDefaultSpacing() {
        let layout = FlowLayout()
        XCTAssertEqual(layout.spacing, 8)
    }

    // MARK: - Min Touch Target Tests

    func testMinTouchTarget() {
        XCTAssertEqual(DSSpacing.minTouchTarget, 44)
    }
}
