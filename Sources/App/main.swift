//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import Guaka


initCommand.add(flags:
  [
    Flag(longName: "foo", value: "", inheritable: true),
    Flag(longName: "remote", value: true, inheritable: true),
    Flag(longName: "bar", value: "", inheritable: false),
    Flag(longName: "xx", value: true, inheritable: false),
    ]
)

addCommand.add(flag: Flag(longName: "parent", shortName: "p", value: "", inheritable: true))

rootCommand.add(flags: [
  Flag(longName: "version", shortName: "v", value: false, inheritable: true),
  Flag(longName: "author", shortName: "a", value: "", inheritable: true),
  Flag(longName: "license", shortName: "l", value: "", inheritable: true),
  ]
)


initCommand.deprecationStatus = .deprecated("Dont use it")
initCommand.flags[0].deprecatedStatus = .deprecated("Dont use it")

rootCommand.execute()
