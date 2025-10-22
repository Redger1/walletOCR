// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v17)],
    products: [.library(name: "DesignSystem", targets: ["DesignSystem"])],
    dependencies: [.package(path: "../CoreTypes")],
    targets: [
        .target(name: "DesignSystem", dependencies: ["CoreTypes"]),
        .testTarget(name: "DesignSystemTests", dependencies: ["DesignSystem"])
    ]
)
