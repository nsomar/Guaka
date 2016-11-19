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
    let flag = Flag(longName: "debug", value: true)
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.longName, "debug")
    XCTAssertEqual(fh.shortName, nil)

    XCTAssertEqual(fh.isDeprecated, false)
    XCTAssertEqual(fh.deprecationMessage, nil)
  }

  func testItGeneratesNamesWithShortName() {
    let flag = Flag(longName: "debug",  shortName: "d", value: true)
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.longName, "debug")
    XCTAssertEqual(fh.shortName, "d")
  }

  func testItGeneratesNamesWithDeprecationStatus() {
    var flag = Flag(longName: "debug",  shortName: "d", value: true)
    flag.deprecationStatus = .deprecated("deprecated")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.isDeprecated, true)
    XCTAssertEqual(fh.deprecationMessage, "deprecated")
  }

  func testItGeneratesNamesWithValue() {
    var flag = Flag(longName: "debug",  shortName: "d", value: true)
    flag.deprecationStatus = .deprecated("deprecated")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.value as! Bool, true)
    XCTAssertEqual(fh.typeDescription, "bool")
  }

  func testItGeneratesNamesWithIntValue() {
    var flag = Flag(longName: "debug",  shortName: "d", value: 1)
    flag.deprecationStatus = .deprecated("deprecated")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.value as! Int, 1)
    XCTAssertEqual(fh.typeDescription, "int")
  }

  func testItGeneratesNamesWithDescription() {
    let flag = Flag(longName: "debug",  shortName: "d", value: 1, description: "abcdef")
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.description, "abcdef")
  }

  func testItGeneratesNamesWithRequiredFlags() {
    let flag = Flag(longName: "debug",  shortName: "d", type: String.self, required: true)
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.isRequired, true)
    XCTAssertEqual(fh.typeDescription, "string")
    XCTAssertEqual(fh.value as? String, nil)
  }

  func testItGeneratesNamesWithRequiredFlagsThatWasSet() {
    var flag = Flag(longName: "debug",  shortName: "d", type: String.self, required: true)
    flag.value = "abc"
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.isRequired, true)
    XCTAssertEqual(fh.wasChanged, false)
    XCTAssertEqual(fh.value as! String, "abc")
  }

  func testItGeneratesNamesWithThatWereChanged() {
    var flag = Flag(longName: "debug",  shortName: "d", type: String.self, required: true)
    flag.didSet = true
    let fh = FlagHelp(flag: flag)

    XCTAssertEqual(fh.wasChanged, true)
  }
  
}

