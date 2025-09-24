# DevTesting Changelog

## 1.2.0: September 24, 2025

This update bumps the minimum supported version of Apple’s OSes to 26.


## 1.1.0: September 17, 2025

Adds two initializers to `ThrowingStub`: `init(defaultReturnValue:resultQueue:)` and
`init(defaultError:resultQueue:)`. These initializers enable cleaner call sites, as in the following
example:

    // Before
    mock.doSomethingSuccessfullyStub = ThrowingStub(defaultResult: .success(value))
    mock.doSomethingUnsuccessfullyStub = ThrowingStub(defaultResult: .failure(error))

    // After
    mock.doSomethingSuccessfullyStub = ThrowingStub(defaultReturnValue: value)
    mock.doSomethingUnsuccessfullyStub = ThrowingStub(defaultError: error)


## 1.0.0: September 1, 2025

This is the first release of DevTesting. The initial feature set includes

  - `SeedableRandomNumberGenerator`, a random number generator that can be seeded to enable
    repeatable tests with random data.
  - `RandomValueGenerating`, a protocol that your test suite can conform to to add random value
    generation. It uses a seedable random number generator, and logs the seed before every test so
    that you can debug tests that failed. It also includes convenient functions for generating
    random data:
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
