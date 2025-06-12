// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "GridMinders",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "GridMinders", targets: ["GridMinders"])
    ],
    targets: [
        .executableTarget(
            name: "GridMinders",
            path: "Sources/GridMinders"
        )
    ]
)
