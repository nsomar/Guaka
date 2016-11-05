//
//  TestHelpers.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 03/11/2016.
//
//

import Foundation
@testable import Guaka

class DummyCommand: CommandType {
  var parent: CommandType?
  var name: String
  var flags: [Flag]
  var commands: [String: CommandType]
  var run: CommandType.Run?
  
  var shortUsage: String?
  var longUsage: String?
  
  var executed: ([String: Flag], [String])?
  var printed: String = ""
  
  public init(name: String, flags: [Flag], commands: [CommandType] = [],
              parent: Command? = nil, run: CommandType.Run? = nil) throws {
    self.name = name
    self.flags = flags
    self.commands = try Command.commandsToMap(commands: commands)
    self.parent = parent
    self.run = run
    
    commands.forEach {
      var mut = $0
      mut.parent = self
    }
  }
  
  func execute(flags: [String : Flag], args: [String]) {
    executed = (flags, args)
  }
  
  func printToConsole(_ string: String) {
    printed = string
  }
}

func expand(_ string: String) -> [String] {
  return string.components(separatedBy: " ")
}

let show = try! DummyCommand(
  name: "show",
  flags: [
    Flag(longName: "foo", value: "-", inheritable: false),
    Flag(longName: "bar", value: "-", inheritable: false),
    Flag(longName: "yy", value: true, inheritable: false),
    ],
  commands: [],
  run: { flags, args in
    
})

let remote = try! DummyCommand(
  name: "remote",
  flags: [
    Flag(longName: "foo", value: "-", inheritable: true),
    Flag(longName: "remote", value: true, inheritable: true),
    Flag(longName: "bar", value: "-", inheritable: false),
    Flag(longName: "xx", value: true, inheritable: false),
    ],
  commands: [show],
  run: { flags, args in
    
})

let rebase = try! DummyCommand(
  name: "rebase",
  flags: [
    Flag(longName: "varvar", value: false, shortName: "v", inheritable: true),
    ],
  commands: [],
  run: { flags, args in
    
})

let git = try! DummyCommand(
  name: "git",
  flags: [
    Flag(longName: "debug", value: true, shortName: "d", inheritable: true),
    Flag(longName: "verbose", value: false, shortName: "v", inheritable: true),
    Flag(longName: "togge", value: false, shortName: "t", inheritable: false),
    Flag(longName: "root", value: 1, shortName: "r", inheritable: false),
    ],
  commands: [rebase, remote],
  run: { flags, args in
    
})
