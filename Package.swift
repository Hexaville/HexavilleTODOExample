// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "HexavilleTODOExample",
    products: [
        .executable(name: "hexaville-todo-example", targets: ["HexavilleTODOExample"]),
        .executable(name: "hexaville-todo-example-dynamodb-migrator", targets: ["HexavilleTODOExampleDynamodbMigrator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Hexaville/HexavilleAuth.git", .upToNextMajor(from: "0.4.0")),
        .package(url: "https://github.com/Hexaville/DynamodbSessionStore.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/kylef/Stencil.git", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        .target(
            name: "HexavilleTODOExampleDynamodbMigrator",
            dependencies: [
                "DynamodbSessionStore"
            ]
        ),
        .target(
            name: "HexavilleTODOExample",
            dependencies: [
                "HexavilleAuth",
                "DynamodbSessionStore",
                "Stencil"
            ]
        ),
    ]
)
