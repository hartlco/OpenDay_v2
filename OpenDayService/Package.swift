// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenDayService",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "OpenDayService",
            targets: ["OpenDayService"])
    ],
    dependencies: [
        .package(path: "../Models")
    ],
    targets: [
        .target(
            name: "OpenDayService",
            dependencies: ["Models"]),
        .testTarget(
            name: "OpenDayServiceTests",
            dependencies: ["OpenDayService"])
    ]
)
