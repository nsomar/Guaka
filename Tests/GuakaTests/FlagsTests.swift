//
//  FlagsTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 12/11/2016.
//
//

import XCTest
@testable import Guaka

class FlagsTests: XCTestCase {

  func testItReuturnInt() {
    let flags =
      ["debug": Flag(longName: "debug", value: true),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    XCTAssertEqual(f.getInt(name: "bla"), 1)
  }

  func testItReuturnBool() {
    let flags =
      ["debug": Flag(longName: "debug", value: false),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    XCTAssertEqual(f.getBool(name: "debug"), false)
  }

  func testItReuturnString() {
    let flags =
      ["debug": Flag(longName: "debug", value: "123"),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    XCTAssertEqual(f.getString(name: "debug"), "123")
  }

  func testItGetsAFlag() {
    let flags =
      ["debug": Flag(longName: "debug", value: "123"),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    XCTAssertEqual(f["debug"]?.value as? String, "123")
  }

  func testItGetsAFlagValue() {
    let flags =
      ["debug": Flag(longName: "debug", value: "123"),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    XCTAssertEqual(f[valueForName: "bla"] as? Int, 1)
  }

  func testItGetsAFlagValueForAType() {
    let flags =
      ["debug": Flag(longName: "debug", value: "123"),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    let v = f.get(name: "debug", type: String.self)
    XCTAssertEqual(v, "123")
  }

  func testItHandlesBadFlagNames() {
    let flags =
      ["debug": Flag(longName: "debug", value: "123"),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    let v = f.get(name: "debug222", type: String.self)
    XCTAssertNil(v)
  }

  func testItHandlesBadFlagType() {
    let flags =
      ["debug": Flag(longName: "debug", value: "123"),
       "bla": Flag(longName: "bla", value: 1)]

    let f = Flags(flags: flags)
    let v = f.get(name: "debug", type: Int.self)
    XCTAssertNil(v)
    XCTAssertNil(f.getInt(name: "debug"))
    XCTAssertNil(f.getString(name: "bla"))
  }

}
