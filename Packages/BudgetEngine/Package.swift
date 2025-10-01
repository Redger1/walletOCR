// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BudgetEngine",
    platforms: [.iOS(.v17)],
    products: [.library(name: "BudgetEngine", targets: ["BudgetEngine"])],
    dependencies: [
        .package(path: "../CoreTypes"),
        .package(path: "../PersistenceKit")
    ],
    targets: [
        .target(name: "BudgetEngine"),
        .testTarget(name: "BudgetEngineTests", dependencies: ["BudgetEngine"])
    ]
)
