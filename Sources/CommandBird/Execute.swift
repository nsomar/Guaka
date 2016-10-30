//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

extension FlagSet {
  
  func parse(args: [String]) throws -> ([Flag: Any], [String]) {
    var ret = [Flag: Any]()
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
        
      case let .shortMultiFlagWithEqual(names, values):
        let partialRet = try parseMultiFlagWithEqual(names: names, value: values)
        ret += partialRet
        
      case let .invalidFlag(string):
        throw CommandErrors.wrongFlagPattern(string)
        
      default:
        break
      }
      
    }
    
    if let pendingFlag = pendingFlag {
      throw CommandErrors.flagNeedsValue(pendingFlag.longName, "No more flags")
    }
    
    return (ret, remainigArgs)
  }
  
  func parseMultiFlagWithEqual(names: [String], value: String) throws -> [Flag: Any] {
    var ret = [Flag: Any]()
    
    try names.forEach { name in
      let flag = try getFlag(forName: name)
      if flag.isBool
      ret[flag] = try flag.convertValueToInnerType(value: value)
    }
    
    return ret
  }
  
  func getFlag(forName name: String) throws -> Flag {
    guard let flag = flags[name] else {
      throw CommandErrors.flagNotFound(name)
    }
    
    return flag
  }
  
}

func += <K, V> (left: inout [K: V], right: [K: V]) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}
