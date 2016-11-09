//
//  rebase.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var initCommand: Command = Command(
  name: "init", run: executeInitCommand, parent: rootCommand)

func executeInitCommand(flags: [String: Flag], args: [String]) {
  // put your code here
}
