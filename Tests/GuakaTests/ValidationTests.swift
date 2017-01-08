//
//  ValidationTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 06/01/2017.
//
//

import XCTest
@testable import Guaka

class ValidationTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }
  
  func testValidateEmptyName() {
    let c = Command(usage: "")

    do {
      try c.validate()
    } catch let e as CommandError {
      let msg = DefaultHelpGenerator(command: git).errorString(forError: e)
      XCTAssertEqual(msg.contains("wrong command name used"), true)
    } catch {
      XCTFail()
    }
    
  }

  func testValidateWrongName() {
    let c = Command(usage: "a-b/c")

    do {
      try c.validate()
    } catch let e as CommandError {
      let msg = DefaultHelpGenerator(command: git).errorString(forError: e)
      XCTAssertEqual(msg.contains("Command name of \'a-b/c\' is not allowed"), true)
    } catch {
      XCTFail()
    }

  }

  func testValidateSubCommandWithWrongName() {
    let c = Command(usage: "correct")
    let sub = Command(usage: "a-b/c")
    c.add(subCommand: sub)

    do {
      try c.validate()
    } catch let e as CommandError {
      let msg = DefaultHelpGenerator(command: git).errorString(forError: e)
      XCTAssertEqual(msg.contains("Command name of \'a-b/c\' is not allowed"), true)
    } catch {
      XCTFail()
    }
    
  }

  func testValidateCommandWithFlagsWithWrongLongName() {
    let c = Command(usage: "correct")
    let f = Flag(longName: "o-x/a", value: 10, description: "")
    c.add(flag: f)

    do {
      try c.validate()
    } catch let e as CommandError {
      let msg = DefaultHelpGenerator(command: git).errorString(forError: e)
      XCTAssertEqual(msg.contains("wrong flag long name used.\nFlag name of \'o-x/a\' is not allowed"), true)
    } catch {
      XCTFail()
    }

  }

  func testValidateCommandWithFlagsWithWrongShortName() {
    let c = Command(usage: "correct")
    let f = Flag(shortName: "x-q", longName: "long", value: 10, description: "")
    c.add(flag: f)

    do {
      try c.validate()
    } catch let e as CommandError {
      let msg = DefaultHelpGenerator(command: git).errorString(forError: e)
      XCTAssertEqual(msg.contains("wrong flag short name used.\nFlag name of \'x-q\' is not allowed"), true)
    } catch {
      XCTFail()
    }
    
  }

}
