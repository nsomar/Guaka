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
    XCTAssertEqual(git.printed, "Error: unknown shorthand flag: \'www\'\nUsage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string   (default -)\n      --foo string   (default -)\n      --remote bool  (default true)\n      --xx bool      (default true)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"remote [command] --help\" for more information about a command.\n\nunknown shorthand flag: \'www\'\nexit status 255")
  }

  func testItCatchesTheHelp() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(git.printed, "Usage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string   (default -)\n      --foo string   (default -)\n      --remote bool  (default true)\n      --xx bool      (default true)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"remote [command] --help\" for more information about a command.")
  }

  func testItCatchesTheCorrectAlias() {
    remote.aliases = ["rem1", "rem2"]
    let (cmd, _) = actualCommand(forCommand: git, args: expand("rem1"))
    XCTAssertEqual(cmd.name, remote.name)
  }

  func testItCatchesTheCorrectAlias2() {
    remote.aliases = ["rem1", "rem2"]
    show.aliases = ["s1", "s2"]
    let (cmd, _) = actualCommand(forCommand: git, args: expand("rem2 s1"))
    XCTAssertEqual(cmd.name, show.name)
  }

  func testItCanGetCommandToExecute() {
    //git.execute
    let c1 = git.commandToExecute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(c1.name, "remote")

    let c2 = git.commandToExecute(commandLineArgs: expand("git remote show --xx --bar=123 -h"))
    XCTAssertEqual(c2.name, "show")
  }

  func testItPrintsThatCommandIsDeprecatedWhenExecutingCommand() {
    remote.deprecationStatus = .deprecated("Pelase dont use it")
    git.execute(commandLineArgs: expand("git remote"))

    XCTAssertEqual(remote.printed, "Command \"remote\" is deprecated, Pelase dont use it")
  }

  func testItPrintsThatFlagIsDeprecatedWhenExecutingCommand() {
    remote.flags[0].deprecatedStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --foo 123"))

    XCTAssertEqual(remote.printed, "Flag --foo has been deprecated, Dont use it")
  }

  func testItItDoesNotPrintsFlagIfWeDidNotUseTheFlag() {
    remote.flags[0].deprecatedStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --bar 1"))

    XCTAssertEqual(remote.printed, "")
  }

  func testItItPrintsBothFlagAndCommandAreDeprecated() {
    remote.deprecationStatus = .deprecated("Dont use it")
    remote.flags[0].deprecatedStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --foo 1"))

    XCTAssertEqual(remote.printed, "Command \"remote\" is deprecated, Dont use it\nFlag --foo has been deprecated, Dont use it")
  }

  func testItCatchesRequiredFlagNotSet() {
    //git.execute
    git.add(flag: Flag(longName: "req", type: String.self, required: true))
    git.execute(commandLineArgs: expand("git"))
    XCTAssertEqual(git.printed, "Error: required flag was not set: \'req\' expected type: \'String\'\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n      --req string    (required)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.\n\nrequired flag was not set: \'req\' expected type: \'String\'\nexit status 255")
  }
}

