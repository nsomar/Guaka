//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

public struct Flags {

  let flagsDict: [String: Flag]

  init(flags: [String: Flag]) {
    self.flagsDict = flags
  }


  /// All the flags passed
  public var flags: [Flag] {
    return Array(flagsDict.values)
  }


  /// Gets a flag with a name
  ///
  /// - parameter name: the flag name
  ///
  /// - returns: the flag
  public subscript(name: String) -> Flag? {
    return flagsDict[name]
  }


  /// Gets a flag with a name
  ///
  /// - parameter name: the flag name
  ///
  /// - returns: the flag
  public subscript(valueForName name: String) -> Any? {
    return flagsDict[name]?.value
  }



  /// Gets an integer value for a flag
  ///
  /// - parameter name: the flag name
  ///
  /// - returns: the value if the flag is found
  public func getInt(name: String) -> Int? {
    return flagsDict[name]?.value as? Int
  }


  /// Gets a bool value for a flag
  ///
  /// - parameter name: the flag name
  ///
  /// - returns: the value if the flag is found
  public func getBool(name: String) -> Bool? {
    return flagsDict[name]?.value as? Bool
  }


  /// Gets a string value for a flag
  ///
  /// - parameter name: the flag name
  ///
  /// - returns: the value if the flag is found
  public func getString(name: String) -> String? {
    return flagsDict[name]?.value as? String
  }


  /// Get a value for a type
  ///
  /// - parameter name: the flag name
  /// - parameter type: the type of the flag
  ///
  /// - returns: the value if the flag is found
  public func get<T: CommandStringConvertible>(name: String, type: T.Type) -> T? {
    return flagsDict[name]?.value as? T
  }

}
