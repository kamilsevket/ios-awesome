import XCTest
import SwiftUI
import SnapshotTesting
@testable import IOSComponents

/// Base class for snapshot tests providing common utilities
class SnapshotTestCase: XCTestCase {

    /// Device configurations for snapshot testing
    enum DeviceConfiguration {
        case iPhoneSE
        case iPhone14
        case iPhone14Pro
        case iPhone14ProMax
        case iPadMini
        case iPadPro

        var config: ViewImageConfig {
            switch self {
            case .iPhoneSE:
                return .iPhoneSe
            case .iPhone14:
                return .iPhone13
            case .iPhone14Pro:
                return .iPhone13Pro
            case .iPhone14ProMax:
                return .iPhone13ProMax
            case .iPadMini:
                return .iPadMini
            case .iPadPro:
                return .iPadPro12_9
            }
        }

        var name: String {
            switch self {
            case .iPhoneSE: return "iPhoneSE"
            case .iPhone14: return "iPhone14"
            case .iPhone14Pro: return "iPhone14Pro"
            case .iPhone14ProMax: return "iPhone14ProMax"
            case .iPadMini: return "iPadMini"
            case .iPadPro: return "iPadPro"
            }
        }
    }

    /// Color scheme configurations
    enum ColorSchemeConfiguration {
        case light
        case dark

        var colorScheme: ColorScheme {
            switch self {
            case .light: return .light
            case .dark: return .dark
            }
        }

        var name: String {
            switch self {
            case .light: return "light"
            case .dark: return "dark"
            }
        }
    }

    /// Default devices for testing
    static let defaultDevices: [DeviceConfiguration] = [.iPhoneSE, .iPhone14, .iPhone14ProMax]

    /// Default color schemes for testing
    static let defaultColorSchemes: [ColorSchemeConfiguration] = [.light, .dark]

    /// Override to set record mode for snapshot tests
    override func setUp() {
        super.setUp()
        // Set to true to record new snapshots
        // isRecording = true
    }

    /// Asserts snapshots across multiple device configurations
    func assertSnapshots<V: View>(
        of view: V,
        named name: String,
        devices: [DeviceConfiguration] = defaultDevices,
        colorSchemes: [ColorSchemeConfiguration] = defaultColorSchemes,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        for device in devices {
            for colorScheme in colorSchemes {
                let themedView = view
                    .environment(\.colorScheme, colorScheme.colorScheme)

                assertSnapshot(
                    of: themedView,
                    as: .image(layout: .device(config: device.config)),
                    named: "\(name)_\(device.name)_\(colorScheme.name)",
                    file: file,
                    testName: testName,
                    line: line
                )
            }
        }
    }

    /// Asserts a single snapshot with custom configuration
    func assertSnapshot<V: View>(
        of view: V,
        named name: String,
        device: DeviceConfiguration = .iPhone14,
        colorScheme: ColorSchemeConfiguration = .light,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let themedView = view
            .environment(\.colorScheme, colorScheme.colorScheme)

        SnapshotTesting.assertSnapshot(
            of: themedView,
            as: .image(layout: .device(config: device.config)),
            named: "\(name)_\(device.name)_\(colorScheme.name)",
            file: file,
            testName: testName,
            line: line
        )
    }

    /// Asserts snapshot with accessibility extra large text size
    func assertAccessibilitySnapshot<V: View>(
        of view: V,
        named name: String,
        device: DeviceConfiguration = .iPhone14,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let accessibleView = view
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)

        SnapshotTesting.assertSnapshot(
            of: accessibleView,
            as: .image(layout: .device(config: device.config)),
            named: "\(name)_\(device.name)_accessibilityXXXL",
            file: file,
            testName: testName,
            line: line
        )
    }
}
