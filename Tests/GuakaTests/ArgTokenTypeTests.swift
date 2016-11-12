//
//  ArgTokenTypeTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import Guaka

class ArgTokenTypeTests: XCTestCase {

  func testItParsesLongFlag() {
    let v = ArgTokenType(fromString: "--long")

    if case let .longFlag(str) = v {
      XCTAssertEqual(str, str)
    } else {
      XCTFail()
    }
  }

  func testItParsesLongFlagWithEqual() {
    let v = ArgTokenType(fromString: "--long=112321")

    if case let .longFlagWithEqual(name, value) = v {
      XCTAssertEqual(name, "long")
      XCTAssertEqual(value, "112321")
    } else {
      XCTFail()
    }
  }

  func testItParsesShortFlag() {
    let v = ArgTokenType(fromString: "-x")

    if case let .shortFlag(str) = v {
      XCTAssertEqual(str, "x")
    } else {
      XCTFail()
    }
  }

  func testItParsesShortFlagWithEqual() {
    let v = ArgTokenType(fromString: "-x=1")

    if case let .shortFlagWithEqual(name, value) = v {
      XCTAssertEqual(name, "x")
      XCTAssertEqual(value, "1")
    } else {
      XCTFail()
    }
  }

  func testItParsesMultiShortFlag() {
    let v = ArgTokenType(fromString: "-xqweq")

    if case let .shortMultiFlag(name) = v {
      XCTAssertEqual(name, "xqweq")
    } else {
      XCTFail()
    }
  }

  func testItParsesMultiShortFlagWithEqual() {
    let v = ArgTokenType(fromString: "-xeeeew=1")

    if case let .shortMultiFlag(name) = v {
      XCTAssertEqual(name, "xeeeew=1")
    } else {
      XCTFail()
    }
  }

  func testItParsesInvalidFlags() {
    let v1 = ArgTokenType(fromString: "---x")

    if case let .invalidFlag(str) = v1 {
      XCTAssertEqual(str, "---x")
    } else {
      XCTFail()
    }

    let v2 = ArgTokenType(fromString: "-")

    if case let .invalidFlag(str) = v2 {
      XCTAssertEqual(str, "-")
    } else {
      XCTFail()
    }
  }

  func testItParsesPositionalArgs() {
    let v1 = ArgTokenType(fromString: "asdsadad")

    if case let .positionalArgument(str) = v1 {
      XCTAssertEqual(str, "asdsadad")
    } else {
      XCTFail()
    }
  }

  func testItKnowsAboutFlags() {
    XCTAssertTrue(ArgTokenType.longFlag("").isFlag)
    XCTAssertTrue(ArgTokenType.longFlagWithEqual("", "").isFlag)
    XCTAssertTrue(ArgTokenType.shortFlag("").isFlag)
    XCTAssertTrue(ArgTokenType.shortFlagWithEqual("", "").isFlag)
    XCTAssertTrue(ArgTokenType.shortMultiFlag("").isFlag)

    XCTAssertFalse(ArgTokenType.invalidFlag("").isFlag)
    XCTAssertFalse(ArgTokenType.positionalArgument("").isFlag)
  }

  func testItKnowsAboutFlagsThatNeedsValue() {
    XCTAssertTrue(ArgTokenType.longFlag("").requiresValue)
    XCTAssertTrue(ArgTokenType.shortFlag("").requiresValue)
    XCTAssertTrue(ArgTokenType.shortMultiFlag("").requiresValue)

    XCTAssertFalse(ArgTokenType.longFlagWithEqual("", "").requiresValue)
    XCTAssertFalse(ArgTokenType.shortFlagWithEqual("", "").requiresValue)
    XCTAssertFalse(ArgTokenType.invalidFlag("").requiresValue)
    XCTAssertFalse(ArgTokenType.positionalArgument("").requiresValue)
  }

  func testItReturnsFlagName() {
    XCTAssertEqual(ArgTokenType.longFlag("abc").flagName!, "abc")
    XCTAssertEqual(ArgTokenType.longFlagWithEqual("abc", "").flagName!, "abc")
    XCTAssertEqual(ArgTokenType.shortFlag("abc").flagName!, "abc")
    XCTAssertEqual(ArgTokenType.shortFlagWithEqual("abc", "").flagName!, "abc")
    XCTAssertEqual(ArgTokenType.shortMultiFlag("abc").flagName!, "abc")
  }

}
