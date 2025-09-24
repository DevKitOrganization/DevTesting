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
            targets: ["DevTesting"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DevTesting",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DevTestingTests",
            dependencies: [
                "DevTesting",
                .product(name: "RealModule", package: "swift-numerics"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
