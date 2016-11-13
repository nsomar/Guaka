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
    XCTAssertEqual(git.usageSection, ["Usage:", "  git [flags]", "  git [command]"])
    XCTAssertEqual(show.usageSection, ["Usage:", "  git remote show [flags]"])
  }

  func testItCanGenerateTheCommandsSectionWithoutUsages() {
    show.shortMessage = nil
    show.longMessage = nil
    XCTAssertEqual(git.avialbleCommandsSection, ["Available Commands:", "  rebase    ", "  remote    ", "\n"])
    XCTAssertEqual(remote.avialbleCommandsSection, ["Available Commands:", "  show    ", "\n"])
    XCTAssertEqual(show.avialbleCommandsSection, [])
  }

  func testItCanGenerateTheCommandsSectionWithshortMessages() {
    show.shortMessage = "The short usage"
    show.longMessage = nil
    XCTAssertEqual(git.avialbleCommandsSection, ["Available Commands:", "  rebase    ", "  remote    ", "\n"])
    XCTAssertEqual(remote.avialbleCommandsSection, ["Available Commands:", "  show    The short usage", "\n"])
    XCTAssertEqual(show.avialbleCommandsSection, [])
  }

  func testItGenerateTheDescriptionSectionWithoutUsage() {
    XCTAssertEqual(git.commandDescriptionSection, [])
  }

  func testItGenerateTheDescriptionSectionWithshortMessage() {
    git.shortMessage = "Short git usage"
    XCTAssertEqual(git.commandDescriptionSection, ["Short git usage", "\n\n"])
  }

  func testItGenerateTheDescriptionSectionWithlongMessage() {
    git.longMessage = "Short git usage long"
    XCTAssertEqual(git.commandDescriptionSection, ["Short git usage long", "\n\n"])
  }

  func testItGenerateTheDescriptionSectionWithLongAndshortMessage() {
    git.longMessage = "Short git usage long"
    git.shortMessage = "Short git usage"
    XCTAssertEqual(git.commandDescriptionSection, ["Short git usage long", "\n\n"])
  }

  func testItGenerateTheFlagsSection() {
    XCTAssertEqual(git.flagsSection.joined(separator: "\n"),
                   "Flags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\n")
  }

  func testItGenerateTheFullHelp() {
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.")

    XCTAssertEqual(remote.helpMessage,
                   "Usage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string   (default -)\n      --foo string   (default -)\n      --remote bool  (default true)\n      --xx bool      (default true)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"remote [command] --help\" for more information about a command.")

    show.shortMessage = "Show short usage"
    XCTAssertEqual(show.helpMessage,
                   "Show short usage\n\nUsage:\n  git remote show [flags]\n\nFlags:\n      --bar string  (default -)\n      --foo string  (default -)\n      --yy bool     (default true)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n      --remote bool   (default true)\n  -v, --verbose bool  (default false)\n\nUse \"show [command] --help\" for more information about a command.")

    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase [flags]\n\nFlags:\n  -v, --varvar bool  (default false)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItGenerateTheFullHelpEvenIfRequiredFlagsAreMissing() {
    git.add(flags: [Flag(longName: "hello", type: Int.self, required: true)])
    git.execute(commandLineArgs: expand("git -h"))
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n      --hello int     (required)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testItPrintsHelpForAliases() {
    git.aliases = ["git1", "git2"]
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAliases:\n  git, git1, git2\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.")
  }

  func testItDoesNotShowDeprecatedCommands() {
    remote.deprecationStatus = .deprecated("Dont use this")
    XCTAssertEqual(git.avialbleCommandsSection.joined(),
                   "Available Commands:  rebase    \n")
  }

  func testItPrintsCommandDeprecatedOnTopOfDeprecatedCommand() {
    remote.deprecationStatus = .deprecated("Dont use this")
    XCTAssertEqual(remote.helpMessage,
                   "Command \"remote\" is deprecated, Dont use this\nUsage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string   (default -)\n      --foo string   (default -)\n      --remote bool  (default true)\n      --xx bool      (default true)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"remote [command] --help\" for more information about a command.")
  }

  func testItFiltersOutDeprecatedFlags() {
    remote.flags[0].deprecatedStatus = .deprecated("Dont use this")
    XCTAssertEqual(remote.helpMessage,
                   "Usage:\n  git remote [flags]\n  git remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string   (default -)\n      --remote bool  (default true)\n      --xx bool      (default true)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"remote [command] --help\" for more information about a command.")
  }

  func testIfAllFlagsAreDeprecatedItDoesNotShowFlags() {
    rebase.flags[0].deprecatedStatus = .deprecated("Dont use this")
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase [flags]\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItPrintsTheExample() {
    rebase.example = "run git rebase blabla"
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase [flags]\n\nExamples:\nrun git rebase blabla\n\nFlags:\n  -v, --varvar bool  (default false)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"rebase [command] --help\" for more information about a command.")
  }

  func testItPrintsTheUsageSection() {
    rebase.usage = "rebase bla bla bla"
    XCTAssertEqual(rebase.name, "rebase")
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  git rebase bla bla bla [flags]\n\nFlags:\n  -v, --varvar bool  (default false)\n\nGlobal Flags:\n  -d, --debug bool    (default true)\n  -v, --verbose bool  (default false)\n\nUse \"rebase [command] --help\" for more information about a command.")
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
