//
//  Flag+Utilities.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import Foundation


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
