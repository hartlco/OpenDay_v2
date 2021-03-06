// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImagePicker",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ImagePicker",
            targets: ["ImagePicker"])
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "ImagePicker",
            dependencies: []),
        .testTarget(
            name: "ImagePickerTests",
            dependencies: ["ImagePicker"])
    ]
)
