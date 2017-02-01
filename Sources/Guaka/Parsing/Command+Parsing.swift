//
//  Command+Parsing.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 26/11/2016.
//
//


/// Get the actual command and parametrs from a root command and command line arguments
///
/// - parameter command: root command
/// - parameter arguments:    the arguments passed
///
/// - returns: returns the actual command based on the subcommands and the command line arguments
/// and the list of arguments to pass to it
/// -----
/// Based on the passed arguments, this function gets the actual commands to execute and the arguments to send to it
func actualCommand(forCommand command: Command, arguments: [String]) -> (Command, [String]) {
  var possibleCommands = [String]()

  let flagSet = command.flagSet

  skippabeIterator(array: arguments) { arg in
    let token = ArgTokenType(fromString: arg)

    if case let .positionalArgument(str) = token {
      possibleCommands.append(str)
    }

    if token.isFlag && !flagSet.isFlagSatisfied(token: token) {
      return true
    }

    return false
  }

  guard
    let first = possibleCommands.first,
    let nextCommand = command[withName: first]
    else {
      return (command, arguments)
  }

  nextCommand.aliasUsedToCallCommand = first
  
  let remainingArgs = remove(argument: first, fromArguments: arguments)

  return actualCommand(forCommand: nextCommand, arguments: remainingArgs)
}


/// Remove argument from the list of arguments
///
/// - parameter argument:  argument to remove
/// - parameter arguments: list of arguments to remove from
///
/// - returns: the remaining list of arguments
private func remove(argument: String, fromArguments arguments: [String]) -> [String] {
  return arguments.filter { $0 != argument }
}


/// An iteratior that is able to skip the next argument
///
/// - parameter array: the array to iterate
/// - parameter block: the block to call for each item
/// Returning true from the block will skip the next element
private func skippabeIterator<T>(array: [T], block: (T) -> (Bool)) {
  var skipNext = false
  for element in array {

    if skipNext {
      skipNext = false
      continue
    }

    if block(element) {
      skipNext = true
    }
  }
}
