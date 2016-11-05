//
//  TestHelpers.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 03/11/2016.
//
//

import Foundation
@testable import Guaka

class DummyCommand: Command {
  
  var executed: ([String: Flag], [String])?
  var printed: String = ""
  
  public init(name: String, flags: [Flag],
              parent: Command? = nil, run: CommandType.Run? = nil) throws {
    try super.init(name: name, flags: flags, shortUsage: nil, longUsage: nil, run: run)
  }
  
  func execute(flags: [String : Flag], args: [String]) {
    executed = (flags, args)
  }
  
  public override func printToConsole(_ string: String) {
    printed = string
  }
}

func expand(_ string: String) -> [String] {
  return string.components(separatedBy: " ")
}

var git: DummyCommand!
var remote: DummyCommand!
var show: DummyCommand!
var rebase: DummyCommand!

var commandExecuted: DummyCommand? = nil
var executed: ([String: Flag], [String])? = nil

func setupTestSamples() {
  commandExecuted = nil
  executed = nil
  
  show = try! DummyCommand(
    name: "show",
    flags: [
      Flag(longName: "foo", value: "-", inheritable: false),
      Flag(longName: "bar", value: "-", inheritable: false),
      Flag(longName: "yy", value: true, inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = show
      executed = (flags, args)
  })
  
  remote = try! DummyCommand(
    name: "remote",
    flags: [
      Flag(longName: "foo", value: "-", inheritable: true),
      Flag(longName: "remote", value: true, inheritable: true),
      Flag(longName: "bar", value: "-", inheritable: false),
      Flag(longName: "xx", value: true, inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = remote
      executed = (flags, args)
  })
  
  rebase = try! DummyCommand(
    name: "rebase",
    flags: [
      Flag(longName: "varvar", value: false, shortName: "v", inheritable: true),
      ],
    run: { flags, args in
      commandExecuted = rebase
      executed = (flags, args)
  })
  
  git = try! DummyCommand(
    name: "git",
    flags: [
      Flag(longName: "debug", value: true, shortName: "d", inheritable: true),
      Flag(longName: "verbose", value: false, shortName: "v", inheritable: true),
      Flag(longName: "togge", value: false, shortName: "t", inheritable: false),
      Flag(longName: "root", value: 1, shortName: "r", inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = git
      executed = (flags, args)
  })
  
  git.add(subCommands: rebase, remote)
  remote.add(subCommands: show)
}
