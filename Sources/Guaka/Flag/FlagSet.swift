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
  
  func globalDescription(withLocalFlags flags: [Flag]) -> String {
    let allFlags = Set(self.flags.values)
    let localFlags = Set(flags)
    let globalFlags = Array(allFlags.subtracting(localFlags))
    return description(forFlags: globalFlags)
  }
  
  func localDescription(withLocalFlags flags: [Flag]) -> String {
    return description(forFlags: flags)
  }
  
  private func description(forFlags flags: [Flag]) -> String {
    if flags.count == 0 { return "" }
    
    let sorted = Set(flags).sorted{ f1, f2 in
      f1.longName < f2.longName
    }
    
    let longestFlagName =
      sorted.map { $0.flagPrintableName }
        .sorted { s1, s2 in return s1.characters.count < s2.characters.count}
        .last!.characters.count
    
    let names =
      sorted.map { flag -> String in
        let diff = longestFlagName - flag.flagPrintableName.characters.count
        let addition = String(repeating: " ", count: diff)
        return "\(flag.flagPrintableName)\(addition)  "
    }
    
    let descriptions = sorted.map { $0.flagPrintableDescription }
    
    return zip(names, descriptions).map { $0 + $1 }.joined(separator: "\n")
  }

}


extension FlagSet {
  
  func flagSetAppeningHelp() -> FlagSet {
    var flags = self.flags
    flags["help"] = helpFlag
    flags["h"] = helpFlag
    
    return FlagSet(flagsMap: flags)
  }
  
  private var helpFlag: Flag {
    return Flag(longName: "help", value: false, shortName: "h", inheritable: true, description: "Show help")
  }
  
}
