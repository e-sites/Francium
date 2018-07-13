// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Francium",
    products: [
        .library(
            name: "Francium",
            targets: ["Francium"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "Francium",
            dependencies: [],
            exclude: ["Francium.xcodeproj", "README.md", "Sources/Info.plist"]),
        .testTarget(
            name: "FranciumTests",
            dependencies: ["Francium"]),
        ]
)
