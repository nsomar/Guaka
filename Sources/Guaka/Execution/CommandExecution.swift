import StringScanner


/// Executes a command with a list of arguments
///
/// - parameter rootCommand: The command to execute
/// - parameter arguments:        The arguments passed
///
/// - returns: The execution result
func executeCommand(rootCommand: Command, arguments: [String]) -> Result<String?, Error> {

  let (command, arguments) = actualCommand(forCommand: rootCommand, arguments: arguments)

  let flagSet = command.flagSet

  let flagSetWithHelp = flagSet.flagSetAppendingHelp()

  do {
    let (optionFlags, positionalArguments) = try flagSetWithHelp.parse(args: arguments)

    if let result = suggestion(forCommand: command, rootCommand: rootCommand, arguments: positionalArguments) {
      return result
    }
    
    // Prepare a map of flag
    var preparedFlags = try flagSetWithHelp.getPreparedFlags(withFlagValues: optionFlags)

    // If help flag is set, show help message
    if
      let help = preparedFlags["help"],
      help.value as? Bool == true {
      return .success(command.helpMessage)
    } else {
      preparedFlags["help"] = nil
    }

    // Make sure that all the required flags are set
    let res = flagSet.checkAllRequiredFlagsAreSet(preparedFlags: preparedFlags)
    if case let .failure(error) = res {
      throw error
    }

    command.execute(flags: Flags(flags: preparedFlags), arguments: positionalArguments)
  } catch {
    return .failure(CommandError.commandGeneralError(command, error))
  }

  return .success(nil)
}

func suggestion(forCommand command: Command, rootCommand: Command, arguments: [String]) -> Result<String?, Error>? {
  guard rootCommand === command else { return nil }
  guard rootCommand.commands.count != 0 else { return nil }

  guard let argument = arguments.first else { return nil }

  let alternatives = rootCommand.commands.map { try! $0.name() }
  let suggestion = Levenshtein.shortestDistance(forSource: argument, withChoices: alternatives)

  guard let suggestionMessage = command.suggestionMessage(original: argument, suggestion: suggestion) else { return nil }

  return .success(suggestionMessage)
}


extension FlagSet {


  /// Gets a map of flag long name and flags, filled with the flag value
  ///
  /// - parameter values: the flag values
  ///
  /// - returns: a map of flag long name and Flag with value set
  func getPreparedFlags(withFlagValues values: [Flag: [FlagValue]])
    throws -> [String: Flag] {

      var returnFlags = self.getFlagsWithLongNames()

      try values.forEach { flag, flagValues in
        guard var foundFlag = self.flags[flag.longName] else {
          throw CommandError.unexpectedFlagPassed(flag.longName, flagValues.map(String.init(describing:)))
        }

        foundFlag.values = flagValues
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
  func checkAllRequiredFlagsAreSet(preparedFlags: [String: Flag]) -> Result<String?, Error> {
    for flag in requiredFlags {
      guard let preparedFlag = preparedFlags[flag.longName] else {
        return .failure(CommandError.flagNotFound(flag.longName))
      }

      if preparedFlag.value == nil {
        return .failure(CommandError.requiredFlagsWasNotSet(flag.longName, flag.type))
      }
    }

    return .success(nil)
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

