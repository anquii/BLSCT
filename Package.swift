// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BLSCT",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "BLSCT",
            targets: ["BLSCT"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/anquii/Base58Check.git",
            .exact("1.0.1")
        ),
        .package(
            url: "https://github.com/attaswift/BigInt.git",
            .exact("5.3.0")
        ),
        .package(
            url: "https://github.com/anquii/CryptoSwiftWrapper.git",
            .exact("1.4.3")
        ),
        .package(
            url: "https://github.com/anquii/MCLSwiftWrapper.git",
            .exact("1.61.0")
        )
    ],
    targets: [
        .target(
            name: "BLSCT",
            dependencies: [
                "Base58Check",
                "BigInt",
                "CryptoSwiftWrapper",
                "MCLSwiftWrapper"
            ]
        ),
        .testTarget(
            name: "BLSCTTests",
            dependencies: ["BLSCT"]
        )
    ]
)
