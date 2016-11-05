//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import Guaka


let git = try! Command(
  name: "git",
  flags: [
    Flag(longName: "debug", type: Bool.self, required: true),
    Flag(longName: "verbose", value: false, shortName: "v", inheritable: true),
    Flag(longName: "togge", value: false, shortName: "t", inheritable: false),
    Flag(longName: "root", value: 1, shortName: "r", inheritable: false),
    ]) { flags, args in
    print("Running git with \(flags) and \(args)")
}

let show = try! Command(
  name: "show",
  flags: [
    Flag(longName: "foo", value: "-", inheritable: false),
    Flag(longName: "bar", value: "-", inheritable: false),
    Flag(longName: "yy", value: true, inheritable: false),
    ]) { flags, args in
      print("Running git with \(flags) and \(args)")
}

let remote = try! Command(
  name: "remote",
  flags: [
    Flag(longName: "foo", value: "-", inheritable: true),
    Flag(longName: "remote", value: true, inheritable: true),
    Flag(longName: "bar", value: "-", inheritable: false),
    Flag(longName: "xx", value: true, inheritable: false),
    ]) { flags, args in
      print("Running git with \(flags) and \(args)")
}

let rebase = try! Command(
  name: "rebase",
  flags: [
    Flag(longName: "varvar", value: false, shortName: "v", inheritable: true),
    ]) { flags, args in
      print("Running git with \(flags) and \(args)")
}

git.add(subCommand: remote)
git.add(subCommand: rebase)

remote.add(subCommand: show)

git.execute(commandLineArgs: CommandLine.arguments)
