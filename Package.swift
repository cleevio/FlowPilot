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
    name: "FlowPilot",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FlowPilot",
            targets: ["FlowPilot"]),
        .library(name: "FlowPilotFloatingRouters", targets: ["FlowPilotFloatingRouters"]),
        .library(name: "FlowPilotLegacyCombineCoordinators", targets: ["FlowPilotLegacyCombineCoordinators"])
    ],
    dependencies: [
        .package(url: "https://github.com/cleevio/CleevioCore.git", .upToNextMajor(from: Version(2,0,0))),
        .package(url: "https://github.com/scenee/FloatingPanel", .upToNextMajor(from: Version(2,6,1))),
        .package(url: "https://github.com/apple/swift-collections", .upToNextMajor(from: Version(1,0,0)))
    ],
    targets: [
        .target(
            name: "FlowPilot",
            dependencies: [
                .product(name: "CleevioCore", package: "CleevioCore"),
                .product(name: "OrderedCollections", package: "swift-collections")
            ],
            swiftSettings: swiftSettings
        ),
        .target(name: "FlowPilotFloatingRouters", dependencies: [
            "FlowPilot",
            .product(name: "FloatingPanel", package: "FloatingPanel", condition: .when(platforms: [.iOS, .macCatalyst]))
        ],
                swiftSettings: swiftSettings
               ),
        .target(name: "FlowPilotLegacyCombineCoordinators", dependencies: [
            "FlowPilot",
            .product(name: "CleevioCore", package: "CleevioCore")
        ]
               ),
        .testTarget(
            name: "FlowPilotTests",
            dependencies: ["FlowPilot"],
            swiftSettings: swiftSettings
        ),
    ]
)
