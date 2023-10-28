// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "BLSCT",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(name: "BLSCT", targets: ["BLSCT"])
    ],
    dependencies: [
        .package(url: "https://github.com/anquii/Base58Check.git", exact: "1.0.1"),
        .package(url: "https://github.com/attaswift/BigInt.git", exact: "5.3.0"),
        .package(url: "https://github.com/anquii/BinaryExtensions.git", exact: "0.1.1"),
        .package(url: "https://github.com/anquii/BLSSwiftWrapper.git", exact: "1.24.1"),
        .package(url: "https://github.com/anquii/ERC2333.git", exact: "1.0.1"),
        .package(url: "https://github.com/anquii/MCLSwiftWrapper.git", exact: "1.61.1"),
        .package(url: "https://github.com/anquii/RIPEMD160.git", exact: "1.0.0")
    ],
    targets: [
        .target(
            name: "BLSCT",
            dependencies: ["Base58Check", "BigInt", "BinaryExtensions", "BLSSwiftWrapper", "ERC2333", "MCLSwiftWrapper", "RIPEMD160"]
        ),
        .testTarget(name: "BLSCTTests", dependencies: ["BLSCT"])
    ]
)
