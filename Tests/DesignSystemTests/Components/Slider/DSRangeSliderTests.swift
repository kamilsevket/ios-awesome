import XCTest
import SwiftUI
@testable import DesignSystem

final class DSRangeSliderTests: XCTestCase {

    // MARK: - Initialization Tests

    func testBasicInitialization() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
        XCTAssertNotNil(slider)
    }

    func testIntegerInitialization() {
        var range = 25...75
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
        XCTAssertNotNil(slider)
    }

    // MARK: - Modifier Tests

    func testSizeModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .size(.large)
        XCTAssertNotNil(slider)
    }

    func testStyleModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .style(.gradient)
        XCTAssertNotNil(slider)
    }

    func testTintColorModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .tintColor(.green)
        XCTAssertNotNil(slider)
    }

    func testStepModifier() {
        var range = 20.0...80.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .step(10)
        XCTAssertNotNil(slider)
    }

    func testShowValueLabelsModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .showValueLabels()
        XCTAssertNotNil(slider)
    }

    func testValueLabelFormatModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .valueLabelFormat { "$\(Int($0))" }
        XCTAssertNotNil(slider)
    }

    func testShowTicksModifier() {
        var range = 20.0...80.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .step(10)
            .showTicks()
        XCTAssertNotNil(slider)
    }

    func testShowBoundsLabelsModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .showBoundsLabels()
        XCTAssertNotNil(slider)
    }

    func testMinMaxLabelModifiers() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .minLabel("$0")
            .maxLabel("$100+")
        XCTAssertNotNil(slider)
    }

    func testDisabledModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .disabled(true)
        XCTAssertNotNil(slider)
    }

    func testHapticFeedbackModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .hapticFeedback(false)
        XCTAssertNotNil(slider)
    }

    func testThumbStyleModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .thumbStyle(.bordered)
        XCTAssertNotNil(slider)
    }

    func testMinDistanceModifier() {
        var range = 30.0...70.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .minDistance(20)
        XCTAssertNotNil(slider)
    }

    func testGradientColorsModifier() {
        var range = 25.0...75.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .gradientColors([.blue, .purple])
        XCTAssertNotNil(slider)
    }

    func testOnRangeChangedModifier() {
        var range = 25.0...75.0
        var changedRange: ClosedRange<Double>?
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .onRangeChanged { changedRange = $0 }
        XCTAssertNotNil(slider)
        XCTAssertNil(changedRange) // Not triggered until interaction
    }

    // MARK: - Combined Modifier Tests

    func testMultipleModifiers() {
        var range = 20.0...80.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...100)
            .size(.large)
            .style(.gradient)
            .tintColor(.purple)
            .step(10)
            .showValueLabels()
            .showTicks()
            .showBoundsLabels()
            .minDistance(10)
            .hapticFeedback(true)
            .thumbStyle(.bordered)
        XCTAssertNotNil(slider)
    }

    // MARK: - Price Range Example Test

    func testPriceRangeConfiguration() {
        var range = 50.0...200.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 0...500)
            .step(10)
            .showValueLabels()
            .showBoundsLabels()
            .valueLabelFormat { "$\(Int($0))" }
            .minLabel("$0")
            .maxLabel("$500+")
            .minDistance(20)
        XCTAssertNotNil(slider)
    }

    // MARK: - Age Range Example Test

    func testAgeRangeConfiguration() {
        var range = 25.0...45.0
        let binding = Binding(get: { range }, set: { range = $0 })
        let slider = DSRangeSlider(range: binding, bounds: 18...100)
            .step(1)
            .showValueLabels()
            .minDistance(5)
            .thumbStyle(.default)
        XCTAssertNotNil(slider)
    }
}
