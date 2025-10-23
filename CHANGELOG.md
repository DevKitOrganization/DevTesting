# DevTesting Changelog

## 1.5.0: October 22, 2025

The `Date.random(in:using:)` functions now use `BinaryFloatingPoint.randomPrintable(in:using:)` to
generate time intervals. This should lead to greater reliability when converting the time intervals
of generated dates into strings.


## 1.4.0: October 12, 2025

`Stub` and `ThrowingStub` now conform to `Observable`. The only property that is tracked is
``calls``. Changes to dependent properties like ``callArguments`` and ``callResults`` can also be
tracked, but changes to ``resultQueue`` and ``defaultResult`` are not.


## 1.3.0: October 2, 2025

Adds functions for randomly generating dates within a specified range.

  - `Date` has been extended with two static functions, both spelled `random(in:using:)`, that
    generate a random date in either a closed or half-open range.
  - `RandomValueGenerating` has been extended with a new property requirement and two new functions.

      - The new property is a `ClosedRange<Date>` spelled `defaultClosedDateRange`. This property
        provides a default closed date range to use when generating random dates. A default
        implementation is provided.
      - The two new functions, both spelled `randomDate(in:)`, generate a random date in either a
        closed or half-open range using the aforementioned `Date` extension. The closed range
        version’s range parameter is optional. When `nil` is used (the default),
        `defaultClosedDateRange` is used.


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
