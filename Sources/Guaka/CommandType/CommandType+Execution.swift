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
    printDeprecationMessages(flags: Array(flags.values))
    self.run?(flags, args)
  }

  public func execute() {
    execute(commandLineArgs: CommandLine.arguments)
  }
  
  public func execute(commandLineArgs: [String]) {
    let res = executeCommand(rootCommand: self, args: Array(commandLineArgs.dropFirst()))
    handleResult(res)
  }
  
  public func commandToExecute(commandLineArgs: [String]) -> CommandType {
    return actualCommand(forCommand: self, args: Array(commandLineArgs.dropFirst())).0
  }
  
  private func handleResult(_ result: Result) {
    switch result {
    case .success:
      // Do nothing
      break
    case let .error(error):
      guard case let CommandErrors.commandGeneralError(command, error) = error else {
        return
      }
      
      if let error = error as? CommandErrors {
        printToConsole(error.errorMessage(forCommand: command))
      } else {
        printToConsole(CommandErrors.generalError(forCommand: command))
      }
      break
    case .message(let message):
      printToConsole(message)
      break
    }
  }
  
  private func printDeprecationMessages(flags: [Flag]) {
    if let deprecationMessage = self.deprecationMessageSection {
      printToConsole(deprecationMessage.joined())
    }
    
    for flag in flags where flag.didSet && flag.isDeprecated {
        printToConsole(flag.deprecationMessage)
      }
    }
  }

