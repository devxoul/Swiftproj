# Swiftproj

[![Gem](https://img.shields.io/gem/v/swiftproj.svg)](https://rubygems.org/gems/swiftproj)
[![Build Status](https://travis-ci.org/devxoul/Swiftproj.svg?branch=master)](https://travis-ci.org/devxoul/Swiftproj)

A command-line tool for managing Xcode project with Swift Package Manager. I wrote this to make it easy to deploy to Carthage in a Swift Package Manager only project.

## Basic Usage

```console
$ swiftproj help
    version               Displays the current version of swiftproj
    help                  Displays this help message
    configure-scheme      Configures a scheme to have buildable targets only
    add-systemframework   Adds a system framework to an existing target
    remove-framework      Removes a framework from a target
    generate-xcconfig     Generates a Xcode project file
    generate-xcodeproj    Generates a xcconfig file from podspec file
```

## Example

This is an example of generating Xcodeproj file and archiving for Carthage release.

```console
$ swiftproj generate-xcconfig --podspec URLNavigator.podspec
$ swiftproj generate-xcodeproj --xcconfig-overrides Config.xcconfig
$ swiftproj add-system-framework \
    --project URLNavigator.xcodeproj \
    --target QuickSpecBase \
    --framework Platforms/iPhoneOS.platform/Developer/Library/Frameworks/XCTest.framework
$ swiftproj configure-scheme \
    --project URLNavigator.xcodeproj \
    --scheme URLNavigator-Package \
    --targets URLNavigator,URLMatcher
$ carthage build --no-skip-current
$ carthage archive URLNavigator,URLMatcher
```

## Installation

```console
gem install swiftproj
```

## License

Swiftproj is under MIT license. See the [LICENSE](LICENSE) for more info.
