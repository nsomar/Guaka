//
//  FlagSet+Parsing.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 26/11/2016.
//
//

import StringScanner


extension FlagSet {

  /// Pares the arguments to return the flag values and the positional arguments
  ///
  /// - parameter args: the arguments to parse
  ///
  /// - throws: throws exception if received wrong arguments
  ///
  /// - returns: The flag values and the positional arguments
  func parse(args: [String]) throws -> ([Flag: [FlagValue]], [String]) {
    var ret = [Flag: [FlagValue]]()
    var remainingArgs = [String]()

    var pendingFlag: Flag?

    // Iterate all args
    for arg in args {

      // Tokenize
      let token = ArgTokenType(fromString: arg)

      // If we have pending flags that needs a value, and the current token is flag
      // return flagNeedsValue exception
      if
        let pendingFlag = pendingFlag,
        token.isFlag {
        throw CommandError.flagNeedsValue(pendingFlag.longName, token.flagName ?? "")
      }

      switch token {

      case let .longFlagWithEqual(name, value),
           let .shortFlagWithEqual(name, value):
        let flag = try getFlag(forName: name)
        let flagValue = try flag.convertValueToInnerType(value: value)
        ret.insert(flagValue, forKey: flag)

      case let .shortFlag(name):
        let flag = try getFlag(forName: name)
        if self.isFlagSatisfied(token: token) {
          ret.insert(true, forKey: flag)
        } else {
          pendingFlag = flag
        }

      case let .longFlag(name):
        let flag = try getFlag(forName: name)
        if self.isFlagSatisfied(token: token) {
          ret.insert(true, forKey: flag)
        } else {
          pendingFlag = flag
        }

      case let .positionalArgument(value):
        if let pf = pendingFlag {
          let flagValue = try pf.convertValueToInnerType(value: value)
          ret.insert(flagValue, forKey: pf)
          pendingFlag = nil
        } else {
          remainingArgs.append(value)
        }

      case let .shortMultiFlag(name):
        let (partialRet, pf) = try parseMultiFlagWithEqual(name: name)
        ret += partialRet
        pendingFlag = pf

      case let .invalidFlag(string):
        throw CommandError.wrongFlagPattern(string)
      }

    }

    // If we finished parsing and we have a flag without value, throw flagNeedsValue exception
    if let pendingFlag = pendingFlag {
      throw CommandError.flagNeedsValue(pendingFlag.longName, "No more flags")
    }

    return (ret, remainingArgs)
  }

  /// Parses `-abcd=123` flag set
  /// Converts it to: `[a: true, b: true, c: true, d: 123]`
  private func parseMultiFlagWithEqual(name: String) throws -> ([Flag: [FlagValue]], Flag?) {
    let scanner = StringScanner(string: name)
    var ret = [Flag: [FlagValue]]()

    while true {
      let token = ArgTokenType(fromString: "-\(scanner.remainingString)")

      switch token {
      case let .shortFlagWithEqual(name, value):
        let flag = try getFlag(forName: name)
        let flagValue = try flag.convertValueToInnerType(value: value)
        ret.insert(flagValue, forKey: flag)
        return (ret, nil)

      case let .shortFlag(name):
        let flag = try getFlag(forName: name)
        if self.isFlagSatisfied(token: token) {
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
          ret.insert(true, forKey: flag)
        } else {
          let flagValue = try flag.convertValueToInnerType(value: scanner.remainingString)
          ret.insert(flagValue, forKey: flag)
          break
        }
      }
    }

    return (ret, nil)
  }

  /// Check if the flag is a boolean
  func isBool(flagName: String) -> Bool {
    guard let flag = flags[flagName] else {
      return false
    }

    return flag.isBool
  }

  /// Is flag token satisfied
  ///
  /// - parameter token: the flag token
  ///
  /// - returns: true if the flag is satisfied
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

  /// Get a flag with a name
  ///
  /// - parameter name: the flag name
  ///
  /// - throws: flagNotFound if flag is not found
  ///
  /// - returns: the flag if found
  private func getFlag(forName name: String) throws -> Flag {
    guard let flag = flags[name] else {
      throw CommandError.flagNotFound(name)
    }
    
    return flag
  }
  
}

extension Dictionary where Element == (key: Flag, value: [FlagValue]) {
  mutating func insert(_ value: FlagValue, forKey key: Flag) {
    // if the flag is repeatable, then try and get the current values so we can
    // append the new one.
    if key.repeatable, var values = self[key] {
      values.append(value)
      self[key] = values
    // If there are no values, or we are not a repeatable flag, then just set the values
    } else {
      self[key] = [value]
    }
  }
}
