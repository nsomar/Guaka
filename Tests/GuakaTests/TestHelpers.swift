//
//  TestHelpers.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 03/11/2016.
//
//

@testable import Guaka

class DummyCommand: Command {

  var executed: ([String: Flag], [String])?
  var printed: String = ""

  public init(name: String, flags: [Flag],
              parent: Command? = nil, run: Run? = nil) {
    super.init(usage: name, shortMessage: nil, longMessage: nil, flags: flags, run: run)
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

  show = DummyCommand(
    name: "show",
    flags: [
      Flag(longName: "foo", value: "-", description: "", inheritable: false),
      Flag(longName: "bar", value: "-", description: "", inheritable: false),
      Flag(longName: "yy", value: true, description: "", inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = show
      executed = (flags, args)
  })

  remote = DummyCommand(
    name: "remote",
    flags: [
      Flag(longName: "foo", value: "-", description: "", inheritable: true),
      Flag(longName: "remote", value: true, description: "", inheritable: true),
      Flag(longName: "bar", value: "-", description: "", inheritable: false),
      Flag(longName: "xx", value: true, description: "", inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = remote
      executed = (flags, args)
  })

  rebase = DummyCommand(
    name: "rebase",
    flags: [
      Flag(shortName: "v", longName: "varvar", value: false, description: "", inheritable: true),
      ],
    run: { flags, args in
      commandExecuted = rebase
      executed = (flags, args)
  })

  git = DummyCommand(
    name: "git",
    flags: [
      Flag(shortName: "d", longName: "debug", value: true, description: "", inheritable: true),
      Flag(shortName: "t", longName: "togge", value: false, description: "", inheritable: false),
      Flag(shortName: "r", longName: "root", value: 1, description: "", inheritable: false),
      ],
    run: { flags, args in
      commandExecuted = git
      executed = (flags, args)
  })

  git.add(subCommands: [rebase, remote])
  git.add(flag: Flag(shortName: "v", longName: "verbose", value: false, description: "", inheritable: true))

  remote.add(subCommands: [show])
}
