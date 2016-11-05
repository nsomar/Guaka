//
//  CommandType+Help.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//


extension CommandType {
  
  public var helpMessage: String {
    return [
      commandDescriptionSection.joined(),
      innerHelpMessage,
    ].joined()
  }
  
  public var innerHelpMessage: String {
    return [
      usageSection.joined(separator: "\n"),
      "\n\n",
      avialbleCommandsSection.joined(separator: "\n"),
      flagsSection.joined(separator: "\n"),
      helpSection
      ].joined()
  }
  
  var usageSection: [String] {
    return [
      "Usage:",
      "  \(name) [flags]",
      "  \(name) [command]"
    ]
  }

  var avialbleCommandsSection: [String] {
    if self.commands.count == 0 {
      return []
    }
    
    return self.commands.reduce(["Available Commands:"]) { acc, val in
      let command = val.value
      return acc + ["  \(command.name)    \(command.shortUsage ?? "")"]
    } + ["\n"]
  }
  
  var flagsSection: [String] {
    let fs = self.flagSet
    if fs.flags.count == 0 {
      return []
    }
    
    return ["Flags:", fs.flagsDescription, "\n"]
  }
  
  var commandDescriptionSection: [String] {
    guard let desc = longUsage ?? shortUsage else { return [] }
    return [desc, "\n\n"]
  }
  
  var helpSection: String {
    return "Use \"\(name) [command] --help\" for more information about a command."
  }
  
}
