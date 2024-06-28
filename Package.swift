// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyNewExecutable",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "ExampleVideo", targets: ["ExampleVideo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/StreamUI/StreamUI.git", from: "0.1.2"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.4.0"),

    ],
    targets: [
        .executableTarget(
            name: "VideoRecorder",
            dependencies: [
                "ExampleVideo",
                .product(name: "StreamUI", package: "StreamUI"),
                .product(name: "VideoViews", package: "StreamUI"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/VideoRecorder"
        ),
        .target(
            name: "ExampleVideo",
            dependencies: [
                .product(name: "StreamUI", package: "StreamUI"),
            ],
            path: "Sources/ExampleVideo"
        ),
    ]
)
