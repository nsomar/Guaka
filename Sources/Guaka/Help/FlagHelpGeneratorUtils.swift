//
//  HelpGeneratorFlags.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 20/11/2016.
//
//

enum FlagHelpGeneratorUtils {

  /// Generate a string message for the list of flag
  ///
  /// - parameter flags: flags to generate help for
  static func description(forFlags flags: [FlagHelp]) -> String {

    let notDeprecatedFlags = flags.filter{ $0.isDeprecated == false }

    if notDeprecatedFlags.count == 0 { return "" }

    let longestFlagName =
      notDeprecatedFlags.map { flagPrintableName(flag: $0) }
        .sorted { s1, s2 in return s1.count < s2.count}
        .last!.count

    let names =
      notDeprecatedFlags.map { flag -> String in
        let printableName = flagPrintableName(flag: flag)
        let diff = longestFlagName - printableName.count
        let addition = String(repeating: " ", count: diff)
        return "\(printableName)\(addition)  "
    }

    let descriptions = notDeprecatedFlags.map { flagPrintableDescription(flag: $0) }

    return zip(names, descriptions).map { $0 + $1 }.joined(separator: "\n")
  }

  /// Return the flag printable name
  static func flagPrintableName(flag: FlagHelp) -> String {
    var nameParts: [String] = []

    nameParts.append("  ")
    if let shortName = flag.shortName {
      nameParts.append("-\(shortName), ")
    } else {
      nameParts.append("    ")
    }

    nameParts.append("--\(flag.longName)")
    nameParts.append(" \(flag.typeDescription)")

    return nameParts.joined()
  }

  /// Return the flag printable description
  static func flagPrintableDescription(flag: FlagHelp) -> String {
    if flag.description == "" {
      return flagValueDescription(flag: flag)
    }

    return "\(flag.description) \(flagValueDescription(flag: flag))"
  }

  static func flagValueDescription(flag: FlagHelp) -> String {
    if flag.isBoolean { return "" }

    if let value = flag.value {
      return "(default \(value))"
    }

    if flag.isRequired {
      return "(required)"
    }
    
    return ""
  }

}
