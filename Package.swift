// swift-tools-version: 6.1

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("MemberImportVisibility"),
]

let package = Package(
    name: "DevTesting",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .visionOS(.v2),
        .watchOS(.v11),
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
