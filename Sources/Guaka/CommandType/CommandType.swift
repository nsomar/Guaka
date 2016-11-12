//
//  CommandType.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//

#if os(Linux)
  @_exported import Glibc
#else
  @_exported import Darwin.C
#endif


public enum DeprecationStatus {
  case notDeprecated
  case deprecated(String)
}


public typealias Run = ([String: Flag], [String]) -> ()
public typealias ConditionalRun = ([String: Flag], [String]) -> (Bool)


public protocol CommandType {

  /// The parent of this command
  /// If the command is the root command, the parent will be nil
  var parent: CommandType? { get }

  /// The command name
  var name: String { get }

  /// The flags available for this command
  /// This list contains only the local flags added to the command
  var flags: [Flag] { get }

  /// The subcommands this command has
  var commands: [CommandType] { get }

  /// After the parsing matches the subcommand, preRun is executed before exacuting run
  /// If preRun returns true, the run is executed next
  /// If preRun returns false, the execution ends
  var preRun: ConditionalRun? { get }

  /// After the parsing matches the subcommand, preRun is executed before exacuting run
  /// If preRun returns true, run is executed next
  /// If preRun returns false, the execution ends
  /// If the current command has an inheritablePostRun, then its called on it.
  /// Otherwise it will be executed on its parent, until the root command
  var inheritablePreRun: ConditionalRun? { get }

  /// After the parsing matches the subcommand, run is called after preRun
  /// the callback registered for preRun must return true for run to be called
  var run: Run? { get }

  /// After the parsing matches the subcommand, postRun is called after run
  /// If postRun returns true, then inheritablePostRun is executed next
  /// If postRun returns false, the execution ends
  var postRun: ConditionalRun? { get }

  /// After the parsing matches the subcommand, postRun is called after run
  /// If the current command has an inheritablePostRun, then its called on it.
  /// Otherwise it will be executed on its parent, until the root command
  var inheritablePostRun: ConditionalRun? { get }

  /// The command aliases
  /// The command will be callable by its name or by any of the aliases set here
  var aliases: [String] { get }

  /// The short usages string
  /// This string will be visible when the help of the command is executed
  var shortUsage: String? { get }

  /// The long usages string
  /// This string will be visible when the help of the command is executed
  var longUsage: String? { get }

  /// The example section of the command
  /// This will be visible when displaying the command help
  var example: String? { get }

  /// The console help message for the command
  var helpMessage: String { get }

  /// The command deprecation status
  var deprecationStatus: DeprecationStatus { get set }

  /// Execute this command
  ///
  /// - parameter commandLineArgs: the command line arguments received in the app
  func execute(commandLineArgs: [String])


  /// The actual command that will be executed
  /// This will be either the current command, or any subcommand tied to the current command
  ///
  /// - parameter commandLineArgs: the command line arguments received in the app
  ///
  /// - returns: the actual command that will be executed
  func commandToExecute(commandLineArgs: [String]) -> CommandType

  /// Get a subcommand from its name
  ///
  /// - parameter name: the name of the subcommand to get
  ///
  /// - returns: the subcommand if found, otherwise nil
  subscript(withName name: String) -> CommandType? { get }

  /// Print a string to console
  /// This method is here to simplify command testability
  func printToConsole(_ string: String)
}
