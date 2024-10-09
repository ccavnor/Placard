// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Placard",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Placard",
            targets: ["Placard"]),
    ],
    targets: [
        .target(
            name: "Placard"),
        .testTarget(
            name: "PlacardTests",
            dependencies: ["Placard"]),
    ]
)
