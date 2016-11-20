//
//  DefaultHelpGenerator.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//


public protocol HelpGenerator {

  var commandHelp: CommandHelp { get }

  init(commandHelp: CommandHelp)

  init(command: CommandType)

  var helpMessage: String { get }
  var errorHelpMessage: String { get }

  var deprecationSection: String? { get }
  var usageSection: String? { get }

  var aliasesSection: String? { get }
  var exampleSection: String? { get }
  var subCommandsSection: String? { get }
  var flagsSection: String? { get }
  var commandDescriptionSection: String? { get }
  var informationSection: String? { get }

  func errorString(forError error: CommandError) -> String
}
