// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "VisionOCRKit",
    platforms: [.iOS(.v17)],
    products: [.library(name: "VisionOCRKit", targets: ["VisionOCRKit"])],
    dependencies: [
        .package(path: "../CoreTypes"),
        .package(path: "../LoggingKit"),
        .package(path: "../FeatureFlags"),
    ],
    targets: [
        .target(name: "VisionOCRKit"),
        .testTarget(name: "VisionOCRKitTests", dependencies: ["VisionOCRKit"])
    ]
)
