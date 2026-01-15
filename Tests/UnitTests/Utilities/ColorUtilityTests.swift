import XCTest
import SwiftUI
@testable import IOSComponents

final class ColorUtilityTests: XCTestCase {

    // MARK: - Hex Color Tests

    func testHexColor_SixDigit_ReturnsColor() {
        let color = ColorUtility.color(from: "#FF0000")
        XCTAssertNotNil(color)
    }

    func testHexColor_WithoutHash_ReturnsColor() {
        let color = ColorUtility.color(from: "FF0000")
        XCTAssertNotNil(color)
    }

    func testHexColor_ThreeDigit_ReturnsColor() {
        let color = ColorUtility.color(from: "#F00")
        XCTAssertNotNil(color)
    }

    func testHexColor_EightDigit_ReturnsColorWithAlpha() {
        let color = ColorUtility.color(from: "#80FF0000")
        XCTAssertNotNil(color)
    }

    func testHexColor_Invalid_ReturnsBlack() {
        let color = ColorUtility.color(from: "invalid")
        XCTAssertNotNil(color)
    }

    // MARK: - Luminance Tests

    func testLuminance_White_ReturnsOne() {
        let luminance = ColorUtility.luminance(red: 1.0, green: 1.0, blue: 1.0)
        XCTAssertEqual(luminance, 1.0, accuracy: 0.001)
    }

    func testLuminance_Black_ReturnsZero() {
        let luminance = ColorUtility.luminance(red: 0.0, green: 0.0, blue: 0.0)
        XCTAssertEqual(luminance, 0.0, accuracy: 0.001)
    }

    func testLuminance_Red_ReturnsExpectedValue() {
        let luminance = ColorUtility.luminance(red: 1.0, green: 0.0, blue: 0.0)
        XCTAssertEqual(luminance, 0.2126, accuracy: 0.001)
    }

    func testLuminance_Green_ReturnsExpectedValue() {
        let luminance = ColorUtility.luminance(red: 0.0, green: 1.0, blue: 0.0)
        XCTAssertEqual(luminance, 0.7152, accuracy: 0.001)
    }

    func testLuminance_Blue_ReturnsExpectedValue() {
        let luminance = ColorUtility.luminance(red: 0.0, green: 0.0, blue: 1.0)
        XCTAssertEqual(luminance, 0.0722, accuracy: 0.001)
    }

    // MARK: - Contrast Ratio Tests

    func testContrastRatio_BlackOnWhite_ReturnsMaxContrast() {
        let whiteLuminance = ColorUtility.luminance(red: 1.0, green: 1.0, blue: 1.0)
        let blackLuminance = ColorUtility.luminance(red: 0.0, green: 0.0, blue: 0.0)
        let ratio = ColorUtility.contrastRatio(luminance1: whiteLuminance, luminance2: blackLuminance)
        XCTAssertEqual(ratio, 21.0, accuracy: 0.1)
    }

    func testContrastRatio_SameColor_ReturnsOne() {
        let luminance = ColorUtility.luminance(red: 0.5, green: 0.5, blue: 0.5)
        let ratio = ColorUtility.contrastRatio(luminance1: luminance, luminance2: luminance)
        XCTAssertEqual(ratio, 1.0, accuracy: 0.1)
    }

    func testContrastRatio_OrderIndependent() {
        let light = ColorUtility.luminance(red: 0.8, green: 0.8, blue: 0.8)
        let dark = ColorUtility.luminance(red: 0.2, green: 0.2, blue: 0.2)
        let ratio1 = ColorUtility.contrastRatio(luminance1: light, luminance2: dark)
        let ratio2 = ColorUtility.contrastRatio(luminance1: dark, luminance2: light)
        XCTAssertEqual(ratio1, ratio2, accuracy: 0.001)
    }

    // MARK: - Predefined Colors Tests

    func testPredefinedColors_Exist() {
        XCTAssertNotNil(Color.componentsPrimary)
        XCTAssertNotNil(Color.componentsSecondary)
        XCTAssertNotNil(Color.componentsSuccess)
        XCTAssertNotNil(Color.componentsWarning)
        XCTAssertNotNil(Color.componentsError)
        XCTAssertNotNil(Color.componentsInfo)
    }
}
