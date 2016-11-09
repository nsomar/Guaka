//
//  Command.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


public class Command: CommandType {
  
  public typealias Run = ([String: Flag], [String]) -> ()
  
  public var parent: CommandType?
  public let name: String
  public var flags: [Flag]
  public var commands: [CommandType] = []
  
  public var run: Run?

  public var aliases: [String] = []
  
  public var shortUsage: String?
  public var longUsage: String?
  
  public var example: String?
  
  public var deprecationStatus = DeprecationStatus.notDeprecated
  
  public init(name: String,
              shortUsage: String? = nil,
              longUsage: String? = nil,
              parent: Command? = nil,
              flags: [Flag] = [],
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
