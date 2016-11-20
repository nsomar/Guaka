//
//  ErrorsTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import XCTest
@testable import Guaka

class ErrorTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItPrintsFlagNotFoundMessage() {
    let e = DefaultHelpGenerator(command: git)
      .errorString(forError: CommandError.flagNotFound("debug"))

    XCTAssertEqual(e, "Error: unknown shorthand flag: \'debug\'\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug     \n  -r, --root int      (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.\n\nunknown shorthand flag: \'debug\'\nexit status 255")
  }

  func testItPrintsFlagNotFoundError() {
    let e = DefaultHelpGenerator(command: git)
      .errorMessage(forError: CommandError.flagNotFound("debug"))
    XCTAssertEqual(e, "unknown shorthand flag: \'debug\'")
  }

  func testItPrintsIncorrectFlagValueFoundErrorMessage() {
    let error = CommandError.incorrectFlagValue("debug", "Error when converting x to int")
    let e = DefaultHelpGenerator(command: git)
      .errorString(forError: error)

    XCTAssertEqual(e, "Error: wrong flag value passed for flag: \'debug\' Error when converting x to int\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug     \n  -r, --root int      (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.\n\nwrong flag value passed for flag: \'debug\' Error when converting x to int\nexit status 255")
  }

  func testItHelpInErrorCanBeReplaces() {

    struct DummyGenerator: HelpGenerator {
      let commandHelp: CommandHelp
      var errorHelpMessage: String = "This is the help"

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    git.usage = "git do this"

    let error = CommandError.incorrectFlagValue("debug", "Error when converting x to int")
    let e = DummyGenerator.init(command: git)
      .errorString(forError: error)

    XCTAssertEqual(e, "Error: wrong flag value passed for flag: \'debug\' Error when converting x to int\nThis is the help\n\nwrong flag value passed for flag: \'debug\' Error when converting x to int\nexit status 255")
  }

  func testItPrintsIncorrectFlagValueFoundErrorError() {
    let error = CommandError.incorrectFlagValue("debug", "error when converting x to bool")
    let e = DefaultHelpGenerator(command: git).errorMessage(forError: error)

    XCTAssertEqual(e, "wrong flag value passed for flag: \'debug\' error when converting x to bool")
  }

}
