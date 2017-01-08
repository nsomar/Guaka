//
//  HelpGeneratorErrors.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 20/11/2016.
//
//

extension HelpGenerator {

  public func errorString(forError error: CommandError) -> String {
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
    case let .wrongCommandUsageString(name):
      return "wrong command name used.\nCommand name of '\(name)' is not allowed."
    case let .wrongFlagLongName(name):
      return "wrong flag long name used.\nFlag name of '\(name)' is not allowed."
    case let .wrongFlagShortName(name):
      return "wrong flag short name used.\nFlag name of '\(name)' is not allowed."
    default:
      return "General error encountered"
    }
  }

}
