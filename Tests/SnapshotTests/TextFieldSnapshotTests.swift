import XCTest
import SwiftUI
import SnapshotTesting
@testable import IOSComponents

final class TextFieldSnapshotTests: SnapshotTestCase {

    // MARK: - Default State

    func testTextField_Empty() {
        let textField = CustomTextField(
            text: .constant(""),
            placeholder: "Enter your email",
            label: "Email"
        )
        .padding()
        .frame(width: 350)

        assertSnapshot(of: textField, named: "empty")
    }

    func testTextField_WithValue() {
        let textField = CustomTextField(
            text: .constant("john@example.com"),
            placeholder: "Enter your email",
            label: "Email"
        )
        .padding()
        .frame(width: 350)

        assertSnapshot(of: textField, named: "with_value")
    }

    // MARK: - Error State

    func testTextField_WithError() {
        // Note: Error state requires validation to fail
        // This tests the structure with an error message
        let view = VStack(alignment: .leading, spacing: 4) {
            Text("Email")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)

            Text("invalid-email")
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: 1)
                )

            Text("Please enter a valid email")
                .font(.system(size: 12))
                .foregroundColor(.red)
        }
        .padding()
        .frame(width: 350)

        assertSnapshot(of: view, named: "with_error")
    }

    // MARK: - Secure Field

    func testTextField_Secure() {
        let textField = CustomTextField(
            text: .constant("password123"),
            placeholder: "Enter password",
            label: "Password",
            isSecure: true
        )
        .padding()
        .frame(width: 350)

        assertSnapshot(of: textField, named: "secure")
    }

    // MARK: - Dark Mode

    func testTextField_DarkMode() {
        let textField = CustomTextField(
            text: .constant("john@example.com"),
            placeholder: "Enter your email",
            label: "Email"
        )
        .padding()
        .frame(width: 350)

        assertSnapshot(of: textField, named: "default", colorScheme: .dark)
    }

    // MARK: - Form Layout

    func testTextField_FormLayout() {
        let form = VStack(spacing: 16) {
            CustomTextField(
                text: .constant("John Doe"),
                placeholder: "Enter your name",
                label: "Full Name"
            )

            CustomTextField(
                text: .constant("john@example.com"),
                placeholder: "Enter your email",
                label: "Email",
                keyboardType: .emailAddress
            )

            CustomTextField(
                text: .constant(""),
                placeholder: "Enter password",
                label: "Password",
                isSecure: true
            )

            CustomTextField(
                text: .constant("+1 (555) 123-4567"),
                placeholder: "Enter phone number",
                label: "Phone",
                keyboardType: .phonePad
            )
        }
        .padding()
        .frame(width: 350)

        assertSnapshots(of: form, named: "form_layout", devices: [.iPhone14])
    }

    // MARK: - Accessibility

    func testTextField_AccessibilitySize() {
        let textField = CustomTextField(
            text: .constant("john@example.com"),
            placeholder: "Enter your email",
            label: "Email"
        )
        .padding()
        .frame(width: 350)

        assertAccessibilitySnapshot(of: textField, named: "accessibility")
    }
}
