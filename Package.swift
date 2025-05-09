// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIAPIService",
    platforms: [
        .iOS(.v13),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AIAPIService",
            targets: ["AIAPIService"]),
    ],
    dependencies: [
        .package(url: "git@github.com:Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "git@github.com:hmlongco/Factory.git", from: "2.4.5")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AIAPIService",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Factory", package: "Factory")
            ],
            path: "Sources/AIAPIService"
        ),
        .testTarget(
            name: "AIAPIServiceTests",
            dependencies: [
                "AIAPIService"
            ],
            path: "Tests/AIAPIServiceTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
