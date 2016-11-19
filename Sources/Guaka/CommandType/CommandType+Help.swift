//
//  CommandType+Help.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//


extension CommandType {

  public var helpMessage: String {
    return DefaultHelpGenerator(command: self).helpMessage
  }

  public var innerHelpMessage: String {
    return DefaultHelpGenerator(command: self).errorHelpMessage
  }

}
