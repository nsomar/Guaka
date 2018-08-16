//
//  Command+Run.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 10/11/2016.
//
//

import XCTest
@testable import Guaka

class CommandRunTests: XCTestCase {

  override func setUp() {
    setupTestSamples()
  }

  func testItRunsPreRunBeforeRun() {
    var events = [String]()

    git.preRun = { (_,_) in events.append("pre"); return true }
    git.run = { (_,_) in events.append("run") }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["pre", "run"])
  }

  func testItPreRunReturnFalseExecutionIsHalted() {
    var events = [String]()

    git.preRun = { (_,_) in events.append("pre"); return false }
    git.run = { (_,_) in events.append("run") }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["pre"])
  }

  func testItRunsPostRunAfterRun() {
    var events = [String]()

    git.postRun = { (_,_) in events.append("post"); return false  }
    git.run = { (_,_) in events.append("run") }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["run", "post"])
  }

  func testItCallsPreRunPostInOrder() {
    var events = [String]()

    git.preRun = { (_,_) in events.append("pre"); return true }
    git.run = { (_,_) in events.append("run") }
    git.postRun = { (_,_) in events.append("post"); return false  }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["pre", "run", "post"])
  }

  func testReturingFalseFromPreStopsPostToo() {
    var events = [String]()

    git.preRun = { (_,_) in events.append("pre"); return false }
    git.run = { (_,_) in events.append("run") }
    git.postRun = { (_,_) in events.append("post"); return false  }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["pre"])
  }

  func testItFindsTheInheritablePreRunFromCurrentCommandIfAvailable() {
    var events = [String]()

    show.inheritablePreRun = { (_,_) in events.append("ipre1"); return true }
    remote.inheritablePreRun = { (_,_) in events.append("ipre2"); return true }
    git.inheritablePreRun = { (_,_) in events.append("ipre3"); return true }

    let f = show.findAdequateInheritableRun(forPre: true)
    _ = f?(Flags(flags: [:]), [])
    XCTAssertEqual(events, ["ipre1"])
  }

  func testItFindsTheInheritablePreRunFromParentCommandIfAvailable() {
    var events = [String]()

    show.inheritablePreRun = nil
    remote.inheritablePreRun = { (_,_) in events.append("ipre2"); return true }
    git.inheritablePreRun = { (_,_) in events.append("ipre3"); return true }

    let f = show.findAdequateInheritableRun(forPre: true)
    _ = f?(Flags(flags: [:]), [])
    XCTAssertEqual(events, ["ipre2"])
  }

  func testItFindsTheInheritablePreRunFromGrandParentCommandIfAvailable() {
    var events = [String]()

    show.inheritablePreRun = nil
    remote.inheritablePreRun = nil
    git.inheritablePreRun = { (_,_) in events.append("ipre3"); return true }

    let f = show.findAdequateInheritableRun(forPre: true)
    _ = f?(Flags(flags: [:]), [])
    XCTAssertEqual(events, ["ipre3"])
  }

  func testItHandlesCasesWherThereAreNoInheritablePreRun() {
    show.inheritablePreRun = nil
    remote.inheritablePreRun = nil
    git.inheritablePreRun = nil

    let f = show.findAdequateInheritableRun(forPre: true)
    XCTAssertNil(f)
  }

  func testItFindsTheInheritablePostRunFromCurrentCommandIfAvailable() {
    var events = [String]()

    show.inheritablePostRun = { (_,_) in events.append("ipost1"); return true}
    remote.inheritablePostRun = { (_,_) in events.append("ipost2"); return true}
    git.inheritablePostRun = { (_,_) in events.append("ipost3"); return true}

    let f = show.findAdequateInheritableRun(forPre: false)
    _ = f?(Flags(flags: [:]), [])
    XCTAssertEqual(events, ["ipost1"])
  }

  func testItFindsTheInheritablePostRunFromParentCommandIfAvailable() {
    var events = [String]()

    show.inheritablePostRun = nil
    remote.inheritablePostRun = { (_,_) in events.append("ipost2"); return true}
    git.inheritablePostRun = { (_,_) in events.append("ipost3"); return true}

    let f = show.findAdequateInheritableRun(forPre: false)
    _ = f?(Flags(flags: [:]), [])
    XCTAssertEqual(events, ["ipost2"])
  }

  func testItFindsTheInheritablePostRunFromGrandParentCommandIfAvailable() {
    var events = [String]()

    show.inheritablePostRun = nil
    remote.inheritablePostRun = nil
    git.inheritablePostRun = { (_,_) in events.append("ipost3"); return true}

    let f = show.findAdequateInheritableRun(forPre: false)
    _ = f?(Flags(flags: [:]), [])
    XCTAssertEqual(events, ["ipost3"])
  }

  func testItHandlesCasesWherThereAreNoInheritablePostRun() {
    show.inheritablePostRun = nil
    remote.inheritablePostRun = nil
    git.inheritablePostRun = nil

    let f = show.findAdequateInheritableRun(forPre: false)
    XCTAssertNil(f)
  }

  func testItRunsInheritablePreRunBeforeRun() {
    var events = [String]()

    git.inheritablePreRun = { (_,_) in events.append("ipre"); return true }
    git.preRun = { (_,_) in events.append("pre"); return true }
    git.run = { (_,_) in events.append("run"); }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["ipre", "pre", "run"])
  }

  func testIfInheritablePreRunReturnFalseItAltersExecution() {
    var events = [String]()

    git.inheritablePreRun = { (_,_) in events.append("ipre"); return false }
    git.preRun = { (_,_) in events.append("pre"); return true }
    git.run = { (_,_) in events.append("run"); }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["ipre"])
  }

  func testItRunsInheritablePreRunFromParentBeforeRun() {
    var events = [String]()

    git.inheritablePreRun = { (_,_) in events.append("ipre"); return true }
    show.preRun = { (_,_) in events.append("pre"); return true }
    show.run = { (_,_) in events.append("run"); }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["ipre", "pre", "run"])
  }

  func testIfInheritablePreRunFromParentReturnFalseItAltersExecution() {
    var events = [String]()

    git.inheritablePreRun = { (_,_) in events.append("ipre"); return false }
    show.preRun = { (_,_) in events.append("pre"); return true }
    show.run = { (_,_) in events.append("run"); }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["ipre"])
  }

  func testItRunsInheritablePostRunAfterRun() {
    var events = [String]()

    git.inheritablePostRun = { (_,_) in events.append("ipost"); return true}
    git.postRun = { (_,_) in events.append("post"); return true }
    git.run = { (_,_) in events.append("run"); }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["run", "post", "ipost"])
  }

  func testIfPostRunReturnFalseItAltersExecutionAndInheritableIsNotCalled() {
    var events = [String]()

    git.inheritablePostRun = { (_,_) in events.append("ipost"); return true}
    git.postRun = { (_,_) in events.append("post"); return false }
    git.run = { (_,_) in events.append("run"); }

    git.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["run", "post"])
  }

  func testItRunsInheritablePostRunParentAfterRun() {
    var events = [String]()

    git.inheritablePostRun = { (_,_) in events.append("ipost"); return true}
    show.postRun = { (_,_) in events.append("post"); return true }
    show.run = { (_,_) in events.append("run"); }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["run", "post", "ipost"])
  }

  func testItExecutesAllRuns() {
    var events = [String]()

    git.inheritablePostRun = { (_,_) in events.append("igpost"); return true}
    show.postRun = { (_,_) in events.append("post"); return true }
    show.run = { (_,_) in events.append("run"); }
    remote.inheritablePreRun = { (_,_) in events.append("irpre"); return true }
    show.preRun = { (_,_) in events.append("pre"); return true }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["irpre", "pre", "run", "post", "igpost"])
  }

  func testItDoesNotCrashIfSomeRunsAreNotSet() {
    var events = [String]()

    show.inheritablePostRun = { (_,_) in events.append("irpost"); return true}
    show.postRun = nil
    show.run = { (_,_) in events.append("run"); }
    git.inheritablePreRun = { (_,_) in events.append("igpre"); return true }
    show.preRun = { (_,_) in events.append("pre"); return true }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["igpre", "pre", "run", "irpost"])
  }

  func testIfItHasLotsOfRunsInheritablePreCanStopAllOfThem() {
    var events = [String]()

    git.inheritablePostRun = { (_,_) in events.append("igpost"); return true}
    show.postRun = { (_,_) in events.append("post"); return true }
    show.run = { (_,_) in events.append("run"); }
    remote.inheritablePreRun = { (_,_) in events.append("irpre"); return false }
    show.preRun = { (_,_) in events.append("pre"); return true }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["irpre"])
  }

  func testIfItHasLotsOfRunsPreCanStopAllOfThemExceptInheritable() {
    var events = [String]()

    git.inheritablePostRun = { (_,_) in events.append("igpost"); return true}
    show.postRun = { (_,_) in events.append("post"); return true }
    show.run = { (_,_) in events.append("run"); }
    show.inheritablePreRun = { (_,_) in events.append("ispre"); return true }
    show.preRun = { (_,_) in events.append("pre"); return false }

    show.execute(commandLineArgs: expand("git"))

    XCTAssertEqual(events, ["ispre", "pre"])
  }

}
