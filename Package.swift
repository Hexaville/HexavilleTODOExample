// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "HexavilleTODOExample",
    targets: [
        Target(name: "HexavilleTODOExample"),
        Target(name: "HexavilleTODOExampleDynamodbMigrator")
    ],
    dependencies: [
        .Package(url: "https://github.com/noppoMan/HexavilleFramework.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Hexaville/HexavilleAuth.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/Hexaville/DynamodbSessionStore.git", majorVersion: 0, minor: 1),
    ]
)
