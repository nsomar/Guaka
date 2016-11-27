//
//  GuakaConfig.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//


/// Guaka global configurations
public struct GuakaConfig {

  /// Sets the help generator strategy
  /// By default this is `DefaultHelpGenerator`
  public static var helpGenerator: HelpGenerator.Type = DefaultHelpGenerator.self
}
