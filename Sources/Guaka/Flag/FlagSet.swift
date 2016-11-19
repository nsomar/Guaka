//
//  FlagSet.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

struct FlagSet {

  let flags: [String: Flag]
  let requiredFlags: [Flag]

  init(flags: [Flag]) {
    var flagMap = [String: Flag]()

    flags.forEach {

      if let shortName = $0.shortName {
        flagMap[shortName] = $0
      }

      flagMap[$0.longName] = $0
    }

    self.flags = flagMap
    self.requiredFlags = FlagSet.requiredFlags(flags: flags)
  }

  fileprivate init(flagsMap: [String: Flag]) {
    self.flags = flagsMap
    self.requiredFlags = FlagSet.requiredFlags(flags: flags.values)
  }

  func isBool(flagName: String) -> Bool {
    guard let flag = flags[flagName] else {
      return false
    }

    return flag.isBool
  }

  func isFlagSatisfied(token: ArgTokenType) -> Bool {
    switch token {
    case .shortFlagWithEqual:
      fallthrough
    case .longFlagWithEqual:
      fallthrough
    case .invalidFlag:
      fallthrough
    case .positionalArgument:
      fallthrough
    case .shortMultiFlag(_):
      return true

    case let .shortFlag(name):
      return isBool(flagName: name)
    case let .longFlag(name):
      return isBool(flagName: name)
    }
  }
}


extension FlagSet {
  static func requiredFlags<T: Sequence>(flags: T) -> [Flag]
  where T.Iterator.Element == Flag {
    let unique = Set(flags)
    let required = unique.filter { $0.required }
    return Array(required)
  }
}


extension FlagSet {

  func globalFlags(withLocalFlags flags: [Flag]) -> [Flag] {
    let allFlags = Set(self.flags.values)
    let localFlags = Set(flags)
    return Array(allFlags.subtracting(localFlags))
  }
  
}


extension FlagSet {

  func flagSetAppendingHelp() -> FlagSet {
    var flags = self.flags
    flags["help"] = helpFlag
    flags["h"] = helpFlag

    return FlagSet(flagsMap: flags)
  }

  private var helpFlag: Flag {
    return Flag(longName: "help", shortName: "h", value: false, inheritable: true, description: "Show help")
  }

}

extension Flag {

  var isDeprecated: Bool {
    if case .deprecated = deprecationStatus { return true}
    return false
  }

  var deprecationMessage: String {
    if case let .deprecated(message) = deprecationStatus {
      return "Flag --\(longName) has been deprecated, \(message)"
    }
    return ""
  }
}
