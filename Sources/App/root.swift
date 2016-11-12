//
//  git.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var rootCommand = Command(
  name: "guaka", configuration: configuration, run: execute)


private func configuration(command: Command) {
  
  command.add(flags: [
    Flag(longName: "version", value: false, inheritable: true),
    ]
  )
  
  command.inheritablePreRun = { flags, args in
    if
      let version = flags["version"]?.value as? Bool,
      version {
      print("Version 0.0.1")
      return false
    } 
    return true
  }
}

private func execute(flags: [String: Flag], args: [String]) {  
  print(rootCommand.helpMessage)
}
