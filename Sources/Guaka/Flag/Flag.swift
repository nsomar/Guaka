//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

public struct Flag: Hashable {
  
  public let longName: String
  public let shortName: String?
  public let inheritable: Bool
  public let description: String
  
  public let type: CommandStringConvertible.Type
  public let required: Bool
  
  public var value: CommandStringConvertible?
  public var didSet: Bool = false
  
  public var deprecatedStatus = DeprecationStatus.notDeprecated
  
  public init(longName: String,
              shortName: String? = nil,
              value: CommandStringConvertible,
              inheritable: Bool = true,
              description: String = "") {
    
    self.longName = longName
    self.shortName = shortName
    self.value = value
    self.inheritable = inheritable
    self.description = description
    self.type = type(of: value)
    self.required = true
  }
  
  public init(longName: String,
              type: CommandStringConvertible.Type,
              required: Bool = false,
              shortName: String? = nil,
              inheritable: Bool = false,
              description: String = "") {
    
    self.longName = longName
    self.shortName = shortName
    self.type = type
    self.inheritable = inheritable
    self.description = description
    self.required = required
  }
  
  
  var isBool: Bool {
    return value is Bool
  }
  
  public var hashValue: Int {
    return longName.hashValue
  }
}

public func ==(left: Flag, right: Flag) -> Bool {
  return left.hashValue == right.hashValue
}

extension Flag {
  
  func convertValueToInnerType(value: String) throws -> CommandStringConvertible {
    
    do {
      let v = try self.type.fromString(flagValue: value)
      return v as! CommandStringConvertible
    } catch let e as CommandConvertibleError {
      throw CommandErrors.incorrectFlagValue(self.longName, e.error)
    }
    
  }
  
}


extension Flag {
  
  var flagPrintableName: String {
    var nameParts: [String] = []
    
    nameParts.append("  ")
    if let shortName = shortName {
      nameParts.append("-\(shortName), ")
    } else {
      nameParts.append("    ")
    }
    
    nameParts.append("--\(longName)")
    nameParts.append(" \(self.type.typeDescription)")
    
    return nameParts.joined()
  }
  
  var flagPrintableDescription: String {
    if description.characters.count == 0 {
      return self.flagValueDescription
    }
    
    return "\(description) \(flagValueDescription)"
  }
  
  var flagValueDescription: String {
    if let value = value {
      return "(default \(value))"
    }
    
    if required {
      return "(required)"
    }
    
    return ""
  }
  
}
