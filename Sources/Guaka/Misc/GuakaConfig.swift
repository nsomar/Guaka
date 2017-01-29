//
//  GuakaConfig.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//


/// Guaka global configurations.
/// Contains config to change global settings.
/// - Changing the global help message strategy
public struct GuakaConfig {

  /// Sets the help generator strategy
  /// By default this is `DefaultHelpGenerator`
  ///
  /// ----
  /// Example
  ///
  /// Altering the full help message returned
  ///
  /// ```
  /// struct SampleGenerator: HelpGenerator {
  ///   let commandHelp: CommandHelp
  ///
  ///     var helpMessage: String {
  ///       // You have to print your own help
  ///       return "custome help message for \(self.commandHelp.name)." +
  ///       "It has \(self.commandHelp.subCommands.count) subcommands"
  ///     }
  ///
  ///    init(commandHelp: CommandHelp) {
  ///      self.commandHelp = commandHelp
  ///    }
  ///  }
  /// ```
  ///
  /// Altering only two sections, usage and subcommands from help.
  /// The overall structure of the help will be the same, only the usage and subcommands will be altered
  ///
  /// ```
  /// struct SampleGenerator: HelpGenerator {
  ///   let commandHelp: CommandHelp
  ///
  ///   var usageSection: String? {
  ///      return "Usage message for \(self.commandHelp.name)."
  ///   }
  ///
  ///   var subCommandsSection: String? {
  ///      return "It has \(self.commandHelp.subCommands.count) subcommands"
  ///   }
  ///
  ///   init(commandHelp: CommandHelp) {
  ///      self.commandHelp = commandHelp
  ///    }
  ///  }
  ///
  /// ```
  ///
  /// Removing a section from the help.
  /// Remove the usage section.
  ///
  /// ```
  /// struct SampleGenerator: HelpGenerator {
  ///   let commandHelp: CommandHelp
  ///
  ///   var usageSection: String? {
  ///      return nil
  ///   }
  ///
  ///   init(commandHelp: CommandHelp) {
  ///      self.commandHelp = commandHelp
  ///    }
  ///  }
  /// ```
  ///
  public static var helpGenerator: HelpGenerator.Type = DefaultHelpGenerator.self
}
