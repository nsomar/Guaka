//
//  Errors.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


enum CommandErrors: Error {
  case wrongFlagPattern(String)
  case commandAlreadyInserterd(Command)
  case flagNotFound(String)
  case incorrectFlagValue(String, String, Any.Type)
  case flagNeedsValue(String, String)
}
