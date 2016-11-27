//
//  FlagHelp.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

/// Structure that represent the information about a flag
public struct FlagHelp {


  /// Flag long name
  public let longName: String


  /// Flag short name
  public let shortName: String?


  /// Is flag required
  public let isRequired: Bool


  /// Flag value.
  public let value: FlagValueStringConvertible?


  /// Flag type description message
  public let typeDescription: String


  /// Flag description messae
  public let description: String


  /// Is flag a boolean
  public let isBoolean: Bool


  /// Was the flag changed by the passed arguments
  public let wasChanged: Bool


  /// Is the flag deprecated
  public let isDeprecated: Bool


  /// The flag deprecation message
  public let deprecationMessage: String?

  
  init(flag: Flag) {
    longName = flag.longName
    shortName = flag.shortName

    isRequired = flag.required

    value = flag.value

    typeDescription = flag.type.typeDescription

    description = flag.description

    isBoolean = flag.isBool

    wasChanged = flag.didSet

    isDeprecated = flag.deprecationStatus.isDeprecated
    deprecationMessage = flag.deprecationStatus.deprecationMessage
  }
  
}
