//
//  Command.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//

/// Deprecation status type for flags and commands
///
/// - notDeprecated: not deprecated, this is the default
/// - deprecated:    the flag/command is deprecated
public enum DeprecationStatus {

  /// not deprecated, this is the default
  case notDeprecated

  /// the flag/command is deprecated
  case deprecated(String)


  /// Is it deprecated
  public var isDeprecated: Bool {
    if case .notDeprecated = self { return false }
    return true
  }


  /// The deprication message
  public var deprecationMessage: String? {
    if case .deprecated(let message) = self { return message }
    return nil
  }
}

/// Run block, called when the command is executed
/// This callback receives the Flags passed to it and the positional arguments
public typealias Run = (Flags, [String]) -> ()


/// Conditional Run block, called when the command is executed
/// When returining true from this command the execution continues
/// Returning false, means dont continue the execution
public typealias ConditionalRun = (Flags, [String]) -> (Bool)


/// Configuration block
public typealias Configuration = (Command) -> ()
