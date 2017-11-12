//
//  Command+Utilities.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 10/11/2016.
//
//

// MARK: Flags
extension Command {

  /// Gets the flagSet of the command
  var flagSet: FlagSet {

    let allFlags =
      iterateToRoot().reduce([Flag]()) { acc, command in
        let flagsToAdd = self === command ? command.flags : command.inheritableFlags
        return flagsToAdd + acc
    }

    return FlagSet(flags: allFlags)
  }

  private var inheritableFlags: [Flag] {
    return self.flags.filter { $0.inheritable }
  }

}


// MARK: Priave
extension Command {


  /// Return the path of a command
  /// if command git had a command named show that had a command named origin
  /// The path of origin is [git, show, origin]
  var path: [String] {
    return getPath(cmd: self, accumolator: []).reversed()
  }


  /// Return the root of a command
  var root: Command {
    var current: Command? = self

    while true {
      let previous = current
      current = current?.parent
      if current == nil {
        return previous!
      }
    }
  }


  /// Iterate from the current command to the root command
  fileprivate func iterateToRoot() -> AnyIterator<Command> {
    var currentCommand: Command? = self

    return AnyIterator<Command>.init({ () -> Command? in

      guard let c = currentCommand else { return nil }

      let prevCommand = c
      currentCommand = c.parent
      return prevCommand
    })
  }


  /// get the path of a command
  private func getPath(cmd: Command?, accumolator: [String]) -> [String] {
    guard let cmd = cmd else {
      return accumolator
    }

    var mut = accumolator
    mut.append(cmd.nameOrEmpty)
    return getPath(cmd: cmd.parent, accumolator: mut)
  }

}


extension Command {

  /// Return the name for a command with a usage string
  /// ----
  /// Example:
  ///    let x = Command.name(forUsage: "run [arguments]")
  ///    x //"run"
  static func name(forUsage usage: String) throws -> String {
    if usage.count == 0 {
      throw CommandError.wrongCommandUsageString(usage)
    }

    var name = ""
    if let index = usage.find(string: " ") {
      name = String(usage[usage.startIndex..<index])
    } else {
      name = usage
    }

    if name.count == 0 ||
      name.contains("/") ||
      name.contains("\\") ||
      name.first! == "-" {
      throw CommandError.wrongCommandUsageString(usage)
    }
    
    return name
  }
  
}
