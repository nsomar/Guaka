//
//  Errors.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


/// Command Error Enum
///
/// - wrongFlagPattern:        Received a wrong flag patter, such as `---f`
/// - flagNeedsValue:          Flag requires a value that was not set
/// - flagNotFound:            Flag with name cannot be found
/// - requiredFlagsWasNotSet:  Required flag was not set
/// - unexpectedFlagPassed:    Parsed an unexpected flag name
/// - commandGeneralError:     General command related error
/// - unknownError:            Unknown error occured
/// - incorrectFlagValue:      An incorrect value type was passed to the flag
/// - wrongCommandUsageString: Wrong usage string was passed to the command
/// - wrongFlagLongName:       Wrong long name was passed for flag
/// - wrongFlagShortName:      Wrong long name was passed for flag
public enum CommandError: Error {

  /// Received a wrong flag patter, such as `---f`
  case wrongFlagPattern(String)

  /// Flag requires a value that was not set
  case flagNeedsValue(String, String)

  /// Flag with name cannot be found
  case flagNotFound(String)

  /// Required flag was not set
  case requiredFlagsWasNotSet(String, Any.Type)

  /// parsed an unexpected flag name
  case unexpectedFlagPassed(String, [String])

  /// general command related error
  case commandGeneralError(Command, Error)

  /// unknown error occured
  case unknownError

  /// an incorrect value type was passed to the flag
  case incorrectFlagValue(String, String)

  /// Wrong usage string was passed to the command
  case wrongCommandUsageString(String)

  /// Wrong long name was passed for flag
  case wrongFlagLongName(String)

  /// Wrong short name was passed for flag
  case wrongFlagShortName(String)
}
