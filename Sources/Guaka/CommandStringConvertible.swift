//
//  CommandStringConvertible.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


public protocol CommandStringConvertible {
  static func fromString(command value: String) -> Any?
}

extension Bool: CommandStringConvertible {
  public static func fromString(command value: String) -> Any? {
    if value == "1" {
      return true
    } else if value == "0" {
      return false
    } else {
      return Bool(value)
    }
  }
}


extension Int: CommandStringConvertible {
  public static func fromString(command value: String) -> Any? {
    return Int(value)
  }
}

extension String: CommandStringConvertible {
  public static func fromString(command value: String) -> Any? {
    return value
  }
}
