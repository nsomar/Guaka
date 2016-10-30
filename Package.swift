import PackageDescription

let package = Package(
  name: "Macaw",
  targets: [
    Target(name: "Macaw")
  ],
  dependencies: [.Package(url: "https://github.com/oarrabi/StringScanner", majorVersion: 0)]
)
