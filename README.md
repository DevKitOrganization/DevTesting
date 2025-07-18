# DevTesting

DevTesting is a small Swift 6 package that contains useful additions for writing tests with [Swift
Testing](https://github.com/swiftlang/swift-testing/).

  - `SeedableRandomNumberGenerator` is a random number generator that can be seeded to enable
    repeatable tests with random data.
  - `RandomValueGenerating` uses a seedable random number generator to repeatably generate values in
    your test suite. It logs the seed before every test so that you can debug tests that failed. It
    also includes convenient functions for generating random data:
      - Booleans
      - Case iterables
      - Data
      - Floating point types
      - Integer types
      - Optionals
      - Strings
      - UUIDs
      - URLs, URL components, and URL query items
  - `Stub` and `ThrowingStub` provide stubbing and spying functionality for your mock objects.


DevTesting is fully documented and tested and supports iOS 18+, macOS 15+, tvOS 18+, visionOS 2+,
and watchOS 11+.

View our [changelog](CHANGELOG.md) to see what’s new.


## Development Requirements

DevTesting requires a Swift 6.1 toolchain to build. We only test on Apple platforms. We follow the
[Swift API Design Guidelines][SwiftAPIDesignGuidelines]. We take pride in the fact that our public
interfaces are fully documented and tested. We aim for overall test coverage over 99%.

[SwiftAPIDesignGuidelines]: https://swift.org/documentation/api-design-guidelines/

### Development Setup

To set up the development environment:

  1. Run `Scripts/install-git-hooks` to install pre-commit hooks that automatically check code
    formatting.
  2. Use `Scripts/lint` to manually check code formatting at any time.


## Bugs and Feature Requests

Find a bug? Want a new feature? Create a GitHub issue and we’ll take a look.


## License

All code is licensed under the MIT license. Do with it as you will.
