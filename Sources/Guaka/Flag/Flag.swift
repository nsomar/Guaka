//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


/// Flag struct
public struct Flag: Hashable {

  /// Flag long name
  public let longName: String

  /// Flag short name
  public let shortName: String?

  /// Set the flag to be inheritable
  /// An inheritable flag is valid for a command and all its subcommands
  public let inheritable: Bool

  /// The flag description
  public let description: String

  /// Flag value type
  public let type: CommandStringConvertible.Type

  /// Set the flag to be required
  // A required flag must be set in order for commands to be executed
  public let required: Bool

  /// Flag value
  public var value: CommandStringConvertible?

  /// Flag deprecation status
  public var deprecatedStatus = DeprecationStatus.notDeprecated


  /// Creats a new flag
  ///
  /// - parameter longName:    Flag long name
  /// - parameter shortName:   Flag short name
  /// - parameter value:       Flag default value
  /// - parameter inheritable: Flag inheritable status
  /// - parameter description: Flag description to be shown when displaying command help
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
              type: CommandStringConvertible.Type,
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

  public var hashValue: Int {
    return longName.hashValue
  }

  var isBool: Bool {
    return value is Bool
  }

  var didSet: Bool = false
}

public func ==(left: Flag, right: Flag) -> Bool {
  return left.hashValue == right.hashValue
}
