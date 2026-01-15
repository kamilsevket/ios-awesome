import XCTest
import SwiftUI
import SnapshotTesting
@testable import IOSComponents

final class PrimaryButtonSnapshotTests: SnapshotTestCase {

    // MARK: - Filled Button Snapshots

    func testFilledButton_Default() {
        let button = PrimaryButton(title: "Continue", style: .filled) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "filled_default")
    }

    func testFilledButton_Disabled() {
        let button = PrimaryButton(title: "Continue", style: .filled, isEnabled: false) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "filled_disabled")
    }

    func testFilledButton_Loading() {
        let button = PrimaryButton(title: "Loading", style: .filled, isLoading: true) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "filled_loading")
    }

    // MARK: - Outlined Button Snapshots

    func testOutlinedButton_Default() {
        let button = PrimaryButton(title: "Continue", style: .outlined) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "outlined_default")
    }

    func testOutlinedButton_Disabled() {
        let button = PrimaryButton(title: "Continue", style: .outlined, isEnabled: false) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "outlined_disabled")
    }

    // MARK: - Text Button Snapshots

    func testTextButton_Default() {
        let button = PrimaryButton(title: "Learn More", style: .text) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "text_default")
    }

    // MARK: - Dark Mode Snapshots

    func testFilledButton_DarkMode() {
        let button = PrimaryButton(title: "Continue", style: .filled) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "filled", colorScheme: .dark)
    }

    func testOutlinedButton_DarkMode() {
        let button = PrimaryButton(title: "Continue", style: .outlined) {}
            .padding()
            .frame(width: 300)

        assertSnapshot(of: button, named: "outlined", colorScheme: .dark)
    }

    // MARK: - All States Combined

    func testAllButtonStyles() {
        let buttons = VStack(spacing: 16) {
            PrimaryButton(title: "Filled Button", style: .filled) {}
            PrimaryButton(title: "Outlined Button", style: .outlined) {}
            PrimaryButton(title: "Text Button", style: .text) {}
            PrimaryButton(title: "Disabled Button", style: .filled, isEnabled: false) {}
            PrimaryButton(title: "Loading Button", style: .filled, isLoading: true) {}
        }
        .padding()
        .frame(width: 350)

        assertSnapshots(
            of: buttons,
            named: "all_styles",
            devices: [.iPhoneSE, .iPhone14]
        )
    }

    // MARK: - Accessibility Snapshots

    func testFilledButton_AccessibilitySize() {
        let button = PrimaryButton(title: "Continue", style: .filled) {}
            .padding()
            .frame(width: 300)

        assertAccessibilitySnapshot(of: button, named: "filled_accessibility")
    }
}
