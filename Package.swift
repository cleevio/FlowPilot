// swift-tools-version: 5.5
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
        .package(url: "https://github.com/cleevio/CleevioCore.git", .upToNextMajor(from: .init(2, 1, 7))),
        .package(url: "https://github.com/scenee/FloatingPanel", .upToNextMajor(from: .init(2, 6, 1)))
    ],
    targets: [
        .target(
            name: "CleevioRouters",
            dependencies: [
                "CleevioCore"
            ]),
        .target(name: "CleevioFloatingRouters", dependencies: [
            "CleevioRouters",
            .product(name: "FloatingPanel", package: "FloatingPanel", condition: .when(platforms: [.iOS, .macCatalyst]))
        ]),
        .testTarget(
            name: "CleevioRoutersTests",
            dependencies: ["CleevioRouters"]),
    ]
)
