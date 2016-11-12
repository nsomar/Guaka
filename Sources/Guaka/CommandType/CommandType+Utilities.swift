//
//  CommandType+Utilities.swift
//  Guaka
//
//  Created by Omar Abdelhafith on 10/11/2016.
//
//

// MARK: Flags
extension CommandType {

  var flagSet: FlagSet {

    let allFlags =
      iterateToRoot().reduce([Flag]()) { acc, command in
        let flagsToAdd = self.equals(other: command) ? command.flags : command.inheritableFlags
        return flagsToAdd + acc
    }

    return FlagSet(flags: allFlags)
  }

  private var inheritableFlags: [Flag] {
    return self.flags.filter { $0.inheritable }
  }

}


// MARK: Priave
extension CommandType {

  var path: [String] {
    return getPath(cmd: self, acc: []).reversed()
  }

  var root: CommandType {
    var current: CommandType? = self

    while true {
      let previous = current
      current = current?.parent
      if current == nil {
        return previous!
      }
    }
  }


  fileprivate func iterateToRoot() -> AnyIterator<CommandType> {
    var currentCommand: CommandType? = self

    return AnyIterator<CommandType>.init({ () -> CommandType? in

      guard let c = currentCommand else { return nil }

      let prevCommand = c
      currentCommand = c.parent
      return prevCommand
    })
  }

  private func getPath(cmd: CommandType?, acc: [String]) -> [String] {
    guard let cmd = cmd else {
      return acc
    }

    var mut = acc
    mut.append(cmd.name)
    return getPath(cmd: cmd.parent, acc: mut)
  }

}
