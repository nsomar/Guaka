//
//  FlagSetTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import Guaka

class FlagSetTests: XCTestCase {
  
  func testItKnowsIfFlagIsBoolean() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", value: 1)
      ]
    )
    
    let v1 = fs.isBool(flagName: "debug")
    XCTAssertTrue(v1)
    
    let v2 = fs.isBool(flagName: "bla")
    XCTAssertFalse(v2)
    
    let v3 = fs.isBool(flagName: "nothere")
    XCTAssertFalse(v3)
  }
  
  func testItKnowsIfTokenIsSatisfied() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true, shortName: "d"),
        Flag(longName: "bla", value: 1, shortName: "b")
      ]
    )
    
    let v1 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "-v=1"))
    XCTAssertTrue(v1)
    
    let v2 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "--v=1"))
    XCTAssertTrue(v2)
    
    let v3 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "----"))
    XCTAssertTrue(v3)
    
    let v4 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "asdsads"))
    XCTAssertTrue(v4)
    
    let v5 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "-vvvv=1"))
    XCTAssertTrue(v5)
    
    let v6 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "-v"))
    XCTAssertFalse(v6)
    
    let v7 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "-d"))
    XCTAssertTrue(v7)
    
    let v8 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "--bla"))
    XCTAssertFalse(v8)
    
    let v9 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "-xxxwwwd"))
    XCTAssertTrue(v9)
    
    let v10 = fs.isFlagSatisfied(token: ArgTokenType(fromString: "-asdb"))
    XCTAssertTrue(v10)
  }
  
  func testItGetsPreparedFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", value: 1),
        Flag(longName: "test", value: "")
      ]
    )
    
    let values = [
      Flag(longName: "debug", value: true): false,
      Flag(longName: "bla", value: 1): 20,
      Flag(longName: "test", value: ""): "Hello"
    ] as [Flag : CommandStringConvertible]
    
    let res = try! fs.getPreparedFlags(withFlagValues: values)
    
    XCTAssertEqual(res["debug"]?.value as? Bool, false)
    XCTAssertEqual(res["bla"]?.value as? Int, 20)
    XCTAssertEqual(res["test"]?.value as? String, "Hello")
  }
  
  func testItGetsDeafaultValueForPreparedFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", value: 1),
        Flag(longName: "test", value: "")
      ]
    )
    
    let values = [
      Flag(longName: "debug", value: true): false,
      Flag(longName: "test", value: ""): "Hello"
      ] as [Flag : CommandStringConvertible]
    
    let res = try! fs.getPreparedFlags(withFlagValues: values)
    
    XCTAssertEqual(res["debug"]?.value as? Bool, false)
    XCTAssertEqual(res["bla"]?.value as? Int, 1)
    XCTAssertEqual(res["test"]?.value as? String, "Hello")
  }
  
  func testItThrowsErrorForUnexpectedFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", value: 1),
        Flag(longName: "test", value: "")
      ]
    )
    
    let values = [
      Flag(longName: "debug", value: true): false,
      Flag(longName: "test2", value: ""): "Hello"
      ] as [Flag : CommandStringConvertible]
    
    do {
      _ = try fs.getPreparedFlags(withFlagValues: values)
      XCTFail()
    } catch CommandErrors.unexpectedFlagPassed(let x, let y)  {
      XCTAssertEqual(x, "test2")
      XCTAssertEqual(y, "Hello")
    } catch {
      
    }
  }
  
  func testAppendsHelpToFlagSet() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", value: 1),
        Flag(longName: "test", value: "")
      ]
    ).flagSetAppeningHelp()
    
    XCTAssertNotNil(fs.flags["h"])
    XCTAssertNotNil(fs.flags["help"])
  }
 
  func testItCanGetRequiredFlags1() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: true),
        ]
    )
    
    XCTAssertEqual(fs.requiredFlags.count, 2)
  }
  
  func testItCanGetRequiredFlags2() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: false),
        ]
    )
    
    XCTAssertEqual(fs.requiredFlags.count, 1)
  }
  
  func testItMakesSureAllRequiredFlagsAreSetWithError() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: true),
        ]
    )
    
    let (flags, _) = try! fs.parse(args: expand("--debug=1"))
    let prepared = try! fs.getPreparedFlags(withFlagValues: flags)
    
    let res = fs.checkAllRequiredFlagsAreSet(preparedFlags: prepared)
    
    if case .flagError(let e) = res {
      if case CommandErrors.requiredFlagsWasNotSet("bla", _) = e {
      } else {
        XCTFail()
      }
    } else {
      XCTFail()
    }
  }
  
  func testItMakesSureAllRequiredFlagsAreSetWithErrorForMultipleFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: true),
        Flag(longName: "xxx", type: Int.self, required: true),
        ]
    )
    
    let (flags, _) = try! fs.parse(args: expand("--debug=1"))
    let prepared = try! fs.getPreparedFlags(withFlagValues: flags)
    
    let res = fs.checkAllRequiredFlagsAreSet(preparedFlags: prepared)
    
    if case .flagError(let e) = res {
      if case CommandErrors.requiredFlagsWasNotSet("bla", _) = e {
      } else {
        XCTFail()
      }
    } else {
      XCTFail()
    }
  }
  
  func testItMakesSureAllRequiredFlagsAreSetWithErrorForMultipleFlagsEvenIfSomeAreSet() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: true),
        Flag(longName: "xxx", type: Int.self, required: true),
        ]
    )
    
    let (flags, _) = try! fs.parse(args: expand("--debug=1 --bla=2"))
    let prepared = try! fs.getPreparedFlags(withFlagValues: flags)
    
    let res = fs.checkAllRequiredFlagsAreSet(preparedFlags: prepared)
    
    if case .flagError(let e) = res {
      if case CommandErrors.requiredFlagsWasNotSet("xxx", _) = e {
      } else {
        XCTFail()
      }
    } else {
      XCTFail()
    }
  }
  
  func testItMakesSureAllRequiredFlagsAreSetWithSuccessIfFlagIsSet() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: true),
        ]
    )
    
    let (flags, _) = try! fs.parse(args: expand("--debug=1 --bla 1"))
    let prepared = try! fs.getPreparedFlags(withFlagValues: flags)
    
    let res = fs.checkAllRequiredFlagsAreSet(preparedFlags: prepared)
    
    if case .success = res {
    } else {
      XCTFail()
    }
  }
  
  func testItMakesSureAllRequiredFlagsAreSetWithSuccessIfMultipleFlagIsSet() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: true),
        Flag(longName: "xxx", type: Int.self, required: true),
        ]
    )
    
    let (flags, _) = try! fs.parse(args: expand("--debug=1 --bla 1 --xxx=1"))
    let prepared = try! fs.getPreparedFlags(withFlagValues: flags)
    
    let res = fs.checkAllRequiredFlagsAreSet(preparedFlags: prepared)
    
    if case .success = res {
    } else {
      XCTFail()
    }
  }
  
  func testItMakesSureAllRequiredFlagsAreSetWithSuccessIfNoRequiredFlags() {
    let fs = FlagSet(
      flags: [
        Flag(longName: "debug", value: true),
        Flag(longName: "bla", type: Int.self, required: false),
        ]
    )
    
    let (flags, _) = try! fs.parse(args: expand("--debug=1"))
    let prepared = try! fs.getPreparedFlags(withFlagValues: flags)
    
    let res = fs.checkAllRequiredFlagsAreSet(preparedFlags: prepared)
    
    if case .success = res {
    } else {
      XCTFail()
    }
  }
}
