import XCTest
import SwiftUI
import SnapshotTesting
@testable import IOSComponents

final class CardSnapshotTests: SnapshotTestCase {

    // MARK: - Style Variations

    func testElevatedCard() {
        let card = Card(style: .elevated) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Elevated Card")
                    .font(.headline)
                Text("This card has a subtle shadow effect.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: 350)

        assertSnapshot(of: card, named: "elevated")
    }

    func testOutlinedCard() {
        let card = Card(style: .outlined) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Outlined Card")
                    .font(.headline)
                Text("This card has a border outline.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: 350)

        assertSnapshot(of: card, named: "outlined")
    }

    func testFilledCard() {
        let card = Card(style: .filled) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Filled Card")
                    .font(.headline)
                Text("This card has a filled background.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: 350)

        assertSnapshot(of: card, named: "filled")
    }

    // MARK: - Dark Mode

    func testCardsDarkMode() {
        let cards = VStack(spacing: 16) {
            Card(style: .elevated) {
                Text("Elevated Card")
                    .font(.headline)
            }

            Card(style: .outlined) {
                Text("Outlined Card")
                    .font(.headline)
            }

            Card(style: .filled) {
                Text("Filled Card")
                    .font(.headline)
            }
        }
        .padding()
        .frame(width: 350)

        assertSnapshot(of: cards, named: "all_styles", colorScheme: .dark)
    }

    // MARK: - Complex Content

    func testCardWithComplexContent() {
        let card = Card(style: .elevated) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Avatar(source: .initials("JD"), size: .medium)
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .font(.headline)
                        Text("Software Engineer")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }

                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.body)
                    .foregroundColor(.secondary)

                HStack {
                    PrimaryButton(title: "Follow", style: .filled) {}
                    PrimaryButton(title: "Message", style: .outlined) {}
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: 350)

        assertSnapshots(of: card, named: "complex_content", devices: [.iPhone14])
    }

    // MARK: - All Styles Combined

    func testAllCardStyles() {
        let cards = VStack(spacing: 16) {
            Card(style: .elevated) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Elevated Card")
                        .font(.headline)
                    Text("With shadow effect")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Card(style: .outlined) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Outlined Card")
                        .font(.headline)
                    Text("With border")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Card(style: .filled) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Filled Card")
                        .font(.headline)
                    Text("With background")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .frame(width: 350)

        assertSnapshots(
            of: cards,
            named: "all_styles",
            devices: [.iPhoneSE, .iPhone14, .iPhone14ProMax]
        )
    }
}
