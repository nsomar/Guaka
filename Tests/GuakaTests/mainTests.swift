import XCTest
@testable import Guaka

class SomeTest: XCTestCase {
  
  var git: Command!
  var show: Command!
  var remote: Command!
  var rebase: Command!
  
  override func setUp() {
    show = try! Command(
      name: "show",
      flags: [
        Flag(longName: "foo", value: "-", inheritable: false),
        Flag(longName: "bar", value: "-", inheritable: false),
        Flag(longName: "yy", value: true, inheritable: false),
        ],
      commands: [],
      run: { flags, args in
        
    })
    
    remote = try! Command(
      name: "remote",
      flags: [
        Flag(longName: "foo", value: "-", inheritable: true),
        Flag(longName: "remote", value: true, inheritable: true),
        Flag(longName: "bar", value: "-", inheritable: false),
        Flag(longName: "xx", value: true, inheritable: false),
        ],
      commands: [show],
      run: { flags, args in
        
    })
    
    rebase = try! Command(
      name: "rebase",
      flags: [
        Flag(longName: "varvar", value: false, shortName: "v", inheritable: true),
        ],
      commands: [],
      run: { flags, args in
        
    })
    
     git = try! Command(
      name: "git",
      flags: [
        Flag(longName: "debug", value: true, shortName: "d", inheritable: true),
        Flag(longName: "verbose", value: false, shortName: "v", inheritable: true),
        Flag(longName: "togge", value: false, shortName: "t", inheritable: false),
        Flag(longName: "root", value: 1, shortName: "r", inheritable: false),
      ],
      commands: [rebase, remote],
      run: { flags, args in
        
     })
  }
  
  func testItParsesSomething() {
//    execute(command: git, args: ["-vd1", "-v", "--bar", "1", "remote", "--foo", "222", "show"])
  }
  
  func testItCanGenerateFlagSetForRoot() {
    let fs1 = git.flagSet
    XCTAssertEqual(fs1.flags["d"]!.longName, "debug")
    XCTAssertEqual(fs1.flags["r"]!.longName, "root")
    XCTAssertEqual(fs1.flags["v"]!.longName, "verbose")
    XCTAssertEqual(fs1.flags["verbose"]!.longName, "verbose")
    XCTAssertEqual(fs1.flags["root"]!.longName, "root")
    XCTAssertEqual(fs1.flags["debug"]!.longName, "debug")
  }
  
  func testItCanGenerateFlagSetSubCommand() {
    let fs1 = show.flagSet
    
    XCTAssertEqual(fs1.flags["d"]!.longName, "debug")
    XCTAssertEqual(fs1.flags["v"]!.longName, "verbose")
    XCTAssertEqual(fs1.flags["foo"]!.longName, "foo")
    XCTAssertEqual(fs1.flags["remote"]!.longName, "remote")
    XCTAssertEqual(fs1.flags["yy"]!.longName, "yy")
    XCTAssertNil(fs1.flags["xx"])
    XCTAssertNil(fs1.flags["root"])
  }
  
  func testItCanGenerateFlagSetSubCommandAndDoesOverride() {
    let fs1 = rebase.flagSet
    
    XCTAssertEqual(fs1.flags["d"]!.longName, "debug")
    XCTAssertEqual(fs1.flags["v"]!.longName, "varvar")
    XCTAssertNil(fs1.flags["root"])
  }
  
  func testItCanGetTheRoot() {
    let r1 = git.root
    XCTAssertEqual(r1.name, "git")
    
    let r2 = show.root
    XCTAssertEqual(r2.name, "git")
  }
  
  func testItCanGetThePathOfACommand() {
    let p1 = git.path
    XCTAssertEqual(p1, ["git"])
    
    let p2 = show.path
    XCTAssertEqual(p2, ["git", "remote", "show"])
  }
  
  
  func testItCanStripFlags() {
    
  }
  
  // docker -D -v -a ps
  // docker -D -v --build "ddd" ps
  // docker -D -v --build="ddd" ps
  // docker -Dva ps
  // docker -Dva=true ps
  // docker -Dva=0 ps
  // docker -Dvab="../../"
  // docker -f "ddddd"
  
}
