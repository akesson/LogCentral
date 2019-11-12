// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogCentral",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v8),
    ],
    products: [
        .library(name: "LogCentral", targets: ["LogCentral"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "LogCentral",
                dependencies: [], path: "Sources")
    ]
)
