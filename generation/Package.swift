// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "generation",
    products: [
        .executable(name: "generation", targets: ["generation"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.14.2"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.2"),
        .package(url: "https://github.com/johnsundell/Ink.git", from: "0.5.1"),
        .package(url: "https://github.com/johnsundell/Splash.git", from: "0.16.0"),
        .package(url: "https://github.com/alexaubry/HTMLString", from: "6.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "generation",
            dependencies: [
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Ink", package: "Ink"),
                .product(name: "Splash", package: "Splash"),
                .product(name: "HTMLString", package: "HTMLString"),
            ]),
        .testTarget(
            name: "generationTests",
            dependencies: ["generation"]),
    ]
)
