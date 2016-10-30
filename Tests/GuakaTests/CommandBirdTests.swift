//
//  ArgTokenTypeTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import Guaka

class CommandBirdTests: XCTestCase {

  func testItCanGetACommandWithMultipleArguments() {
    let (command, args) = stripFlags(command: git, args: ["-vd1", "-v", "--bar", "1", "remote", "--foo", "222", "show"])
    
    XCTAssertEqual(command.name, "show")
    XCTAssertEqual(args, ["-vd1", "-v", "--bar", "1", "--foo", "222"])
  }
  
  func testItCanGetACommand1() {
    let (command, args) = stripFlags(command: git, args: ["-vd1", "-v", "--bar", "1", "remote", "--foo", "show"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["-vd1", "-v", "--bar", "1", "--foo", "show"])
  }
  
  func testItCanGetACommand2() {
    let (command, args) = stripFlags(command: git, args: ["-vd1", "-v", "--bar", "remote"])
    
    XCTAssertEqual(command.name, "git")
    XCTAssertEqual(args, ["-vd1", "-v", "--bar", "remote"])
  }
  
  func testItCanGetACommand3() {
    let (command, args) = stripFlags(command: git, args: ["-v", "-w", "remote"])
    
    XCTAssertEqual(command.name, "git")
    XCTAssertEqual(args, ["-v", "-w", "remote"])
  }
  
  func testItCanGetACommand4() {
    let (command, args) = stripFlags(command: git, args: ["-v", "-w", "1", "remote"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["-v", "-w", "1"])
  }
  
  func testItCanGetACommand5() {
    let (command, args) = stripFlags(command: git, args: ["-v", "-t", "remote"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["-v", "-t"])
  }
  
  func testItCanGetACommand6() {
    let (command, args) = stripFlags(command: git, args: ["remote", "--xx"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--xx"])
  }
  
  func testItCanGetACommand7() {
    let (command, args) = stripFlags(command: git, args: ["--xx", "remote"])
    
    XCTAssertEqual(command.name, "git")
    XCTAssertEqual(args, ["--xx", "remote"])
  }
  
  func testItCanGetACommand8() {
    let (command, args) = stripFlags(command: git, args: ["--xx=1", "remote"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--xx=1"])
  }
  
  func testItCanGetACommand9() {
    let (command, args) = stripFlags(command: git, args: ["--bar", "1", "remote"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--bar", "1"])
  }
  
  func testItCanGetACommand10() {
    let (command, args) = stripFlags(command: git, args: ["remote", "--bar", "1"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--bar", "1"])
  }
  
  func testItCanGetACommand11() {
    let (command, args) = stripFlags(command: git, args: ["--xx", "first", "remote", "second"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--xx", "first", "second"])
  }
  
  func testItCanGetACommand12() {
    let (command, args) = stripFlags(command: git, args: ["remote", "--yy", "show"])
    
    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--yy", "show"])
  }
  
  func testItCanGetACommand13() {
    let (command, args) = stripFlags(command: git, args: ["remote", "show", "--yy"])
    
    XCTAssertEqual(command.name, "show")
    XCTAssertEqual(args, ["--yy"])
  }
  
  var git: Command!
  var show: Command!
  var remote: Command!
  var rebase: Command!
  
  override func setUp() {
    show = try! Command(
      name: "show",
      flags: [
        Flag(longName: "foo", defaultValue: "-", inheritable: false),
        Flag(longName: "bar", defaultValue: "-", inheritable: false),
        Flag(longName: "yy", defaultValue: true, inheritable: false),
        ],
      commands: [],
      run: { flags, args in
        
    })
    
    remote = try! Command(
      name: "remote",
      flags: [
        Flag(longName: "foo", defaultValue: "-", inheritable: true),
        Flag(longName: "remote", defaultValue: true, inheritable: true),
        Flag(longName: "bar", defaultValue: "-", inheritable: false),
        Flag(longName: "xx", defaultValue: true, inheritable: false),
        ],
      commands: [show],
      run: { flags, args in
        
    })
    
    rebase = try! Command(
      name: "rebase",
      flags: [
        Flag(longName: "varvar", defaultValue: false, shortName: "v", inheritable: true),
        ],
      commands: [],
      run: { flags, args in
        
    })
    
    git = try! Command(
      name: "git",
      flags: [
        Flag(longName: "debug", defaultValue: true, shortName: "d", inheritable: true),
        Flag(longName: "verbose", defaultValue: false, shortName: "v", inheritable: true),
        Flag(longName: "togge", defaultValue: false, shortName: "t", inheritable: false),
        Flag(longName: "root", defaultValue: 1, shortName: "r", inheritable: false),
        ],
      commands: [rebase, remote],
      run: { flags, args in
        
    })
  }
  
}
