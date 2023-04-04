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
//        .package(url: "git@github.com:cleevio/CleevioCore-iOS.git", branch: "feature/new-coordinators"), //.init(2, 0, 0, prereleaseIdentifiers: ["dev3"])
        .package(url: "git@gitlab.cleevio.cz:cleevio-dev-ios/CleevioCore", branch: "feature/new-coordinators"),
        .package(url: "https://github.com/scenee/FloatingPanel", .upToNextMajor(from: .init(2, 6, 1)))
    ],
    targets: [
        .target(
            name: "CleevioRouters",
            dependencies: [
                .product(name: "CleevioCore", package: "CleevioCore")
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
