# Using Random Value Generation

How to generate reproducible random test data using DevTesting’s RandomValueGenerating protocol.


## Introduction

DevTesting’s random value generation system provides a powerful way to create varied test data while
ensuring that your tests remain reproducible and debuggable. The system centers around the
``RandomValueGenerating`` protocol, which gives your test suites access to a comprehensive set of
functions for generating random values of many different types.

The key insight behind DevTesting’s approach is that randomness in tests should be _reproducible_.
When a test fails due to a particular combination of random inputs, you need to be able to recreate
those exact same inputs to debug the failure. DevTesting achieves this through a seeding system that
automatically logs the random seeds used in each test, allowing you to reproduce any test failure
exactly.

The random value generation system integrates seamlessly with Swift Testing, automatically logging
seeds both to the console and as test attachments. This means that when a test fails, you have
multiple ways to capture and reuse the seed that caused the failure, making debugging much more
straightforward than with traditional random testing approaches.

In this guide, we’ll explore how to use DevTesting’s random value generation effectively in your
test suites, from basic random data creation to advanced patterns for testing complex scenarios with
varied inputs.


## Getting Started

Using DevTesting’s random value generation is straightforward: conform your test struct to the
``RandomValueGenerating`` protocol and start generating random values in your test methods.


### Basic setup

To use random value generation in your tests, conform your test struct to ``RandomValueGenerating``
and add the required property:

    struct MyTests: RandomValueGenerating {
        var randomNumberGenerator = makeRandomNumberGenerator()


        @Test
        mutating func testSomething() {
            let randomName = randomAlphanumericString()
            let randomAge = randomInt(in: 0 ... 120)
            let randomEmail = randomOptional("\(randomName)@example.com")

            // Use these random values in your test...
        }
    }

The ``makeRandomNumberGenerator()`` function creates a seeded random number generator and
automatically logs the seed for reproducibility. Each time your test runs, it will use a different
seed (based on the current time), giving you varied test data while maintaining the ability to
reproduce any specific run.


### The required property

The ``RandomValueGenerating`` protocol requires a single property:

    var randomNumberGenerator: SeedableRandomNumberGenerator { get set }

This property holds the seeded random number generator that all the random value functions use. By
using a single generator instance throughout your test, all random values in a test method are
deterministically linked to the same seed, ensuring complete reproducibility.


### Mutating test methods

Test methods that use random value generation must be marked as `mutating` because generating random
values modifies the internal state of the random number generator:

    @Test
    mutating func testWithRandomValues() {
        // Note the `mutating` keyword

        let value1 = randomInt(in: 1 ... 100)
        let value2 = randomInt(in: 1 ... 100)
        // value1 and value2 will be different because the generator state changed
    }

This ensures that successive calls to random value functions produce different values, which is
typically what you want in tests.


## Core Random Value Functions

DevTesting provides a comprehensive set of functions for generating random values of different
types. All of these functions are available once you conform to ``RandomValueGenerating``.


### Basic types

For fundamental Swift types, use these convenient functions:

    @Test
    mutating func testBasicTypes() {
        let flag = randomBool()                           // true or false
        let count = randomInt(in: 1 ... 100)             // Integer in specified range
        let percentage = randomFloat64(in: 0.0 ..< 1.0)  // Double in specified range

        // You can also specify other integer and floating-point types
        let smallNumber = random(UInt8.self, in: .min ... .max)
        let precise = random(Float32.self, in: -1.0 ... 1.0)
    }

The `random(_:in:)` family of functions works with any `FixedWidthInteger` or `BinaryFloatingPoint`
type, giving you flexibility for specific numeric requirements. For example


### Strings

String generation provides several options depending on your needs:

    @Test
    mutating func testStrings() {
        // Alphanumeric strings (letters and digits)
        let username = randomAlphanumericString()        // 5-10 characters by default
        let shortCode = randomAlphanumericString(count: 4)  // Exactly 4 characters

        // Basic Latin characters (printable ASCII)
        let displayName = randomBasicLatinString()       // 5-10 characters by default
        let title = randomBasicLatinString(count: 20)    // Exactly 20 characters

        // Custom character sets
        let hexString = randomString(withCharactersFrom: "0123456789ABCDEF", count: 8)
        let vowelString = randomString(withCharactersFrom: "aeiou")  // 5-10 characters
    }

These string functions are particularly useful for generating test data that needs to be
human-readable or conform to specific character set requirements.


### Optionals

Generate optional values easily:

    @Test
    mutating func testOptionals() {
        let maybeName = randomOptional(randomAlphanumericString())  // String?
        let maybeAge = randomOptional(randomInt(in: 0 ... 120))    // Int?

        // Roughly 50/50 chance of nil vs the provided value
        let result = randomOptional("some value")  // "some value" or nil
    }

This is particularly useful for testing code paths that need to handle both present and absent
values.


### Foundation types

DevTesting includes generators for common Foundation types:

    @Test
    mutating func testFoundationTypes() {
        let identifier = randomUUID()                    // UUID
        let webpage = randomURL()                        // URL with random components
        let imageData = randomData()                     // Data with 16-128 bytes
        let largeFile = randomData(count: 1024)         // Data with exactly 1024 bytes

        // URLs with specific characteristics
        let simpleURL = randomURL(includeFragment: false, includeQueryItems: false)
        let complexURL = randomURL(includeFragment: true, includeQueryItems: true)
    }

The ``randomURL()`` function creates realistic URLs with random schemes, hosts, paths, and
optionally query parameters and fragments.


### Collections

Work with collections and enumerations easily:

    enum Priority: CaseIterable {
        case low, medium, high, urgent
    }

    @Test
    mutating func testCollections() {
        let colors = ["red", "green", "blue", "yellow"]
        let selectedColor = randomElement(in: colors)  // Returns String?

        let priority = randomCase(of: Priority.self)   // Returns Priority?

        // Both return nil for empty collections
        let emptyResult = randomElement(in: [Int]())   // nil
    }

Note that both ``randomElement(in:)`` and ``randomCase(of:)`` return optionals because they return
`nil` when called on empty collections.


### Collection generation

DevTesting includes powerful collection generation functions that make it easy to create arrays,
dictionaries, and sets filled with random data:

    @Test
    mutating func testCollectionGeneration() {
        // Generate an array of random users
        let users = Array(count: 5) { randomUser() }

        // Generate a dictionary mapping IDs to names
        let userNames = Dictionary(count: 10) {
            (randomUUID(), randomAlphanumericString())
        }

        // Generate a set of unique identifiers
        let uniqueIDs = Set(count: 8) { randomUUID() }

        // Array with index-based generation
        let numberedItems = Array(count: 3) { index in
            "Item \(index): \(randomAlphanumericString())"
        }
    }

These functions are particularly useful because they maintain reproducibility while generating
complex data structures. The `Dictionary` and `Set` initializers will keep calling your generator
function until they have the required number of unique elements, so make sure your generator can
produce enough unique values.


## The Seeding System

The key to DevTesting’s reproducible randomness is its seeding system, which automatically logs
seeds and provides multiple ways to reproduce test failures.


### Automatic seed logging

Every time you create a random number generator with ``makeRandomNumberGenerator()``, DevTesting
automatically logs the seed being used. This logging happens in two places:

  1. **Log output**: The seed is logged using the Unified Logging system. It is logged with
     subsystem `"DevTesting"` and category `"randomization"`. This output is logged to Xcode’s
     console.

         MyTestsTests.MyTests.testSomething(): Using random seed 4636473893658426368

  2. **Test attachments**: The seed is also saved as a test attachment named
     `randomSeed_ModuleName.TestType.testFunction_*.txt`, making it easy to find and access
     programmatically.

This dual approach ensures that you can always recover the seed that caused a test failure, whether
you’re debugging interactively or analyzing results in a CI system.


### Setting custom seeds

When you need to reproduce a specific test failure, you can override the automatic seed generation
by setting the ``randomSeed`` property:

    struct MyTests: RandomValueGenerating {
        var randomNumberGenerator = makeRandomNumberGenerator()


        @Test
        mutating func testReproducibleScenario() {
            // Use a specific seed to reproduce a failure
            randomSeed = 4636473893658426368

            let value = randomInt(in: 1 ... 1000)
            // This will always generate the same value with this seed
        }
    }

You can also provide a seed directly when creating the generator:

    var randomNumberGenerator = makeRandomNumberGenerator(seed: 4636473893658426368)

Both approaches will log the seed, ensuring that your intention to use a specific seed is clearly
documented.


### Reproducing failures

When a test fails due to random inputs, follow these steps to reproduce and debug the failure:

  1. **Find the seed**: Look for the seed in your test output or check the test attachments for the
    `randomSeed_*.txt` file.

  2. **Set the seed**: Use the ``randomSeed`` property in your test to force the same sequence of
     random values:

         @Test
         mutating func testThatFailed() {
             randomSeed = 4636473893658426368  // The seed from the failure
             // Now run your test logic - it will use the exact same random values
         }

  3. **Debug with consistency**: Since the random values are now deterministic, you can set
     breakpoints, add logging, or modify the test logic while still working with the exact same
     inputs that caused the original failure.

This workflow makes debugging random test failures as straightforward as debugging deterministic
tests, while still providing the benefits of varied test inputs across different test runs.


### Maintaining reproducibility

To preserve DevTesting’s reproducibility guarantees, avoid using non-seedable sources of randomness
in your tests. Functions like `UUID()`, `collection.randomElement()`, or `Int.random(in:)` use
system randomness that cannot be controlled by DevTesting’s seeding system, which defeats the
purpose of reproducible test failures.

    @Test
    mutating func badExample() {
        // ❌ These break reproducibility
        let id = UUID()                           // Uses system randomness
        let item = colors.randomElement()         // Uses system randomness
        let count = Int.random(in: 1...100)       // Uses system randomness
    }

    @Test
    mutating func goodExample() {
        // ✅ These maintain reproducibility
        let id = randomUUID()                     // Uses seeded randomness
        let item = randomElement(in: colors)      // Uses seeded randomness
        let count = randomInt(in: 1...100)        // Uses seeded randomness
    }

When DevTesting doesn’t provide a specific random function you need, pass your
`randomNumberGenerator` directly to the system function:

    @Test
    mutating func shufflingExample() {
        let numbers = [1, 2, 3, 4, 5]

        // ❌ Breaks reproducibility
        let shuffled = numbers.shuffled()

        // ✅ Maintains reproducibility
        let shuffledReproducibly = numbers.shuffled(using: &randomNumberGenerator)
    }

This ensures that all randomness in your tests flows through the same seeded generator, maintaining
complete reproducibility of test failures.


## Extending Random Generation

DevTesting’s random value generation becomes even more powerful when you extend it with
domain-specific functions tailored to your application’s data types.


### Creating domain-specific extensions

The recommended pattern is to create extensions on ``RandomValueGenerating`` for your specific
types. For example:

    extension RandomValueGenerating {
        mutating func randomDate() -> Date {
            return Date(timeIntervalSinceNow: random(TimeInterval.self, in: -10_000 ... 10_000))
        }


        mutating func randomError() -> MyAppError {
            return MyAppError(code: randomInt(in: 100 ..< 1000))
        }


        mutating func randomUser() -> User {
            return User(
                id: randomUUID(),
                name: randomAlphanumericString(count: randomInt(in: 5 ... 15)),
                email: "\(randomAlphanumericString())@\(randomAlphanumericString()).com",
                age: randomOptional(randomInt(in: 18 ... 100))
            )
        }
    }

These extensions become immediately available in any test that conforms to ``RandomValueGenerating``,
allowing you to generate complex domain objects with a single function call.


### Combining existing functions

Build complex random objects by combining the built-in random value functions:

    extension RandomValueGenerating {
        mutating func randomHTTPResponse() -> HTTPResponse<Data> {
            return HTTPResponse(
                httpURLResponse: randomHTTPURLResponse(),
                body: randomData()
            )
        }


        mutating func randomHTTPURLResponse(statusCode: Int? = nil) -> HTTPURLResponse {
            return HTTPURLResponse(
                url: randomURL(),
                statusCode: statusCode ?? randomInt(in: 100 ... 599),
                httpVersion: "1.1",
                headerFields: Dictionary(count: randomInt(in: 0 ... 5)) {
                    (randomAlphanumericString(), randomAlphanumericString())
                }
            )!
        }
    }

This approach creates realistic test data that exercises the full range of your application’s data
structures while maintaining the reproducibility guarantees of the seeding system.


### Best practices

When creating domain-specific random value generators, follow these guidelines:

  - **Keep extensions focused**: Create separate extension files for different modules or feature
    areas of your application
  - **Use realistic ranges**: Choose ranges that reflect real-world data rather than extreme values
    unless you’re specifically testing edge cases
  - **Combine deterministic and random elements**: Mix fixed values (like `".com"` in email
    addresses) with random components to create realistic but controlled test data
  - **Document your ranges**: Use comments to explain why you chose specific ranges for random
    values

        extension RandomValueGenerating {
            mutating func randomProductPrice() -> Decimal {
                // Prices between $0.01 and $999.99, matching our app’s business rules
                return Decimal(randomInt(in: 1 ... 99_999)) / 100
            }
        }

By following these patterns, you can create a comprehensive library of random value generators that
make your tests both more realistic and easier to write.


## Conclusion

DevTesting’s random value generation system provides a powerful foundation for creating
comprehensive, varied test suites while maintaining the reproducibility essential for effective
debugging. By combining extensive random value functions with sophisticated seeding and logging, you
can write tests that exercise your code with realistic data while ensuring that any failures can be
reliably reproduced and debugged.

The key benefits include:

  - **Comprehensive coverage**: Test your code with a wide variety of inputs automatically
  - **Reproducible failures**: Every random test run can be exactly reproduced using logged seeds
  - **Easy debugging**: Failed tests become as debuggable as deterministic tests
  - **Extensible design**: Create domain-specific random generators that match your application’s data

Whether you’re testing simple functions with varied inputs or complex workflows with intricate data
structures, DevTesting’s random value generation gives you the tools to write thorough, maintainable
tests that provide confidence in your code’s robustness across a wide range of real-world scenarios.
