// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "StolenBikeKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "BikeMapFeature", targets: ["BikeMapFeature"]),
        .library(name: "RegisterBikeFeature", targets: ["RegisterBikeFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture",
                 from: "0.50.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing",
                 from: "1.10.0"),
    ],
    targets: [
        // MARK: - Feature
        .target(name: "AppFeature",
                dependencies: [
                    "BikeMapFeature",
                    "RegisterBikeFeature",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .testTarget(name: "AppFeatureTests",
                    dependencies: [
                        "AppFeature",
                        "TestUtils",
                    ]),
        .target(name: "BikeMapFeature",
                dependencies: [
                    "BikeClient",
                    "LocationClient",
                    "MapView",
                    "Utils",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .testTarget(name: "BikeMapFeatureTests",
                    dependencies: [
                        "BikeMapFeature",
                        "TestUtils",
                    ]),
        .target(name: "RegisterBikeFeature",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        // MARK: - Effect
        .target(name: "SharedModel",
                dependencies: []),
        .target(name: "LocationClient",
                dependencies: [
                    "SharedModel",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .target(name: "BikeClient",
                dependencies: [
                    "SharedModel",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .testTarget(name: "BikeClientTests",
                    dependencies: [
                        "BikeClient",
                        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                    ]),
        // MARK: - Common
        .target(name: "MapView",
                dependencies: []),
        .target(name: "Utils",
                dependencies: []),
        // MARK: - Test
        .target(name: "TestUtils",
                dependencies: [])
    ]
)
