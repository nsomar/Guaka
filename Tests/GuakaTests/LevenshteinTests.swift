
//
//  ArgTokenTypeTests.swift
//  CommandLine
//
//  Created by Omar Abdelhafith on 30/10/2016.
//
//

import XCTest
@testable import Guaka

class LevenshteinTests: XCTestCase {

  func testItCalculatesLevenshteinDistance() {
    let source = "book"
    let target = "back"

    XCTAssertEqual(Levenshtein.distance(source: source, target: target), 2)
  }

  func testItCalculatesLevenshteinShortestDistance() {
    let source = "lag"
    let choices = ["log", "long", "flog"]

    XCTAssertEqual(Levenshtein.shortestDistance(forSource: source, withChoices: choices), "log")
  }

  #if os(Linux)
  static let allTests = [
    ("testItCalculatesLevenshteinDistancevDist", testItCalculatesLevenshteinDistance),
    ("testItCalculatesLevenshteinShortestDistance", testItCalculatesLevenshteinShortestDistance),
  ]
  #endif

}
