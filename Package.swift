// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Guaka",
    products: [
        .library(name: "Guaka", targets: ["Guaka"])
    ],
    dependencies: [
        .package(url: "https://github.com/nsomar/StringScanner.git", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "Guaka",
            dependencies: [
                "StringScanner"
            ]
        ),

        .testTarget(
            name: "GuakaTests",
            dependencies: [
                "Guaka"
            ]
        )
    ],
    swiftLanguageVersions: [4]
)
