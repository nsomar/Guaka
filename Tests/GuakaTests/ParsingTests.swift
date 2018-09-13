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
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: "")
      ]
    )

    let r = try! fs.parse(args: expand("--debug=true --bla=22")).0
    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Int, 22)

    let r2 = try! fs.parse(args: expand("--debug=1 --bla=22")).0
    XCTAssertEqual(r2[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r2[fs.flags["bla"]!]!.first as? Int, 22)
  }

  func testItParsesShortFlag() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: "")
      ]
    )

    let r = try! fs.parse(args: expand("-d=true -b=22")).0
    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Int, 22)

    let r2 = try! fs.parse(args: expand("-d=1 -b=22")).0
    XCTAssertEqual(r2[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r2[fs.flags["bla"]!]!.first as? Int, 22)
  }

  func testItParsesBooleanLongAndShortFlagsWithNoArguments() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: "")
      ]
    )

    let r = try! fs.parse(args: expand("--debug -b=22")).0
    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Int, 22)

    let r2 = try! fs.parse(args: expand("-d -b=22")).0
    XCTAssertEqual(r2[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r2[fs.flags["bla"]!]!.first as? Int, 22)
  }

  func testItParsesShortUnsatisfiedFlag() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: 1, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: ""),
        Flag(shortName: "v", longName: "value", value: "ss", description: ""),
      ]
    )

    let r = try! fs.parse(args: expand("-d 20 -b=22")).0
    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Int, 20)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Int, 22)

    let r2 = try! fs.parse(args: expand("-d=20 -v abcd")).0
    XCTAssertEqual(r2[fs.flags["d"]!]!.first as? Int, 20)
    XCTAssertEqual(r2[fs.flags["value"]!]!.first as? String, "abcd")
  }

  func testItParsesLongUnsatisfiedFlag() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: 1, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: ""),
        Flag(shortName: "v", longName: "value", value: "ss", description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("--debug 20 --bla=22")).0
    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Int, 20)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Int, 22)

    let r2 = try! fs.parse(args: expand("--debug=20 --value abcd")).0
    XCTAssertEqual(r2[fs.flags["d"]!]!.first as? Int, 20)
    XCTAssertEqual(r2[fs.flags["value"]!]!.first as? String, "abcd")
  }

  func testItGetsPositionalArguments() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: ""),
        Flag(shortName: "v", longName: "value", value: "ss", description: ""),
        ]
    )

    let r1 = try! fs.parse(args: expand("-d first -b=1 second"))
    XCTAssertEqual(r1.0[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r1.0[fs.flags["bla"]!]!.first as? Int, 1)

    XCTAssertEqual(r1.1, ["first", "second"])

    let r2 = try! fs.parse(args: expand("first --debug=false second -b=1 third"))
    XCTAssertEqual(r2.0[fs.flags["d"]!]!.first as? Bool, false)
    XCTAssertEqual(r2.0[fs.flags["b"]!]!.first as? Int, 1)

    XCTAssertEqual(r2.1, ["first", "second", "third"])
  }

  func testItCatchesWrongFlags() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: "")
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
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: "")
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
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: "")
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
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: true, description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("-dbx")).0
    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["x"]!]!.first as? Bool, true)
  }

  func testItParseMultipleBoolFlagsWithEqual() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: true, description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("-dbx=0")).0

    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["x"]!]!.first as? Bool, false)
  }

  func testItParseMultipleBoolFlagsWithEqualAndPending() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: 1, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: true, description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("-bxd 123")).0

    XCTAssertEqual(r[fs.flags["d"]!]!.first as? Int, 123)
    XCTAssertEqual(r[fs.flags["bla"]!]!.first as? Bool, true)
    XCTAssertEqual(r[fs.flags["x"]!]!.first as? Bool, true)
  }

  func testItParseMultipleBoolFlagsWithEqualAndPendingWillThrowIfUnsatisfied() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: 1, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: true, description: ""),
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
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: "aa", description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("-bxd=0")).0

    XCTAssertEqual(r[fs.flags["x"]!]!.first as? String, "d=0")
  }

  func testANonBoolShortFlagWillSwallowTheOutputAndConvertsIt() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: 1, description: ""),
        Flag(shortName: "x", longName: "xxx", value: "aa", description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("-b12345")).0

    XCTAssertEqual(r[fs.flags["b"]!]!.first as? Int, 12345)
  }

  func testANonBoolShortFlagWillSwallowTheOutputAndConvertsIt2() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: "aa", description: ""),
        ]
    )

    let r = try! fs.parse(args: expand("-bx12345")).0

    XCTAssertEqual(r[fs.flags["x"]!]!.first as? String, "12345")
    XCTAssertEqual(r[fs.flags["b"]!]!.first as? Bool, true)
  }

  func testANonBoolShortFlagWillSwallowTheOutputAndConvertsItAndThrowErrorIfCannotConvert() {
    let fs = FlagSet(
      flags: [
        Flag(shortName: "d", longName: "debug", value: true, description: ""),
        Flag(shortName: "b", longName: "bla", value: true, description: ""),
        Flag(shortName: "x", longName: "xxx", value: 1, description: ""),
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

  func testItParsesRepeatableFlags() {
    let fs = FlagSet(
        flags: [
            Flag(longName: "target1", type: [String].self, description: ""),
            Flag(longName: "target2", type: String.self, description: "", repeatable: true),
            Flag(longName: "target3", values: [String](), description: ""),
            Flag(longName: "target4", values: "small", "quick", description: "")
            ]
    )

    let r = try! fs.parse(args: expand("--target1 small --target1 quick --target2 small --target2 quick --target3 small --target3 quick --target4 small --target4 quick")).0

    let values = ["small", "quick"]
    XCTAssertEqual(r[fs.flags["target1"]!] as! [String], values)
    XCTAssertEqual(r[fs.flags["target2"]!] as! [String], values)
    XCTAssertEqual(r[fs.flags["target3"]!] as! [String], values)
    XCTAssertEqual(r[fs.flags["target4"]!] as! [String], values)
  }

}
