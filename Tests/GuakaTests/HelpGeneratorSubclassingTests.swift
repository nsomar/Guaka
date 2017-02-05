//
//  HelpGeneratorSubclassingTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

import XCTest
import Foundation
@testable import Guaka


class HelpGeneratorSubclassingTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testCanOverrideDeprecationSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var deprecationSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    git.deprecationStatus = .deprecated("abc")
    var h = DummyHelp(command: git)
    h.deprecationSection = "abcdefg\n"

    XCTAssertEqual(h.helpMessage.contains("abcdefg\n\nUsage:\n  git [flags]"), true)
  }

  func testCanOverrideUsageSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var usageSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.usageSection = "use it like this"

    XCTAssertEqual(h.helpMessage, "use it like thisAvailable Commands:\n  rebase  \n  remote  \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testCanOverrideAliasSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var aliasesSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    git.aliases = ["1", "2"]
    var h = DummyHelp(command: git)
    h.aliasesSection = "aliases are 1 2 3"

    XCTAssertEqual(h.helpMessage, "Usage:\n  git [flags]\n  git [command]\n\naliases are 1 2 3Available Commands:\n  rebase  \n  remote  \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testCanOverrideExampleSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var exampleSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    git.example = "1234"
    var h = DummyHelp(command: git)
    h.exampleSection = "This is the example"

    XCTAssertEqual(h.helpMessage, "Usage:\n  git [flags]\n  git [command]\n\nThis is the exampleAvailable Commands:\n  rebase  \n  remote  \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testCanOverrideCommandsSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var subCommandsSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.subCommandsSection = "This is the subcommands section"

    XCTAssertEqual(h.helpMessage, "Usage:\n  git [flags]\n  git [command]\n\nThis is the subcommands sectionFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testCanOverrideFlagsSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var flagsSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.flagsSection = "This is the flags section"

    XCTAssertEqual(h.helpMessage, "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase  \n  remote  \n\nThis is the flags sectionUse \"git [command] --help\" for more information about a command.")
  }

  func testCanOverrideCommandDescriptionSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var commandDescriptionSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.commandDescriptionSection = "This is the command description section"

    XCTAssertEqual(h.helpMessage, "This is the command description sectionUsage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase  \n  remote  \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testCanOverrideInformationSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var informationSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.informationSection = "This is the info section"

    XCTAssertEqual(h.helpMessage, "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase  \n  remote  \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nThis is the info section")
  }

  func testCanOverrideHelpSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var helpMessage: String = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.helpMessage = "HELP!!!"

    XCTAssertEqual(h.helpMessage.contains("HELP!!!"), true)
  }

  func testCanOverrideErrorSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var errorHelpMessage: String = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    var h = DummyHelp(command: git)
    h.errorHelpMessage = "ERROR"

    XCTAssertEqual(h.errorHelpMessage.contains("ERROR"), true)
  }

  func testCanOverrideFlagDeprecation() {
    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp

      func deprecationMessage(forDeprecatedFlag flag: FlagHelp) -> String? {
        return "Flag is wrong \(flag.longName)"
      }

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    GuakaConfig.helpGenerator = DummyHelp.self
    remote.flags[0].deprecationStatus = .deprecated("Dont use it")
    git.execute(commandLineArgs: expand("git remote --foo 123"))

    XCTAssertEqual(remote.printed, "Flag is wrong foo")
    GuakaConfig.helpGenerator = DefaultHelpGenerator.self
  }

  func testCanOverrideAllSection() {

    struct DummyHelp: HelpGenerator {
      let commandHelp: CommandHelp
      var deprecationSection: String? = ""
      var usageSection: String? = ""
      var aliasesSection: String? = ""
      var exampleSection: String? = ""
      var subCommandsSection: String? = ""
      var flagsSection: String? = ""
      var commandDescriptionSection: String? = ""
      var informationSection: String? = ""

      init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
      }
    }

    git.deprecationStatus = .deprecated("Deprecated")
    git.aliases = ["1", "2"]
    git.example = "Example is this"

    var h = DummyHelp(command: git)

    h.deprecationSection = "I am deprecate\n"
    h.usageSection = "Use it like this\n"
    h.aliasesSection = "I have aliases\n"
    h.exampleSection = "And an example\n"
    h.subCommandsSection = "The subcommands\n"
    h.flagsSection = "Some flags\n"
    h.commandDescriptionSection = "Descriptions\n"
    h.informationSection = "Informations\n"


    XCTAssertEqual(h.helpMessage, "I am deprecate\n\nDescriptions\nUse it like this\nI have aliases\nAnd an example\nThe subcommands\nSome flags\nInformations\n")
  }
}

