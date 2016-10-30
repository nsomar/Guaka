//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

struct Flag: Hashable {
  let longName: String
  let shortName: String?
  let defaultValue: CommandStringConvertible
  let inheritable: Bool
  
  init(longName: String, defaultValue: CommandStringConvertible, shortName: String? = nil, inheritable: Bool = true) {
    self.longName = longName
    self.shortName = shortName
    self.defaultValue = defaultValue
    self.inheritable = inheritable
  }
  
  var isBool: Bool {
    return defaultValue is Bool
  }
  
  var hashValue: Int {
    return longName.hashValue
  }
}

func ==(left: Flag, right: Flag) -> Bool {
  return left.hashValue == right.hashValue
}

extension Flag {
  func convertValueToInnerType(value: String) throws -> Any {
    guard let v = type(of: defaultValue).fromString(command: value) else {
      throw CommandErrors.incorrectFlagValue(self.longName, value, Int.self)
    }
    
    return v
  }
}


struct FlagSet {
  let flags: [String: Flag]
//  var flagValues: [String: Any] = [:]
  
  init(flags: [Flag]) {
    var flagMap = [String: Flag]()
    
    flags.forEach {
      
      if let shortName = $0.shortName {
        flagMap[shortName] = $0
      }
      
      flagMap[$0.longName] = $0
    }
    
    self.flags = flagMap
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
