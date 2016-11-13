//
//  Command+Utilities.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 13/11/2016.
//
//

import Foundation

extension Command {

  static func name(forUsage usage: String) -> String {
    if let index = usage.find(string: " ") {
      return usage[usage.startIndex..<index]
    } else {
      return usage
    }
  }
  
}
