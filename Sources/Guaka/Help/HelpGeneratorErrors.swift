//
//  HelpGeneratorErrors.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 20/11/2016.
//
//

extension HelpGenerator {

  func errorString(forError error: CommandError) -> String {
    return [
      "Error: \(errorMessage(forError: error))",
      errorHelpMessage,
      "\n\(errorMessage(forError: error))",
      "exit status 255"
      ].joined(separator: "\n")
  }

  func errorMessage(forError error: CommandError) -> String {
    switch error {
    case let .flagNotFound(flag):
      return "unknown shorthand flag: '\(flag)'"
    case let .requiredFlagsWasNotSet(flag, type):
      return "required flag was not set: '\(flag)' expected type: '\(type)'"
    case let .incorrectFlagValue(flag, error):
      return "wrong flag value passed for flag: '\(flag)' \(error)"
    default:
      return "General error encountered"
    }
  }

}
