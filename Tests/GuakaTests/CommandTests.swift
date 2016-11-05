//
//  CommandTests.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 05/11/2016.
//
//

import XCTest
@testable import Guaka

class CommandTests: XCTestCase {
  
  override func setUp() {
    setupTestSamples()
  }
  
  func testItCanAddCommands() {
    XCTAssertEqual(git.commands.count, 2)
    git.add(subCommands: show)
    XCTAssertEqual(git.commands.count, 3)
  }
  
}
