//
//  DefaultHelpGenerator.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//


/// Protocol that defines the help generation logic.
/// This protocol has an extension that implements all the methods required.
/// You can choose to override `helpMessage` to completely costumize the help message to print.
/// Alternatively, override one of the sections only to alter that section.
///
/// When the help is about to be printed, a `CommandHelp` is generated from the current `Command`.
/// a `HelpGenerator` is created and passed this `CommandHelp`.
/// the `HelpGenerator` is used to print the help message string
///
/// -----
///
/// The help has this format
/// ```
/// Usage:
///   command [flags]
///   command [command]
///
/// Aliases:
///   alias1, alias2
///
/// Examples:
///   the command usage example
///
/// Available Commands:
///   sub_command1  subcommand description
///   sub_command2  subcommand description
///
/// Flags:
///   -f, --flag         flag1 description
///       --user string  flag2 description
///
/// Use "command [command] --help" for more information about a command.
/// ```
public protocol HelpGenerator {

  /// Command Help instance
  var commandHelp: CommandHelp { get }

  /// Initialize with a command help
  init(commandHelp: CommandHelp)

  /// Initialize with a command
  init(command: Command)

  /// Return the full help message
  /// This help message will be printed when passing `-h` or `--help` to the command
  /// Override this method when you need to costumize the full message returned to consol
  /// If you need to only costumize part of the help, override one or more of the section strings
  ///
  /// ----
  /// Examples:
  /// ```
  /// var helpMessage: String {
  ///   return "the help"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// the help
  /// ```
  var helpMessage: String { get }

  /// Return the message to be printed after printing the error occured
  /// This message will be printed after the specific error occured
  /// Override this method when you need to costumize the full error message returned to consol
  /// If you need to only costumize part of the help, override one or more of the section strings
  ///
  /// ----
  /// Examples:
  /// ```
  /// var errorHelpMessage: String {
  ///   return "the help"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// Some error occured
  /// the help
  /// ```
  var errorHelpMessage: String { get }

  /// Returns the deprecation for this command
  /// When this is called, the help generator must return a message that uses the command.deprecatedStatus message
  /// This method will only be called if Guaka is about to execute this specific command.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var deprecationSection: String? {
  ///   return "this command is deprecated"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// this command is deprecated
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var deprecationSection: String? { get }

  /// Return command description section to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var commandDescriptionSection: String? {
  ///   return "this is the command"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// this is the command
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var commandDescriptionSection: String? { get }

  /// Return the usage secion to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var usageSection: String? {
  ///   return "use as"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// use as
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var usageSection: String? { get }

  /// Return the aliases section to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var aliasesSection: String? {
  ///   return "my aliases are 1, 2"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// my aliases are 1, 2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var aliasesSection: String? { get }

  /// Return the example section to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var exampleSection: String? {
  ///   return "some examples"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// some examples
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var exampleSection: String? { get }

  /// Return the subcommands section to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var subCommandsSection: String? {
  ///   return "Some sub commands" //should iterate the commands yourself
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Some sub commands
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var subCommandsSection: String? { get }

  /// Return the flags description section to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var flagsSection: String? {
  ///   return "the flags I have" // iterate the flags
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// the flags I have
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  var flagsSection: String? { get }

  /// Return command information description section to be printed for when the command help is printed.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// var informationSection: String? {
  ///   return "command info to get help"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// command info to get help
  /// ```
  var informationSection: String? { get }

  /// Return the string printed when an error occur.
  /// Returning nil ignores this section from the help message.
  ///
  /// ----
  /// Examples:
  /// ```
  /// func errorString(forError error: CommandError) -> String {
  ///   return "error occured"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// error occured
  /// Usage:
  ///   command [flags]
  ///   command [command]
  ///
  /// Aliases:
  ///   alias1, alias2
  ///
  /// Examples:
  ///   the command usage example
  ///
  /// Available Commands:
  ///   sub_command1  subcommand description
  ///   sub_command2  subcommand description
  ///
  /// Flags:
  ///   -f, --flag         flag1 description
  ///       --user string  flag2 description
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  func errorString(forError error: CommandError) -> String

  /// Return the string printed when a flag is deprecated.
  /// Returning nil ignores this section from the help message
  ///
  /// ----
  /// Examples:
  /// ```
  /// func deprecationMessage(forDeprecatedFlag flag: FlagHelp) -> String? {
  ///   return "this flag is deprecated"
  /// }
  /// ```
  ///
  /// The help returned
  ///
  /// ```
  /// this flag is deprecated
  /// ```
  func deprecationMessage(forDeprecatedFlag flag: FlagHelp) -> String?

  /// Returns a suggestion message string when a unrecognized command is passed to the root command.
  /// Returning nil does not show the message
  ///
  /// ----
  /// Examples:
  /// ```
  /// public func suggestionMessage(original: String, suggestion: String) -> String? {
  ///  return [
  ///    "\(commandHelp.name): '\(original)' is not a \(commandHelp.name) command. See '\(commandHelp.name) --help'.",
  ///    "",
  ///    "Did you mean this?",
  ///    "  \(suggestion)"].joined(separator: "\n")
  /// }
  /// ```
  ///
  /// The suggestion message
  ///
  /// ```
  /// git: 'rbase' is not a git command. See 'git --help'.
  ///
  /// Did you mean this?
  ///   rebase
  /// ```
  func suggestionMessage(original: String, suggestion: String) -> String?
}
