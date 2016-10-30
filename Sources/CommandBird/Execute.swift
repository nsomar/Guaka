//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import StringScanner

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
  
  
  func parseMultiFlagWithEqual(name: String) throws -> ([Flag: Any], Flag?) {
    let scanner = StringScanner(string: name)
    var ret = [Flag: Any]()
    
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
