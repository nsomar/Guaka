//
//  CommandType+Help.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//


extension CommandType {

  public var helpMessage: String {
    return GuakaConfig.helpGenerator.init(command: self).helpMessage
  }

  public var innerHelpMessage: String {
    return GuakaConfig.helpGenerator.init(command: self).errorHelpMessage
  }

}
