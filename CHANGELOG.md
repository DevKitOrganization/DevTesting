# DevTesting Changelog


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
