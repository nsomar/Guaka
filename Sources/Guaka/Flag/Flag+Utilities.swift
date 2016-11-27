//
//  Flag+Utilities.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import Foundation


extension Flag {

  /// Converts the value from string to the internal flag value type
  /// Throws exception if cannot convert
  func convertValueToInnerType(value: String) throws -> FlagValueStringConvertible {
    do {
      return try self.type.fromString(flagValue: value)
    } catch let e as FlagValueConversationError {
      throw CommandError.incorrectFlagValue(self.longName, e.error)
    }
  }

}

