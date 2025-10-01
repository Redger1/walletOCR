// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "LoggingKit",
    platforms: [.iOS(.v17)],
    products: [.library(name: "LoggingKit", targets: ["LoggingKit"])],
    targets: [
        .target(name: "LoggingKit"),
        .testTarget(name: "LoggingKitTests", dependencies: ["LoggingKit"])
    ]
)
