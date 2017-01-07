# Guaka

[![Build Status](https://travis-ci.org/oarrabi/Guaka.svg?branch=master)](https://travis-ci.org/oarrabi/Guaka)
[![codecov](https://codecov.io/gh/oarrabi/Guaka/branch/master/graph/badge.svg)](https://codecov.io/gh/oarrabi/Guaka)
[![Platform](https://img.shields.io/badge/platform-osx-lightgrey.svg)](https://travis-ci.org/oarrabi/Guaka)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/oarrabi/Guaka)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Guaka` is the smartest and most beautiful (POSIX compliant) Command line framework for Swift. Inspired by [cobra](https://github.com/spf13/cobra).   

Also, it is currently in early stages of development and may do scary stuff including and not limited to eat your laundry and/or scare your neighbors.

## Is it any good?

### [Yes](https://news.ycombinator.com/item?id=3067434)

## Why?
- **It can be statically linked**: No libFoundation, and does no rely on many thirdparty libs.
- **POSIX compliant flag parsing**: Handles both short and long flag names. Flag names can appear anywhere.
- **Create modern and familar command line apps**: Inspied and aims to enable the creating of CLIs in the vein of widely used projects: Docker, Kubernetes, OpenShift and Hugo, etc.
- **Safe and crash free**: 100% safe code (e.g no unsafe code) also extensively covered with tests and with use cases.

# Features
- [x] Easy to use API: Create a modern command line app in 2 lines.
- [x] Super costumizable Commands and Flags; costumize the usage, the short message, long message, example and others
- [x] [POSIX-Compliant](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap12.html) flags: Handles short and long flags (-f, --flag)
- [x] Commands can have code sub-comamnds. Allowing you to create cli apps similar to git `git remote show`
- [x] Inheritable and non inheritable flags. Create root flags that are inherited from all the command's sub-commands
- [x] Automatically generates help message for your commands, sub-commands and flags
- [x] Handles user input errors with useful help messages
- [x] Costumizable help and error messages
- [x] Type safe flags: specify the type of the flag when defining it and Guaka will make sure the user inputs the correct flag type
- [x] Custom flag support; you can define your own flag types
- [x] Command and Flag deprecation; guaka will the user know that they are using deprecated command/flags
- [x] Command and Flag aliasing; you can alias a command or a flag to different names
- [x] Define code that run before the command and after the command is executed
- [x] Aptly documented: lots of documentation in code (we tried)
- Smart generator to easily bootstrap your CLIs (WIP)

Planned Features:
- [ ] Generate Markdown documentation
- [ ] Levenshtein distance for subcommand names
- [ ] Man pages and bash/zsh/tcsh completions
- [ ] Generate a command line application from a configuration (Yaml, Taml, Json)file
- [ ] Carthage and Cocoapod support

## Structure

With Guaka you can build modern command line applications that are commposed of **Commands** and **Flags**. 

Each command represent an action with flags that represent switches or modifiers on this command. Also, each command can have a group of sub-commands under it.

With Guaka you can build command line applicatations with interfaces like the following:

```bash
> git checkout "NAME Of Branch"
```

`git` command cli has a `checkout` subcommand that accepts a string as its argument.

```bash
> docker ps --all
```

`docker` command cli has `ps` subcommand that accepts the `--all` flag.

### Command

The `Command` it the main object of a Guaka cli project. It represents a verb with a block that will get executed.

In the `docker ps --all` example. We have a `docker` command that has a `ps` command as its sub-command.

```bash
└── docker
    ├── ps
    └── ...
```

The `Command` class has a lot of costumization objects. At its minimum a command must have the following:

```swift
let command = Command(usage: "mycommand") { flags, args in
  // the flags passed to the command
  // args the positional arguments passed to the command
}
```

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

## Installation
You can install Guaka using Swift package manager (SPM).   
Add Guaka as dependency in your `Package.swift`

```swift
import PackageDescription

let package = Package(name: "YourPackage",
  dependencies: [
    .Package(url: "https://github.com/getGuaka/Guaka.git", majorVersion: 0),
  ]
)
```

## Usage
You can create you Guaka command line application using the `guaka` generator app or by manually creating a swift project.

### Using guaka generator

### Manual Usage
We start by creating a swift executable project:

```
swift package init --type executable
```

Add `Guaka` library to your `Package.swift` file

```
import PackageDescription

let package = Package(name: "YourPackage",
  dependencies: [
    .Package(url: "https://github.com/getGuaka/Guaka.git", majorVersion: 0),
  ]
)
```

Run `swift package fetch` to fetch the dependencies.

Next, lets add our first command. Go to `main.swift` and type in the following:

```
import Guaka

let command = Command(usage: "hello") { _, args in
  print("You passed \(args) to your Guaka app!")
}
```



## Topics

### Commands

#### Hooks

### Flags

### Help Generation

## Tests
Tests can be found [here](https://github.com/oarrabi/Guaka/tree/master/Tests).

Run them with
```
swift test
```

## Todo

For a list of task planned, head to the [Guaka GitHub project](https://github.com/oarrabi/Guaka/projects/1)

## Contributing

Just send a PR! We don't bite ;)
