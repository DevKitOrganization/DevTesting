// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "DevTesting",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26),
        .watchOS(.v26),
    ],
    products: [
        .library(
            name: "DevTesting",
            targets: ["DevRandom", "DevTesting"]
        ),
        .library(
            name: "DevRandom",
            targets: ["DevRandom"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DevRandom",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DevRandomTests",
            dependencies: [
                "DevRandom",
                .product(name: "RealModule", package: "swift-numerics"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DevTesting",
            dependencies: [
                "DevRandom"
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DevTestingTests",
            dependencies: [
                "DevTesting",
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
