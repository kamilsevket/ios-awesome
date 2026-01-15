import XCTest
import SwiftUI
import SnapshotTesting
@testable import IOSComponents

final class AvatarSnapshotTests: SnapshotTestCase {

    // MARK: - Size Variations

    func testAvatarSizes() {
        let avatars = HStack(spacing: 16) {
            Avatar(source: .initials("JD"), size: .small)
            Avatar(source: .initials("JD"), size: .medium)
            Avatar(source: .initials("JD"), size: .large)
            Avatar(source: .initials("JD"), size: .extraLarge)
        }
        .padding()

        assertSnapshot(of: avatars, named: "sizes")
    }

    // MARK: - Shape Variations

    func testAvatarShapes() {
        let avatars = HStack(spacing: 16) {
            Avatar(source: .initials("AB"), size: .large, shape: .circle)
            Avatar(source: .initials("AB"), size: .large, shape: .rounded)
            Avatar(source: .initials("AB"), size: .large, shape: .square)
        }
        .padding()

        assertSnapshot(of: avatars, named: "shapes")
    }

    // MARK: - Source Types

    func testAvatarWithInitials() {
        let avatar = Avatar(source: .initials("AB"), size: .large)
            .padding()

        assertSnapshot(of: avatar, named: "initials")
    }

    func testAvatarWithSystemIcon() {
        let avatar = Avatar(source: .systemIcon("person.fill"), size: .large)
            .padding()

        assertSnapshot(of: avatar, named: "system_icon")
    }

    func testAvatarWithImage() {
        let avatar = Avatar(source: .image(Image(systemName: "star.fill")), size: .large)
            .padding()

        assertSnapshot(of: avatar, named: "image")
    }

    // MARK: - Dark Mode

    func testAvatarDarkMode() {
        let avatars = HStack(spacing: 16) {
            Avatar(source: .initials("JD"), size: .medium)
            Avatar(source: .systemIcon("person.fill"), size: .medium)
        }
        .padding()

        assertSnapshot(of: avatars, named: "dark_mode", colorScheme: .dark)
    }

    // MARK: - All Variations

    func testAllAvatarVariations() {
        let avatars = VStack(spacing: 20) {
            // Sizes
            HStack(spacing: 8) {
                Text("Sizes:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Avatar(source: .initials("SM"), size: .small)
                Avatar(source: .initials("MD"), size: .medium)
                Avatar(source: .initials("LG"), size: .large)
                Avatar(source: .initials("XL"), size: .extraLarge)
            }

            // Shapes
            HStack(spacing: 8) {
                Text("Shapes:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Avatar(source: .initials("C"), size: .medium, shape: .circle)
                Avatar(source: .initials("R"), size: .medium, shape: .rounded)
                Avatar(source: .initials("S"), size: .medium, shape: .square)
            }

            // Sources
            HStack(spacing: 8) {
                Text("Sources:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Avatar(source: .initials("IN"), size: .medium)
                Avatar(source: .systemIcon("person.fill"), size: .medium)
                Avatar(source: .image(Image(systemName: "star.fill")), size: .medium)
            }
        }
        .padding()
        .frame(width: 350)

        assertSnapshots(of: avatars, named: "all_variations", devices: [.iPhone14])
    }
}
