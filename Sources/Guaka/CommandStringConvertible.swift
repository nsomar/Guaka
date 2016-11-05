//
//  CommandStringConvertible.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


public protocol CommandStringConvertible {
  static func fromString(command value: String) -> Any?
  static var typeName: String { get }
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
  
  public static var typeName: String { return "bool" }
}


extension Int: CommandStringConvertible {
  public static func fromString(command value: String) -> Any? {
    return Int(value)
  }
  
  public static var typeName: String { return "int" }
}

extension String: CommandStringConvertible {
  public static func fromString(command value: String) -> Any? {
    return value
  }
  
  public static var typeName: String { return "string" }
}
