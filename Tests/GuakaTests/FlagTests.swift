//
//  FlagTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import XCTest
@testable import Guaka

class FlagTests: XCTestCase {

  func testItGeneratesAPrintableNameWithLongNameAndDescription() {
    let f = Flag(longName: "debug", value: 1, description: "Here is a desc")
    let s = FlagHelpGeneratorUtils.flagPrintableName(flag: FlagHelp(flag: f))

    XCTAssertEqual(s, "      --debug int")
  }

  func testItGeneratesAPrintableNameWithLongNameAndDescriptionAndShortName() {
    let f = Flag(shortName: "d", longName: "debug", value: 1, description: "Here is a desc")

    let s = FlagHelpGeneratorUtils.flagPrintableName(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "  -d, --debug int")
  }

  func testItGeneratesAPrintableNameForRequiredFlagsWithtoutDesc() {
    let f = Flag(longName: "debug", type: Int.self, description: "", required: true)

    let s = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "(required)")
  }

  func testItGeneratesAPrintableNameForRequiredFlagsWithDesc() {
    let f = Flag(longName: "debug", type: Int.self, description: "Here is a desc", required: true)

    let s = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "Here is a desc (required)")
  }

  func testItGeneratesAPrintableNameForNonRequiredFlagsWithDesc() {
    let f = Flag(longName: "debug", type: Int.self, description: "Here is a desc", required: false)

    let s = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "Here is a desc ")
  }

  func testItGeneratesAPrintableDescription() {
    let f1 = Flag(shortName: "d", longName: "debug", value: 1, description: "Here is a desc")

    let s1 = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f1))
    XCTAssertEqual(s1, "Here is a desc (default 1)")

    let f2 = Flag(shortName: "d", longName: "debug", value: true, description: "Here is a desc")

    let s2 = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f2))
    XCTAssertEqual(s2, "Here is a desc ")

    let f3 = Flag(shortName: "d", longName: "debug", value: "hello", description: "")

    let s3 = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f3))
    XCTAssertEqual(s3, "(default hello)")
  }

  func testItCanPrintAFlagTable1ForLocalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        Flag(shortName: "d", longName: "toggle", value: "", description: ""),
        ]
    )

    let flags = CommandHelp.flags(forFlagSet: fs, flags: [])
    let description = FlagHelpGeneratorUtils.description(forFlags: flags.global)

    XCTAssertEqual(description
      , "  -d, --debug          Here is a desc \n  -d, --toggle string  (default )\n      --verbose int    Here is a desc (default 1)")
  }

  func testItCanPrintAFlagTable2ForLocalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debugxxxxxxxxxxx", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: ""),
        Flag(shortName: "d", longName: "xxx", value: "123", description: "Here is a desc"),
        ]
    )

    let flags = CommandHelp.flags(forFlagSet: fs, flags: [])
    let description = FlagHelpGeneratorUtils.description(forFlags: flags.global)

    XCTAssertEqual(description
      , "  -d, --debugxxxxxxxxxxx   Here is a desc \n      --verbose int        (default 1)\n  -d, --xxx string         Here is a desc (default 123)")
  }

  func testItCanPrintAFlagTableWithRequiredFlags() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        Flag(longName: "toggle", type: Int.self, description: "", required: true),
        ]
    )

    let flags = CommandHelp.flags(forFlagSet: fs, flags: [])
    let description = FlagHelpGeneratorUtils.description(forFlags: flags.global)

    XCTAssertEqual(description
      , "  -d, --debug        Here is a desc \n      --toggle int   (required)\n      --verbose int  Here is a desc (default 1)")
  }

  func testItCanPrintAFlagTable1ForGlobalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        Flag(shortName: "d", longName: "toggle", value: "", description: ""),
        ]
    )

    let flags = CommandHelp.flags(forFlagSet: fs, flags: [])

    let description = FlagHelpGeneratorUtils.description(forFlags: flags.global)

    XCTAssertEqual(description
      , "  -d, --debug          Here is a desc \n  -d, --toggle string  (default )\n      --verbose int    Here is a desc (default 1)")
  }

  func testItCanPrintAFlagTable2ForGlobalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debugxxxxxxxxxxx", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: ""),
        Flag(shortName: "d", longName: "xxx", value: "123", description: "Here is a desc"),
        ]
    )

    let flags = CommandHelp.flags(forFlagSet: fs, flags: [])

    let description = FlagHelpGeneratorUtils.description(forFlags: flags.global)

    XCTAssertEqual(description
      , "  -d, --debugxxxxxxxxxxx   Here is a desc \n      --verbose int        (default 1)\n  -d, --xxx string         Here is a desc (default 123)")
  }

  func testItTestsLongFlagName() {

    do {
      try Flag(longName: "", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }

    do {
      try Flag(longName: "-a", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }

    do {
      try Flag(longName: "abc def", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }

    do {
      try Flag(longName: "/d/a/w", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }
  }

  func testItTestsShortFlagName() {

    do {
      try Flag(shortName: "", longName: "abc", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      try Flag(shortName: "--a", longName: "abc", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      try Flag(shortName: "-", longName: "abc", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      try Flag(shortName: "a a b", longName: "abc", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      try Flag(shortName: "ab", longName: "abc", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      try Flag(shortName: "a/b", longName: "abc", value: 1, description: "Here is a desc").validate()
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }
  }

  #if os(Linux)
  static let allTests = [
    ("testItGeneratesAPrintableNameWithLongNameAndDescription", testItGeneratesAPrintableNameWithLongNameAndDescription),
    ("testItGeneratesAPrintableNameWithLongNameAndDescriptionAndShortName", testItGeneratesAPrintableNameWithLongNameAndDescriptionAndShortName),
    ("testItGeneratesAPrintableNameForRequiredFlagsWithtoutDesc", testItGeneratesAPrintableNameForRequiredFlagsWithtoutDesc),
    ("testItGeneratesAPrintableNameForRequiredFlagsWithDesc", testItGeneratesAPrintableNameForRequiredFlagsWithDesc),
    ("testItGeneratesAPrintableNameForNonRequiredFlagsWithDesc", testItGeneratesAPrintableNameForNonRequiredFlagsWithDesc),
    ("testItGeneratesAPrintableDescription", testItGeneratesAPrintableDescription),
    ("testItCanPrintAFlagTable1ForLocalFlags", testItCanPrintAFlagTable1ForLocalFlags),
    ("testItCanPrintAFlagTable2ForLocalFlags", testItCanPrintAFlagTable2ForLocalFlags),
    ("testItCanPrintAFlagTableWithRequiredFlags", testItCanPrintAFlagTableWithRequiredFlags),
    ("testItCanPrintAFlagTable1ForGlobalFlags", testItCanPrintAFlagTable1ForGlobalFlags),
    ("testItCanPrintAFlagTable2ForGlobalFlags", testItCanPrintAFlagTable2ForGlobalFlags),
    ("testItTestsLongFlagName", testItTestsLongFlagName),
    ("testItTestsShortFlagName", testItTestsShortFlagName),
  ]
  #endif

}
