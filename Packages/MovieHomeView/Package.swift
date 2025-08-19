// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieHomeView",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MovieHomeView",
            targets: ["MovieHomeView"]),
    ],
    dependencies: [
        .package(path: "../MovieModels"),
        .package(path: "../Caching"),
        .package(path: "../Networking"),
        .package(path: "../Utilities")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MovieHomeView",
            dependencies: ["MovieModels", "Caching", "Networking", "Utilities"]),
        .testTarget(
            name: "MovieHomeViewTests",
            dependencies: ["MovieHomeView", "MovieModels", "Caching", "Networking", "Utilities"]
        ),
    ]
)
