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
    git.add(subCommands: [show])
    XCTAssertEqual(git.commands.count, 3)
  }

  func testItCanAddCommandsThroughParent() {
    XCTAssertEqual(git.commands.count, 2)
    show.parent = git
    XCTAssertEqual(git.commands.count, 3)
  }

  func testItCanRemoveACommands() {
    XCTAssertEqual(git.commands.count, 2)
    git.removeCommand { $0.usage == "remote" }
    XCTAssertEqual(git.commands.count, 1)
  }

  func testItCanAddFlags() {
    XCTAssertEqual(git.flags.count, 4)
    git.add(flag: Flag(longName: "new", type: Int.self, description: ""))
    XCTAssertEqual(git.flags.count, 5)
  }

  func testItCanAddMultipleFlags() {
    XCTAssertEqual(git.flags.count, 4)
    git.add(flags: [Flag(longName: "new1", type: Int.self, description: ""), Flag(longName: "new2", type: Int.self, description: "")])
    XCTAssertEqual(git.flags.count, 6)
  }

  func testItCanRemoveAFlag() {
    XCTAssertEqual(git.flags.count, 4)
    git.removeFlag { $0.longName == "verbose" }
    XCTAssertEqual(git.flags.count, 3)
  }

  func testItGetsNameForUsage() {
    XCTAssertEqual(try! Command.name(forUsage: "git"), "git")
    XCTAssertEqual(try! Command.name(forUsage: "git show/ab/c"), "git")
    XCTAssertEqual(try! Command.name(forUsage: "show this and that"), "show")
  }

  func testItThrowsErrorForWrongUsage() {
//    let c = Command(
    do {
      _ = try Command.name(forUsage: " git")
      XCTFail()
    } catch CommandError.wrongCommandUsageString { } catch {
      XCTFail()
    }

    do {
      _ = try Command.name(forUsage: "")
      XCTFail()
    } catch CommandError.wrongCommandUsageString { } catch {
      XCTFail()
    }

    do {
      _ = try Command.name(forUsage: "a/b")
      XCTFail()
    } catch CommandError.wrongCommandUsageString { } catch {
      XCTFail()
    }

    do {
      _ = try Command.name(forUsage: "- show it")
      XCTFail()
    } catch CommandError.wrongCommandUsageString { } catch {
      XCTFail()
    }

  }

  func testItCanBeInitializedWith3Params() {

    class flag {
      public init(usage: String,
                  shortMessage: String? = nil,
                  longMessage: String? = nil,
                  flags: [Flag],
                  example: String? = nil,
                  parent: Command? = nil,
                  aliases: [String] = [],
                  deprecationStatus: DeprecationStatus = .notDeprecated,
                  run: Run? = nil) throws{
      }

      public init(usage: String,
                  shortMessage: String,
                  flags: [Flag] = [],
                  run: Run?) throws {}

      public init(usage: String,
                  configuration: Configuration?,
                  run: Run?) {}
    }
  }
  
}
