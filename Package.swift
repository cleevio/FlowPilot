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
        .package(url: "git@gitlab.cleevio.cz:cleevio-dev-ios/CleevioCore", .upToNextMajor(from: .init(1, 0, 0))),
        .package(url: "https://github.com/scenee/FloatingPanel", .upToNextMajor(from: .init(2, 6, 1)))
    ],
    targets: [
        .target(
            name: "CleevioRouters",
            dependencies: [
                "CleevioCore"
            ]),
        .target(name: "CleevioFloatingRouters", dependencies: ["CleevioRouters", "FloatingPanel"]),
        .testTarget(
            name: "CleevioRoutersTests",
            dependencies: ["CleevioRouters"]),
    ]
)
