//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import Guaka


let show = try! Command(
  name: "show",
  flags: [
    Flag(longName: "foo", value: "-", inheritable: false),
    Flag(longName: "bar", value: "-", inheritable: false),
    Flag(longName: "yy", value: true, inheritable: false),
    ],
  commands: []) { flags, args in
    print("Running git with \(flags) and \(args)")
}

let remote = try! Command(
  name: "remote",
  flags: [
    Flag(longName: "foo", value: "-", inheritable: true),
    Flag(longName: "remote", value: true, inheritable: true),
    Flag(longName: "bar", value: "-", inheritable: false),
    Flag(longName: "xx", value: true, inheritable: false),
    ],
  commands: [show]) { flags, args in
    print("Running git with \(flags) and \(args)")
}

let rebase = try! Command(
  name: "rebase",
  flags: [
    Flag(longName: "varvar", value: false, shortName: "v", inheritable: true),
    ],
  commands: []) { flags, args in
    print("Running git with \(flags) and \(args)")
}

let git = try! Command(
  name: "git",
  flags: [
    Flag(longName: "debug", value: true, shortName: "d", inheritable: true),
    Flag(longName: "verbose", value: false, shortName: "v", inheritable: true),
    Flag(longName: "togge", value: false, shortName: "t", inheritable: false),
    Flag(longName: "root", value: 1, shortName: "r", inheritable: false),
    ],
  commands: [rebase, remote]) { flags, args in
    print("Running git with \(flags) and \(args)")
}


git.execute(commandLineArgs: CommandLine.arguments)
