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
  public var commands: [String: CommandType] = [:]
  public var run: Run?
  
  public var shortUsage: String?
  public var longUsage: String?
  
  public init(name: String,
              flags: [Flag],
              shortUsage: String? = nil,
              longUsage: String? = nil,
              run: Run? = nil) throws {
    self.name = name
    self.flags = flags
    self.run = run
    self.shortUsage = shortUsage
    self.longUsage = longUsage
  }
 
  public func add(subCommand command: Command) {
    command.parent = self
    commands[command.name] = command
  }
  
  public func add(subCommands commands: Command...) {
    commands.forEach { add(subCommand: $0) }
  }
  
  public func removeCommand(passingTest test: (CommandType) -> Bool) {
    if let index = commands.index(where: { test($1) }) {
      commands.remove(at: index)
    }
  }
  
  public func add(flag: Flag) {
    flags.append(flag)
  }
  
  public func add(flags: Flag...) {
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
