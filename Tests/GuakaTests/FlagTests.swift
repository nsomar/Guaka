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
    let f = try! Flag(longName: "debug", value: 1, description: "Here is a desc")
    let s = FlagHelpGeneratorUtils.flagPrintableName(flag: FlagHelp(flag: f))

    XCTAssertEqual(s, "      --debug int")
  }

  func testItGeneratesAPrintableNameWithLongNameAndDescriptionAndShortName() {
    let f = try! Flag(longName: "debug", shortName: "d", value: 1, description: "Here is a desc")

    let s = FlagHelpGeneratorUtils.flagPrintableName(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "  -d, --debug int")
  }

  func testItGeneratesAPrintableNameForRequiredFlagsWithtoutDesc() {
    let f = try! Flag(longName: "debug", type: Int.self, required: true)

    let s = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "(required)")
  }

  func testItGeneratesAPrintableNameForRequiredFlagsWithDesc() {
    let f = try! Flag(longName: "debug", type: Int.self, required: true, description: "Here is a desc")

    let s = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "Here is a desc (required)")
  }

  func testItGeneratesAPrintableNameForNonRequiredFlagsWithDesc() {
    let f = try! Flag(longName: "debug", type: Int.self, required: false, description: "Here is a desc")

    let s = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f))
    XCTAssertEqual(s, "Here is a desc ")
  }

  func testItGeneratesAPrintableDescription() {
    let f1 = try! Flag(longName: "debug", shortName: "d", value: 1, description: "Here is a desc")

    let s1 = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f1))
    XCTAssertEqual(s1, "Here is a desc (default 1)")

    let f2 = try! Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc")

    let s2 = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f2))
    XCTAssertEqual(s2, "Here is a desc ")

    let f3 = try! Flag(longName: "debug", shortName: "d", value: "hello")

    let s3 = FlagHelpGeneratorUtils.flagPrintableDescription(flag: FlagHelp(flag: f3))
    XCTAssertEqual(s3, "(default hello)")
  }

  func testItCanPrintAFlagTable1ForLocalFlags() {
    let fs = FlagSet(
      flags: [
        try! Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc"),
        try! Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        try! Flag(longName: "toggle", shortName: "d", value: ""),
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
        try! Flag(longName: "debugxxxxxxxxxxx", shortName: "d", value: true, description: "Here is a desc"),
        try! Flag(longName: "verbose", value: 1),
        try! Flag(longName: "xxx", shortName: "d", value: "123", description: "Here is a desc"),
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
        try! Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc"),
        try! Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        try! Flag(longName: "toggle", type: Int.self, required: true),
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
        try! Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc"),
        try! Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        try! Flag(longName: "toggle", shortName: "d", value: ""),
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
        try! Flag(longName: "debugxxxxxxxxxxx", shortName: "d", value: true, description: "Here is a desc"),
        try! Flag(longName: "verbose", value: 1),
        try! Flag(longName: "xxx", shortName: "d", value: "123", description: "Here is a desc"),
        ]
    )

    let flags = CommandHelp.flags(forFlagSet: fs, flags: [])

    let description = FlagHelpGeneratorUtils.description(forFlags: flags.global)

    XCTAssertEqual(description
      , "  -d, --debugxxxxxxxxxxx   Here is a desc \n      --verbose int        (default 1)\n  -d, --xxx string         Here is a desc (default 123)")
  }

  func testItTestsLongFlagName() {

    do {
      _ = try Flag(longName: "", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "-a", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "abc def", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "/d/a/w", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagLongName { } catch {
      XCTFail()
    }
  }

  func testItTestsShortFlagName() {

    do {
      _ = try Flag(longName: "abc", shortName: "", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "abc", shortName: "--a", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "abc", shortName: "-", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "abc", shortName: "a a b", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "abc", shortName: "ab", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }

    do {
      _ = try Flag(longName: "abc", shortName: "a/b", value: 1, description: "Here is a desc")
      XCTFail()
    } catch CommandError.wrongFlagShortName { } catch {
      XCTFail()
    }
  }
}
