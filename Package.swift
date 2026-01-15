// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]
        ),
        .library(
            name: "FoundationColor",
            targets: ["FoundationColor"]
        ),
        .library(
            name: "DesignSystemTypography",
            targets: ["DesignSystemTypography"]
        ),
        .library(
            name: "FoundationIcons",
            targets: ["FoundationIcons"]
        ),
        .library(
            name: "GestureUtilities",
            targets: ["GestureUtilities"]
        ),
        .library(
            name: "IOSComponents",
            targets: ["IOSComponents"]
        ),
        .library(
            name: "ShowcaseApp",
            targets: ["ShowcaseApp"]
        ),
        .library(
            name: "SampleApp",
            targets: ["SampleApp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
    ],
    targets: [
        // Design System targets
        .target(
            name: "DesignSystem",
            path: "Sources/DesignSystem"
        ),
        .target(
            name: "FoundationColor",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "DesignSystemTypography",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "FoundationIcons",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "GestureUtilities"
        ),

        // IOSComponents target
        .target(
            name: "IOSComponents",
            dependencies: [],
            path: "Sources/IOSComponents"
        ),

        // ShowcaseApp target
        .target(
            name: "ShowcaseApp",
            dependencies: [
                "DesignSystem",
                "FoundationColor",
                "DesignSystemTypography",
                "FoundationIcons",
                "GestureUtilities"
            ],
            path: "Sources/ShowcaseApp"
        ),

        // SampleApp target - Comprehensive demo of all components
        .target(
            name: "SampleApp",
            dependencies: [
                "DesignSystem",
                "FoundationColor",
                "DesignSystemTypography",
                "FoundationIcons",
                "GestureUtilities"
            ],
            path: "Sources/SampleApp"
        ),

        // Design System test targets
        .testTarget(
            name: "DesignSystemTests",
            dependencies: ["DesignSystem"],
            path: "Tests/DesignSystemTests"
        ),
        .testTarget(
            name: "FoundationColorTests",
            dependencies: ["FoundationColor"]
        ),
        .testTarget(
            name: "DesignSystemTypographyTests",
            dependencies: ["DesignSystemTypography"]
        ),
        .testTarget(
            name: "FoundationIconsTests",
            dependencies: ["FoundationIcons"]
        ),
        .testTarget(
            name: "GestureUtilitiesTests",
            dependencies: ["GestureUtilities"]
        ),

        // IOSComponents test targets
        .testTarget(
            name: "UnitTests",
            dependencies: ["IOSComponents"],
            path: "Tests/UnitTests"
        ),
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                "IOSComponents",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/SnapshotTests"
        ),
        .testTarget(
            name: "UITests",
            dependencies: ["IOSComponents"],
            path: "Tests/UITests"
        ),
        .testTarget(
            name: "AccessibilityTests",
            dependencies: ["IOSComponents"],
            path: "Tests/AccessibilityTests"
        ),
    ]
)
