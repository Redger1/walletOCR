// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FeatureFlags",
    platforms: [.iOS(.v17)],
    products: [.library(name: "FeatureFlags", targets: ["FeatureFlags"])],
    dependencies: [
        .package(path: "../CoreTypes")
    ],
    targets: [
        .target(name: "FeatureFlags"),
        .testTarget(name: "FeatureFlagsTests", dependencies: ["FeatureFlags"])
    ]
)
