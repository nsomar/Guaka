import StringScanner


/// Executes a command with a list of arguments
///
/// - parameter rootCommand: The command to execute
/// - parameter arguments:        The arguments passed
///
/// - returns: The execution result
func executeCommand(rootCommand: Command, arguments: [String]) -> Result {

  let (command, arguments) = actualCommand(forCommand: rootCommand, arguments: arguments)
  let flagSet = command.flagSet

  let flagSetWithHelp = flagSet.flagSetAppendingHelp()

  do {
    let (optionFlags, positionalArguments) = try flagSetWithHelp.parse(args: arguments)

    // Prepare a map of flag
    var preparedFlags = try flagSetWithHelp.getPreparedFlags(withFlagValues: optionFlags)

    // If help flag is set, show help message
    if
      let help = preparedFlags["help"],
      help.value as? Bool == true {
      return .message(command.helpMessage)
    } else {
      preparedFlags["help"] = nil
    }

    // Make sure that all the required flags are set
    let res = flagSet.checkAllRequiredFlagsAreSet(preparedFlags: preparedFlags)
    if case let .error(error) = res {
      throw error
    }

    command.execute(flags: Flags(flags: preparedFlags), arguments: positionalArguments)
  } catch {
    return .error(CommandError.commandGeneralError(command, error))
  }

  return .success
}


extension FlagSet {


  /// Gets a map of flag long name and flags, filled with the flag value
  ///
  /// - parameter values: the flag values
  ///
  /// - returns: a map of flag long name and Flag with value set
  func getPreparedFlags(withFlagValues values: [Flag: FlagValueStringConvertible])
    throws -> [String: Flag] {

      var returnFlags = self.getFlagsWithLongNames()

      try values.forEach { flag, value in
        guard var foundFlag = self.flags[flag.longName] else {
          throw CommandError.unexpectedFlagPassed(flag.longName, "\(value)")
        }

        foundFlag.value = value
        foundFlag.didSet = true
        returnFlags[foundFlag.longName] = foundFlag
      }

      return returnFlags
  }


  /// Check that all required flags are set
  ///
  /// - parameter preparedFlags: the flags to check
  ///
  /// - returns: the result of the check
  /// success if all the flags are set
  /// error if some flags are not set
  func checkAllRequiredFlagsAreSet(preparedFlags: [String: Flag]) -> Result {
    for flag in requiredFlags {
      guard let preparedFlag = preparedFlags[flag.longName] else {
        return .error(CommandError.flagNotFound(flag.longName))
      }

      if preparedFlag.value == nil {
        return .error(CommandError.requiredFlagsWasNotSet(flag.longName, flag.type))
      }
    }

    return .success
  }


  /// Get a map of [long flag names: Flag]
  private func getFlagsWithLongNames() -> [String: Flag] {
    var returnFlags = [String: Flag]()
    self.flags.forEach { key, flag in
      if key == flag.longName {
        returnFlags[key] = flag
      }
    }

    return returnFlags
  }

}


/// Merge two maps and update the first element
///
/// - parameter left:  The map to update
/// - parameter right: the map to merge
func += <K, V> (left: inout [K: V], right: [K: V]) {
  for (k, v) in right {
    left.updateValue(v, forKey: k)
  }
}

