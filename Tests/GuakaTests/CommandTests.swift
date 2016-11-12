//
//  CommandTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import XCTest
@testable import Guaka

class CommandTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItCanAddCommands() {
    XCTAssertEqual(git.commands.count, 2)
    git.add(subCommands: show)
    XCTAssertEqual(git.commands.count, 3)
  }

  func testItCanAddCommandsThroughParent() {
    XCTAssertEqual(git.commands.count, 2)
    show.parent = git
    XCTAssertEqual(git.commands.count, 3)
  }

  func testItCanRemoveACommands() {
    XCTAssertEqual(git.commands.count, 2)
    git.removeCommand { $0.name == "remote" }
    XCTAssertEqual(git.commands.count, 1)
  }

  func testItCanAddFlags() {
    XCTAssertEqual(git.flags.count, 4)
    git.add(flag: Flag(longName: "--new", type: Int.self))
    XCTAssertEqual(git.flags.count, 5)
  }

  func testItCanAddMultipleFlags() {
    XCTAssertEqual(git.flags.count, 4)
    git.add(flags: [Flag(longName: "--new1", type: Int.self), Flag(longName: "--new2", type: Int.self)])
    XCTAssertEqual(git.flags.count, 6)
  }

  func testItCanRemoveAFlag() {
    XCTAssertEqual(git.flags.count, 4)
    git.removeFlag { $0.longName == "verbose" }
    XCTAssertEqual(git.flags.count, 3)
  }
  
}
