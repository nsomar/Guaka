//
//  FlagHelpTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 19/11/2016.
//
//

import XCTest
@testable import Guaka

class FlagHelpTests: XCTestCase {

  func testItGeneratesNamesWithLongName() {
    let flag = Flag(longName: "debug", value: true, description: "")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.longName, "debug")
    XCTAssertEqual(fh.shortName, nil)

    XCTAssertEqual(fh.isDeprecated, false)
    XCTAssertEqual(fh.deprecationMessage, nil)
  }

  func testItGeneratesNamesWithShortName() {
    let flag = Flag(shortName: "d", longName: "debug", value: true, description: "")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.longName, "debug")
    XCTAssertEqual(fh.shortName, "d")
  }

  func testItGeneratesNamesWithDeprecationStatus() {
    var flag = Flag(shortName: "d", longName: "debug", value: true, description: "")
    flag.deprecationStatus = .deprecated("deprecated")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.isDeprecated, true)
    XCTAssertEqual(fh.deprecationMessage, "deprecated")
  }

  func testItGeneratesNamesWithValue() {
    var flag = Flag(shortName: "d", longName: "debug", value: true, description: "")
    flag.deprecationStatus = .deprecated("deprecated")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.value as! Bool, true)
    XCTAssertEqual(fh.typeDescription, "")
  }

  func testItGeneratesNamesWithIntValue() {
    var flag = Flag(shortName: "d", longName: "debug", value: 1, description: "")
    flag.deprecationStatus = .deprecated("deprecated")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.value as! Int, 1)
    XCTAssertEqual(fh.typeDescription, "int")
  }

  func testItGeneratesNamesWithDescription() {
    let flag = Flag(shortName: "d", longName: "debug", value: 1, description: "abcdef")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.description, "abcdef")
  }

  func testItGeneratesNamesWithRequiredFlags() {
    let flag = Flag(shortName: "d", longName: "debug", type: String.self, description: "", required: true)
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.isRequired, true)
    XCTAssertEqual(fh.typeDescription, "string")
    XCTAssertEqual(fh.value as? String, nil)
  }

  func testItGeneratesNamesWithRequiredFlagsThatWasSet() {
    var flag = Flag(shortName: "d", longName: "debug", type: String.self, description: "", required: true)
    flag.values = ["abc"]
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.isRequired, true)
    XCTAssertEqual(fh.wasChanged, false)
    XCTAssertEqual(fh.value as! String, "abc")
  }

  func testItGeneratesNamesWithThatWereChanged() {
    var flag = Flag(shortName: "d", longName: "debug", type: String.self, description: "", required: true)
    flag.didSet = true
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.wasChanged, true)
  }

  #if os(Linux)
  static let allTests = [
    ("testItGeneratesNamesWithLongName", testItGeneratesNamesWithLongName),
    ("testItGeneratesNamesWithShortName", testItGeneratesNamesWithShortName),
    ("testItGeneratesNamesWithDeprecationStatus", testItGeneratesNamesWithDeprecationStatus),
    ("testItGeneratesNamesWithValue", testItGeneratesNamesWithValue),
    ("testItGeneratesNamesWithIntValue", testItGeneratesNamesWithIntValue),
    ("testItGeneratesNamesWithDescription", testItGeneratesNamesWithDescription),
    ("testItGeneratesNamesWithRequiredFlags", testItGeneratesNamesWithRequiredFlags),
    ("testItGeneratesNamesWithRequiredFlagsThatWasSet", testItGeneratesNamesWithRequiredFlagsThatWasSet),
    ("testItGeneratesNamesWithThatWereChanged", testItGeneratesNamesWithThatWereChanged),
  ]
  #endif

}
