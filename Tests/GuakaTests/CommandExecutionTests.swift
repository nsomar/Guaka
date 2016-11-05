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
    git.execute(commandLineArgs: expand("git remote show --yy"))
    
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
    git.execute(commandLineArgs: expand("git remote show --yy aaaa bbbb cccc"))
    
    XCTAssertEqual(show.executed?.0.count, 6)
    
    XCTAssertEqual((show.executed?.1)!, ["aaaa", "bbbb", "cccc"])
  }
  
  func testItCanExecuteRemoteCommand() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123"))
    
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
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 --www 123"))
    XCTAssertEqual(git.printed, "Error: unknown shorthand flag: \'www\'\nUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  remote    \n  rebase    \n\nFlags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.\n\nunknown shorthand flag: \'www\'\nexit status 255")
  }
  
  func testItCatchesTheHelp() {
    //git.execute
    git.execute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(git.printed, "Usage:\n  remote [flags]\n  remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string    (default -)\n  -d, --debug bool    (default true)\n      --foo string    (default -)\n      --remote bool   (default true)\n  -v, --verbose bool  (default false)\n      --xx bool       (default true)\n\nUse \"remote [command] --help\" for more information about a command.")
  }
  
  func testItCanGetCommandToExecute() {
    //git.execute
    let c1 = git.commandToExecute(commandLineArgs: expand("git remote --foo show --xx --bar=123 -h"))
    XCTAssertEqual(c1.name, "remote")
    
    let c2 = git.commandToExecute(commandLineArgs: expand("git remote show --xx --bar=123 -h"))
    XCTAssertEqual(c2.name, "show")
  }
  
}

