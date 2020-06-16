// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MapView",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MapView",
            targets: ["MapView"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "MapView",
            dependencies: ["Models"]),
        .testTarget(
            name: "MapViewTests",
            dependencies: ["MapView"])
    ]
)
