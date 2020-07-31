// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "generation",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/groue/GRMustache.swift", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.2.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "generation",
            dependencies: [
                "Mustache",
                "ArgumentParser"
            ]),
        .testTarget(
            name: "generationTests",
            dependencies: ["generation"]),
    ]
)
