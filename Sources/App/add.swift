//
//  remote.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import Guaka

var addCommand: Command = Command(
  name: "add", 
  run: executeAddCommand, parent: rootCommand)


func executeAddCommand(flags: [String: Flag], args: [String]) {
  
}
