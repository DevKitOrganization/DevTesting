# ``DevTesting``

Write repeatable tests with random data and create mock objects with powerful stubbing.


## Overview

DevTesting is a small testing package that contains useful additions for writing tests with Swift
Testing. Its functionality is divided into two distinct subsystems: random value generation and
stubbing.

The random value generation subsystem builds atop DevRandom to enable repeatable testing with random
data. Its main type is the ``RandomValueGenerating`` protocol, which uses a seedable random number
generator to repeatably generate random values in your automated tests. It captures the seed before
every test so that you can re-run failed tests with the exact same random values. It also includes
convenient functions for generating random booleans, numeric types, strings, optionals, UUIDs, data,
URLs, and more.

The stubbing subsystem includes ``Stub`` and ``ThrowingStub``, which make it easy to mock
dependencies and verify their behavior in tests. The system is designed to help you isolate the code
under test while maintaining complete control over how its dependencies behave and providing
detailed information about how those dependencies were used.


## Topics

### Generating Random Values

- <doc:UsingRandomValueGeneration>
- ``RandomValueGenerating``

### Stubbing

- <doc:UsingStubs>
- ``Stub``
- ``ThrowingStub``

### Collection Generation Extensions

- ``Swift/Array``
- ``Swift/Dictionary``
- ``Swift/Set``
