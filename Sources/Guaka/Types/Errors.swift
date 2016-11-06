//
//  Errors.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


public enum CommandErrors: Error {
  
  case wrongFlagPattern(String)
  case commandAlreadyInserterd(CommandType)
  case flagNotFound(String)
  
  case flagNeedsValue(String, String)
  case requiredFlagsWasNotSet(String, Any.Type)
  case unexpectedFlagPassed(String, String)
  case commandGeneralError(CommandType, Error)
  
  case errorConvertingFlagValue(String, Any.Type, String)
  case incorrectFlagValue(String, String)
}

extension CommandErrors {
  
  var error: String {
    switch self {
    case let .flagNotFound(flag):
      return "unknown shorthand flag: '\(flag)'"
    case let .errorConvertingFlagValue(flag, type, error):
      return "error setting flag value for flag: '\(flag)' type: '\(type)' error: '\(error)'"
    case let .requiredFlagsWasNotSet(flag, type):
      return "required flag was not set: '\(flag)' expected type: '\(type)'"
    case let .incorrectFlagValue(flag, error):
      return "wrong flag value passed for flag: '\(flag)' \(error)"
    default:
      return "Error: General error encountered"
    }
  }
  
  func errorMessage(forCommand command: CommandType) -> String {
    return [
      "Error: \(error)",
      command.innerHelpMessage,
      "\n\(error)",
      "exit status 255"
    ].joined(separator: "\n")
  }
  
  static func generalError(forCommand command: CommandType) -> String {
    return [
      "Error: General error encountered",
      command.innerHelpMessage,
      "\nGeneral error encountered",
      "exit status 255"
      ].joined(separator: "\n")
  }
  
}
