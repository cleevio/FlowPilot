// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    // Use for development to catch concurrency issues. SPM packages cannot depend on other packages that use unsafeFlags.
//    SwiftSetting.unsafeFlags([
//        "-Xfrontend", "-strict-concurrency=complete",
//        "-Xfrontend", "-warn-concurrency",
//        "-Xfrontend", "-enable-actor-data-race-checks",
//    ])
]

let package = Package(
    name: "CleevioRouters",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CleevioRouters",
            targets: ["CleevioRouters"]),
        .library(name: "CleevioFloatingRouters", targets: ["CleevioFloatingRouters"]),
        .library(name: "LegacyCoordinators", targets: ["LegacyCoordinators"])
    ],
    dependencies: [
//        .package(url: "git@github.com:cleevio/CleevioCore-iOS.git", branch: "feature/new-coordinators"), //.init(2, 0, 0, prereleaseIdentifiers: ["dev3"])
        .package(url: "git@gitlab.cleevio.cz:cleevio-dev-ios/CleevioCore", .upToNextMajor(from: Version(2,0,0))),
        .package(url: "https://github.com/scenee/FloatingPanel", .upToNextMajor(from: Version(2,6,1))),
        .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: Version(1,0,0)))
    ],
    targets: [
        .target(
            name: "CleevioRouters",
            dependencies: [
                .product(name: "CleevioCore", package: "CleevioCore"),
                .product(name: "OrderedCollections", package: "swift-collections")
            ],
            swiftSettings: swiftSettings
        ),
        .target(name: "CleevioFloatingRouters", dependencies: [
            "CleevioRouters",
            .product(name: "FloatingPanel", package: "FloatingPanel", condition: .when(platforms: [.iOS, .macCatalyst]))
        ],
                swiftSettings: swiftSettings
               ),
        .target(name: "LegacyCoordinators", dependencies: [
            "CleevioRouters",
            .product(name: "CleevioCore", package: "CleevioCore")
        ]
               ),
        .testTarget(
            name: "CleevioRoutersTests",
            dependencies: ["CleevioRouters"],
            swiftSettings: swiftSettings
        ),
    ]
)
