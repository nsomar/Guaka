//
//  Errors.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


public enum CommandError: Error {

  case wrongFlagPattern(String)
  case flagNeedsValue(String, String)
  case flagNotFound(String)

  case requiredFlagsWasNotSet(String, Any.Type)
  case unexpectedFlagPassed(String, String)
  case commandGeneralError(CommandType, Error)

  case unknownError

  case incorrectFlagValue(String, String)

  case commandAlreadyInserterd(CommandType)
}
