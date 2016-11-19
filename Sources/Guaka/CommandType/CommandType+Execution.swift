//
//  CommandType+Execution.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

// MARK: Execution
extension CommandType {

  public func execute(flags: Flags, args: [String], config: GuakaConfig = GuakaConfig()) {
    printDeprecationMessages(flags: Array(flags.flags))

    // FIXME: Refactor and simplify
    if
      let inheritablePreRun = self.findAdequateInheritableRun(forPre: true),
      inheritablePreRun(flags, args) == false
    { return }

    if
      let preRun = preRun,
      preRun(flags, args) == false
    { return }

    self.run?(flags, args)

    if
      let postRun = postRun,
      postRun(flags, args) == false
    { return }

    _ = self.findAdequateInheritableRun(forPre: false)?(flags, args)
  }

  public func execute(config: GuakaConfig = GuakaConfig()) {
    execute(commandLineArgs: CommandLine.arguments)
  }

  public func execute(commandLineArgs: [String], config: GuakaConfig = GuakaConfig()) {
    let res = executeCommand(rootCommand: self, args: Array(commandLineArgs.dropFirst()))
    handleResult(res)
  }

  public func commandToExecute(commandLineArgs: [String]) -> CommandType {
    return actualCommand(forCommand: self, args: Array(commandLineArgs.dropFirst())).0
  }

}


extension CommandType {
  func findAdequateInheritableRun(forPre: Bool) -> ConditionalRun?  {

    var cmd: CommandType? = self

    while true {
      let toFind = forPre ? cmd?.inheritablePreRun : cmd?.inheritablePostRun

      if let toFind = toFind { return toFind }

      cmd = cmd?.parent
      if cmd == nil { return nil }
    }
  }
}


extension CommandType {

  fileprivate func handleResult(_ result: Result) {
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

  fileprivate func printDeprecationMessages(flags: [Flag]) {

    if let deprecationMessage =
      DefaultHelpGenerator(command: self).deprecationSection {
      printToConsole(deprecationMessage)
    }

    for flag in flags where flag.didSet && flag.isDeprecated {
      printToConsole(flag.deprecationMessage)
    }
  }

}

