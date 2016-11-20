//
//  FlagHelp.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

public struct FlagHelp {

  public let longName: String
  public let shortName: String?

  public let isRequired: Bool
  public let value: CommandStringConvertible?

  public let typeDescription: String

  public let description: String

  public let isBoolean: Bool

  public let wasChanged: Bool

  public let isDeprecated: Bool
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
