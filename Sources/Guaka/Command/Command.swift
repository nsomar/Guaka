//
//  Command.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif


public class Command: CommandType {

  public let name: String

  public var commands: [CommandType] = []

  public var inheritablePreRun: ConditionalRun?
  public var preRun: ConditionalRun?
  public var run: Run?
  public var postRun: ConditionalRun?
  public var inheritablePostRun: ConditionalRun?

  public var aliases: [String] = []

  public var shortUsage: String?
  public var longUsage: String?

  public var example: String?

  public var flags: [Flag]

  public var deprecationStatus = DeprecationStatus.notDeprecated

  public var parent: CommandType? {
    willSet {
      if
        let oldParent = parent as? Command,
        let newParent = newValue as? Command,
        newParent !== oldParent {
        newParent.add(subCommand: self, setParent: false)
      }
    }
  }

  /// Initialize a command
  ///
  /// - parameter name:              Command name
  /// - parameter shortUsage:        Short usage string
  /// - parameter longUsage:         Long usage string
  /// - parameter example:           Example show when printing the help message
  /// - parameter parent:            The command parent
  /// - parameter aliases:           List of command aliases
  /// - parameter deprecationStatus: Command deprecation status
  /// - parameter flags:             Command list of flags
  /// - parameter configuration:     Confuguration block to configure the command
  /// - parameter run:               Callback called when the command is executed
  public init(name: String,
              shortUsage: String? = nil,
              longUsage: String? = nil,
              example: String? = nil,
              parent: Command? = nil,
              aliases: [String] = [],
              deprecationStatus: DeprecationStatus = .notDeprecated,
              flags: [Flag] = [],
              configuration: Configuration? = nil,
              run: Run? = nil) {
    self.name = name

    self.shortUsage = shortUsage
    self.longUsage = longUsage

    self.example = example
    self.deprecationStatus = deprecationStatus

    self.aliases = aliases

    self.flags = flags

    self.run = run

    if let parent = parent {
      self.parent = parent
      parent.add(subCommand: self)
    }

    configuration?(self)
  }


  /// Gets the subcommand with a name
  ///
  /// - parameter name: the command name to get
  ///
  /// - returns: return a command if found
  public subscript(withName name: String) -> CommandType? {
    for command in commands where
      command.name == name || command.aliases.contains(name) {
        return command
    }

    return nil
  }


  /// Adds a new subcommand
  ///
  /// - parameter command:    the command to add
  /// - parameter setParent:  set self as parent of the passed command
  public func add(subCommand command: Command, setParent: Bool = true) {
    if setParent {
      command.parent = self
    }

    if commands.contains(where: { $0.equals(other: command) }) == false {
      commands.append(command)
    }
  }


  /// Add a list of commands
  ///
  /// - parameter commands: the commands to add
  public func add(subCommands commands: Command...) {
    commands.forEach { add(subCommand: $0) }
  }


  /// Remove a command
  ///
  /// - parameter test: the test to run agains the command
  /// Returning true from this callback deletes the command
  public func removeCommand(passingTest test: (CommandType) -> Bool) {
    if let index = commands.index(where: { test($0) }) {
      commands.remove(at: index)
    }
  }


  /// Adds a flag
  ///
  /// - parameter flag: the flag to add
  public func add(flag: Flag) {
    flags.append(flag)
  }


  /// Adds a list of flag
  ///
  /// - parameter flag: the flags to add
  public func add(flags: [Flag]) {
    self.flags.append(contentsOf: flags)
  }


  /// Remove a command
  ///
  /// - parameter test: the test to run agains the flag
  /// Returning true from this callback deletes the flag
  public func removeFlag(passingTest test: (Flag) -> Bool) {
    if let index = flags.index(where: test) {
      flags.remove(at: index)
    }
  }

  public func printToConsole(_ string: String) {
    print(string)
  }


  /// Fail, print the help message and exit the application
  /// Call this method when you want to exit and print the help message
  ///
  /// - parameter statusCode: the status code to report
  public func fail(statusCode: Int) {
    printToConsole(helpMessage)
    exit(Int32(statusCode))
  }

  public func equals(other: CommandType) -> Bool {
    let command: AnyObject = other as AnyObject
    return command === self
  }
}
