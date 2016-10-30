import PackageDescription

let package = Package(
  name: "CommandLine",
  targets: [
    Target(name: "App",
           dependencies: ["CommandBird"]
    ),
    Target(name: "CommandBird")
  ],
  dependencies: [.Package(url: "../StringScanner", majorVersion: 0)]
)
