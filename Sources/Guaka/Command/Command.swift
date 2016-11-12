//
//  Command.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


public typealias Configuration = (Command) -> ()


public class Command: CommandType {
  public var parent: CommandType?

  public let name: String
  public var flags: [Flag]
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

  public var parent: CommandType? {
    didSet {
      if 
        let currentParent = self.parent as? Command,
        let newParent = parent as? Command,
        newParent !== currentParent  {
        newParent.add(subCommand: self)
      }
    }
  }

  public var deprecationStatus = DeprecationStatus.notDeprecated

  public init(name: String,
              shortUsage: String? = nil,
              longUsage: String? = nil,
              parent: Command? = nil,
              flags: [Flag] = [],
              configuration: Configuration? = nil,
              run: Run? = nil) {
    self.name = name
    self.flags = flags
    self.run = run
    self.shortUsage = shortUsage
    self.longUsage = longUsage

    if let parent = parent {
      self.parent = parent
      parent.add(subCommand: self)
    }
    
    configuration?(self)
  }

  public subscript(withName name: String) -> CommandType? {
    for command in commands where
      command.name == name || command.aliases.contains(name) {
        return command
    }

    return nil
  }

  public func add(subCommand command: Command) {
    command.parent = self
    commands.append(command)
  }

  public func add(subCommands commands: Command...) {
    commands.forEach { add(subCommand: $0) }
  }

  public func removeCommand(passingTest test: (CommandType) -> Bool) {
    if let index = commands.index(where: { test($0) }) {
      commands.remove(at: index)
    }
  }

  public func add(flag: Flag) {
    flags.append(flag)
  }

  public func add(flags: [Flag]) {
    self.flags.append(contentsOf: flags)
  }

  public func removeFlag(passingTest test: (Flag) -> Bool) {
    if let index = flags.index(where: test) {
      flags.remove(at: index)
    }
  }

  public func printToConsole(_ string: String) {
    print(string)
  }
}
