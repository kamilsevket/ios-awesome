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
    ],
    targets: [
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
    ]
)
