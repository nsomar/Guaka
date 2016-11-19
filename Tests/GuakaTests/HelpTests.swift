//
//  HelpTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 04/11/2016.
//
//

import XCTest
@testable import Guaka

class HelpTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
    git.shortMessage = nil
    git.longMessage = nil
  }

  func testItCanGenerateTheUsageMessage() {
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.usageSection, ["Usage:", "  git [flags]", "  git [command]", "\n"].joined(separator: "\n"))

    let hs = DefaultHelpGenerator(command: show)
    XCTAssertEqual(hs.usageSection, ["Usage:", "  git remote show [flags]", "\n"].joined(separator: "\n"))
  }

  func testItCanGenerateTheCommandsSectionWithoutUsages() {
    show.shortMessage = nil
    show.longMessage = nil

    let hg = DefaultHelpGenerator(command: git)
    let hr = DefaultHelpGenerator(command: remote)
    let hs = DefaultHelpGenerator(command: show)

    XCTAssertEqual(hg.subCommandsSection, ["Available Commands:", "  rebase    ", "  remote    ", "\n"].joined(separator: "\n"))
    XCTAssertEqual(hr.subCommandsSection, ["Available Commands:", "  show    ", "\n"].joined(separator: "\n"))
    XCTAssertEqual(hs.subCommandsSection, "")
  }

  func testItCanGenerateTheCommandsSectionWithshortMessages() {
    show.shortMessage = "The short usage"
    show.longMessage = nil

    let hg = DefaultHelpGenerator(command: git)
    let hs = DefaultHelpGenerator(command: show)
    let hr = DefaultHelpGenerator(command: remote)

    XCTAssertEqual(hg.subCommandsSection, ["Available Commands:", "  rebase    ", "  remote    ", "\n"].joined(separator: "\n"))
    XCTAssertEqual(hr.subCommandsSection, ["Available Commands:", "  show    The short usage", "\n"].joined(separator: "\n"))
    XCTAssertEqual(hs.subCommandsSection, "")
  }

  func testItGenerateTheDescriptionSectionWithoutUsage() {
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.commandDescriptionSection, "")
  }

  func testItGenerateTheDescriptionSectionWithshortMessage() {
    git.shortMessage = "Short git usage"
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.commandDescriptionSection, ["Short git usage", "\n"].joined(separator: "\n"))
  }

  func testItGenerateTheDescriptionSectionWithlongMessage() {
    git.longMessage = "Short git usage long"
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.commandDescriptionSection, ["Short git usage long", "\n"].joined(separator: "\n"))
  }

  func testItGenerateTheDescriptionSectionWithLongAndshortMessage() {
    git.longMessage = "Short git usage long"
    git.shortMessage = "Short git usage"
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.commandDescriptionSection, ["Short git usage long", "\n"].joined(separator: "\n"))
  }

  func testItGenerateTheFlagsSection() {
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.flagsSection,
                   "Flags:\n  -d, --debug     \n  -r, --root int      (default 1)\n  -t, --togge     \n  -v, --verbose   \n\n")
  }

  func testItGenerateTheFullHelp() {
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")

    XCTAssertEqual(remote.helpMessage,
                   "Usage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"remote [command] --help\" for more information about a command.")

    show.shortMessage = "Show short usage"
    XCTAssertEqual(show.helpMessage,
                   "Show short usage\n\nUsage:\n  git remote show [flags]\n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --yy          \n\nGlobal Flags:\n  -d, --debug     \n      --remote    \n  -v, --verbose   \n\nUse \"show [command] --help\" for more information about a command.")

    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase [flags]\n\nFlags:\n  -v, --varvar   \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItGenerateTheFullHelpEvenIfRequiredFlagsAreMissing() {
    git.add(flags: [Flag(longName: "hello", type: Int.self, required: true)])
    git.execute(commandLineArgs: expand("git -h"))
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug      \n      --hello int  (required)\n  -r, --root int   (default 1)\n  -t, --togge      \n  -v, --verbose    \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testItPrintsHelpForAliases() {
    git.aliases = ["git1", "git2"]
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAliases:\n  git, git1, git2\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug     \n  -r, --root int  (default 1)\n  -t, --togge     \n  -v, --verbose   \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testItDoesNotShowDeprecatedCommands() {
    remote.deprecationStatus = .deprecated("Dont use this")
    let hg = DefaultHelpGenerator(command: git)
    XCTAssertEqual(hg.subCommandsSection,
                   "Available Commands:\n  rebase    \n\n")
  }

  func testItPrintsCommandDeprecatedOnTopOfDeprecatedCommand() {
    remote.deprecationStatus = .deprecated("Dont use this")
    XCTAssertEqual(remote.helpMessage,
                   "Command \"remote\" is deprecated, Dont use this\nUsage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"remote [command] --help\" for more information about a command.")
  }

  func testItFiltersOutDeprecatedFlags() {
    remote.flags[0].deprecationStatus = .deprecated("Dont use this")
    XCTAssertEqual(remote.helpMessage,
                   "Usage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string  (default -)\n      --remote      \n      --xx          \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"remote [command] --help\" for more information about a command.")
  }

  func testIfAllFlagsAreDeprecatedItDoesNotShowFlags() {
    rebase.flags[0].deprecationStatus = .deprecated("Dont use this")
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase [flags]\n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItPrintsTheExample() {
    rebase.example = "run git rebase blabla"
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase [flags]\n\nExamples:\nrun git rebase blabla\n\nFlags:\n  -v, --varvar   \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItPrintsTheUsageSection() {
    rebase.usage = "rebase bla bla bla"
    XCTAssertEqual(rebase.name, "rebase")
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase bla bla bla [flags]\n\nFlags:\n  -v, --varvar   \n\nGlobal Flags:\n  -d, --debug     \n  -v, --verbose   \n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItDoesNotPrintFlagsIfCommandHaveZeroFlags() {
    git.flags = []
    git.usage = "git do this"
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git do this\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testNoFlagsNoCommands() {
    git.flags = []
    git.commands = []
    git.usage = "git do this"
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git do this\n\nUse \"git [command] --help\" for more information about a command.")
  }
}
