//
//  CommandExecutionTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 03/11/2016.
//
//

import XCTest
@testable import Guaka

class CommandExecutionTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItCanExecuteShowCommand() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote show --yy"))

    XCTAssertEqual(executed?.0.flags.count, 6)
    XCTAssertEqual(executed?.0["yy"]?.value as? Bool, true)
    XCTAssertEqual(executed?.0["debug"]?.value as? Bool, true)
    XCTAssertEqual(executed?.0["verbose"]?.value as? Bool, false)
    XCTAssertEqual(executed?.0["foo"]?.value as? String, "-")
    XCTAssertEqual(executed?.0["remote"]?.value as? Bool, true)
    XCTAssertEqual(executed?.0["bar"]?.value as? String, "-")

    XCTAssertEqual((executed?.1)!, [])
  }

  func testItCanExecuteShowCommandWithArgs() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote show --yy aaaa bbbb cccc"))

    XCTAssertEqual(executed?.0.flags.count, 6)

    XCTAssertEqual((executed?.1)!, ["aaaa", "bbbb", "cccc"])
  }

  func testItCanExecuteRemoteCommand() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123"))

    XCTAssertEqual(executed?.0.flags.count, 6)
    XCTAssertEqual(executed?.0["xx"]?.value as? Bool, true)
    XCTAssertEqual(executed?.0["debug"]?.value as? Bool, true)
    XCTAssertEqual(executed?.0["verbose"]?.value as? Bool, false)
    XCTAssertEqual(executed?.0["foo"]?.value as? String, "show")
    XCTAssertEqual(executed?.0["remote"]?.value as? Bool, true)
    XCTAssertEqual(executed?.0["bar"]?.value as? String, "123")

    XCTAssertEqual((executed?.1)!, [])
  }

  func testItCatchesExceptionsInExecution() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 --www 123"))
    XCTAssertEqual(git.printed, "Error: unknown shorthand flag: \'www\'\nUsage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"git remote [command] --help\" for more information about a command.\n\nunknown shorthand flag: \'www\'\nexit status 255")
  }

  func testItCatchesTheHelp() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(git.printed, "Usage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"git remote [command] --help\" for more information about a command.")
  }

  func testItCatchesTheHelpForTheCorrectAlias() {
    //git.execute
    remote.aliases = ["remote2"]
    git.execute(commandLineArgs: expand("git remote2 -h"))
    XCTAssertEqual(git.printed, "Usage:\n  git remote2 [flags]\n  git remote2 [command]\n\nAliases:\n  remote, remote2\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"git remote2 [command] --help\" for more information about a command.")
  }

  func testItCatchesTheHelpThatIsOverriden() {
    struct DummyGenerator: HelpGenerator {
      let commandHelp: CommandHelp
      var usageSection: String? = "Usage is this"

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    GuakaConfig.helpGenerator = DummyGenerator.self
    git.usage = "git do this"

    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(git.printed, "Usage is thisAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"git remote [command] --help\" for more information about a command.")

    GuakaConfig.helpGenerator = DefaultHelpGenerator.self
  }

  func testItCatchesTheCorrectAlias() {
    remote.aliases = ["rem1", "rem2"]
    let (cmd, _) = actualCommand(forCommand: git, arguments: expand("rem1"))
    XCTAssertEqual(cmd.nameOrEmpty, remote.nameOrEmpty)
  }

  func testItCatchesTheCorrectAlias2() {
    remote.aliases = ["rem1", "rem2"]
    show.aliases = ["s1", "s2"]
    let (cmd, _) = actualCommand(forCommand: git, arguments: expand("rem2 s1"))
    XCTAssertEqual(cmd.nameOrEmpty, show.nameOrEmpty)
  }

  func testItCanGetCommandToExecute() {
    //git.execute
    let c1 = git.commandToExecute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(c1.nameOrEmpty, "remote")

    let c2 = git.commandToExecute(commandLineArgs: expand("git remote show --xx --bar=123 -h"))
    XCTAssertEqual(c2.nameOrEmpty, "show")
  }

  func testItPrintsThatCommandIsDeprecatedWhenExecutingCommand() {
    remote.deprecationStatus = .deprecated("Pelase dont use it")
    git.execute(commandLineArgs: expand("git remote"))

    XCTAssertEqual(remote.printed, "Command \"remote\" is deprecated, Pelase dont use it")
  }

  func testItPrintsThatFlagIsDeprecatedWhenExecutingCommand() {
    remote.flags[0].deprecationStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --foo 123"))

    XCTAssertEqual(remote.printed, "Flag --foo has been deprecated, Dont use it")
  }

  func testItItDoesNotPrintsFlagIfWeDidNotUseTheFlag() {
    remote.flags[0].deprecationStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --bar 1"))

    XCTAssertEqual(remote.printed, "")
  }

  func testItItPrintsBothFlagAndCommandAreDeprecated() {
    remote.deprecationStatus = .deprecated("Dont use it")
    remote.flags[0].deprecationStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --foo 1"))

    XCTAssertEqual(remote.printed, "Command \"remote\" is deprecated, Dont use it\nFlag --foo has been deprecated, Dont use it")
  }

  func testItCatchesRequiredFlagNotSet() {
    //git.execute
    git.add(flag: Flag(longName: "req", type: String.self, description: "", required: true))
    git.execute(commandLineArgs: expand("git"))
    XCTAssertEqual(git.printed, "Error: required flag was not set: \'req\' expected type: \'String\'\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug       \n      --req string  (required)\n  -r, --root int    (default 1)\n  -t, --togge       \n  -v, --verbose     \n\nUse \"git [command] --help\" for more information about a command.\n\nrequired flag was not set: \'req\' expected type: \'String\'\nexit status 255")
  }

  func testItSuggestsAlterntivesWhenNotMatchingNoFlags() {
    git.execute(commandLineArgs: expand("git rbase"))

    XCTAssertEqual(git.printed, "git: 'rbase' is not a git command. See 'git --help'.\n\nDid you mean this?\n  rebase")
  }

  func testItSuggestsAlterntivesWhenNotMatchingFlags() {
    git.execute(commandLineArgs: expand("git rbase -v"))

    XCTAssertEqual(git.printed, "git: 'rbase' is not a git command. See 'git --help'.\n\nDid you mean this?\n  rebase")
  }

  func testItShouldNotShowSuggestionIfFlagIsPassed() {
    git.execute(commandLineArgs: expand("git --help"))

    XCTAssertFalse(git.printed.contains("is not a git command"))
  }

  func testItShouldShowHelpIfHelpFlagIsPassedToWrongCommand() {
    git.execute(commandLineArgs: expand("git rbase --help"))

    XCTAssertTrue(git.printed.contains("is not a git command"))
  }

  func testItShouldBotShowSuggestionIfDoesNotHaveSubcomamnds() {
    git.commands = []
    git.execute(commandLineArgs: expand("git \"Hello from cli\""))

    XCTAssertEqual(git.printed, "")
    XCTAssertEqual(try! commandExecuted?.name(), "git")
  }

  static var allTests : [(String, (CommandExecutionTests) -> () throws -> Void)] {
    return [
      ("testItSuggestsAlterntivesWhenNotMatchingNoFlags", testItSuggestsAlterntivesWhenNotMatchingNoFlags),
      ("testItSuggestsAlterntivesWhenNotMatchingFlags", testItSuggestsAlterntivesWhenNotMatchingFlags),
    ]
  }
}

