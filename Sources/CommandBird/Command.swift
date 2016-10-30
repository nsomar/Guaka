//
//  Command.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


class Command {
  typealias Run = ([Flag], [String]) -> ()
  var parent: Command?
  let name: String
  let flags: [Flag]
  let commands: [String: Command]
  let run: Run?
  
  init(name: String, flags: [Flag], commands: [Command] = [], parent: Command? = nil, run: Run? = nil) throws {
    self.name = name
    self.flags = flags
    self.commands = try Command.commandsToMap(commands: commands)
    self.parent = parent
    self.run = run
    
    commands.forEach { $0.parent = self }
  }
  
  static func commandsToMap(commands: [Command]) throws -> [String: Command] {
    var m = [String: Command]()
    
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

extension Command {
  var inheritableFlags: [Flag] {
    return self.flags.filter { $0.inheritable }
  }
}

extension Command {
  
  var flagSet: FlagSet {
    
    let allFlags =
      iterateToRoot().reduce([Flag]()) { acc, command in
        let flagsToAdd = self === command ? command.flags : command.inheritableFlags
        return flagsToAdd + acc
    }
    
    return FlagSet(flags: allFlags)
  }
  
  var path: [String] {
    return getPath(cmd: self, acc: []).reversed()
  }
  
  var root: Command {
    var current: Command? = self
    
    while true {
      let previous = current
      current = current?.parent
      if current == nil {
        return previous!
      }
    }
  }
  
  
  private func iterateToRoot() -> AnyIterator<Command> {
    var currentCommand: Command? = self
    
    return AnyIterator<Command>.init({ () -> Command? in
      
      guard let c = currentCommand else { return nil }
      
      let prevCommand = c
      currentCommand = c.parent
      return prevCommand
    })
  }
  
  private func getPath(cmd: Command?, acc: [String]) -> [String] {
    guard let cmd = cmd else {
      return acc
    }
    
    var mut = acc
    mut.append(cmd.name)
    return getPath(cmd: cmd.parent, acc: mut)
  }
}
