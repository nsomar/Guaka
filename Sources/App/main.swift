//
//  Execute.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import Guaka

setup()

root.add(flag: Flag(longName: "togge", value: false, shortName: "t", inheritable: false))
root.add(flag: Flag(longName: "root", value: 1, shortName: "r", inheritable: false))

root.execute()
