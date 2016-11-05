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
}
