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
  
  
  public init(longName: String,
              value: CommandStringConvertible,
              shortName: String? = nil,
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
              inheritable: Bool = true,
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
    guard
      let v = self.type.fromString(command: value) else {
        throw CommandErrors.incorrectFlagValue(self.longName, value, self.type)
    }
    
    return v as! CommandStringConvertible
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
    nameParts.append(" \(self.type.typeName)")
    
    return nameParts.joined()
  }
  
  var flagPrintableDescription: String {
    if description.characters.count == 0 {
      return "(default \(value!))"
    }
    
    return "\(description) (default \(value!))"
  }
  
}
