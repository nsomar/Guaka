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

  func testItCanExecuteShowCommand() {
    //git.execute
    try! git.execute(commandLineArgs: expand("git remote show --yy"))
    
    XCTAssertEqual(show.executed?.0.count, 6)
    XCTAssertEqual(show.executed?.0["yy"]?.value as? Bool, true)
    XCTAssertEqual(show.executed?.0["debug"]?.value as? Bool, true)
    XCTAssertEqual(show.executed?.0["verbose"]?.value as? Bool, false)
    XCTAssertEqual(show.executed?.0["foo"]?.value as? String, "-")
    XCTAssertEqual(show.executed?.0["remote"]?.value as? Bool, true)
    XCTAssertEqual(show.executed?.0["bar"]?.value as? String, "-")
    
    XCTAssertEqual((show.executed?.1)!, [])
  }
  
  func testItCanExecuteShowCommandWithArgs() {
    //git.execute
    try! git.execute(commandLineArgs: expand("git remote show --yy aaaa bbbb cccc"))
    
    XCTAssertEqual(show.executed?.0.count, 6)
    
    XCTAssertEqual((show.executed?.1)!, ["aaaa", "bbbb", "cccc"])
  }
  
  func testItCanExecuteRemoteCommand() {
    //git.execute
    try! git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123"))
    
    XCTAssertEqual(remote.executed?.0.count, 6)
    XCTAssertEqual(remote.executed?.0["xx"]?.value as? Bool, true)
    XCTAssertEqual(remote.executed?.0["debug"]?.value as? Bool, true)
    XCTAssertEqual(remote.executed?.0["verbose"]?.value as? Bool, false)
    XCTAssertEqual(remote.executed?.0["foo"]?.value as? String, "show")
    XCTAssertEqual(remote.executed?.0["remote"]?.value as? Bool, true)
    XCTAssertEqual(remote.executed?.0["bar"]?.value as? String, "123")
    
    XCTAssertEqual((remote.executed?.1)!, [])
  }
  
  func testItCatchesExceptionsInExecution() {
    //git.execute
    do {
      try git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 --www 123"))
      XCTFail()
    } catch let CommandErrors.flagNotFound(x) {
      XCTAssertEqual(x, "www")
    } catch {
      print(error)
    }
  }
  
}

