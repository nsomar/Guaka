//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import StringScanner

extension FlagSet {
  
  func parse(args: [String]) throws -> ([Flag: CommandStringConvertible], [String]) {
    var ret = [Flag: CommandStringConvertible]()
    var remainigArgs = [String]()
    
    var pendingFlag: Flag?
    
    for arg in args {
      let token = ArgTokenType(fromString: arg)
      
      if
        let pendingFlag = pendingFlag,
        token.isFlag {
        throw CommandErrors.flagNeedsValue(pendingFlag.longName, token.flagName ?? "")
      }
      
      switch token {
      case let .longFlagWithEqual(name, value):
        let flag = try getFlag(forName: name)
        try ret[flag] = flag.convertValueToInnerType(value: value)
        
      case let .shortFlagWithEqual(name, value):
        let flag = try getFlag(forName: name)
        try ret[flag] = flag.convertValueToInnerType(value: value)
        
      case let .shortFlag(name):
        let flag = try getFlag(forName: name)
        if self.isFlagSatisfied(token: token) {
          ret[flag] = true
        } else {
          pendingFlag = flag
        }
        
      case let .longFlag(name):
        let flag = try getFlag(forName: name)
        if self.isFlagSatisfied(token: token) {
          ret[flag] = true
        } else {
          pendingFlag = flag
        }
        
      case let .positionalArgument(value):
        if let pf = pendingFlag {
          ret[pf] = try pf.convertValueToInnerType(value: value)
          pendingFlag = nil
        } else {
          remainigArgs.append(value)
        }
        
      case let .shortMultiFlag(name):
        let (partialRet, pf) = try parseMultiFlagWithEqual(name: name)
        ret += partialRet
        pendingFlag = pf
        
      case let .invalidFlag(string):
        throw CommandErrors.wrongFlagPattern(string)
      }
      
    }
    
    if let pendingFlag = pendingFlag {
      throw CommandErrors.flagNeedsValue(pendingFlag.longName, "No more flags")
    }
    
    return (ret, remainigArgs)
  }
 
  private func parseMultiFlagWithEqual(name: String) throws -> ([Flag: CommandStringConvertible], Flag?) {
    let scanner = StringScanner(string: name)
    var ret = [Flag: CommandStringConvertible]()
    
    while true {
      let token = ArgTokenType(fromString: "-\(scanner.remainingString)")
      
      switch token {
      case let .shortFlagWithEqual(name, value):
        let flag = try getFlag(forName: name)
        try ret[flag] = flag.convertValueToInnerType(value: value)
        return (ret, nil)
        
      case let .shortFlag(name):
        let flag = try getFlag(forName: name)
        if self.isFlagSatisfied(token: token) {
          ret[flag] = true
          return (ret, nil)
        } else {
          return (ret, flag)
        }
        
      default:
        break;
      }
      
      if case let .value(current) = scanner.scan(length: 1) {
        let flag = try getFlag(forName: current)
        if flag.isBool {
          ret[flag] = true
        } else {
          ret[flag] = try flag.convertValueToInnerType(value: scanner.remainingString)
          break
        }
      }
    }
    
    return (ret, nil)
  }

  func getPreparedFlags(withFlagValues values: [Flag: CommandStringConvertible])
    throws -> [String: Flag] {
      
      var returnFlags = self.getFlagsWithLongNames()
      
      try values.forEach { flag, value in
        guard var foundFlag = self.flags[flag.longName] else {
          throw CommandErrors.unexpectedFlagPassed(flag.longName, "\(value)")
        }
        
        foundFlag.value = value
        returnFlags[foundFlag.longName] = foundFlag
      }

      return returnFlags
  }
  
  func checkAllRequiredFlagsAreSet(preparedFlags: [String: Flag]) -> Result {
    for flag in requiredFlags {
      guard let preparedFlag = preparedFlags[flag.longName] else {
        return .flagError(CommandErrors.flagNotFound(flag.longName))
      }
      
      if preparedFlag.value == nil {
        return .flagError(CommandErrors.requiredFlagsWasNotSet(flag.longName, flag.type))
      }
    }
    
    return .success
  }
  
  private func getFlag(forName name: String) throws -> Flag {
    guard let flag = flags[name] else {
      throw CommandErrors.flagNotFound(name)
    }
    
    return flag
  }
  
  private func getFlagsWithLongNames() -> [String: Flag] {
    var returnFlags = [String: Flag]()
    self.flags.forEach { key, flag in
      if key == flag.longName {
        returnFlags[key] = flag
      }
    }
    
    return returnFlags
  }
  
}

func += <K, V> (left: inout [K: V], right: [K: V]) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}

