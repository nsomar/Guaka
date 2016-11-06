//
//  CommandStringConvertible.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

public protocol CommandStringConvertible {
  static func fromString(flagValue value: String) throws -> Any
  static var typeName: String { get }
}

public enum CommandConvertibleError: Error {
  case conversionError(String)
  
  var error: String {
    switch self {
    case .conversionError(let s):
      return s
    default:
      return ""
    }
  }
}

extension Bool: CommandStringConvertible {
  
  public static func fromString(flagValue value: String) throws -> Any {
    if value == "1" {
      return true
    } else if value == "0" {
      return false
    } else if let b = Bool(value) {
      return b
    }
    
    throw CommandConvertibleError.conversionError("cannot convert '\(value)' to '\(Bool.self)' ")
  }
  
  public static var typeName: String { return "bool" }
  
}


extension Int: CommandStringConvertible {
  
  public static func fromString(flagValue value: String) throws -> Any {
    guard let val = Int(value) else {
      throw CommandConvertibleError.conversionError("cannot convert '\(value)' to '\(Int.self)' ")
    }
    
    return val
  }
  
  public static var typeName: String { return "int" }
  
}


extension String: CommandStringConvertible {
  
  public static func fromString(flagValue value: String) throws -> Any {
    return value
  }
  
  public static var typeName: String { return "string" }
  
}
