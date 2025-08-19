// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovieDetailsView",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MovieDetailsView",
            targets: ["MovieDetailsView"]),
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
            name: "MovieDetailsView",
            dependencies: ["MovieModels", "Caching", "Networking", "Utilities"]),
        .testTarget(
            name: "MovieDetailsViewTests",
            dependencies: ["MovieDetailsView", "MovieModels", "Caching", "Networking", "Utilities"]
        ),
    ]
)
