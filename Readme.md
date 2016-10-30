# Guaka

[![Build Status](https://travis-ci.org/oarrabi/guaka.svg?branch=master)](https://travis-ci.org/oarrabi/guaka)
[![codecov](https://codecov.io/gh/oarrabi/guaka/branch/master/graph/badge.svg)](https://codecov.io/gh/oarrabi/guaka)
[![Platform](https://img.shields.io/badge/platform-osx-lightgrey.svg)](https://travis-ci.org/oarrabi/guaka)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/oarrabi/guaka)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Guaka` is the smartest and most beautiful (POSIX compliant) Command line framework for Swift. Inspired by [cobra](https://github.com/spf13/cobra). 
(Also its a WIP)

`Guaka` promises the following:
- It can be statically linked: That means it does not use libFoundation, and does no rely on many thirdparty libs.
- Posix complient flags: It handles both short and long flag names. Flag names can appear anywhere (ala posix)
- Familiar with widely used cli apps: Have you used Docker, Kubernetes, OpenShift and Hugo. 
- Safe and crash free: Extensively covered with tests and with use cases.

Features:
- Easy to use interface (WIP)
- POSIX-Complient flags
- Inheritable and non inheritable flags
- Generator cli to easy generate a cli app (WIP)
- Levenshtein distance for subcommand names (WIP)
- Ability to have commands and subcommands (like git remote show has 3 subcommands)
- Generate a good help message (WIP)
- Man pages and bash completion (WIP)
- Manage settings from configuration files (WIP)
- Provides a way to generate custom help messages (WIP)
- Type safe flags (WIP)
- Ability to define your own structures as flag parameters (WIP)
- Generate command line apps from a configuration file (WIP)
- WIP

## Usage

WIP....


## Installation
You can install Guaka using Swift package manager (SPM) and carthage

### Swift Package Manager
Add swiftline as dependency in your `Package.swift`

```
  import PackageDescription

  let package = Package(name: "YourPackage",
    dependencies: [
      .Package(url: "https://github.com/oarrabi/guaka.git", majorVersion: 0),
    ]
  )
```

### Carthage
    github 'oarrabi/guaka'

## Tests
Tests can be found [here](https://github.com/oarrabi/guaka/tree/master/Tests). 

Run them with 
```
swift test
```

## Todo
This is going to be a long list:

- Static compilation is not yet there. It depends on a [pr on swift-lang](https://github.com/apple/swift/pull/5269) being merged.
- Create a better API to add commands.
- Add generation cli to generate commands.
- Handle errors when commands are not found.
- Implement Levenshtein distance when commands are not matched.
- Actually call the run block in the Command when the command is matched.
- Implement PreRun and PostRun.
- Implement PersistentPreRun and PersistentPostRun.
- Implement a way of reading the args when calling the run method.
- Consolidate and refactor the Command and Flag structs.
- Review the public interface of the library.
- Generate help message
- Generate man page and bash completion
- Implement environment file reading and writing
- Implement template engine for help messages
- Flag and command deprication.
- Flag and command aliasing.
- Review the type safty of the flags
- Generate command line apps from a yaml, taml, json files
- Add more documentation on the code.