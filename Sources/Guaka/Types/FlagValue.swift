//
//  FlagValue.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


/// Protocol that defines the needs to be implemented for a type to be used as a flag value
///
/// ----
/// Example
/// 
/// Flag with User type
///
/// ```
/// struct User: FlagValue {
///   let name: String
///
///   static func fromString(flagValue value: String) throws -> User {
///     return User(name: value)
///   }
///
///   static var typeDescription: String {
///     return "A user structure"
///   }
/// }
/// ```
///
/// We can then use user to define flag type:
///
/// ```
/// let flag = try! Flag(longName: "debug", type: User.self)
/// ```
///
public protocol FlagValue {

  /// Create a command string convertible from string
  ///
  /// - parameter value: the string to be converted
  ///
  /// - throws: exception thrown if cannot convert from string.
  /// The exception of type FlagValueError
  ///
  /// ----
  /// Example
  ///
  /// Create a correct user from string
  ///
  /// ```
  /// struct User: FlagValue {
  ///   let name: String
  ///
  ///   static func fromString(flagValue value: String) throws -> User {
  ///     return User(name: value)
  ///   }
  ///
  ///   static var typeDescription: String {
  ///     return "A user structure"
  ///   }
  /// }
  /// ```
  ///
  /// Return a parsing error
  ///
  /// ```
  /// struct User: FlagValue {
  ///   let name: String
  ///
  ///   static func fromString(flagValue value: String) throws -> User {
  ///     if value == "wrong" {
  ///         throw FlagValueError.conversionError("wrong user passed")
  ///     }
  ///     return User(name: value)
  ///   }
  ///
  ///   static var typeDescription: String {
  ///     return "A user structure"
  ///   }
  /// }
  /// ```
  ///
  static func fromString(flagValue value: String) throws -> Self

  /// Return a decription to be printed when priting the command help
  ///
  /// -----
  /// Example
  ///
  /// ```
  /// struct User: FlagValue {
  ///   let name: String
  ///
  ///   static func fromString(flagValue value: String) throws -> User {
  ///
  ///     return User(name: value)
  ///   }
  ///
  ///   static var typeDescription: String {
  ///     return "A user structure"
  ///   }
  /// }
  /// ```
  ///
  /// When printing the help, the `typeDescription` will be used.
  ///
  /// ```
  /// Flags:
  ///   -u, --user         A user structure
  ///
  /// Use "command [command] --help" for more information about a command.
  /// ```
  ///
  static var typeDescription: String { get }
}


/// Error to throw when converting string to FlagValue
///
/// - conversionError: conversation error string
/// This string will be used to be printed to the console
///
/// ----
/// Example
///
/// ```
/// struct User: FlagValue {
///   let name: String
///
///   static func fromString(flagValue value: String) throws -> User {
///     if value == "wrong" {
///         throw FlagValueError.conversionError("wrong user passed")
///     }
///     return User(name: value)
///   }
///
///   static var typeDescription: String {
///     return "A user structure"
///   }
/// }
/// ```
///
public enum FlagValueError: Error {

  /// Conversation error happened while parsing string to type
  /// This string will be used to be printed to the console
  ///
  /// ----
  /// Example
  ///
  /// ```
  /// struct User: FlagValue {
  ///   let name: String
  ///
  ///   static func fromString(flagValue value: String) throws -> User {
  ///     if value == "wrong" {
  ///         throw FlagValueError.conversionError("wrong user passed")
  ///     }
  ///     return User(name: value)
  ///   }
  ///
  ///   static var typeDescription: String {
  ///     return "A user structure"
  ///   }
  /// }
  /// ```
  ///
  case conversionError(String)

  var error: String {
    switch self {
    case .conversionError(let s):
      return s
    }
  }
}


extension Bool: FlagValue {

  public static func fromString(flagValue value: String) throws -> Bool {
    if value == "1" {
      return true
    } else if value == "0" {
      return false
    } else if let b = Bool(value) {
      return b
    }

    throw FlagValueError.conversionError("cannot convert '\(value)' to '\(Bool.self)' ")
  }

  public static var typeDescription: String { return "" }

}


extension Int: FlagValue {

  public static func fromString(flagValue value: String) throws -> Int {
    guard let val = Int(value) else {
      throw FlagValueError.conversionError("cannot convert '\(value)' to '\(Int.self)' ")
    }

    return val
  }

  public static var typeDescription: String { return "int" }

}


extension String: FlagValue {

  public static func fromString(flagValue value: String) throws -> String {
    return value
  }

  public static var typeDescription: String { return "string" }

}
