// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CleevioRoutersLibrary",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CleevioRouters",
            targets: ["CleevioRouters"]),
        .library(name: "CleevioFloatingRouters", targets: ["CleevioFloatingRouters"])
    ],
    dependencies: [
        .package(url: "git@gitlab.cleevio.cz:cleevio-dev-ios/CleevioFramework-ios.git", branch: "feature/reworked-cleevio-framework-packages"),
        .package(url: "https://github.com/scenee/FloatingPanel", .upToNextMajor(from: .init(2, 6, 1)))
    ],
    targets: [
        .target(
            name: "CleevioRouters",
            dependencies: [
                .product(name: "CleevioCore", package: "CleevioFramework-ios")
            ]),
        .target(name: "CleevioFloatingRouters", dependencies: ["CleevioRouters", "FloatingPanel"]),
        .testTarget(
            name: "CleevioRoutersTests",
            dependencies: ["CleevioRouters"]),
    ]
)
