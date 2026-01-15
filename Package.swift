// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DSTextField",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "DSTextField",
            targets: ["DSTextField"]
        )
    ],
    targets: [
        .target(
            name: "DSTextField",
            path: "Sources/DSTextField"
        ),
        .testTarget(
            name: "DSTextFieldTests",
            dependencies: ["DSTextField"],
            path: "Tests/DSTextFieldTests"
        )
    ]
)
