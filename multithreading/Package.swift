// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "multithreading",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        .package(name: "SnapKit", url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.6.0"))
    ],
    targets: [
        .target(
            name: "multithreading",
            dependencies: ["SnapKit"])
    ]
)

