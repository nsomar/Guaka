<p align="center">
<br/>
<br/>
<img src="https://rawgit.com/nsomar/Guaka/master/Misc/logo.svg" height=150px/>
<br/><br/><br/><br/>
</p>

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Build Status](https://travis-ci.org/nsomar/Guaka.svg?branch=master)](https://travis-ci.org/nsomar/Guaka)
[![codecov](https://codecov.io/gh/nsomar/Guaka/branch/master/graph/badge.svg)](https://codecov.io/gh/nsomar/Guaka)
[![Platform](https://img.shields.io/badge/platform-osx-lightgrey.svg)](https://travis-ci.org/nsomar/Guaka)
![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg) 
[![Analytics](https://ga-beacon.appspot.com/UA-90175183-1/repo/github/guaka?pixel)](https://github.com/nsomar/Guaka)


`Guaka` - Smart and beautiful POSIX compliant CLI framework for Swift.   
It helps you create modern and familiar CLI apps in the vein of widely used projects such as: Docker, Kubernetes, OpenShift, Hugo and more!.

Guaka is both a swift library and a command line application that help generate Guaka projects. Inspired by the amazing [Cobra package](https://github.com/spf13/cobra) from the Golang's ecosystem.

## Is it any good?

### [Yes](https://news.ycombinator.com/item?id=3067434)

## Why?
- **Simple and idiomatic API**: No rocket science here! Full modern CLI apps in a few lines of code.
- **Easy to use**: With the Guaka generator you can bootstrap your own CLI in matter of minutes.
- **Lightweight and portable**: No libFoundation and friends, can be statically linked.
- **POSIX compliant**: Short and long flags, flags can appear anywhere.
- **Safe and crash free**: 100% safe code as in: unsafe code.
- **Tested**: Close to 100% test coverage and 100% dog fooded (the Guaka CLI app is written in, yes you guessed, Guaka ;).
- **Documented**: Lots of docs and samples.
- **Batteries included**: We created a set cross-platform Swift libraries to [work with files](https://github.com/getGuaka/FileUtils.git), [regular expressions](https://github.com/getGuaka/Regex.git), [launching processes](https://github.com/getGuaka/Process.git), [dealing with the environment variables](https://github.com/getGuaka/Env.git) and [colorizing ouput](https://github.com/getGuaka/Colorizer) so you can be productive instantaneously.

----

## In this readme

- [Features](#features)
- [Introduction](#introduction)
  - [Command](#command)
  - [Flag](#flag)
- [Getting started](#getting-started)
  - [Using Guaka generator](#using-guaka-generator)
  - [Manually implementing Guaka](#manually-implementing-guaka)
- [Cross-Platform utility libraries - aka batteries](#cross-platform-utility-libraries-aka-batteries)
- [Documentation](#documentation)
  - [Command documentation](#command-documentation)
  - [Flag documentation](#flag-documentation)
  - [Help customization](#help-customization)
- [Tests](#tests)
- [Future work](#future-work)
- [Contributing](#Contributing)

## Features
- [x] Easy to use API: Create a modern command line app in 2 lines.
- [x] Super customizable Commands and Flags; customize the usage, the short message, long message, example and others
- [x] [POSIX-Compliant](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html) flags: Handles short and long flags (-f, --flag)
- [x] Commands can have code sub-commands. Allowing you to create CLI apps similar to git `git remote show`
- [x] Inheritable and non-inheritable flags. Create root flags that are inherited from all the command's sub-commands
- [x] Batteries included: With our
  [Args](https://github.com/getGuaka/Args.git),
  [Colorizer](https://github.com/getGuaka/Colorizer),
  [Env](https://github.com/getGuaka/Env.git),
  [FileUtils](https://github.com/getGuaka/FileUtils.git),
  [Process](https://github.com/getGuaka/Process.git),
  [Prompt](https://github.com/getGuaka/Prompt.git),
  [Regex](https://github.com/getGuaka/Regex.git) and
  [Run](https://github.com/getGuaka/Run.git)
  cross-platform libraries you
  can be productive instantaneously.
- [x] Automatically generates help message for your commands, sub-commands and flags
- [x] Handles user input errors with useful help messages
- [x] Customizable help and error messages
- [x] Type safe flags: specify the type of the flag when defining it and Guaka will make sure the user inputs the correct flag type
- [x] Custom flag support; you can define your own flag types
- [x] Command and Flag deprecation; guaka will the user know that they are using deprecated command/flags
- [x] Command and Flag aliasing; you can alias a command or a flag to different names
- [x] Define code that runs before the command and after the command is executed
- [x] Aptly documented: lots of documentation in code (we tried)
- [x] Levenshtein distance for subcommand names

Planned Features:
- [ ] Generate Markdown documentation
- [ ] Man pages and bash/zsh/tcsh completions
- [ ] Generate a command line application from a configuration (Yaml, Taml, Json)file
- [ ] Carthage and CocoaPods support (maybe?)

## Introduction

With Guaka you can build modern command line applications that are composed of **Commands** and **Flags**. 

Each command represents an action with flags that represent switches or modifiers on this command. Also, each command can have a group of sub-commands under it.

With Guaka you can build command line applications with interfaces like the following:

```
> git checkout "NAME Of Branch"
```

`git` command CLI has a `checkout` subcommand that accepts a string as its argument.

```
> docker ps --all
```

`docker` command CLI has `ps` subcommand that accepts the `--all` flag.

Guaka also automatically generate the command line help for your command tree. This help is accessible by passing `-h` or `--help` to any of your commands:

```
> docker --help
> git checkout -h
```

The help displays the commands, subcommands, and flag information.

### Command

The `Command` it the main object of a Guaka CLI project. It represents a verb with a block that will get executed.

In the `docker ps --all` example. We have a `docker` command that has a `ps` command as its sub-command.

```
└── docker
    ├── ps
    └── ...
```

The `Command` class has a lot of customization objects. At its minimum, a command must have the following:

```swift
let command = Command(usage: "command") { flags, args in
  // the flags passed to the command
  // args the positional arguments passed to the command
}
```

Check the [Command documentation](https://getguaka.github.io/Classes/Command.html)

### Flag
A `Flag` represent an option or switch that a `Command` accepts. Guaka supports both short and long flag formats (inline with POSIX flags).

In `docker ps --all`. `--all` is a flag that `ps` accepts.

Flags have lots of costumization objects. The simplest way to create a flag and add it to ps would look like the following:

```swift
let flag = Flag(longName: "all", value: false, description: "Show all the stuff")
let command = Command(usage: "ps", flags: [flag]) { flags, args in
  flags.getBool(name: "all")
  // args the positional arguments passed to the command
}
```

Above we defined a `Flag` with `all` as longName  and a default value of `false`.    
To read this flag in the command we use `flags.getBool(...)` which returns the flag value.

Check the [Flag documentation](https://getguaka.github.io/Structs/Flag.html)

## Getting started
You can create you Guaka command line application using the `guaka` generator app or by manually creating a swift project.

### Using Guaka generator
The easiest way to use guaka is by using `guaka` generator command line app. This CLI app helps you generate a Guaka project.

First lets install `guaka` using brew:

```
> brew install getGuaka/tap/guaka
```

As an alternative, you can install `guaka` using the installation script (This works on macOS and Linux):

```
> curl https://raw.githubusercontent.com/getGuaka/guaka-cli/master/scripts/install.sh -sSf | bash
```

(Note: For other installation options check [Guaka Generator readme](https://github.com/getGuaka/guaka-cli#installing).)

Check that `guaka` is installed:

```
> guaka --version
 
Version x.x.x
```

To understand `guaka` generator, let's say we want to create the following command tree:
- git checkout
- git remote
- git remote show
- git remote --some-flag

#### guaka create
To create a new Guaka project you can run `guaka create`. This command creates a new swift project and the swift project files required to have a minimal Guaka project.

`guaka create` behaves differently based on the parameter that is passed it:

- If nothing is passed, the project is created in the current working folder.
- If a name is passed, a new folder with that name will be created. This folder will contain the Guaka project.
- If an absolute or relative path is passed. Guaka will resolve the path and create the project there.

To create the `git` command we described above, we do the following:

```
> guaka create git
```

The generated Guaka swift project structure will look like:

```
├── Package.swift
└── Sources
    ├── main.swift
    ├── root.swift
    └── setup.swift
```

Let's run this newly created project.

```
> swift build
```

The generated built binary will be located under `./.build/debug/git`.

```
> ./.build/debug/git --help
```

Which will print out:

```
Usage:
  git

Use "git [command] --help" for more information about a command.
```

#### guaka add
After running `guaka create` we have a skeleton Guaka project. This project will only have a root command.

You can add new sub-commands to your project you can use `guaka add ...`.

Lets add the checkout and remote command. Both these commands are sub-commands of the root.

```
> guaka add checkout
> guaka add remote
```

Next, lets add a sub-command for `remote`:

```
> guaka add show --parent remote
```

The generated Guaka swift project structure will look like:

```
├── Package.swift
└── Sources
    ├── main.swift
    ├── root.swift
    ├── checkout.swift
    ├── remote.swift
    ├── show.swift
    └── setup.swift
```

#### Adding a flag
To add a flag we need to alter the command swift file. To add a flag to our sample `Command` (git remote --some-flag). We edit `Sources/remote.swift`.

Locate the `command.add(flags: [])` function call and edit it to look like this:

```swift
command.add(flags: [
  Flag(longName: "some-name", value: false, description: "...")
  ]
)
```

Now save the file and build it with `swift build`. Run the built binary `./.build/debug/git -h` and check the created command structure.

Check [add flag documentation](https://getguaka.github.io/Classes/Command.html#/s:FC5Guaka7Command3addFT4flagVS_4Flag_T_)

### Manually implementing Guaka
Alternatively, you can create a Guaka command line app by implementing `Guaka` in a swift project.

#### Adding Guaka to the project dependencies
We start by creating a swift executable project:

```
swift package init --type executable
```

Add `Guaka` library to your `Package.swift` file

```swift
import PackageDescription

let package = Package(name: "YourPackage",
  dependencies: [
    .Package(url: "https://github.com/nsomar/Guaka.git", majorVersion: 0),
  ]
)
```

Run `swift package fetch` to fetch the dependencies.

#### Implementing the first command
Next, lets add our first command. Go to `main.swift` and type in the following:

```swift
import Guaka

let command = Command(usage: "hello") { _, args in
  print("You passed \(args) to your Guaka app!")
}

command.execute()
```

Run `swift build` to build your project. Congratulations! You have created your first Guaka app.

To run it execute:

```
> ./.build/debug/{projectName} "Hello from cli"
```

You should get:

```
You passed ["Hello from cli"] to your Guaka app!
```

Check the [Command documentation](https://getguaka.github.io/Classes/Command.html)

#### Adding a flag to the command
Lets proceed at adding a flag. Go to `main.swift` and change it to the following:

```swift
import Guaka

let version = Flag(longName: "version", value: false, description: "Prints the version")

let command = Command(usage: "hello", flags: [version]) { flags, args in
  if let hasVersion = flags.getBool(name: "version"),
     hasVersion == true {
    print("Version is 1.0.0")
    return
  }

  print("You passed \(args) to your Guaka app!")
}

command.execute()
```

The above adds a flag called `version`. Notices how we are getting the flag using `flags.getBool`.

Now lets test it by building and running the command:

```
> swift build
> ./.build/debug/{projectName} --version

Version is 1.0.0
```

Check [add flag documentation](https://getguaka.github.io/Classes/Command.html#/s:FC5Guaka7Command3addFT4flagVS_4Flag_T_)

#### Adding a subcommand
To add a subcommand we alter `main.swift`. Add the following before calling `command.execute()`

```swift
// Create the command
...

let subCommand = Command(usage: "sub-command") { _, _ in
  print("Inside subcommand")
}

command.add(subCommand: subCommand)

command.execute()
```

Now build and run the command:

```
> swift build
> ./.build/debug/{projectName} sub-command

Inside subcommand
```

Check [add sub command](Check [add flag documentation](https://getguaka.github.io/Classes/Command.html#/s:FC5Guaka7Command3addFT4flagVS_4Flag_T_))

#### Displaying the command help message
Guaka automatically generates help for your commands. We can get the help by running:

```
> ./.build/debug/{projectName} --help

Usage:
  hello [flags]
  hello [command]

Available Commands:
  sub-command

Flags:
      --version   Prints the version

Use "hello [command] --help" for more information about a command.
```

Notice how the command the sub-command and flag info are displayed.

Read more about the [help message](https://getguaka.github.io/Protocols/HelpGenerator.html)

## Cross-Platform utility libraries aka batteries

Writing a command line application is more than just parsing the command line arguments and flags. 

Swift ecosystem is still very young and lacks of a cross-platform standard library. We did not wanted to make Guaka depend on libFoundation, so we rolled up our sleeves and built a few small cross-platform (as in whenever there is a usable C standard library) libraries. so you don't have to and can be productive instantaneously. Also , they are usable on their own. You are welcome to use them too! <3:

- [FileUtils](https://github.com/getGuaka/FileUtils.git): Help you work with files, directories and paths. 
- [Regex](https://github.com/getGuaka/Regex.git): Match and capture regex.
- [Process](https://github.com/getGuaka/Process.git): Launch external programs and capture their standard output and standard error.
- [Env](https://github.com/getGuaka/Env.git): Read and write environment variables sent to your process.

## Documentation

### Command documentation
`Command` represents the main class in Guaka. It encapsulates a command or subcommand that Guaka defines.

For the full [Command documentation](https://getguaka.github.io/Classes/Command.html)

#### Usage and Run block
As a minimum, a command needs a usage string and a `Run` block. The usage string describes how this command can be used.

- If the usage is a single string `command-name`; the command will have that name
- If the usage is a string with spaces `command-name args..`; the command name is the first segment of the string.

```swift
let c = Command(usage: "command-name") { _, args in
}
```

The `Run` block gets called with two parameters. The `Flags` class which contains the flags passed to the command and the `args` which is an array of arguments passed to the command.

The `Command` constructor takes lots of parameters. However most of them have sensible defaults. Feel free to fill as much or as little of the parameters as you want:

```
Command(usage: "...",
        shortMessage: "...",
        longMessage: "...",
        flags: [],
        example: "...",
        parent: nil,
        aliases: [],
        deprecationStatus: .notDeprecated,
        run: {..})
```

At a minimum, you need to pass the `usage` and the `run` block. Refer to the code documentation for info about the parameters.

Check the [Flags documentation](https://getguaka.github.io/Structs/Flags.html)

#### Adding Sub-commands to the command
Commands are organised in a tree structure. Each command can have zero, one or many sub-commands associated with it.

We can add a sub-command by calling `command.add(subCommand: theSubCommand)`. If we wanted to add `printCommand` as a sub-command to `rootCommand`, we would do the following:

```swift
let rootCommand = //Create the root command
let printCommand = //Create the print command

rootCommand.add(subCommand: printCommand)
```

Alternatively, you can pass the `rootCommand` as the `parent` when creating the `printCommand`:

```swift
let rootCommand = //Create the root command
let printCommand = Command(usage: "print",
                           parent: rootCommand) { _, _ in
}
```

Our command line application will now respond to both:

```
> mainCommand
> mainCommand print
```

You can build your command trees in this fashion and create modern, complex, elegant command line applications.

#### Short and Long messages
The `Command` defines the `shortMessage` and the `longMessage`. These are two strings that get displayed when showing the `Command` help.

```swift
Command(usage: "print",
        shortMessage: "prints a string",
        longMessage: "This is the long mesage for the print command") { _, _ in
} 
```

The `shortMessage` is shown when the command is a sub-command.

```
> mainCommand -h

Usage:
  mainCommand [flags]
  mainCommand [command]

Available Commands:
  print    prints a string

Use "mainCommand [command] --help" for more information about a command.
Program ended with exit code: 0
```

The `longMessage` is shown when getting help of the current command

```
> mainCommand print -h

This is the long message for the print command

Usage:
  mainCommand print

Use "mainCommand print [command] --help" for more information about a command.
Program ended with exit code: 0
```

#### Command flags
You can add a `Flag` to a command in two ways.

You can pass the flags in the constructor:

```
let f = Flag(longName: "some-flag", value: "value", description: "flag information")

let otherCommand = Command(usage: "print",
        shortMessage: "prints a string",
        longMessage: "This is the long mesage for the print command",
        flags: [f]) { _, _ in
}
```

Alternatively, you can call `command.add(flag: yourFlag)`.

Now the flag will be associated with the command. We can see it if we display the help of the command.

```
> mainCommand print -h

This is the long message for the print command

Usage:
  mainCommand print [flags]

Flags:
      --some-flag string  flag information (default value)

Use "mainCommand print [command] --help" for more information about a command.
```

#### Command example section
You can attach a textual example on how to use the command. You do that by setting the `example` variable in the `Command` (or by filling the `example` parameter in the constructor):

```swift
printCommand.example = "Use it like this `mainCommand print \"the string to print\""
```

Then we can see it in the command help:

```
> mainCommand print -h

This is the long message for the print command

Usage:
  mainCommand print

Examples:
Use it like this `mainCommand print "the string to print"

Use "mainCommand print [command] --help" for more information about a command.
```

##### Command aliases and deprecation
You can mark a command as deprecated by setting the `deprecationStatus` on the command.

```swift
printCommand.deprecationStatus = .deprecated("Dont use it")
```
When the user call this command, a deprecation message will be displayed.

Aliases help giving command alternative names. We can have both `print` and `echo` represent the same command:

```swift
printCommand.aliases = ["echo"]
```

#### Different kind of Run Hooks
The command can have different run Hooks. If they are set, they will be executed in this order.

- `inheritablePreRun`
- `preRun` 
- `run`
- `postRun`
- `inheritablePostRun`

When a command is about to execute. It will first search for its parent list. If any of its parents have an `inheritablePreRun` then Guaka will first execute that block.

Next the current command `preRun` is executed. Followed by the `run` and the `postRun`.

After that, as with the `inheritablePreRun`, Guaka will search for any parent that has an `inheritablePostRun` and execute that too.

All of `inheritablePreRun`, `preRun`, `postRun` and `inheritablePostRun` blocks return a boolean. If they return `false` then the command execution will end. 

This allows you to create smart command trees where the parent of the command can decide if any of it sub-commands must continue executing.

For example. The parent command can define a version flag. If this flag is set, the parent will handle the call and return false from its `inheritablePreRun`. Doing that help us to not repeat the version handling in each sub-command.

The example bellow shows this use case:

```swift
// Create root command
let rootCommand = Command(usage: "main")  { _, _ in
  print("main called")
}

// Create sub command
let subCommand = Command(usage: "sub", parent: rootCommand) { _, _ in
  print("sub command called")
}

// Add version flag to the root
// We made the version flag inheritable 
// print will also have this flag as part of its flags
let version = Flag(longName: "version", value: false,
                   description: "Prints the version", inheritable: true)

rootCommand.add(flag: version)
rootCommand.inheritablePreRun = { flags, args in
  if
    let version = flags.getBool(name: "version"),
    version == true {
    print("Version is 0.0.1")
    return false
  }

  return true
}

rootCommand.execute()
```

Now we can get the version by calling:

```
> main --version
> main sub --version
```

#### Exiting early from a command

In some sitiuation you might want to exit early from a command you can use `command.fail(statusCode: errorCode, errorMessage: "Error message")`

```swift
let printCommand = Command(usage: "print",
                           parent: rootCommand) { _, _ in
    // Error happened
    printCommand.fail(statusCode: 1, errorMessage: "Some error happaned")
}
```

### Flag documentation

A `Flag` represent an option or switch that a `Command` accepts. Guaka defines 4 types of flags; integer, boolean, string and custom types.

Check the full [Flag documentation](https://getguaka.github.io/Structs/Flag.html)

#### Creating a flag with default value
To create a `Flag` with default value, we call do the following:

```swift
let f = Flag(longName: "version", value: false, description: "prints the version")
```

We created a flag that has a `longName` of `version`. Has a default value of `false` and has a description. This creates a POSIX compliant flag. To set this flag:

```
> myCommand --version
> myCommand --version=true
> myCommand --version true
```

`Flag` is a generic class, in the previous example, since we set `false` as its value, that creates a `boolean` `Flag`. If you try to pass a non-bool argument in the terminal, Guaka will display an error message.

The flag constructor, as with the command, defines lots of parameters. Most of them have sensible defaults, so feel free to pass as much, or little, as you need. 

For example, we could set the flag short name by doing this:

```swift
Flag(shortName: "v", longName: "version", value: false, description: "prints the version")
```

Now we can either use `-v` or `--version` when calling the command.

#### Creating a flag with flag type
We can create a flag that has no default value. This type of flag can be marked as optional or required.

To create an optional flag
```
Flag(longName: "age", type: Int.self, description: "the color")
```

Here we defined a flag that has an int value. If we execute the command with a non-integer value, Guaka will inform us of an error.

A required flag can be created by passing true to the `required` argument in the `Flag` constructor:

```swift
Flag(longName: "age", type: Int.self, description: "the color", required: true)
```

Now if we call the command without setting the `--age=VALUE`. Guaka will display an error.

#### Reading the flag values
When the `Command` `run` block is called, a `Flags` argument will be sent to the block. This `Flags` argument contains the values for each flag the command defined.

This example illustrate flag reading:

```swift
// Create the flag
var uppercase = Flag(shortName: "u", longName: "upper",
                     value: false, description: "print in bold")

// Create the command
let printCommand = Command(usage: "print", parent: rootCommand) { flags, args in

  // Read the flag
  let isUppercase = flags.getBool(name: "upper") ?? false

  if isUppercase {
    print(args.joined().uppercased())
  } else {
    print(args.joined())
  }
}

// Add the flag
printCommand.add(flag: uppercase)
```

Let's execute this command:

```
> print "Hello World"

Hello World

> print -u "Hello World"

HELLO WORLD
```

`Flags` class defines methods to read all the different type of flags:

- `func getBool(name: String) -> Bool?`
- `func getInt(name: String) -> Int?`
- `func getString(name: String) -> String?`
- `func get<T: FlagValue>(name: String, type: T.Type) -> T?`

Check the full [Flags documentation](https://getguaka.github.io/Structs/Flags.html)

#### Inheritable flags
Flags that are set to a parent `Command` can be also inherited to the sub-commands by passing `true` to the `inheritable` argument in the flag constructor.

To create an inheritable flag:

```swift
var version = Flag(longName: "version", value: false,
                   description: "print in bold", inheritable: true)

rootCommand.add(flag: version)
```

This makes `--version` a flag that can be set in the `rootCommand` and any of its sub-commands.

#### Flag deprecation
As with a `Command`, a `Flag` can be set to be deprecated by setting it's `deprecationStatus`:

```swift
var version = Flag(longName: "version", value: false,
                   description: "print in bold", inheritable: true)
version.deprecationStatus = .deprecated("Dont use this flag")
```

Guaka will warn each time this flag is set.

#### Flag with custom types
Out of the box, you can create flags with integer, boolean and string values and types. If you however, want to define custom types for your flags, you can do it by implementing the `FlagValue` protocol.

Let's define a flag that has a `User` type:

```swift
// Create the enum
enum Language: FlagValue {
  case english, arabic, french, italian

  // Try to convert a string to a Language
  static func fromString(flagValue value: String) throws -> Language {
    switch value {
    case "english":
      return .english
    case "arabic":
      return .arabic
    case "french":
      return .french
    case "italian":
      return .italian
    default:

      // Wrong parameter passed. Throw an error
      throw FlagValueError.conversionError("Wrong language passed")
    }
  }

  static var typeDescription: String {
    return "the language to use"
  }
}

// Create the flag
var lang = Flag(longName: "lang", type: Language.self, description: "print in bold")

// Create the command
let printCommand = Command(usage: "print", parent: rootCommand) { flags, args in

  // Read the flag
  let lang = flags.get(name: "lang", type: Language.self)
  // Do something with it
}

// Add the flag
printCommand.add(flag: lang)

// Execute the command
printCommand.execute()
```

Notice that incase the argument is not correct we throw a `FlagValueError.conversionError`. This error will be printed to the console.

```
> print --lang undefined "Hello"

Error: wrong flag value passed for flag: 'lang' Wrong language passed
Usage:
  main print [flags]

Flags:
      --lang the language to use  print in bold 

Use "main print [command] --help" for more information about a command.

wrong flag value passed for flag: 'lang' Wrong language passed
exit status 255
```

Check the full [FlagValue documentation](https://getguaka.github.io/Protocols/FlagValue.html) and the [FlagValueError documentation](https://getguaka.github.io/Enums/FlagValueError.html).

### Help customization
Guaka allows you to customize the format of the generated help. You can do that by implementing the `HelpGenerator` and passing your class to `GuakaConfig.helpGenerator`.

The `HelpGenerator` protocol defines all the sections of the help message that you can subclass. `HelpGenerator` provides protocol extensions with defaults for all the section. That allows you to cherry-pick which sections of the help you want to alter.

Each of the variable and section in the `HelpGenerator` corresponds to a section in the printed help message. To get the documentation of each section, refer to the in-code documentation of `HelpGenerator`.

Say we only want to change the `usageSection` of the help, we would do the following:

```swift
struct CustomHelp: HelpGenerator {
  let commandHelp: CommandHelp

  init(commandHelp: CommandHelp) {
    self.commandHelp = commandHelp
  }

  var usageSection: String? {
    return "This is the usage section of \(commandHelp.name) command"
  }
}

GuakaConfig.helpGenerator = CustomHelp.self
```

Any `HelpGenerator` subclass will have a `commandHelp` variable which is an instance of `CommandHelp` structure. This structure contains all the info available for a command.

Check the full [HelpGenerator documentation](https://getguaka.github.io/Protocols/HelpGenerator.html)

## Tests
Tests can be found [here](https://github.com/nsomar/Guaka/tree/master/Tests).

Run them with
```
swift test
```

## Future work

- [x] Levenshtein distance for subcommand names
- [ ] Generate Markdown documentation
- [ ] Man pages and bash/zsh/tcsh completions
- [ ] Generate a command line application from a configuration (Yaml, Taml, Json)file
- [ ] Carthage and Cocoapod support

For a list of task planned, head to the [Guaka GitHub project](https://github.com/nsomar/Guaka/projects/1)

## Contributing

Just send a PR! We don't bite ;)
