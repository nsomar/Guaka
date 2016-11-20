//
//  DefaultHelpGenerator.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

struct DefaultHelpGenerator: HelpGenerator {

  let commandHelp: CommandHelp

  init(commandHelp: CommandHelp) {
    self.commandHelp = commandHelp
  }

}

