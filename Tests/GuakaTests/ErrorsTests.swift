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
    let e = CommandErrors.flagNotFound("debug").errorMessage(forCommand: git)
    XCTAssertEqual(e, "Error: unknown shorthand flag: \'debug\'\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.\n\nunknown shorthand flag: \'debug\'\nexit status 255")
  }

  func testItPrintsFlagNotFoundError() {
    let e = CommandErrors.flagNotFound("debug").error
    XCTAssertEqual(e, "unknown shorthand flag: \'debug\'")
  }

  func testItPrintsIncorrectFlagValueFoundErrorMessage() {
    let e = CommandErrors.incorrectFlagValue("debug", "Error when converting x to int").errorMessage(forCommand: git)
    XCTAssertEqual(e, "Error: wrong flag value passed for flag: \'debug\' Error when converting x to int\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.\n\nwrong flag value passed for flag: \'debug\' Error when converting x to int\nexit status 255")
  }

  func testItPrintsIncorrectFlagValueFoundErrorError() {
    let e = CommandErrors.incorrectFlagValue("debug", "error when converting x to bool").error
    XCTAssertEqual(e, "wrong flag value passed for flag: \'debug\' error when converting x to bool")
  }

}
