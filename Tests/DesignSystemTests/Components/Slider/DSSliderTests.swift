import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSliderTests: XCTestCase {

    // MARK: - Size Tests

    func testSmallSizeValues() {
        let size = DSSliderSize.small
        XCTAssertEqual(size.trackHeight, 2)
        XCTAssertEqual(size.thumbSize, 16)
        XCTAssertEqual(size.tickSize, 4)
    }

    func testMediumSizeValues() {
        let size = DSSliderSize.medium
        XCTAssertEqual(size.trackHeight, 4)
        XCTAssertEqual(size.thumbSize, 24)
        XCTAssertEqual(size.tickSize, 6)
    }

    func testLargeSizeValues() {
        let size = DSSliderSize.large
        XCTAssertEqual(size.trackHeight, 6)
        XCTAssertEqual(size.thumbSize, 32)
        XCTAssertEqual(size.tickSize, 8)
    }

    func testAllSizeCases() {
        let allCases = DSSliderSize.allCases
        XCTAssertEqual(allCases.count, 3)
        XCTAssertTrue(allCases.contains(.small))
        XCTAssertTrue(allCases.contains(.medium))
        XCTAssertTrue(allCases.contains(.large))
    }

    // MARK: - Style Tests

    func testStyleTrackColors() {
        let standard = DSSliderStyle.standard
        let filled = DSSliderStyle.filled
        let gradient = DSSliderStyle.gradient

        // Light mode
        XCTAssertNotNil(standard.trackColor(colorScheme: .light))
        XCTAssertNotNil(filled.trackColor(colorScheme: .light))
        XCTAssertNotNil(gradient.trackColor(colorScheme: .light))

        // Dark mode
        XCTAssertNotNil(standard.trackColor(colorScheme: .dark))
        XCTAssertNotNil(filled.trackColor(colorScheme: .dark))
        XCTAssertNotNil(gradient.trackColor(colorScheme: .dark))
    }

    // MARK: - Thumb Style Tests

    func testDefaultThumbStyle() {
        let style = DSSliderThumbStyle.default
        XCTAssertEqual(style.size, 24)
        XCTAssertEqual(style.borderWidth, 0)
        XCTAssertEqual(style.shadowRadius, 2)
        XCTAssertNil(style.borderColor)
    }

    func testBorderedThumbStyle() {
        let style = DSSliderThumbStyle.bordered
        XCTAssertNotNil(style.borderColor)
        XCTAssertEqual(style.borderWidth, 2)
    }

    func testMinimalThumbStyle() {
        let style = DSSliderThumbStyle.minimal
        XCTAssertEqual(style.size, 16)
        XCTAssertEqual(style.shadowRadius, 0)
    }

    func testCustomThumbStyle() {
        let customColor = Color.red
        let style = DSSliderThumbStyle(
            size: 30,
            color: customColor,
            borderColor: .blue,
            borderWidth: 3,
            shadowRadius: 5,
            shape: .roundedSquare
        )

        XCTAssertEqual(style.size, 30)
        XCTAssertNotNil(style.borderColor)
        XCTAssertEqual(style.borderWidth, 3)
        XCTAssertEqual(style.shadowRadius, 5)
    }

    // MARK: - Initialization Tests

    func testBasicInitialization() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
        XCTAssertNotNil(slider)
    }

    func testInitializationWithRange() {
        var value = 50.0
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding, range: 0...100)
        XCTAssertNotNil(slider)
    }

    func testIntegerInitialization() {
        var value = 50
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding, range: 0...100)
        XCTAssertNotNil(slider)
    }

    func testFloatInitialization() {
        var value: Float = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding, range: 0...1)
        XCTAssertNotNil(slider)
    }

    // MARK: - Modifier Tests

    func testSizeModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .size(.large)
        XCTAssertNotNil(slider)
    }

    func testStyleModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .style(.gradient)
        XCTAssertNotNil(slider)
    }

    func testTintColorModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .tintColor(.green)
        XCTAssertNotNil(slider)
    }

    func testStepModifier() {
        var value = 50.0
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding, range: 0...100)
            .step(10)
        XCTAssertNotNil(slider)
    }

    func testShowValueLabelModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .showValueLabel()
        XCTAssertNotNil(slider)
    }

    func testValueLabelFormatModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .valueLabelFormat { "\(Int($0 * 100))%" }
        XCTAssertNotNil(slider)
    }

    func testShowTicksModifier() {
        var value = 50.0
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding, range: 0...100)
            .step(10)
            .showTicks()
        XCTAssertNotNil(slider)
    }

    func testShowMinMaxLabelsModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .showMinMaxLabels()
        XCTAssertNotNil(slider)
    }

    func testMinMaxLabelModifiers() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .minLabel("Low")
            .maxLabel("High")
        XCTAssertNotNil(slider)
    }

    func testDisabledModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .disabled(true)
        XCTAssertNotNil(slider)
    }

    func testHapticFeedbackModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .hapticFeedback(false)
        XCTAssertNotNil(slider)
    }

    func testThumbStyleModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .thumbStyle(.bordered)
        XCTAssertNotNil(slider)
    }

    func testGradientColorsModifier() {
        var value = 0.5
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .gradientColors([.blue, .purple])
        XCTAssertNotNil(slider)
    }

    func testOnValueChangedModifier() {
        var value = 0.5
        var changedValue: Double?
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding)
            .onValueChanged { changedValue = $0 }
        XCTAssertNotNil(slider)
        XCTAssertNil(changedValue) // Not triggered until interaction
    }

    // MARK: - Combined Modifier Tests

    func testMultipleModifiers() {
        var value = 50.0
        let binding = Binding(get: { value }, set: { value = $0 })
        let slider = DSSlider(value: binding, range: 0...100)
            .size(.large)
            .style(.gradient)
            .tintColor(.purple)
            .step(10)
            .showValueLabel()
            .showTicks()
            .showMinMaxLabels()
            .hapticFeedback(true)
            .thumbStyle(.bordered)
        XCTAssertNotNil(slider)
    }

    // MARK: - AnyShape Tests

    func testAnyShapeWithCircle() {
        let shape = AnyShape(Circle())
        let path = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertFalse(path.isEmpty)
    }

    func testAnyShapeWithRoundedRectangle() {
        let shape = AnyShape(RoundedRectangle(cornerRadius: 8))
        let path = shape.path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        XCTAssertFalse(path.isEmpty)
    }
}
