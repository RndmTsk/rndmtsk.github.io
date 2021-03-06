// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "generator",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "generator",
            dependencies: [
                "Stencil"
            ]),
        .testTarget(
            name: "generatorTests",
            dependencies: ["generator"]),
    ]
)
