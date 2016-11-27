//
//  ArgTokenTypeTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import Guaka

class CommandParsingTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItCanGetACommandWithMultipleArguments() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["-vd1", "-v", "--bar", "1", "remote", "--foo", "222", "show"])

    XCTAssertEqual(command.name, "show")
    XCTAssertEqual(args, ["-vd1", "-v", "--bar", "1", "--foo", "222"])
  }

  func testItCanGetACommand1() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["-vd1", "-v", "--bar", "1", "remote", "--foo", "show"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["-vd1", "-v", "--bar", "1", "--foo", "show"])
  }

  func testItCanGetACommand2() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["-vd1", "-v", "--bar", "remote"])

    XCTAssertEqual(command.name, "git")
    XCTAssertEqual(args, ["-vd1", "-v", "--bar", "remote"])
  }

  func testItCanGetACommand3() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["-v", "-w", "remote"])

    XCTAssertEqual(command.name, "git")
    XCTAssertEqual(args, ["-v", "-w", "remote"])
  }

  func testItCanGetACommand4() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["-v", "-w", "1", "remote"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["-v", "-w", "1"])
  }

  func testItCanGetACommand5() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["-v", "-t", "remote"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["-v", "-t"])
  }

  func testItCanGetACommand6() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["remote", "--xx"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--xx"])
  }

  func testItCanGetACommand7() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["--xx", "remote"])

    XCTAssertEqual(command.name, "git")
    XCTAssertEqual(args, ["--xx", "remote"])
  }

  func testItCanGetACommand8() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["--xx=1", "remote"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--xx=1"])
  }

  func testItCanGetACommand9() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["--bar", "1", "remote"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--bar", "1"])
  }

  func testItCanGetACommand10() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["remote", "--bar", "1"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--bar", "1"])
  }

  func testItCanGetACommand11() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["--xx", "first", "remote", "second"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--xx", "first", "second"])
  }

  func testItCanGetACommand12() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["remote", "--yy", "show"])

    XCTAssertEqual(command.name, "remote")
    XCTAssertEqual(args, ["--yy", "show"])
  }

  func testItCanGetACommand13() {
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["remote", "show", "--yy"])

    XCTAssertEqual(command.name, "show")
    XCTAssertEqual(args, ["--yy"])
  }

  func testItCanGetACommandEvenIfUsageIsLong() {
    show.usage = "show bla bla"
    let (command, args) = actualCommand(forCommand: git,
                                        arguments: ["remote", "show", "--yy"])
    
    XCTAssertEqual(command.name, "show")
    XCTAssertEqual(args, ["--yy"])
  }
  
}
