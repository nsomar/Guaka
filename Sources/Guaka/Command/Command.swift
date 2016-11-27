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


/// Command class representing a Command that can be executed.
///
/// ----
/// Examples:
///
/// Create a simple command
///
/// ```
/// var newCommand = Command(usage: "new") { flags, args in
///
/// }
/// ```
///
/// Create a command with costumizations
/// ```
/// var newCommand = Command(usage: "new",
///                          shortMessage: "Use new to generate a new thing",
///                          longMessage: "Long description",
///                          example: "Example",
///                          aliases: ["create", "generate"]) { flags, args in
///
/// }
/// ```
///
/// Create a command with configuration block and an execute block
///
/// ```
/// var rootCommand = Command(
///   usage: "test", configuration: configuration, run: execute)
///
///
/// private func configuration(command: Command) {
///
///   command.add(flags: [
///     // Add your flags here
///     ]
///   )
///
///   // Other configurations
/// }
///
/// private func execute(flags: Flags, args: [String]) {
///   // Execute code here
///   print("test called")
/// }
/// ```
public class Command {


  /// The command uasage oneliner string.
  /// This is printed in the usage section.
  public var usage: String


  /// The command name, this is the first string in the usage
  public var name: String {
    return Command.name(forUsage: usage)
  }


  /// The short usages string
  /// This string will be visible when the help of the command is executed
  public var shortMessage: String?


  /// The long usages string
  /// This string will be visible when the help of the command is executed
  public var longMessage: String?


  /// The example section of the command
  /// This will be visible when displaying the command help
  public var example: String?


  /// The command deprecation status.
  /// This defines if a command is deprecated or not, default not deprecated
  public var deprecationStatus = DeprecationStatus.notDeprecated

  
  /// The flags available for this command
  /// This list contains only the local flags added to the command
  public var flags: [Flag]


  /// The subcommands this command has
  public var commands: [Command] = []


  /// The parent of this command.
  /// If the command is the root command, the parent will be nil.
  public var parent: Command? {
    willSet {
      if
        let oldParent = parent,
        let newParent = newValue,
        newParent !== oldParent {
        newParent.add(subCommand: self, setParent: false)
      }
    }
  }

  /// After the parsing matches the subcommand, preRun is executed before exacuting run
  /// If preRun returns true, the run is executed next
  /// If preRun returns false, the execution ends
  public var preRun: ConditionalRun?


  /// After the parsing matches the subcommand, preRun is executed before exacuting run
  /// If preRun returns true, run is executed next
  /// If preRun returns false, the execution ends
  /// If the current command has an inheritablePostRun, then its called on it.
  /// Otherwise it will be executed on its parent, until the root command
  public var inheritablePreRun: ConditionalRun?


  /// After the parsing matches the subcommand, run is called after preRun
  /// the callback registered for preRun must return true for run to be called
  public var run: Run?


  /// After the parsing matches the subcommand, postRun is called after run
  /// If postRun returns true, then inheritablePostRun is executed next
  /// If postRun returns false, the execution ends
  public var postRun: ConditionalRun?


  /// After the parsing matches the subcommand, postRun is called after run
  /// If the current command has an inheritablePostRun, then its called on it.
  /// Otherwise it will be executed on its parent, until the root command
  public var inheritablePostRun: ConditionalRun?

  /// The command aliases
  /// The command will be callable by its name or by any of the aliases set here
  public var aliases: [String] = []

  /// Get the help message for the command
  /// The console help message for the command
  public var helpMessage: String {
    return GuakaConfig.helpGenerator.init(command: self).helpMessage
  }
  
  /// Initialize a command
  ///
  /// - parameter usage:             Command usage oneliner
  /// - parameter shortMessage:      Short usage string
  /// - parameter longMessage:       Long usage string
  /// - parameter example:           Example show when printing the help message
  /// - parameter parent:            The command parent
  /// - parameter aliases:           List of command aliases
  /// - parameter deprecationStatus: Command deprecation status
  /// - parameter flags:             Command list of flags
  /// - parameter configuration:     Confuguration block to configure the command
  /// - parameter run:               Callback called when the command is executed
  public init(usage: String,
              shortMessage: String? = nil,
              longMessage: String? = nil,
              example: String? = nil,
              parent: Command? = nil,
              aliases: [String] = [],
              deprecationStatus: DeprecationStatus = .notDeprecated,
              flags: [Flag] = [],
              configuration: Configuration? = nil,
              run: Run? = nil) {
    self.usage = usage

    self.shortMessage = shortMessage
    self.longMessage = longMessage

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
  public subscript(withName name: String) -> Command? {
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
  ///
  /// ----
  /// Examples:
  ///
  /// ```
  /// let command = ...
  /// let subcommand = ...
  /// command.add(subCommand: subCommand)
  /// ```
  public func add(subCommand command: Command, setParent: Bool = true) {
    if setParent {
      command.parent = self
    }

    if commands.contains(where: { $0 === command }) == false {
      commands.append(command)
    }
  }


  /// Add a list of commands
  ///
  /// - parameter commands: the commands to add
  ///
  /// ----
  /// Examples:
  ///
  /// ```
  /// let command = ...
  /// let subcommand1 = ...
  /// let subcommand2 = ...
  /// command.add(subCommands: [subCommand1, subCommand2])
  /// ```
  public func add(subCommands commands: Command...) {
    commands.forEach { add(subCommand: $0) }
  }


  /// Remove a command
  ///
  /// - parameter test: the test to run agains the command
  /// Returning true from this callback deletes the command
  public func removeCommand(passingTest test: (Command) -> Bool) {
    if let index = commands.index(where: { test($0) }) {
      commands.remove(at: index)
    }
  }


  /// Adds a flag
  ///
  /// - parameter flag: the flag to add
  ///
  /// ----
  /// Examples:
  ///
  /// ```
  /// let command = ...
  /// let flag = ...
  /// command.add(flag: flag)
  /// ```
  public func add(flag: Flag) {
    flags.append(flag)
  }


  /// Adds a list of flag
  ///
  /// - parameter flag: the flags to add
  ///
  /// ----
  /// Examples:
  ///
  /// ```
  /// let command = ...
  /// let flag1 = ...
  /// let flag2 = ...
  /// command.add(flags: [flag1, flag2])
  /// ```
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


  /// Fail, print the help message and exit the application
  /// Call this method when you want to exit and print the help message
  ///
  /// - parameter statusCode: the status code to report
  public func fail(statusCode: Int) {
    printToConsole(helpMessage)
    exit(Int32(statusCode))
  }

  /// Print a string to console. This method is for enabling testability only
  func printToConsole(_ string: String) {
    print(string)
  }

}
