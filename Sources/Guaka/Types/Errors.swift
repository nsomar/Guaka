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
  case incorrectFlagValue(String, String, Any.Type)
  case flagNeedsValue(String, String)
  case unexpectedFlagPassed(String, String)
}

extension CommandErrors {
  
  var error: String {
    switch self {
    case let .flagNotFound(flag):
      return "unknown shorthand flag: '\(flag)'"
    default:
      return ""
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
