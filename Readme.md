# Guaka

[![Build Status](https://travis-ci.org/oarrabi/Guaka.svg?branch=master)](https://travis-ci.org/oarrabi/Guaka)
[![codecov](https://codecov.io/gh/oarrabi/Guaka/branch/master/graph/badge.svg)](https://codecov.io/gh/oarrabi/Guaka)
[![Platform](https://img.shields.io/badge/platform-osx-lightgrey.svg)](https://travis-ci.org/oarrabi/Guaka)
[![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)](https://travis-ci.org/oarrabi/Guaka)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Guaka` is the smartest and most beautiful (POSIX compliant) Command line framework for Swift. Inspired by [cobra](https://github.com/spf13/cobra). Also, it is currently in early stages of development and may do scary stuff including and not limited to eat your laundry and/or scare your neighbors.

## Is it any good?

## [Yes](https://news.ycombinator.com/item?id=3067434)

## Why?
- It can be statically linked: No libFoundation, and does no rely on many thirdparty libs.
- POSIX compliant flag parsing: Handles both short and long flag names. Flag names can appear anywhere.
- Inspied and aims to enable the creating of CLIs in the vein of widely used projects: Docker, Kubernetes, OpenShift and Hugo, etc.
- Safe and crash free: 100% safe code (e.g no unsafe code) also extensively covered with tests and with use cases.

Features:
- Easy to use API
- POSIX-Compliant flags
- Inheritable and non inheritable flags
- Smart generator to easily bootstrap your CLIs (WIP)
- Levenshtein distance for subcommand names (WIP)
- Ability to have commands and subcommands (`git remote show` 3 subcommands)
- Good help messages (WIP)
- Man pages and bash/zsh/tcsh completions (WIP)
- Manage settings from configuration files (WIP)
- Provides a way to generate custom help messages (WIP)
- Type safe flags (WIP)
- Ability to define your own structures as flag parameters (WIP)
- Generate command line apps from a configuration file (WIP)

## Usage

WIP....

## Installation
You can install Guaka using Swift package manager (SPM) and carthage

### Swift Package Manager
Add Guaka as dependency in your `Package.swift`

```
  import PackageDescription

  let package = Package(name: "YourPackage",
    dependencies: [
      .Package(url: "https://github.com/oarrabi/Guaka.git", majorVersion: 0),
    ]
  )
```

### Carthage
    github 'oarrabi/Guaka'

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
