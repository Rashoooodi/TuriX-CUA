// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TuriXMacApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "TuriXMacApp",
            targets: ["TuriXMacApp"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "TuriXMacApp",
            dependencies: [],
            path: "TuriXMacApp"
        )
    ]
)
