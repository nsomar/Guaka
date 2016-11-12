//
//  rebase.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var initCommand = Command(
  name: "init", parent: rootCommand, configuration: configuration, run: execute)


private func configuration(command: Command) {
  command.deprecationStatus = .deprecated("Dont use it")
  command.add(flags: [
    Flag(longName: "version", shortName: "v", value: false, inheritable: true),
    Flag(longName: "author", shortName: "a", value: "", inheritable: true),
    Flag(longName: "license", shortName: "l", value: "", inheritable: true),
    ]
  )
}

private func execute(flags: [String: Flag], args: [String]) {
  // Execute code here
}
