import StringScanner

public func executeCommand(rootCommand: CommandType, args: [String]) throws {
  let (command, args) = getCurrentCommand(command: rootCommand, args: args)
  
  let fs = command.flagSet
  let (optionFlags, positionalArguments) = try fs.parse(args: args)
  let preparedFlags = try fs.getPreparedFlags(withFlagValues: optionFlags)
  
  command.execute(flags: preparedFlags, args: positionalArguments)
}

func getCurrentCommand(command: CommandType, args: [String]) -> (CommandType, [String]) {
  return stripFlags(command: command, args: args)
}

func stripFlags(command: CommandType, args: [String]) -> (CommandType, [String]) {
  var possibleCommands = [String]()
  
  let flagSet = command.flagSet
  
  skippabeIterator(array: args) { arg in
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
    let nextCommand = command.commands[first]
    else {
      return (command, args)
  }
  
  let remainingArgs = remove(arg: first, fromArgs: args)
  
  return stripFlags(command: nextCommand, args: remainingArgs)
}

func remove(arg: String, fromArgs args: [String]) -> [String] {
  return args.filter { $0 != arg }
}

func skippabeIterator<T>(array: [T], block: (T) -> (Bool)) {
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
