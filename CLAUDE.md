# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this
repository.


## Development Commands

### Building and Testing

  - **Build for testing**: `swift build --package-path . --disable-automatic-resolution`
  - **Run tests**: `swift test --package-path . --disable-automatic-resolution`
  - **Run tests with code coverage**: Tests are run through the GitHub Actions workflow using
    `build_and_test.sh` from DevBuilds
  - **Test specific platform**: Use `xcodebuild` with appropriate destination (see
    `.github/workflows/VerifyChanges.yaml` for examples)

### Code Formatting and Linting

  - **Lint check**: `Scripts/lint` (runs `swift format lint --recursive --strict` from anywhere)
  - **Format code**: `swift format --in-place --recursive Sources/ Tests/`
  - **Manual lint**: `swift format lint --recursive --strict Sources/ Tests/`
  - **Swift format configuration**: Uses `.swift-format` file with 4-space indentation and 120
    character line length

### Git Hooks

  - **Install git hooks**: `Scripts/install-git-hooks` (installs pre-commit hook that runs lint
    check)
  - **Pre-commit hook**: Automatically runs `Scripts/lint` before each commit

### Documentation

  - **Build documentation**: `swift package generate-documentation`
  - **Documentation source**: `Sources/DevTesting/Documentation.docc/`


## Code Architecture

### Core Components

**RandomValueGenerating Protocol**: The central protocol that test suites conform to for generating
repeatable random test data. Uses `SeedableRandomNumberGenerator` and logs seeds for test
reproducibility.

**Three Main Feature Areas**:

  1. **Random Value Generation** (`Sources/DevTesting/Random Value Generation/`): Extensions for
     generating random values of various types (String, Data, URL, UUID, etc.) with seeded
     randomness
  2. **Collection Generation** (`Sources/DevTesting/Collection Generation/`): Array extensions for
     generating collections of random data
  3. **Stubbing** (`Sources/DevTesting/Stubbing/`): `Stub` and `ThrowingStub` classes for mocking
     and spying in tests

### Key Design Patterns

  - **Seeded Randomness**: All random generation uses `SeedableRandomNumberGenerator` to ensure
    test reproducibility
  - **Logging Integration**: Random seeds are logged using `os.Logger` (subsystem: "DevTesting",
    category: "randomization")
  - **Swift Testing Integration**: Designed specifically for Swift Testing framework, not XCTest
  - **Type Safety**: Extensive use of Swift 6 features including typed throws and existential
    types

### Dependencies

  - **Swift Numerics**: Used for `RealModule` in tests
  - **Platform Requirements**: iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+
  - **Swift Version**: Requires Swift 6.2 toolchain

### Testing Strategy

  - **Test Plans**: Uses `DevTesting.xctestplan` for organized test execution
  - **Coverage Target**: Aims for 99%+ test coverage
  - **Platform Testing**: Tests run on iOS, macOS, tvOS, and watchOS simulators
  - **CI/CD**: GitHub Actions workflow with matrix strategy across platforms

### Documentation Standards

  - **Full Documentation**: All public APIs are documented with Swift DocC
  - **API Guidelines**: Follows Swift API Design Guidelines
  - **Documentation Comments**: Uses triple-slash comments (`///`)
  - **Markdown Style**: Follow `Documentation/MarkdownStyleGuide.md` for consistent formatting:
      - 100 character line length
      - 4-space indented code blocks (no fenced blocks)
      - 2-space indented bullet lists with alignment
      - Consistent terminology (function vs method, type vs class)
