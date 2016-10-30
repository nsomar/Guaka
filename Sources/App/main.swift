print("Hello, world!")


struct Flag {
  let shortName: String
  let longName: String
  let isBool: Bool
  let defaultValue: Any
}

struct Command {
  let name: String
  let flags: [Flag]
  let commands: [Command]
}




//
