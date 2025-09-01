# Using Stub and ThrowingStub

How to use stubs to mock dependencies and verify behavior in your tests.


## Introduction

DevTesting provides a sophisticated stubbing system that makes it easy to mock dependencies and
verify their behavior in tests. The system is designed to help you isolate the code under test
while maintaining complete control over how its dependencies behave and providing detailed
information about how those dependencies were used.

The stubbing system centers around two key types: ``Stub`` for functions that cannot throw errors
and ``ThrowingStub`` for functions that can throw errors. Both types automatically record every
call made to them, allowing you to verify not just that your code works, but that it interacts
with its dependencies in exactly the way you expect.

In this guide, we’ll explore how to use both types of stubs effectively in your test suites, from
basic mocking scenarios to advanced patterns for complex testing requirements.


## Getting Started

Before diving into examples, it’s important to understand the generic parameters that define how
stubs work.


### Understanding generic parameters

`Stub` and `ThrowingStub` use generic type parameters to ensure type safety and make their
interfaces clear.

`Stub<Arguments, ReturnType>` is for stubbing properties and functions that _can’t_ throw errors.
The `Arguments` parameter is a type representing the function’s input parameters; `ReturnType` is
the type that the function returns. These types can be `Void` if the function takes no parameters or
doesn’t return a value.

`ThrowingStub<Arguments, ReturnType, ErrorType>` is for functions that can _can_ throw errors. Its
`Arguments` and `ReturnType` parameters have the same meaning as `Stub`’s. `ErrorType` is the type
of error that the function can throw.

The `Arguments` type deserves special attention. For functions with a single parameter, use that
parameter’s type directly. For functions with multiple parameters, you’ll typically create a
dedicated structure to group them together (we’ll see this pattern in the next section).


### Complete example

Let’s look at a comprehensive example that demonstrates all the stub variations using a single
protocol:

    protocol FileManager {
        var documentsDirectory: URL { get }
        func fileExists(at path: String) -> Bool
        func loadContent(from path: String) throws -> Data
    }

Now we’ll create a mock implementation that stubs each of these requirements:

    final class MockFileManager: FileManager {
        // URL-valued property that takes no arguments
        var documentsDirectoryStub: Stub<Void, URL>!

        // Function with a single argument that returns Bool and cannot throw
        var fileExistsStub: Stub<String, Bool>!

        // Function with single argument that returns Data and can throw any Error
        var loadContentStub: ThrowingStub<String, Data, any Error>!


        var documentsDirectory: URL {
            documentsDirectoryStub()
        }

        func fileExists(at path: String) -> Bool {
            fileExistsStub(path)
        }

        func loadContent(from path: String) throws -> Data {
            try loadContentStub(path)
        }
    }

This example shows the three most common stub patterns:

  1. **No arguments (`Void`)**: The `documentsDirectory` property takes no input, so we use
     `Stub<Void, URL>`
  2. **Single argument**: Both `fileExists(at:)` and `loadContent(from:)` take a single `String`
     parameter
  3. **Throwing vs non-throwing**: `fileExists(at:)` cannot throw, so it uses `Stub<String, Bool>`,
     while `loadContent(from:)` can throw, so it uses `ThrowingStub<String, Data, any Error>`


## Essential Design Patterns

We recommend several important design patterns to make using stubs effective and reliable in your
tests.


### Argument structures

When your stubbed function takes multiple parameters, create a dedicated argument structure to group
them together. This makes the stub’s call history easier to inspect:

    struct CreateDirectoryArguments {
        let path: String
        let createIntermediates: Bool
        let attributes: [FileAttributeKey: Any]?
    }

This pattern is especially valuable when writing assertions about how your code called the stubbed
function, as you can easily access specific parameters from the recorded calls.


### Force unwrapping stub properties

Stub properties are declared as implicitly unwrapped optionals to fail fast when stubs are not set
up correctly. By using implicitly unwrapped optionals, failing to properly mock a required
dependency will crash immediately at test time, making it obvious what went wrong.

    final class MockFileManager: FileManager {
        var documentsDirectoryStub: Stub<Void, URL>!

        // If this stub isn’t initialized and the property is accessed, the test will crash
        // immediately with a clear error
        var documentsDirectory: URL {
            documentsDirectoryStub()
        }
    }


## Configuring Stub Behavior

Stubs provide flexible mechanisms for controlling their behavior across multiple calls, allowing you
to simulate various real-world scenarios in your tests.


### Default values

The simplest configuration is setting a default result that will be used for all calls.

For ``Stub``, use a default return value:

    // Simple stub setup
    fileManager.documentsDirectoryStub = Stub(defaultReturnValue: URL(filePath: "/Documents"))
    fileManager.fileExistsStub = Stub(defaultReturnValue: true)

For ``ThrowingStub``, you can configure default success or failure behavior:

    // Always succeed with the same response
    let responseData = Data("file content".utf8)
    fileManager.loadContentStub = ThrowingStub(defaultResult: .success(responseData))

    // Always throw the same error
    fileManager.loadContentStub = ThrowingStub(defaultResult: .failure(FileError.notFound))


### Result queues

For more complex scenarios where you want different behavior on successive calls, use result queues.
The stub will use values from the queue first, then fall back to the default when the queue is
empty.

For ``Stub``:

    // First call returns true, subsequent calls return false
    fileManager.fileExistsStub = Stub(
        defaultReturnValue: false,
        returnValueQueue: [true]
    )

For ``ThrowingStub``, you can mix successes and failures:

    let successData = Data("success content".utf8)
    let retryData = Data("retry content".utf8)

    fileManager.loadContentStub = ThrowingStub(
        defaultResult: .success(successData),
        resultQueue: [
            // First call fails
            .failure(FileError.networkTimeout),

            // Second call succeeds
            .success(retryData)
        ]
    )

This pattern is especially useful for testing retry logic, where you want the first attempt to fail
but subsequent attempts to succeed.


### Void return type conveniences

For functions that don’t return a value but can throw errors, ``ThrowingStub`` provides convenient
initializers that work with errors directly:

    // Function that can throw but returns nothing
    var deleteFileStub: ThrowingStub<String, Void, FileError>!

    deleteFileStub = ThrowingStub(
        // Don’t throw by default
        defaultError: nil,

        // First call throws, second doesn’t
        errorQueue: [FileError.permissionDenied, nil]
    )

The `nil` error values indicate that the function should return normally without throwing.

For ``Stub`` functions that return `Void`, there’s an even simpler convenience initializer:

    var notifyStub: Stub<String, Void>!
    notifyStub = Stub()


## Verifying Interactions

One of the most powerful features of DevTesting’s stubs is their ability to record all interactions,
allowing you to verify that your code behaved correctly.


### Call counts and arguments

Every stub automatically records every call made to it:

    #expect(fileManager.documentsDirectoryStub.calls.count == 1)
    #expect(fileManager.loadContentStub.calls.count == 2)

You can inspect specific arguments passed to the stub:

    let loadContentCalls = fileManager.loadContentStub.callArguments
    #expect(loadContentCalls == ["/path/to/file1.txt", "/path/to/file2.txt"])

For stubs with argument structures, you can access individual fields:

    let retryCall = try #require(retryPolicy.retryDelayStub.callArguments.first)
    #expect(retryCall.attemptCount == 1)
    #expect(retryCall.input == expectedRequest)
    #expect(retryCall.previousDelay == nil)


### Clearing call history

When testing multiple scenarios in a single test function, you might want to reset the call history:

    fileManager.loadContentStub.clearCalls()
    #expect(fileManager.loadContentStub.calls.isEmpty)

    // Now test the next scenario with a clean slate
    performSecondScenario()
    #expect(fileManager.loadContentStub.calls.count == expectedCallsInSecondScenario)


## Advanced Patterns

DevTesting’s stubs support several advanced patterns for complex testing scenarios.


### Prologues

Sometimes you need to perform side effects before your stub returns. You can use prologue closures
for this, which are especially useful for testing cancellation behavior or triggering other
asynchronous events:

    final class MockLoader: Loader {
        struct LoadDataArguments { … }

        var loadDataPrologue: (@Sendable () async throws -> Void)?
        var loadDataStub: ThrowingStub<LoadDataArguments, Data?, any Error>!


        func loadData(at url: URL, retryPolicy: RetryPolicy) async throws -> Data? {
            // Execute the prologue before returning the stub’s result
            try await loadDataPrologue?()
            return try loadDataStub(.init(url: url, retryPolicy: retryPolicy))
        }
    }

    // In your test, set up cancellation behavior
    mockLoader.loadDataPrologue = {
        withUnsafeCurrentTask { $0?.cancel() }
    }

This pattern allows you to test complex scenarios like cancellation, timeouts, or other side effects
that need to happen during the execution of your stubbed function. For functions with no return
value, you can similarly create an epilogue closure for executing code after your stub has been
called.


### Sendable Mocks

When your mock objects need to be `Sendable`, we recommend marking stub properties as
`nonisolated(unsafe)`. Making stubs truly concurrency-safe requires more effort than is typically
worthwhile in test code. Stubs are internally thread-safe and `Sendable` if their generic parameters
are `Sendable`.

    final class MockRetryPolicy<Input, Output>: RetryPolicy {
        struct RetryDelayArguments { … }

        nonisolated(unsafe) var retryDelayStub: Stub<RetryDelayArguments, Duration?>!


        func retryDelay(
            forInput input: Input,
            output: Output,
            attemptCount: Int,
            previousDelay: Duration?
        ) -> Duration? {
            retryDelayStub(
                .init(
                    input: input,
                    output: output,
                    attemptCount: attemptCount,
                    previousDelay: previousDelay
                )
            )
        }
    }


## Conclusion

DevTesting’s stub system provides a powerful foundation for writing reliable, maintainable tests. By
using ``Stub`` and ``ThrowingStub``, you can easily mock dependencies, control their behavior, and
verify that your code interacts with them correctly.

The key benefits of this approach include:

  - **Complete isolation**: Test your code in isolation from real dependencies
  - **Behavioral control**: Simulate various scenarios including failures and edge cases
  - **Comprehensive verification**: Inspect every interaction between your code and its dependencies
  - **Thread safety**: Work seamlessly in concurrent testing environments with Swift 6 compatibility

Whether you’re testing simple functions or complex asynchronous workflows, DevTesting’s stubs give
you the tools you need to write thorough, reliable tests that clearly express your code’s expected
behavior.
