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
      throw CommandError.incorrectFlagValue(self.longName, e.error)
    }

  }

}

