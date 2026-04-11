// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ADIBUIKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "ADIBUIKit",
            targets: ["ADIBUIKit"]
        ),
    ],
    targets: [
        .target(
            name: "ADIBUIKit"
        ),
    ]
)
