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
    XCTAssertEqual(f.flagPrintableName, "      --debug int")
  }

  func testItGeneratesAPrintableNameWithLongNameAndDescriptionAndShortName() {
    let f = Flag(longName: "debug", shortName: "d", value: 1, description: "Here is a desc")
    XCTAssertEqual(f.flagPrintableName, "  -d, --debug int")
  }

  func testItGeneratesAPrintableNameForRequiredFlagsWithtoutDesc() {
    let f = Flag(longName: "debug", type: Int.self, required: true)
    XCTAssertEqual(f.flagPrintableDescription, "(required)")
  }

  func testItGeneratesAPrintableNameForRequiredFlagsWithDesc() {
    let f = Flag(longName: "debug", type: Int.self, required: true, description: "Here is a desc")
    XCTAssertEqual(f.flagPrintableDescription, "Here is a desc (required)")
  }

  func testItGeneratesAPrintableNameForNonRequiredFlagsWithDesc() {
    let f = Flag(longName: "debug", type: Int.self, required: false, description: "Here is a desc")
    XCTAssertEqual(f.flagPrintableDescription, "Here is a desc ")
  }

  func testItGeneratesAPrintableDescription() {
    let f1 = Flag(longName: "debug", shortName: "d", value: 1, description: "Here is a desc")
    XCTAssertEqual(f1.flagPrintableDescription, "Here is a desc (default 1)")

    let f2 = Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc")
    XCTAssertEqual(f2.flagPrintableDescription, "Here is a desc ")

    let f3 = Flag(longName: "debug", shortName: "d", value: "hello")
    XCTAssertEqual(f3.flagPrintableDescription, "(default hello)")
  }

  func testItCanPrintAFlagTable1ForLocalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        Flag(longName: "toggle", shortName: "d", value: ""),
        ]
    )

    let description = fs.localFlagDescription(withLocalFlags: Array(fs.flags.values))
    XCTAssertEqual(description
      , "  -d, --debug          Here is a desc \n  -d, --toggle string  (default )\n      --verbose int    Here is a desc (default 1)")
  }

  func testItCanPrintAFlagTable2ForLocalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debugxxxxxxxxxxx", shortName: "d", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1),
        Flag(longName: "xxx", shortName: "d", value: "123", description: "Here is a desc"),
        ]
    )

    let description = fs.localFlagDescription(withLocalFlags: Array(fs.flags.values))
    XCTAssertEqual(description
      , "  -d, --debugxxxxxxxxxxx   Here is a desc \n      --verbose int        (default 1)\n  -d, --xxx string         Here is a desc (default 123)")
  }

  func testItCanPrintAFlagTableWithRequiredFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        Flag(longName: "toggle", type: Int.self, required: true),
        ]
    )

    let description = fs.localFlagDescription(withLocalFlags: Array(fs.flags.values))
    XCTAssertEqual(description
      , "  -d, --debug        Here is a desc \n      --toggle int   (required)\n      --verbose int  Here is a desc (default 1)")
  }

  func testItCanPrintAFlagTable1ForGlobalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1, description: "Here is a desc"),
        Flag(longName: "toggle", shortName: "d", value: ""),
        ]
    )

    let description = fs.globalFlagsDescription(withLocalFlags: [])
    XCTAssertEqual(description
      , "  -d, --debug          Here is a desc \n  -d, --toggle string  (default )\n      --verbose int    Here is a desc (default 1)")
  }

  func testItCanPrintAFlagTable2ForGlobalFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debugxxxxxxxxxxx", shortName: "d", value: true, description: "Here is a desc"),
        Flag(longName: "verbose", value: 1),
        Flag(longName: "xxx", shortName: "d", value: "123", description: "Here is a desc"),
        ]
    )

    let description = fs.globalFlagsDescription(withLocalFlags: [])
    XCTAssertEqual(description
      , "  -d, --debugxxxxxxxxxxx   Here is a desc \n      --verbose int        (default 1)\n  -d, --xxx string         Here is a desc (default 123)")
  }

}
