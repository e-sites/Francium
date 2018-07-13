// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "Francium",
    products: [
    .library(name: "Francium", type: .dynamic, targets: ["Francium"])
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "Francium",
            dependencies: [ ],
            path: ".",
            sources: ["Sources"]
        )
    ]
)
