//
//  CommandHelpTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

import XCTest
@testable import Guaka

class CommandHelpTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItCreatesACommandHelpFromACommandWithName() {
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.name, "show")
    XCTAssertEqual(ch.usage, "show")
    XCTAssertEqual(ch.aliases, [])
  }

  func testItCreatesACommandHelpFromACommandWithAliases() {
    show.aliases = ["1", "2"]
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.aliases, ["1", "2"])
  }

  func testItCreatesACommandHelpFromACommandWithDeprecated() {
    show.deprecationStatus = .deprecated("Depricated")
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.deprecationMessage, "Depricated")
    XCTAssertEqual(ch.isDeprecated , true)
  }

  func testItCreatesACommandHelpFromACommandWithExample() {
    show.example = "example"
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.example, "example")
    XCTAssertEqual(ch.hasExample, true)
  }

  func testItCreatesACommandHelpFromACommandWithNoSubCommands() {

    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.subCommands.count, 0)
  }

  func testItCreatesACommandHelpFromACommandWithNoDescriptions() {

    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.longDescriptionMessage, nil)
    XCTAssertEqual(ch.shortDescriptionMessage, nil)
  }


  func testItCreatesACommandHelpFromACommandWithDescriptions() {

    show.shortMessage = "short"
    show.longMessage = "long"
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.shortDescriptionMessage, "short")
    XCTAssertEqual(ch.longDescriptionMessage, "long")
  }

  func testItCreatesACommandHelpFromACommandWithSubCommands() {
    let ch = CommandHelp(command: remote)

    XCTAssertEqual(ch.subCommands[0].name, "show")
  }

  func testCommandThatHasGlobalFlags() {
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.globalFlags.count, 3)
    XCTAssertEqual(ch.globalFlags.map({ $0.longName }), ["debug", "remote", "verbose"])
  }

  func testCommandThatHasLocalFlags() {
    let ch = CommandHelp(command: show)

    XCTAssertEqual(ch.localFlags.count, 3)
    XCTAssertEqual(ch.localFlags.map({ $0.longName }), ["bar", "foo", "yy"])
  }

  func testGeneratesFullName() {
    XCTAssertEqual(CommandHelp(command: show).fullName, "git remote show")
    XCTAssertEqual(CommandHelp(command: remote).fullName, "git remote")
    XCTAssertEqual(CommandHelp(command: git).fullName, "git")
  }

  func testGeneratesFullUsage() {
    XCTAssertEqual(CommandHelp(command: show).fullUsage, "git remote show")
    XCTAssertEqual(CommandHelp(command: remote).fullUsage, "git remote")
    XCTAssertEqual(CommandHelp(command: git).fullUsage, "git")
  }

  func testGeneratesFullUsageForCommandsWithUsage() {
    show.usage = "show abcd"
    XCTAssertEqual(CommandHelp(command: show).fullUsage, "git remote show abcd")
  }
  
}
