//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

public struct Flag: Hashable {
  public let longName: String
  public let shortName: String?
  public let inheritable: Bool
  
  public var value: Any
  
  public init(longName: String, value: CommandStringConvertible, shortName: String? = nil, inheritable: Bool = true) {
    self.longName = longName
    self.shortName = shortName
    self.value = value
    self.inheritable = inheritable
  }
  
  var isBool: Bool {
    return value is Bool
  }
  
  public var hashValue: Int {
    return longName.hashValue
  }
}

public func ==(left: Flag, right: Flag) -> Bool {
  return left.hashValue == right.hashValue
}

extension Flag {
  func convertValueToInnerType(value: String) throws -> CommandStringConvertible {
    guard
      let typedValue = self.value as? CommandStringConvertible,
      let v = type(of: typedValue).fromString(command: value) else {
      throw CommandErrors.incorrectFlagValue(self.longName, value, Int.self)
    }
    
    return v as! CommandStringConvertible
  }
}


struct FlagSet {
  let flags: [String: Flag]
  
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
