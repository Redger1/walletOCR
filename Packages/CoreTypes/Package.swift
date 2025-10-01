// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "CoreTypes",
    platforms: [.iOS(.v17)],
    products: [.library(name: "CoreTypes", targets: ["CoreTypes"])],
    targets: [
        .target(name: "CoreTypes"),
        .testTarget(name: "CoreTypesTests", dependencies: ["CoreTypes"])
    ]
)
