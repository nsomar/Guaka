//
//  ArgTokenType.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//
import StringScanner



/// tokenize enum
///
/// - longFlag:                matches flags like `--verbose`
/// - longFlagWithEqual:       matches flags like `--verbose=1`
/// - shortFlag:               matches flags like `-v`
/// - shortFlagWithEqual:      matches flags like `-v=1`
/// - shortMultiFlag:          matches flags like `-abc`
/// - invalidFlag:             matches invalid flags like `---`
/// - positionalArgument:      matches positional arguments that are not flags
enum ArgTokenType {

  case longFlag(String), longFlagWithEqual(String, String)
  case shortFlag(String), shortFlagWithEqual(String, String)
  case shortMultiFlag(String)
  case invalidFlag(String)
  case positionalArgument(String)

  /// Is the token a boolean flag
  var isFlag: Bool {
    switch self {
    case .longFlag:
      fallthrough
    case .shortFlag:
      fallthrough
    case .longFlagWithEqual:
      fallthrough
    case .shortFlagWithEqual:
      fallthrough
    case .shortMultiFlag:
      return true

    default:
      return false
    }
  }

  /// Is it a flag that requires values
  var requiresValue: Bool {
    switch self {
    case .longFlag:
      fallthrough
    case .shortFlag:
      fallthrough
    case .shortMultiFlag:
      return true

    default:
      return false
    }
  }

  /// Returns the flag name if the token is a flag
  var flagName: String? {
    switch self {
    case let .longFlag(name):
      return name
    case let .shortFlag(name):
      return name
    case let .longFlagWithEqual(name, _):
      return name
    case let .shortFlagWithEqual(name, _):
      return name
    case let .shortMultiFlag(name):
      return name

    default:
      return nil
    }
  }

  init(fromString string: String) {

    if string.isPrefixed(by: "---") {

      self = .invalidFlag(string)
    } else if string.isPrefixed(by: "--") {

      self = ArgTokenType.parseLongFlag(string)
    } else if string.isPrefixed(by: "-") {

      self = ArgTokenType.parseShortFlag(string)
    } else {
      self = .positionalArgument(string)
    }
  }

}

extension ArgTokenType {

  /// Parses a long flag, like `--verbose`
  fileprivate static func parseLongFlag(_ string: String) -> ArgTokenType {
    let scanner = StringScanner(string: string)
    _ = scanner.drop(length: 2)

    if ArgTokenType.hasEqual(string) {
      let (name, value) = parseEqual(scanner)
      return .longFlagWithEqual(name, value)
    } else {
      return .longFlag(scanner.remainingString)
    }
  }

  /// Parses a short flag like `-a`
  fileprivate static func parseShortFlag(_ string: String) -> ArgTokenType {
    let scanner = StringScanner(string: string)
    _ = scanner.drop(length: 1)

    let length = scanner.remainingString.count

    if length <= 0 {

      return .invalidFlag(string)
    } else if length == 1 {

      return .shortFlag(scanner.remainingString)
    } else {

      if isMultiFlag(scanner) {
        return .shortMultiFlag(scanner.remainingString)
      } else {
        let (name, value) = parseEqual(scanner)
        return .shortFlagWithEqual(name, value)
      }
    }
  }

  /// Parses a `-a=` to (a, 1) and `--abc=123` to (abc, 123)
  fileprivate static func parseEqual(_ scanner: StringScanner) -> (String, String) {
    var name = "", value = ""

    scanner.transaction {
      if case let .value(string) = scanner.scan(untilString: "=") {
        name = string
        _ = scanner.drop(length: 1)
        value = scanner.remainingString
      }
    }

    return (name, value)
  }

  /// Is the scanned flag multiple flags
  /// Return true for `-abc`
  fileprivate static func isMultiFlag(_ scanner: StringScanner) -> Bool {
    if case .value (let str) = scanner.peek(untilString: "=") {
      return str.count > 1
    }

    return scanner.remainingString.count > 1
  }

  /// Return true if the string has equal. like `-a=1`, `-abc=1` and `--verbose=one`
  fileprivate static func hasEqual(_ string: String) -> Bool {
    return string.first { $0 == "=" } != nil
  }
}
