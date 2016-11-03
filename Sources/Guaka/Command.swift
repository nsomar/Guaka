//
//  Command.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

public protocol CommandType {
  typealias Run = ([String: Flag], [String]) -> ()
  
  var parent: CommandType? { get set }
  var name: String { get }
  var flags: [Flag] { get }
  var commands: [String: CommandType] { get }
  var run: Run? { get set }
  
  func execute(flags: [String: Flag], args: [String])
  func execute(commandLineArgs: [String]) throws
}

public class Command: CommandType {
  public typealias Run = ([String: Flag], [String]) -> ()
  
  public var parent: CommandType?
  public let name: String
  public let flags: [Flag]
  public let commands: [String: CommandType]
  public var run: Run?
  
  public init(name: String, flags: [Flag], commands: [CommandType] = [], run: Run? = nil) throws {
    self.name = name
    self.flags = flags
    self.commands = try Command.commandsToMap(commands: commands)
    self.run = run
    
    commands.forEach {
      var mut = $0
      mut.parent = self
    }
  }
}

extension CommandType {
  // FIXME make sure we test for command childern too
  func equals(other: Any) -> Bool {
    guard let other = other as? CommandType else { return false }
    
    return self.name == other.name &&
      self.flags == other.flags &&
      self.commands.count == other.commands.count
  }
}

extension CommandType {
  static func commandsToMap(commands: [CommandType]) throws -> [String: CommandType] {
    var m = [String: CommandType]()
    
    try commands.forEach { cmd in
      if m[cmd.name] == nil {
        m[cmd.name] = cmd
      } else {
        throw CommandErrors.commandAlreadyInserterd(cmd)
      }
    }
    
    return m
  }
}

extension CommandType {
  var inheritableFlags: [Flag] {
    return self.flags.filter { $0.inheritable }
  }
}

extension CommandType {
  
  var flagSet: FlagSet {
    
    let allFlags =
      iterateToRoot().reduce([Flag]()) { acc, command in
        let flagsToAdd = self.equals(other: command) ? command.flags : command.inheritableFlags
        return flagsToAdd + acc
    }
    
    return FlagSet(flags: allFlags)
  }
  
  var path: [String] {
    return getPath(cmd: self, acc: []).reversed()
  }
  
  var root: CommandType {
    var current: CommandType? = self
    
    while true {
      let previous = current
      current = current?.parent
      if current == nil {
        return previous!
      }
    }
  }
  
  
  private func iterateToRoot() -> AnyIterator<CommandType> {
    var currentCommand: CommandType? = self
    
    return AnyIterator<CommandType>.init({ () -> CommandType? in
      
      guard let c = currentCommand else { return nil }
      
      let prevCommand = c
      currentCommand = c.parent
      return prevCommand
    })
  }
  
  private func getPath(cmd: CommandType?, acc: [String]) -> [String] {
    guard let cmd = cmd else {
      return acc
    }
    
    var mut = acc
    mut.append(cmd.name)
    return getPath(cmd: cmd.parent, acc: mut)
  }
}



extension CommandType {
  public func execute(flags: [String: Flag], args: [String]) {
    self.run?(flags, args)
  }
  
  public func execute(commandLineArgs: [String]) throws {
    try executeCommand(rootCommand: self, args: commandLineArgs)
  }
}
