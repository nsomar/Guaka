//
//  CommandType+Execution.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

// MARK: Execution
extension CommandType {

  public func execute(flags: Flags, args: [String]) {
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

  public func execute() {
    execute(commandLineArgs: CommandLine.arguments)
  }

  public func execute(commandLineArgs: [String]) {
    let res = executeCommand(rootCommand: self,
                             args: Array(commandLineArgs.dropFirst()))
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
      guard case let CommandError.commandGeneralError(command, error) = error else {
        return
      }

      let helpGenerator = GuakaConfig.helpGenerator.init(command: command)
      if let error = error as? CommandError {
        printToConsole(helpGenerator.errorString(forError: error))
      } else {
        printToConsole(helpGenerator.errorString(forError: .unknownError))
      }
      break
    case .message(let message):
      printToConsole(message)
      break
    }
  }

  fileprivate func printDeprecationMessages(flags: [Flag]) {

    let helpGenerator = GuakaConfig.helpGenerator.init(command: self)

    if let deprecationMessage = helpGenerator.deprecationSection {
      printToConsole(deprecationMessage)
    }

    flags.map { FlagHelp(flag: $0) }
      .filter { $0.isDeprecated && $0.wasChanged }
      .flatMap { helpGenerator.deprecationMessage(forDeprecatedFlag: $0) }
      .forEach { printToConsole($0) }
  }

}

