//
//  CommandHelp.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

public struct CommandHelp {

  public let name: String
  public let fullName: String

  public let usage: String
  public let fullUsage: String

  public let longDescriptionMessage: String?
  public let shortDescriptionMessage: String?

  public let hasExample: Bool
  public let example: String?

  public let isDeprecated: Bool
  public let deprecationMessage: String?

  public let hasAliases: Bool
  public let aliases: [String]

  public let hasSubCommands: Bool
  public let subCommands: [CommandHelp]

  public let hasFlags: Bool

  public let localFlags: [FlagHelp]
  public let globalFlags: [FlagHelp]

  init(command: CommandType) {
    name = command.name
    usage = command.usage

    fullUsage = CommandHelp.fullUsage(forCommand: command)
    fullName = CommandHelp.fullPath(forCommand: command)

    longDescriptionMessage = command.longMessage
    shortDescriptionMessage = command.shortMessage

    isDeprecated = command.deprecationStatus.isDeprecated
    deprecationMessage = command.deprecationStatus.deprecationMessage

    hasAliases = command.aliases.count > 0
    aliases = command.aliases

    let commands = CommandHelp.subCommands(command: command)

    hasSubCommands = commands.count > 0
    subCommands = commands

    hasExample = command.example != nil
    example = command.example

    let flags = CommandHelp.flags(command: command)

    localFlags = flags.local
    globalFlags = flags.global
    hasFlags = flags.local.count + flags.global.count > 0
  }

  private static func fullPath(forCommand command: CommandType) -> String {
    return path(forCommand: command) + command.name
  }

  private static func fullUsage(forCommand command: CommandType) -> String {
    return path(forCommand: command) + command.usage
  }

  private static func path(forCommand command: CommandType) -> String {
    if command.path.count <= 1 {
      return ""
    } else {
      return command.path.dropLast().joined(separator: " ") + " "
    }
  }

  private static func subCommands(command: CommandType) -> [CommandHelp] {
    return command.commands.map { CommandHelp(command: $0) }.sorted { $0.name < $1.name }
  }

  private static func flags(command: CommandType) -> (local: [FlagHelp], global: [FlagHelp]) {
    return flags(forFlagSet: command.flagSet, flags: Array(command.flags))
  }

  static func flags(forFlagSet flagSet: FlagSet, flags: [Flag]) -> (local: [FlagHelp], global: [FlagHelp]) {

    let localFlags = flags.sorted { $0.longName < $1.longName }.map { FlagHelp (flag: $0) }
    let globalFlags = flagSet.globalFlags(withLocalFlags: flags)
      .sorted { $0.longName < $1.longName }.map { FlagHelp (flag: $0) }

    return (localFlags, globalFlags)
  }
  
}
