//
//  FlagSet.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//


/// FlagSet represents a list of flags
struct FlagSet {

  /// Map of flags
  let flags: [String: Flag]

  /// List of required flags
  let requiredFlags: [Flag]

  /// Initialize wit ha set of flags
  ///
  /// - parameter flags: list of flags
  init(flags: [Flag]) {
    var flagMap = [String: Flag]()

    flags.forEach {

      if let shortName = $0.shortName {
        flagMap[shortName] = $0
      }

      flagMap[$0.longName] = $0
    }

    self.flags = flagMap
    self.requiredFlags = FlagSet.requiredFlags(flags: flags)
  }

  fileprivate init(flagsMap: [String: Flag]) {
    self.flags = flagsMap
    self.requiredFlags = FlagSet.requiredFlags(flags: flags.values)
  }
}


extension FlagSet {

  /// Get the list of required flags
  ///
  /// - parameter flags: the flags to check
  ///
  /// - returns: the required flags
  static func requiredFlags<T: Sequence>(flags: T) -> [Flag]
  where T.Iterator.Element == Flag {
    let unique = Set(flags)
    let required = unique.filter { $0.required }
    return Array(required)
  }
}


extension FlagSet {

  /// Get the global flags based on the local flags
  ///
  /// - parameter flags: the local flags
  ///
  /// - returns: the global flags
  func globalFlags(withLocalFlags flags: [Flag]) -> [Flag] {
    let allFlags = Set(self.flags.values)
    let localFlags = Set(flags)
    return Array(allFlags.subtracting(localFlags))
  }
  
}


extension FlagSet {

  /// Returns an updated FlagSet appending the help flag
  func flagSetAppendingHelp() -> FlagSet {
    var flags = self.flags
    flags["help"] = helpFlag
    flags["h"] = helpFlag

    return FlagSet(flagsMap: flags)
  }

  private var helpFlag: Flag {
    return Flag(longName: "help", shortName: "h", value: false, inheritable: true, description: "Show help")
  }

}
