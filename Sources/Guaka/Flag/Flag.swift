//
//  Flag.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//


/// Flag struct representing a flag
///
/// ----
/// Example:
///
/// Create a flag with a default value
///
/// ```
/// let flag = try! try! Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc")
/// ```
///
/// Create a non required flag without value
///
/// ```
/// let flag = try! Flag(longName: "debug", type: Int.self)
/// ```
///
/// Create a required flag without value
///
/// ```
/// let flag = try! Flag(longName: "debug", type: Int.self, required: true)
/// ```
///
public struct Flag: Hashable {


  /// Flag long name. Such as `verbose`
  /// Must be non empty without spaces and special characters
  public let longName: String


  /// Flag short name. Should be one letter. Such as `v`
  /// Must be 1 alpha numeric character
  public let shortName: String?


  /// Set the flag to be inheritable
  /// An inheritable flag is valid for a command and all its subcommands
  public let inheritable: Bool


  /// The flag description printed in the help beside the flag name
  public let description: String


  /// Flag value type.
  public let type: FlagValue.Type


  /// Set the flag to be required
  /// A required flag must be set in order for commands to be executed.
  public let required: Bool


  /// Flag values.
  /// The value can be `int`, `bool`, `string` or any other type that implements `FlagValue`
  public var values: [FlagValue] = []


  /// Set the flag to allow multiple values
  /// A repeatable flag can be specified multiple times and will return an array of values.
  public var repeatable: Bool


  /// Flag value.
  /// The value can be `int`, `bool`, `string` or any other type that implements `FlagValue`
  public var value: FlagValue? {
    get { return values.first }
    set {
      if let val = newValue {
        values = [val]
      }
    }
  }


  /// Flag deprecation status.
  public var deprecationStatus = DeprecationStatus.notDeprecated


  /// Gets the flag hash value.
  public var hashValue: Int {
    return longName.hashValue
  }


  /// Return if the flag is a boolean or not.
  var isBool: Bool {
    return value is Bool
  }


  /// Was the flag value set from the arguments
  var didSet: Bool = false


  /// Creates a new flag
  ///
  /// - parameter shortName:   (Optional) Flag short name, the short name must be 1 alpha numeric character. Defaults to nil
  /// - parameter longName:    Flag long name, must be non empty without spaces or empty characters
  /// - parameter value:       Flag default value
  /// - parameter description: Flag description to be shown when displaying command help
  /// - parameter inheritable: (Optional)Flag inheritable status. Defaults to false
  ///
  /// -----
  /// Discussion:
  ///
  /// If the flag contains spaces, dashes and other special characters the command will exit printing the error
  ///
  /// -----
  /// Example:
  ///
  /// Create a flag with a default value
  ///
  /// ```
  /// let flag = try! Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc")
  /// ```
  ///
  /// -----
  public init<T: FlagValue>(shortName: String? = nil,
                            longName: String,
                            value: T,
                            description: String,
                            inheritable: Bool = false) {

    self.longName = longName
    self.shortName = shortName
    self.values = [value]
    self.inheritable = inheritable
    self.description = description
    self.type = T.self
    self.required = true
    self.repeatable = false
  }


  /// Creates a new flag
  ///
  /// - parameter shortName:   (Optional) Flag short name, the short name must be 1 alpha numeric character. Defaults to nil
  /// - parameter longName:    Flag long name, must be non empty without spaces or empty characters
  /// - parameter values:      Flag default values
  /// - parameter description: Flag description to be shown when displaying command help
  /// - parameter inheritable: (Optional)Flag inheritable status. Defaults to false
  ///
  /// -----
  /// Discussion:
  ///
  /// If the flag contains spaces, dashes and other special characters the command will exit printing the error
  ///
  /// -----
  /// Example:
  ///
  /// Create a flag with a default value
  ///
  /// ```
  /// let flag = try! Flag(longName: "target", shortName: "t", values: "small", "fast", description: "Here is a desc")
  /// ```
  ///
  /// -----
  public init<T: FlagValue>(shortName: String? = nil,
                            longName: String,
                            values: [T],
                            description: String,
                            inheritable: Bool = false) {

    self.longName = longName
    self.shortName = shortName
    self.values = values
    self.inheritable = inheritable
    self.description = description
    self.type = T.self
    self.required = true
    self.repeatable = true
  }


  /// Creates a new flag
  ///
  /// - parameter shortName:   (Optional) Flag short name, the short name must be 1 alpha numeric character. Defaults to nil
  /// - parameter longName:    Flag long name, must be non empty without spaces or empty characters
  /// - parameter values:      Flag default values
  /// - parameter description: Flag description to be shown when displaying command help
  /// - parameter inheritable: (Optional)Flag inheritable status. Defaults to false
  ///
  /// -----
  /// Discussion:
  ///
  /// If the flag contains spaces, dashes and other special characters the command will exit printing the error
  ///
  /// -----
  /// Example:
  ///
  /// Create a flag with a default value
  ///
  /// ```
  /// let flag = try! Flag(longName: "target", shortName: "t", values: "small", "fast", description: "Here is a desc")
  /// ```
  ///
  /// -----
  public init<T: FlagValue>(shortName: String? = nil,
                            longName: String,
                            values: T...,
                            description: String,
                            inheritable: Bool = false) {

    self.longName = longName
    self.shortName = shortName
    self.values = values
    self.inheritable = inheritable
    self.description = description
    self.type = T.self
    self.required = true
    self.repeatable = true
  }


  /// Creates a new flag
  ///
  /// - parameter shortName:   (Optional) Flag short name, the short name must be 1 alpha numeric character. Defaults to nil
  /// - parameter longName:    Flag long name, must be non empty without spaces or empty characters
  /// - parameter type:        Flag value type
  /// - parameter description: Flag description to be shown when displaying command help
  /// - parameter required:    (Optional)Flag requirement status. Defaults to false
  /// - parameter repeatable:  (Optional)Flag may contain multiple values. Defaults to false
  /// - parameter inheritable: (Optional)Flag inheritable status. Defaults to false
  ///
  /// -----
  /// Discussion:
  ///
  /// If the flag contains spaces, dashes and other special characters the command will exit printing the error
  ///
  /// -----
  /// Example:
  ///
  /// Create a flag with a default value
  ///
  /// ```
  /// let flag = try! Flag(longName: "debug", type: Int.self, required: true)
  /// ```
  ///
  /// -----
  public init<T: FlagValue>(shortName: String? = nil,
              longName: String,
              type: T.Type,
              description: String,
              required: Bool = false,
              repeatable: Bool = false,
              inheritable: Bool = false) {

    self.longName = longName
    self.shortName = shortName
    self.type = type
    self.inheritable = inheritable
    self.description = description
    self.required = required
    self.repeatable = repeatable
  }


  /// Creates a new flag
  ///
  /// - parameter shortName:   (Optional) Flag short name, the short name must be 1 alpha numeric character. Defaults to nil
  /// - parameter longName:    Flag long name, must be non empty without spaces or empty characters
  /// - parameter type:        Flag value type
  /// - parameter description: Flag description to be shown when displaying command help
  /// - parameter required:    (Optional)Flag requirement status. Defaults to false
  /// - parameter inheritable: (Optional)Flag inheritable status. Defaults to false
  ///
  /// -----
  /// Discussion:
  ///
  /// If the flag contains spaces, dashes and other special characters the command will exit printing the error
  ///
  /// -----
  /// Example:
  ///
  /// Create a flag with a default value
  ///
  /// ```
  /// let flag = try! Flag(longName: "debug", type: Int.self, required: true)
  /// ```
  ///
  /// -----
  public init<T: FlagValue>(shortName: String? = nil,
              longName: String,
              type: [T].Type,
              description: String,
              required: Bool = false,
              inheritable: Bool = false) {

    self.longName = longName
    self.shortName = shortName
    self.type = type.Element.self
    self.inheritable = inheritable
    self.description = description
    self.required = required
    self.repeatable = true
  }

  func validate() throws {
    try checkFlagLongName()
    try checkFlagShortName()
  }

}


/// Check for flags equality
public func ==(left: Flag, right: Flag) -> Bool {
  return left.hashValue == right.hashValue
}
