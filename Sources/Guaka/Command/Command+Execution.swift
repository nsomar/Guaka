//
//  Command+Execution.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

// MARK: Execution
extension Command {

  /// Execute a command passing all the command line arguments received
  public func execute() {
    execute(commandLineArgs: CommandLine.arguments)
  }

  /// Executes a command with a list of arguments
  ///
  /// - parameter commandLineArgs: the arguments passed to the executable
  /// The arguments include the name of the exacutable as the first input
  ///
  /// -----
  /// Example:
  /// ```
  /// rootCommand.execute(commandLineArgs: CommandLine.arguments)
  /// ```
  public func execute(commandLineArgs: [String]) {
    let res = executeCommand(rootCommand: self,
                             arguments: Array(commandLineArgs.dropFirst()))
    handleResult(res)
  }


  /// Get the actual command to execute based on the current command and the arguments passed
  ///
  /// - parameter commandLineArgs: the command line arguments passed
  /// The arguments include the name of the exacutable as the first input
  ///
  /// - returns: the actual command to execute
  ///
  /// -----
  /// Example:
  /// ```
  /// let command = rootCommand.commandToExecute(commandLineArgs: CommandLine.arguments)
  /// ```
  public func commandToExecute(commandLineArgs: [String]) -> Command {
    return actualCommand(forCommand: self, arguments: Array(commandLineArgs.dropFirst())).0
  }

  /// Validate a Command it flags and subcommands
  ///
  /// - Throws: error if command, subcommands or flags are not valid
  public func validate() throws {
    _ = try self.name()

    for flag in self.flags {
      try flag.validate()
    }

    for command in self.commands {
      try command.validate()
    }
  }

  /// Validate a Command it flags and subcommands
  ///
  /// - Throws: error if command, subcommands or flags are not valid
  func validateAndExitIfNeeded() {
    do {
      try validate()
    } catch let e as CommandError {
      fail(statusCode: -2, errorMessage: e.localizedDescription)
    } catch let e as FlagValueError {
      fail(statusCode: -2, errorMessage: e.error)
    } catch {
      fail(statusCode: -2, errorMessage: "Unknown error ocurred")
    }
  }


  /// Execute a command with flags and positional arguments
  func execute(flags: Flags, arguments: [String]) {
    printDeprecationMessages(flags: Array(flags.flags))

    // FIXME: Refactor and simplify
    if
      let inheritablePreRun = self.findAdequateInheritableRun(forPre: true),
      inheritablePreRun(flags, arguments) == false
    { return }

    if
      let preRun = preRun,
      preRun(flags, arguments) == false
    { return }

    self.run?(flags, arguments)

    if
      let postRun = postRun,
      postRun(flags, arguments) == false
    { return }

    _ = self.findAdequateInheritableRun(forPre: false)?(flags, arguments)
  }

}


extension Command {

  /// Find the preRun or Post run for the current command
  /// This searches for the parent post/pre run blocks
  func findAdequateInheritableRun(forPre: Bool) -> ConditionalRun?  {

    var cmd: Command? = self

    while true {
      let toFind = forPre ? cmd?.inheritablePreRun : cmd?.inheritablePostRun

      if let toFind = toFind { return toFind }

      cmd = cmd?.parent
      if cmd == nil { return nil }
    }
  }

}


extension Command {

  /// Handles the result of an execution
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


  /// Prints the deprecation message
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
