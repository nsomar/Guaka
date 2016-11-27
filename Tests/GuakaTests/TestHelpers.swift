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
              parent: Command? = nil, run: Run? = nil) throws {
    try super.init(usage: name, shortMessage: nil, longMessage: nil, flags: flags, run: run)
  }

  func execute(flags: [String : Flag], args: [String]) {
    executed = (flags, args)
  }

  public override func printToConsole(_ string: String) {
    if printed != "" {
      printed += "\n"
    }
    printed += string

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
var executed: (Flags, [String])? = nil

func setupTestSamples() {
  commandExecuted = nil
  executed = nil

  show = try! DummyCommand(
    name: "show",
    flags: [
      try! Flag(longName: "foo", value: "-", inheritable: false),
      try! Flag(longName: "bar", value: "-", inheritable: false),
      try! Flag(longName: "yy", value: true, inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = show
      executed = (flags, args)
  })

  remote = try! DummyCommand(
    name: "remote",
    flags: [
      try! Flag(longName: "foo", value: "-", inheritable: true),
      try! Flag(longName: "remote", value: true, inheritable: true),
      try! Flag(longName: "bar", value: "-", inheritable: false),
      try! Flag(longName: "xx", value: true, inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = remote
      executed = (flags, args)
  })

  rebase = try! DummyCommand(
    name: "rebase",
    flags: [
      try! Flag(longName: "varvar", shortName: "v", value: false, inheritable: true),
      ],
    run: { flags, args in
      commandExecuted = rebase
      executed = (flags, args)
  })

  git = try! DummyCommand(
    name: "git",
    flags: [
      try! Flag(longName: "debug", shortName: "d", value: true, inheritable: true),
      try! Flag(longName: "togge", shortName: "t", value: false, inheritable: false),
      try! Flag(longName: "root", shortName: "r", value: 1, inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = git
      executed = (flags, args)
  })

  git.add(subCommands: [rebase, remote])
  git.add(flag: try! Flag(longName: "verbose", shortName: "v", value: false, inheritable: true))
  remote.add(subCommands: [show])
}
