// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "IOSComponents",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "IOSComponents",
            targets: ["IOSComponents"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
    ],
    targets: [
        // Main library target
        .target(
            name: "IOSComponents",
            dependencies: [],
            path: "Sources/IOSComponents"
        ),

        // Unit tests target
        .testTarget(
            name: "UnitTests",
            dependencies: ["IOSComponents"],
            path: "Tests/UnitTests"
        ),

        // Snapshot tests target
        .testTarget(
            name: "SnapshotTests",
            dependencies: [
                "IOSComponents",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            path: "Tests/SnapshotTests"
        ),

        // UI tests target
        .testTarget(
            name: "UITests",
            dependencies: ["IOSComponents"],
            path: "Tests/UITests"
        ),

        // Accessibility tests target
        .testTarget(
            name: "AccessibilityTests",
            dependencies: ["IOSComponents"],
            path: "Tests/AccessibilityTests"
        )
    ]
)
