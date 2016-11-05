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
  
  func testItPrintsAnErrorMessage() {
    let e = CommandErrors.flagNotFound("debug").errorMessage(forCommand: git)
    XCTAssertEqual(e, "Error: unknown shorthand flag: \'debug\'\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  remote    \n  rebase    \n\nFlags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.\n\nunknown shorthand flag: \'debug\'\nexit status 255")
  }
  
}
