# DevTesting

DevTesting is a small Swift 6 package that contains useful additions for writing tests with [Swift
Testing](https://github.com/swiftlang/swift-testing/). It contains two small libraries, DevTesting
and DevRandom. The primary library for automated testing is DevTesting. It provides

  - `RandomValueGenerating`, a protocol that uses a seedable random number generator to repeatably
    generate values in your test suite. It logs the seed before every test so that you can debug
    tests that failed. It also includes convenient functions for generating random values:
      - Booleans
      - Case iterables
      - Data
      - Dates
      - Floating point types
      - Integer types
      - Optionals
      - Strings
      - UUIDs
      - URLs, URL components, and URL query items
  - `Stub` and `ThrowingStub`, which provide stubbing and spying functionality for your mocks.

DevRandom is a supporting library that includes the core random value generation code. It is used by
DevTesting, but can also be used in your application for random value generation.

  - `SeedableRandomNumberGenerator` is a random number generator that can be seeded to enable
    repeatable tests with random values.
  - Extensions for random value generation on
      - `BinaryFloatingPoint`
      - `CaseIterable`
      - `Data`
      - `Date`
      - `Optional`
      - `String`
      - `URL`
      - `URLComponents`
      - `URLQueryItem`
      - `UUID`

DevTesting and DevRandom are fully documented and tested and support version 26 of Apple’s OSes.

View our [changelog](CHANGELOG.md) to see what’s new.


## Development Requirements

DevTesting requires a Swift 6.2+ toolchain to build. We only test on Apple platforms. We follow the
[Swift API Design Guidelines][SwiftAPIDesignGuidelines]. We take pride in the fact that our public
interfaces are fully documented and tested. We aim for overall test coverage over 99%.

[SwiftAPIDesignGuidelines]: https://swift.org/documentation/api-design-guidelines/

### Development Setup

To set up the development environment:

  1. Run `Scripts/install-git-hooks` to install the pre-push hook that automatically checks
     code formatting before pushing.
  2. Use `Scripts/lint` to manually check code formatting at any time.
  3. Use `Scripts/format` to auto-fix code formatting issues.


## Continuous Integration

DevTesting uses GitHub Actions for continuous integration. The CI pipeline:

  - **Linting**: Automatically checks code formatting on all pull requests using `swift format`
  - **Testing**: Runs tests on iOS, macOS, tvOS, and watchOS
  - **Coverage**: Generates code coverage reports using xccovPretty


## Bugs and Feature Requests

Find a bug? Want a new feature? Create a GitHub issue and we’ll take a look.


## License

All code is licensed under the MIT license. Do with it as you will.
