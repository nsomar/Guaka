//
//  ExecuteTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import Guaka

class ParsingTests: XCTestCase {

  func testItParsesLongWithEqual() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1)
      ]
    )

    let r = try! fs.parse(args: expand("--debug=true --bla=22")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Int, 22)

    let r2 = try! fs.parse(args: expand("--debug=1 --bla=22")).0
    XCTAssertEqual(r2[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r2[fs.flags["bla"]!] as? Int, 22)
  }

  func testItParsesShortFlag() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1)
      ]
    )

    let r = try! fs.parse(args: expand("-d=true -b=22")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Int, 22)

    let r2 = try! fs.parse(args: expand("-d=1 -b=22")).0
    XCTAssertEqual(r2[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r2[fs.flags["bla"]!] as? Int, 22)
  }

  func testItParsesBooleanLongAndShortFlagsWithNoArguments() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1)
      ]
    )

    let r = try! fs.parse(args: expand("--debug -b=22")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Int, 22)

    let r2 = try! fs.parse(args: expand("-d -b=22")).0
    XCTAssertEqual(r2[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r2[fs.flags["bla"]!] as? Int, 22)
  }

  func testItParsesShortUnsatisfiedFlag() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: 1),
        Flag(longName: "bla", shortName: "b", value: 1),
        Flag(longName: "value", shortName: "v", value: "ss"),
      ]
    )

    let r = try! fs.parse(args: expand("-d 20 -b=22")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Int, 20)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Int, 22)

    let r2 = try! fs.parse(args: expand("-d=20 -v abcd")).0
    XCTAssertEqual(r2[fs.flags["d"]!] as? Int, 20)
    XCTAssertEqual(r2[fs.flags["value"]!] as? String, "abcd")
  }

  func testItParsesLongUnsatisfiedFlag() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: 1),
        Flag(longName: "bla", shortName: "b", value: 1),
        Flag(longName: "value", shortName: "v", value: "ss"),
        ]
    )

    let r = try! fs.parse(args: expand("--debug 20 --bla=22")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Int, 20)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Int, 22)

    let r2 = try! fs.parse(args: expand("--debug=20 --value abcd")).0
    XCTAssertEqual(r2[fs.flags["d"]!] as? Int, 20)
    XCTAssertEqual(r2[fs.flags["value"]!] as? String, "abcd")
  }

  func testItGetsPositionalArguments() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1),
        Flag(longName: "value", shortName: "v", value: "ss"),
        ]
    )

    let r1 = try! fs.parse(args: expand("-d first -b=1 second"))
    XCTAssertEqual(r1.0[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r1.0[fs.flags["bla"]!] as? Int, 1)

    XCTAssertEqual(r1.1, ["first", "second"])

    let r2 = try! fs.parse(args: expand("first --debug=false second -b=1 third"))
    XCTAssertEqual(r2.0[fs.flags["d"]!] as? Bool, false)
    XCTAssertEqual(r2.0[fs.flags["b"]!] as? Int, 1)

    XCTAssertEqual(r2.1, ["first", "second", "third"])
  }

  func testItCatchesWrongFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1)
      ]
    )


    do {
      _ = try fs.parse(args: expand("---"))
      XCTFail()
    } catch CommandError.wrongFlagPattern(let str) {
      XCTAssertEqual(str, "---")
    } catch {
      XCTFail()
    }
  }

  func testItCatchesFlagsThatNeedValue() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1)
      ]
    )


    do {
      _ = try fs.parse(args: expand("-b -d"))
      XCTFail()
    } catch let CommandError.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "d")
    } catch {
      XCTFail()
    }


    do {
      _ = try fs.parse(args: expand("--bla -d"))
      XCTFail()
    } catch let CommandError.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "d")
    } catch {
      XCTFail()
    }
  }

  func testItCatchesLastFlagsThatNeedValue() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1)
      ]
    )


    do {
      _ = try fs.parse(args: expand("-d --bla"))
      XCTFail()
    } catch let CommandError.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "No more flags")
    } catch {
      XCTFail()
    }


    do {
      _ = try fs.parse(args: expand("-d -b"))
      XCTFail()
    } catch let CommandError.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "No more flags")
    } catch {
      XCTFail()
    }
  }

  func testItParseMultipleBoolFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: true),
        ]
    )

    let r = try! fs.parse(args: expand("-dbx")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["x"]!] as? Bool, true)
  }

  func testItParseMultipleBoolFlagsWithEqual() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: true),
        ]
    )

    let r = try! fs.parse(args: expand("-dbx=0")).0

    XCTAssertEqual(r[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["x"]!] as? Bool, false)
  }

  func testItParseMultipleBoolFlagsWithEqualAndPending() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: 1),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: true),
        ]
    )

    let r = try! fs.parse(args: expand("-bxd 123")).0

    XCTAssertEqual(r[fs.flags["d"]!] as? Int, 123)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Bool, true)
    XCTAssertEqual(r[fs.flags["x"]!] as? Bool, true)
  }

  func testItParseMultipleBoolFlagsWithEqualAndPendingWillThrowIfUnsatisfied() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: 1),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: true),
        ]
    )

    do {
      _ = try fs.parse(args: expand("-bxd"))
      XCTFail()
    } catch let CommandError.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "debug")
      XCTAssertEqual(val, "No more flags")
    } catch {
      XCTFail()
    }
  }

  func testANonBoolShortFlagWillSwallowTheOutput() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: "aa"),
        ]
    )

    let r = try! fs.parse(args: expand("-bxd=0")).0

    XCTAssertEqual(r[fs.flags["x"]!] as? String, "d=0")
  }

  func testANonBoolShortFlagWillSwallowTheOutputAndConvertsIt() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: 1),
        Flag(longName: "xxx", shortName: "x", value: "aa"),
        ]
    )

    let r = try! fs.parse(args: expand("-b12345")).0

    XCTAssertEqual(r[fs.flags["b"]!] as? Int, 12345)
  }

  func testANonBoolShortFlagWillSwallowTheOutputAndConvertsIt2() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: "aa"),
        ]
    )

    let r = try! fs.parse(args: expand("-bx12345")).0

    XCTAssertEqual(r[fs.flags["x"]!] as? String, "12345")
    XCTAssertEqual(r[fs.flags["b"]!] as? Bool, true)
  }

  func testANonBoolShortFlagWillSwallowTheOutputAndConvertsItAndThrowErrorIfCannotConvert() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", shortName: "d", value: true),
        Flag(longName: "bla", shortName: "b", value: true),
        Flag(longName: "xxx", shortName: "x", value: 1),
        ]
    )

    do {
      _ = try fs.parse(args: expand("-bx1234s5"))
      XCTFail()
    } catch let CommandError.incorrectFlagValue(name, error) {
      XCTAssertEqual(name, "xxx")
      XCTAssertEqual(error, "cannot convert \'1234s5\' to \'Int\' ")
    } catch {
      XCTFail()
    }
  }

}
