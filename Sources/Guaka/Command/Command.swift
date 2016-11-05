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
  public let flags: [Flag]
  public let commands: [String: CommandType]
  public var run: Run?
  
  public var shortUsage: String?
  public var longUsage: String?
  
  public init(name: String,
              flags: [Flag],
              commands: [CommandType] = [],
              shortUsage: String? = nil,
              longUsage: String? = nil,
              run: Run? = nil) throws {
    self.name = name
    self.flags = flags
    self.commands = try Command.commandsToMap(commands: commands)
    self.run = run
    self.shortUsage = shortUsage
    self.longUsage = longUsage
    
    commands.forEach {
      var mut = $0
      mut.parent = self
    }
  }
  
}
