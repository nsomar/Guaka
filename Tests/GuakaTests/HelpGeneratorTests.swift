//
//  HelpGeneratorTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

import XCTest
@testable import Guaka

class HelpGeneratorTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItGeneratesHelpSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.helpMessage, "Usage:\n  git remote show [flags]\n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --yy          \n\nGlobal Flags:\n  -d, --debug     \n      --remote    \n  -v, --verbose   \n\n")

    show.longMessage = "abcd"
    let h2 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h2.helpMessage, "abcd\n\nUsage:\n  git remote show [flags]\n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --yy          \n\nGlobal Flags:\n  -d, --debug     \n      --remote    \n  -v, --verbose   \n\n")
  }

  func testItGeneratesErrorHelpSection() {
    let h = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h.errorHelpMessage, "Usage:\n  git remote show [flags]\n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --yy          \n\nGlobal Flags:\n  -d, --debug     \n      --remote    \n  -v, --verbose   \n\n")
  }

  func testItGeneratesErrorDeprecationMessage() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.deprecationSection, nil)

    show.deprecationStatus = .deprecated("Dont use it")
    let h2 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h2.deprecationSection, "Command \"show\" is deprecated, Dont use it")
  }

  func testItGeneratesErrorDeprecationMessageWhenAlias() {
    show.deprecationStatus = .deprecated("Dont use it")
    show.aliasUsedToCallCommand = "shw"
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.deprecationSection, "Command \"shw\" is deprecated, Dont use it")
  }

  func testItGeneratesErrorUsageSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.usageSection, ["Usage:", "  git remote show [flags]", "\n"].joined(separator: "\n"))

    show.usage = "show abc"
    let h2 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h2.usageSection, ["Usage:", "  git remote show abc [flags]", "\n"].joined(separator: "\n"))

    show.usage = "show abc"
    show.aliasUsedToCallCommand = "tttt"
    let h3 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h3.usageSection, ["Usage:", "  git remote tttt abc [flags]", "\n"].joined(separator: "\n"))
  }

  func testItGeneratesAliasesSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.aliasesSection, "")

    show.aliases = ["1", "2"]
    let h2 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h2.aliasesSection, ["Aliases:", "  show, 1, 2", "\n"].joined(separator: "\n"))
  }

  func testItGeneratesExampleSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.exampleSection, "")

    show.example = "Example"
    let h2 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h2.exampleSection, ["Examples:", "Example", "\n"].joined(separator: "\n"))
  }

  func testItGeneratesCommandsSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.subCommandsSection, "")

    let h2 = DefaultHelpGenerator(command: git)
    XCTAssertEqual(h2.subCommandsSection, ["Available Commands:", "  rebase  ", "  remote  ", "\n"].joined(separator: "\n"))
  }

  func testItGeneratesFlagsSection() {
    git.flags = []
    let h1 = DefaultHelpGenerator(command: git)
    XCTAssertEqual(h1.flagsSection, "")

    let h2 = DefaultHelpGenerator(command: remote)
    XCTAssertEqual(h2.flagsSection, "Flags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\n")

    show.flags = []
    let h3 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h3.flagsSection, "Global Flags:\n      --foo string  (default -)\n      --remote      \n\n")
  }

  func testItGeneratesCommandsDescriptionSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h1.commandDescriptionSection, "")

    show.shortMessage = "Short Message"
    let h2 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h2.commandDescriptionSection, ["Short Message", "\n"].joined(separator: "\n"))

    show.longMessage = "Long Message"
    let h3 = DefaultHelpGenerator(command: show)
    XCTAssertEqual(h3.commandDescriptionSection, ["Long Message", "\n"].joined(separator: "\n"))
  }

  func testItGeneratesInformationSection() {
    let h1 = DefaultHelpGenerator(command: show)
    XCTAssertNil(h1.informationSection)
    let h2 = DefaultHelpGenerator(command: git)
    XCTAssertEqual(h2.informationSection, ["Use \"git [command] --help\" for more information about a command."].joined(separator: "\n"))
  }

  func testItGeneratesFlagDeprecationMessage() {
    var f = Flag(longName: "abcd", value: 1, description: "")
    f.deprecationStatus = .deprecated("deprecated")
    let h1 = DefaultHelpGenerator(command: show)

    XCTAssertEqual(h1.deprecationMessage(forDeprecatedFlag: FlagHelp(flag: f)) , "Flag --abcd has been deprecated, deprecated")
  }

}
