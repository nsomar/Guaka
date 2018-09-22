//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


/// Flags represent an abstraction on a list of flags
/// It provides method to get the flags by name
/// And functions to get int, string, bool and custom types
///
/// ------
/// Example
///
/// ```
/// // flags: Flags
/// flags.getInt(name: "verbose") // return integer value of flag verbose if possible
/// flags.getBool(name: "verbose") // return boolean value of flag verbose if possible
/// flags.getString(name: "user") // return string value of flag user if possible
/// flags.get(name: "debug", type: YourType.self) // get the value of debug if it is of YourType
/// ```
///
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
  public subscript(valueForName name: String) -> FlagValue? {
    return flagsDict[name]?.value
  }


  /// Gets a flag with a name
  ///
  /// - parameter name: the flag name
  ///
  /// - returns: the flag
  public subscript(valuesForName name: String) -> [FlagValue]? {
    return flagsDict[name]?.values
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
  public func get<T: FlagValue>(name: String, type: T.Type) -> T? {
    return flagsDict[name]?.value as? T
  }


  /// Get an array of values for a type
  ///
  /// - parameter name: the flag name
  /// - parameter type: the array type of the flag
  ///
  /// - returns: the values if the flag is found
  public func get<T: FlagValue>(name: String, type: [T].Type) -> [T]? {
    return flagsDict[name]?.values as? [T]
  }

}
