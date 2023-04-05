// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "StolenBikeKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "BikeMapFeature", targets: ["BikeMapFeature"]),
        .library(name: "RegisterBikeFeature", targets: ["RegisterBikeFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture",
                 from: "0.50.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing",
                 from: "1.10.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git",
                 from: "2.0.0")
    ],
    targets: [
        // MARK: - Feature
        .target(name: "BikeMapFeature",
                dependencies: [
                    "BikeClient",
                    "LocationClient",
                    "SettingsClient",
                    "BottomSheetView",
                    "MapView",
                    "SearchBarView",
                    "Utils",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .testTarget(name: "BikeMapFeatureTests",
                    dependencies: [
                        "BikeMapFeature",
                        "TestUtils",
                        .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                    ]),
        .target(name: "RegisterBikeFeature",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        // MARK: - Effect
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
        .target(name: "LocationClient",
                dependencies: [
                    "SharedModel",
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .target(name: "SettingsClient",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                ]),
        .target(name: "SharedModel",
                dependencies: []),
        // MARK: - Common
        .target(name: "BottomSheetView",
                dependencies: []),
        .target(name: "MapView",
                dependencies: []),
        .target(name: "SearchBarView",
                dependencies: []),
        .target(name: "Utils",
                dependencies: [
                    .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
                ]),
        // MARK: - Test
        .target(name: "TestUtils",
                dependencies: [])
    ]
)
