//
//  CommandType+Help.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//


extension CommandType {

  var isVisible: Bool {
    if case .notDeprecated = deprecationStatus {
      return true
    }
    return false
  }

  public var helpMessage: String {
    var ret = [String]()

    if let message = deprecationMessageSection {
      ret.append(message.joined())
      ret.append("\n")
    }

    return (ret + [
      commandDescriptionSection.joined(),
      innerHelpMessage,
    ]).joined()
  }

  public var innerHelpMessage: String {
    return [
      usageSection.joined(separator: "\n"),
      "\n\n",
      aliasesSection.joined(separator: "\n"),
      exampleSection.joined(separator: "\n"),
      avialbleCommandsSection.joined(separator: "\n"),
      flagsSection.joined(separator: "\n"),
      helpSection
      ].joined()
  }

  var usageSection: [String] {
    let flagsString = flagSet.flags.count == 0 ? "" : " [flags]"

    var usageString = [
      "Usage:",
      "  \(usage)\(flagsString)"
    ]

    if commands.count > 0 {
      usageString.append("  \(name) [command]")
    }
    
    return usageString
  }

  var aliasesSection: [String] {
    if aliases.count == 0 { return [] }

    return [
      "Aliases:",
      "  \(name), \(aliases.joined(separator: ", "))",
      "\n"
    ]
  }

  var exampleSection: [String] {
    guard let example = example else { return [] }

    return [
      "Examples:",
      example,
      "\n"
    ]
  }

  var avialbleCommandsSection: [String] {
    if self.commands.count == 0 {
      return []
    }

    let availableCommands = self.commands.filter { $0.isVisible }
    let sortedCommands = availableCommands.sorted { $0.0.name < $0.1.name }

    return sortedCommands.reduce(["Available Commands:"]) { acc, command in
      return acc + ["  \(command.name)    \(command.shortMessage ?? "")"]
    } + ["\n"]
  }

  var flagsSection: [String] {
    let fs = self.flagSet
    if fs.flags.count == 0 {
      return []
    }

    var ret: [String] = []

    let localFlagsDescription = fs.localDescription(withLocalFlags: flags)
    if localFlagsDescription != "" {
      ret.append("Flags:")
      ret.append(localFlagsDescription)
      ret.append("")
    }


    let globalFlagsDescription = fs.globalDescription(withLocalFlags: flags)
    if globalFlagsDescription != "" {
      ret.append("Global Flags:")
      ret.append(globalFlagsDescription)
      ret.append("")
    }

    return ret + [""]
  }

  var deprecationMessageSection: [String]? {
    guard case let .deprecated(message) = deprecationStatus else {
      return nil
    }
    return ["Command \"\(name)\" is deprecated, \(message)"]
  }

  var commandDescriptionSection: [String] {
    guard let desc = longMessage ?? shortMessage else { return [] }
    return [desc, "\n\n"]
  }

  var helpSection: String {
    return "Use \"\(name) [command] --help\" for more information about a command."
  }

}
