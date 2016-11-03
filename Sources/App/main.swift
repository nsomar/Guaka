//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import Guaka


let c = try! Command(name: "git", flags: [], commands: [], run: { flags, args in
  print("Running git with \(flags) and \(args)")
})
try! c.execute(commandLineArgs: CommandLine.arguments)
