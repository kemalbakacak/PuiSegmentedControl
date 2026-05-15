// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PuiSegmentedControl",
    defaultLocalization: "en",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "PuiSegmentedControl", targets: ["PuiSegmentedControl"]),
    ],
    targets: [
        .target(
            name: "PuiSegmentedControl",
            path: "Source"
        )
    ],
    swiftLanguageModes: [.v5]
)
