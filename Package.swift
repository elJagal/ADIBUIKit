// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ADIBUIKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ADIBUIKit",
            targets: ["ADIBUIKit"]
        ),
    ],
    targets: [
        .target(
            name: "ADIBUIKit",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
