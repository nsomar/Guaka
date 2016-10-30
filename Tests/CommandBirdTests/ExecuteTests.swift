//
//  ExecuteTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import CommandBird

class ExecuteTests: XCTestCase {
  
  func testItParsesLongWithEqual() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b")
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
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b")
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
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b")
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
        Flag(longName: "debug", defaultValue: 1, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b"),
        Flag(longName: "value", defaultValue: "ss", shortName: "v"),
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
        Flag(longName: "debug", defaultValue: 1, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b"),
        Flag(longName: "value", defaultValue: "ss", shortName: "v"),
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
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b"),
        Flag(longName: "value", defaultValue: "ss", shortName: "v"),
        ]
    )
    
    let r1 = try! fs.parse(args: expand("-d first -b=1 second"))
    XCTAssertEqual(r1.0[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r1.0[fs.flags["bla"]!] as? Int, 1)
    
    XCTAssertEqual(r1.1, ["first", "second"])
    
    let r2 = try! fs.parse(args: expand("first --debug second -b=1 third"))
    XCTAssertEqual(r2.0[fs.flags["d"]!] as? Bool, true)
    XCTAssertEqual(r2.0[fs.flags["b"]!] as? Int, 1)
    
    XCTAssertEqual(r2.1, ["first", "second", "third"])
  }
  
  func testItCatchesWrongFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b")
      ]
    )
    
    
    do {
      _ = try fs.parse(args: expand("---"))
      XCTFail()
    } catch CommandErrors.wrongFlagPattern(let str) {
      XCTAssertEqual(str, "---")
    } catch {
      XCTFail()
    }
  }
  
  func testItCatchesFlagsThatNeedValue() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b")
      ]
    )
    
    
    do {
      _ = try fs.parse(args: expand("-b -d"))
      XCTFail()
    } catch let CommandErrors.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "d")
    } catch {
      XCTFail()
    }
    
    
    do {
      _ = try fs.parse(args: expand("--bla -d"))
      XCTFail()
    } catch let CommandErrors.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "d")
    } catch {
      XCTFail()
    }
  }
  
  func testItCatchesLastFlagsThatNeedValue() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: 1, shortName: "b")
      ]
    )
    
    
    do {
      _ = try fs.parse(args: expand("-d --bla"))
      XCTFail()
    } catch let CommandErrors.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "No more flags")
    } catch {
      XCTFail()
    }
    
    
    do {
      _ = try fs.parse(args: expand("-d -b"))
      XCTFail()
    } catch let CommandErrors.flagNeedsValue(name, val) {
      XCTAssertEqual(name, "bla")
      XCTAssertEqual(val, "No more flags")
    } catch {
      XCTFail()
    }
  }
  
  
  func testItParseMultipleFlagsWithEqual() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", defaultValue: true, shortName: "d"),
        Flag(longName: "bla", defaultValue: true, shortName: "b"),
        Flag(longName: "value", defaultValue: "ss", shortName: "v"),
        ]
    )
    
    let r = try! fs.parse(args: expand("--debug 20 --bla=22")).0
    XCTAssertEqual(r[fs.flags["d"]!] as? Int, 20)
    XCTAssertEqual(r[fs.flags["bla"]!] as? Int, 22)
    
    let r2 = try! fs.parse(args: expand("--debug=20 --value abcd")).0
    XCTAssertEqual(r2[fs.flags["d"]!] as? Int, 20)
    XCTAssertEqual(r2[fs.flags["value"]!] as? String, "abcd")
  }
  
}

func expand(_ string: String) -> [String] {
  return string.components(separatedBy: " ")
}
