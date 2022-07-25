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
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/attaswift/BigInt.git",
            .upToNextMajor(from: "5.3.0")
        ),
        .package(
            url: "https://github.com/anquii/CryptoSwiftWrapper.git",
            .upToNextMajor(from: "1.4.3")
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
