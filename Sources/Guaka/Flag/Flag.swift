//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


/// Flag struct representing a flag
///
/// ----
/// Example
/// Create a flag with a default value
/// ```
/// let flag = Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc")
/// ```
///
/// Create a non required flag without value
/// ```
/// let flag = Flag(longName: "debug", type: Int.self)
/// ```
///
/// Create a required flag without value
/// ```
/// let flag = Flag(longName: "debug", type: Int.self, required: true)
/// ```
public struct Flag: Hashable {


  /// Flag long name. Such as `verbose`
  public let longName: String


  /// Flag short name. Should be one letter. Such as `v`
  public let shortName: String?


  /// Set the flag to be inheritable
  /// An inheritable flag is valid for a command and all its subcommands
  public let inheritable: Bool


  /// The flag description printed in the help beside the flag name
  public let description: String


  /// Flag value type.
  public let type: FlagValueStringConvertible.Type


  /// Set the flag to be required/
  /// A required flag must be set in order for commands to be executed.
  public let required: Bool


  /// Flag value.
  /// The value can be `int`, `bool`, `string` or any other type that implements `FlagValueStringConvertible`
  public var value: FlagValueStringConvertible?


  /// Flag deprecation status.
  public var deprecationStatus = DeprecationStatus.notDeprecated


  /// Gets the flag hash value.
  public var hashValue: Int {
    return longName.hashValue
  }


  /// Return if the flag is a boolean or not.
  var isBool: Bool {
    return value is Bool
  }


  /// Was the flag value set from the arguments
  var didSet: Bool = false


  /// Creats a new flag
  ///
  /// - parameter longName:    Flag long name
  /// - parameter shortName:   Flag short name
  /// - parameter value:       Flag default value
  /// - parameter inheritable: Flag inheritable status
  /// - parameter description: Flag description to be shown when displaying command help
  public init(longName: String,
              shortName: String? = nil,
              value: FlagValueStringConvertible,
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


  /// Creats a new flag
  ///
  /// - parameter longName:    Flag long name
  /// - parameter shortName:   Flag short name
  /// - parameter type:        Flag value type
  /// - parameter required:    Flag requirement status
  /// - parameter inheritable: Flag inheritable status
  /// - parameter description: Flag description to be shown when displaying command help
  public init(longName: String,
              shortName: String? = nil,
              type: FlagValueStringConvertible.Type,
              required: Bool = false,
              inheritable: Bool = false,
              description: String = "") {

    self.longName = longName
    self.shortName = shortName
    self.type = type
    self.inheritable = inheritable
    self.description = description
    self.required = required
  }

}


/// Check for flags equality
public func ==(left: Flag, right: Flag) -> Bool {
  return left.hashValue == right.hashValue
}
