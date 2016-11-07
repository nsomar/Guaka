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
    git.shortUsage = nil
    git.longUsage = nil
  }
  
  func testItCanGenerateTheUsageMessage() {
    XCTAssertEqual(git.usageSection, ["Usage:", "  git [flags]", "  git [command]"])
    XCTAssertEqual(show.usageSection, ["Usage:", "  show [flags]", "  show [command]"])
  }
  
  func testItCanGenerateTheCommandsSectionWithoutUsages() {
    show.shortUsage = nil
    show.longUsage = nil
    XCTAssertEqual(git.avialbleCommandsSection, ["Available Commands:", "  rebase    ", "  remote    ", "\n"])
    XCTAssertEqual(remote.avialbleCommandsSection, ["Available Commands:", "  show    ", "\n"])
    XCTAssertEqual(show.avialbleCommandsSection, [])
  }
  
  func testItCanGenerateTheCommandsSectionWithShortUsages() {
    show.shortUsage = "The short usage"
    show.longUsage = nil
    XCTAssertEqual(git.avialbleCommandsSection, ["Available Commands:", "  rebase    ", "  remote    ", "\n"])
    XCTAssertEqual(remote.avialbleCommandsSection, ["Available Commands:", "  show    The short usage", "\n"])
    XCTAssertEqual(show.avialbleCommandsSection, [])
  }
  
  func testItGenerateTheDescriptionSectionWithoutUsage() {
    XCTAssertEqual(git.commandDescriptionSection, [])
  }
  
  func testItGenerateTheDescriptionSectionWithShortUsage() {
    git.shortUsage = "Short git usage"
    XCTAssertEqual(git.commandDescriptionSection, ["Short git usage", "\n\n"])
  }
  
  func testItGenerateTheDescriptionSectionWithLongUsage() {
    git.longUsage = "Short git usage long"
    XCTAssertEqual(git.commandDescriptionSection, ["Short git usage long", "\n\n"])
  }
  
  func testItGenerateTheDescriptionSectionWithLongAndShortUsage() {
    git.longUsage = "Short git usage long"
    git.shortUsage = "Short git usage"
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
                   "Usage:\n  remote [flags]\n  remote [command]\n\nAvailable Commands:\n  show    \n\nFlags:\n      --bar string    (default -)\n  -d, --debug bool    (default true)\n      --foo string    (default -)\n      --remote bool   (default true)\n  -v, --verbose bool  (default false)\n      --xx bool       (default true)\n\nUse \"remote [command] --help\" for more information about a command.")
    
    show.shortUsage = "Show short usage"
    XCTAssertEqual(show.helpMessage,
                   "Show short usage\n\nUsage:\n  show [flags]\n  show [command]\n\nFlags:\n      --bar string    (default -)\n  -d, --debug bool    (default true)\n      --foo string    (default -)\n      --remote bool   (default true)\n  -v, --verbose bool  (default false)\n      --yy bool       (default true)\n\nUse \"show [command] --help\" for more information about a command.")
    
    XCTAssertEqual(rebase.helpMessage,
                   "Usage:\n  rebase [flags]\n  rebase [command]\n\nFlags:\n  -d, --debug bool    (default true)\n  -v, --varvar bool   (default false)\n  -v, --verbose bool  (default false)\n\nUse \"rebase [command] --help\" for more information about a command.")
  }
  
  func testItGenerateTheFullHelpEvenIfRequiredFlagsAreMissing() {
    git.add(flags: Flag(longName: "hello", type: Int.self, required: true))
    git.execute(commandLineArgs: expand("git -h"))
    XCTAssertEqual(git.helpMessage,
                   "Usage:\n  git [flags]\n  git [command]\n\nAvailable Commands:\n  rebase    \n  remote    \n\nFlags:\n  -d, --debug bool    (default true)\n      --hello int     (required)\n  -r, --root int      (default 1)\n  -t, --togge bool    (default false)\n  -v, --verbose bool  (default false)\n\nUse \"git [command] --help\" for more information about a command.")
  }
}
