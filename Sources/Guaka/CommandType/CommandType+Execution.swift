//
//  CommandType+Execution.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

// MARK: Execution
extension CommandType {
  public func execute(flags: [String: Flag], args: [String]) {
    self.run?(flags, args)
  }
  
  public func execute(commandLineArgs: [String]) {
    let res = executeCommand(rootCommand: self, args: Array(commandLineArgs.dropFirst()))
    handleResult(res)
  }
  
  public func commandToExecute(commandLineArgs: [String]) -> CommandType {
    return getCurrentCommand(command: self, args: Array(commandLineArgs.dropFirst())).0
  }
  
  private func handleResult(_ result: Result) {
    switch result {
    case .success:
      // Do nothing
      break
    case .error(let error):
      if let error = error as? CommandErrors {
        printToConsole(error.errorMessage(forCommand: self))
      } else {
        printToConsole(CommandErrors.generalError(forCommand: self))
      }
      break
    case .message(let message):
      printToConsole(message)
      break
    }
  }
  
}


// MARK: Printing
extension CommandType {
  public func printToConsole(_ string: String) {
    print(string)
  }
}
