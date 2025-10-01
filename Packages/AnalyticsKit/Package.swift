// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "AnalyticsKit",
    platforms: [.iOS(.v17)],
    products: [.library(name: "AnalyticsKit", targets: ["AnalyticsKit"])],
    dependencies: [
        .package(path: "../CoreTypes"),
        .package(path: "../LoggingKit"),
    ],
    targets: [
        .target(name: "AnalyticsKit"),
        .testTarget(name: "AnalyticsKitTests", dependencies: ["AnalyticsKit"])
    ]
)
