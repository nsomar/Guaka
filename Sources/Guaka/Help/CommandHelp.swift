//
//  CommandHelp.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//


/// Structure that represents a Command information.
///
/// When the help is about to be printed, a `CommandHelp` is generated from the current `Command`.
/// A `CommandHelp` represents all the info required to print the help message of a command.
///
/// a `HelpGenerator` is created and passed this `CommandHelp`.
/// the `HelpGenerator` is used to print the help message string
public struct CommandHelp {

  /// The command name
  public let name: String

  /// The command full name with the name of all its parents. For example `git show help`
  public let fullName: String

  /// The command usage string
  public let usage: String

  /// The command full usage string containg the full name of the command (that contain the parents)
  public let fullUsage: String

  /// The command long description message.
  public let longDescriptionMessage: String?

  /// The command short description message.
  public let shortDescriptionMessage: String?

  /// Does this command have an example
  public let hasExample: Bool

  /// The command example message
  public let example: String?

  /// Is this command deprecated
  public let isDeprecated: Bool

  /// The command deprication message
  public let deprecationMessage: String?

  /// Does this command have aliases
  public let hasAliases: Bool

  /// The command aliases array
  public let aliases: [String]

  /// Does this command have sub commands
  public let hasSubCommands: Bool

  /// The command subcommands
  public let subCommands: [CommandHelp]

  /// Does this command have flags
  public let hasFlags: Bool

  /// The command local flags. These are the flags that the command defines.
  public let localFlags: [FlagHelp]

  /// The command global flags. These are the flags the command inherited from its parents.
  /// Contains a list of inheritable flags.
  public let globalFlags: [FlagHelp]

  init(command: Command) {
    name = (try? command.name()) ?? ""
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

  /// Full path `git show origin`
  private static func fullPath(forCommand command: Command) -> String {
    return path(forCommand: command) + command.nameOrEmpty
  }

  /// Full path `git show origin use as its`
  private static func fullUsage(forCommand command: Command) -> String {
    return path(forCommand: command) + command.usage
  }

  /// Return a commands path
  private static func path(forCommand command: Command) -> String {
    if command.path.count <= 1 {
      return ""
    } else {
      return command.path.dropLast().joined(separator: " ") + " "
    }
  }

  /// Return a command sub commands
  private static func subCommands(command: Command) -> [CommandHelp] {
    return command.commands.map { CommandHelp(command: $0) }.sorted { $0.name < $1.name }
  }

  /// Return a command flags
  private static func flags(command: Command) -> (local: [FlagHelp], global: [FlagHelp]) {
    return flags(forFlagSet: command.flagSet, flags: Array(command.flags))
  }

  static func flags(forFlagSet flagSet: FlagSet, flags: [Flag]) -> (local: [FlagHelp], global: [FlagHelp]) {

    let localFlags = flags.sorted { $0.longName < $1.longName }.map { FlagHelp (flag: $0) }
    let globalFlags = flagSet.globalFlags(withLocalFlags: flags)
      .sorted { $0.longName < $1.longName }.map { FlagHelp (flag: $0) }

    return (localFlags, globalFlags)
  }
  
}
