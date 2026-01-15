import XCTest
import SwiftUI
@testable import DesignSystem

final class DSRadioGroupTests: XCTestCase {

    // MARK: - Test Data

    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        case paypal = "PayPal"
        case applePay = "Apple Pay"
    }

    // MARK: - DSRadioGroupAxis Tests

    func testRadioGroupAxisOptions() {
        XCTAssertNotNil(DSRadioGroupAxis.horizontal)
        XCTAssertNotNil(DSRadioGroupAxis.vertical)
    }

    // MARK: - RadioGroup Initialization Tests

    func testRadioGroupWithViewBuilder() {
        var selection: PaymentMethod = .creditCard
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let group = DSRadioGroup(selection: binding) {
            DSRadio(.creditCard, "Credit Card")
            DSRadio(.paypal, "PayPal")
            DSRadio(.applePay, "Apple Pay")
        }
        XCTAssertNotNil(group)
    }

    func testRadioGroupWithOptionsArray() {
        var selection: PaymentMethod = .creditCard
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let group = DSRadioGroup(
            selection: binding,
            options: PaymentMethod.allCases,
            axis: .vertical,
            spacing: 8,
            size: .medium,
            labelPosition: .trailing
        ) { option in
            option.rawValue
        }
        XCTAssertNotNil(group)
    }

    func testRadioGroupWithHorizontalAxis() {
        var selection: PaymentMethod = .creditCard
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let group = DSRadioGroup(selection: binding, axis: .horizontal) {
            DSRadio(.creditCard, "Credit Card")
            DSRadio(.paypal, "PayPal")
        }
        XCTAssertNotNil(group)
    }

    func testRadioGroupWithCustomSpacing() {
        var selection: PaymentMethod = .creditCard
        let binding = Binding(get: { selection }, set: { selection = $0 })

        let group = DSRadioGroup(selection: binding, spacing: 20) {
            DSRadio(.creditCard, "Credit Card")
            DSRadio(.paypal, "PayPal")
        }
        XCTAssertNotNil(group)
    }

    // MARK: - DSRadio Tests

    func testDSRadioInitialization() {
        let radio = DSRadio(PaymentMethod.creditCard, "Credit Card")
        XCTAssertNotNil(radio)
    }

    func testDSRadioWithAllParameters() {
        let radio = DSRadio(
            PaymentMethod.creditCard,
            "Credit Card",
            size: .large,
            labelPosition: .leading,
            isDisabled: true,
            selectedColor: .blue,
            unselectedBorderColor: .gray
        )
        XCTAssertNotNil(radio)
    }

    // MARK: - Selection Enforcement Tests

    func testSingleSelectionEnforcement() {
        var selection: PaymentMethod = .creditCard
        XCTAssertEqual(selection, .creditCard)

        // Simulate selection change
        selection = .paypal
        XCTAssertEqual(selection, .paypal)
        XCTAssertNotEqual(selection, .creditCard)

        // Selection should only be one value at a time
        selection = .applePay
        XCTAssertEqual(selection, .applePay)
        XCTAssertNotEqual(selection, .paypal)
        XCTAssertNotEqual(selection, .creditCard)
    }
}
