import PackageDescription

let package = Package(
  name: "Guaka",
  targets: [
    Target(name: "Guaka")
  ],
  dependencies: [.Package(url: "https://github.com/oarrabi/StringScanner", majorVersion: 0)]
)
