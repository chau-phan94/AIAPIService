// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AIAPIService",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AIAPIService",
            targets: ["AIAPIService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.5.3"),
        .package(url: "git@github.com:hmlongco/Factory.git", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.7.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AIAPIService",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            path: "Sources/AIAPIService"
        ),
        .testTarget(
            name: "AIAPIServiceTests",
            dependencies: [
                "AIAPIService",
                .product(name: "Testing", package: "swift-testing")
            ],
            path: "Tests/AIAPIServiceTests"
        ),
    ]
)
