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
///
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
///
/// After creating a command, to execute it do:
///
/// ```
/// let command = ...
/// command.execute()
/// ```
///
public class Command {


  /// The command uasage oneliner string.
  /// This is printed in the usage section.
  /// The usage must contain the command name as its first word
  ///
  /// Correct usages strings:
  ///
  /// - login [name]
  /// - login [flags] name
  public var usage: String


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
  public var flags: [Flag] = []


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

  /// Returns the suggestion message for the original command
  func suggestionMessage(original: String, suggestion: String) -> String? {
    return GuakaConfig.helpGenerator.init(command: self).suggestionMessage(original: original, suggestion: suggestion)
  }

  var nameOrEmpty: String  {
    return (try? Command.name(forUsage: usage)) ?? ""
  }

  /// We can call the command with different aliases
  /// This varialbe hold the alias used
  var aliasUsedToCallCommand: String?

  /// Initialize a command
  ///
  /// - parameter usage:             Command usage oneliner
  /// - parameter shortMessage:      (Optional)Short usage string. Defaults to nil
  /// - parameter longMessage:       (Optional)Long usage string. Defaults to nil
  /// - parameter flags:             (Optional)Command list of flags. Defaults to emoty array
  /// - parameter example:           (Optional)Example show when printing the help message. Defaults to nil
  /// - parameter parent:            (Optional)The command parent. Defaults to nil
  /// - parameter aliases:           (Optional)List of command aliases. Defaults to empty array
  /// - parameter deprecationStatus: (Optional)Command deprecation status. . Defaults to .notDeprecated
  /// - parameter run:               (Optional)Callback called when the command is executed. Defaults to nil
  ///
  /// - throws: exception if the usage is incorrect (empty, or has wrong command name format)
  ///
  /// ----
  /// Discussion:
  ///
  /// The command usage must be a string that contains the command name as the first word.
  ///
  /// Some correct usages strings:
  ///
  /// - login [name]
  /// - login [flags] name
  ///
  /// The first word of the usage will be the command name
  ///
  /// ----
  public init(usage: String,
              shortMessage: String? = nil,
              longMessage: String? = nil,
              flags: [Flag] = [],
              example: String? = nil,
              parent: Command? = nil,
              aliases: [String] = [],
              deprecationStatus: DeprecationStatus = .notDeprecated,
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
  }


  /// Initialize a command
  ///
  /// - parameter usage:             Command usage oneliner
  /// - parameter configuration:     Confuguration block to configure the command
  /// - parameter run:               Callback called when the command is executed
  ///
  /// - throws: exception if the usage is incorrect (empty, or has wrong command name format)
  ///
  /// Discussion:
  /// The command usage must be a string that contains the command name as the first word.
  ///
  /// Some correct usages strings:
  /// - login [name]
  /// - login [flags] name
  ///
  /// The first word of the usage will be the command name
  public convenience init(usage: String,
                          configuration: Configuration?,
                          run: Run?) {
    self.init(usage: usage, shortMessage: nil, longMessage: nil, flags: [], run: run)
    configuration?(self)
  }


  /// Gets the subcommand with a name
  ///
  /// - parameter name: the command name to get
  ///
  /// - returns: return a command if found
  public subscript(withName name: String) -> Command? {

    for command in commands where
      command.nameOrEmpty == name || command.aliases.contains(name) {
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
  ///
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
  ///
  public func add(subCommands commands: [Command]) {
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
  ///
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
  ///
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
  /// - parameter errorMessage: additinal error message to print
  public func fail(statusCode: Int, errorMessage: String? = nil) -> Never {
    printToConsole(errorMessage ?? helpMessage)
    exit(Int32(statusCode))
  }

  /// Print a string to console. This method is for enabling testability only
  @available(*, deprecated, message: "This method is for enabling testability and as such should only be used in tests.")
  func printToConsole(_ string: String) {
    print(string)
  }

  func name() throws -> String {
    return try Command.name(forUsage: usage)
  }
}

/// Fail, print the error message and exit the application
/// Call this method when you want to exit and print an error message
///
/// - parameter statusCode: the status code to report
/// - parameter errorMessage: additional error message to print
public func fail(statusCode: Int, errorMessage: String) -> Never {
  print(errorMessage)
  exit(Int32(statusCode))
}

/// Fail, print the help message and exit the application
/// Call this method when you want to exit and print the help message
///
/// - parameter statusCode: the status code to report
/// - parameter command: the command whose help message should be printed
public func fail(statusCode: Int, command: Command) -> Never {
    Guaka.fail(statusCode: statusCode, errorMessage: command.helpMessage)
}
