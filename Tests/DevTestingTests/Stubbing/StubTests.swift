//
//  StubTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/7/25.
//

import DevTesting
import Foundation
import Testing

struct StubTests {
    @Test
    func initSetsProperties() {
        let defaultResult = Result<Int, HashableError>.success(5)
        let resultQueue: [Result<Int, HashableError>] = (0 ..< 5).map { (i) in
            i.isMultiple(of: 2) ? .success(i) : .failure(.init(id: i))
        }

        let stub = ThrowingStub<String, Int, HashableError>(
            defaultResult: defaultResult,
            resultQueue: resultQueue
        )

        #expect(stub.defaultResult == defaultResult)
        #expect(stub.resultQueue == resultQueue)
        #expect(stub.calls.isEmpty)
    }


    @Test
    func initDefaultReturnValueSetsProperties() {
        let defaultReturnValue = 10
        let resultQueue: [Result<Int, HashableError>] = (0 ..< 5).map { (i) in
            i.isMultiple(of: 2) ? .success(i) : .failure(.init(id: i))
        }

        let stub = ThrowingStub<String, Int, HashableError>(
            defaultReturnValue: 10,
            resultQueue: resultQueue
        )

        #expect(stub.defaultResult == .success(defaultReturnValue))
        #expect(stub.resultQueue == resultQueue)
        #expect(stub.calls.isEmpty)
    }


    @Test
    func initDefaultErrorSetsProperties() {
        let defaultError = HashableError(id: 7)
        let resultQueue: [Result<Int, HashableError>] = (0 ..< 5).map { (i) in
            i.isMultiple(of: 2) ? .success(i) : .failure(.init(id: i))
        }

        let stub = ThrowingStub<String, Int, HashableError>(
            defaultError: defaultError,
            resultQueue: resultQueue
        )

        #expect(stub.defaultResult == .failure(defaultError))
        #expect(stub.resultQueue == resultQueue)
        #expect(stub.calls.isEmpty)
    }


    @Test
    func accessingProperties() {
        let stub = ThrowingStub<String, Int, HashableError>(defaultResult: .success(0))

        let defaultResult = Result<Int, HashableError>.success(5)
        stub.defaultResult = defaultResult
        #expect(stub.defaultResult == defaultResult)

        let resultQueue: [Result<Int, HashableError>] = (0 ..< 5).map { (i) in
            i.isMultiple(of: 2) ? .success(i) : .failure(.init(id: i))
        }
        stub.resultQueue = resultQueue
        #expect(stub.resultQueue == resultQueue)
    }


    @Test
    func callAsFunctionReturnsOrThrows() throws {
        let defaultResult = Result<Int, HashableError>.success(5)
        let resultQueue: [Result<Int, HashableError>] = (0 ..< 5).map { (i) in
            i.isMultiple(of: 2) ? .success(i) : .failure(.init(id: i))
        }

        let stub = ThrowingStub<String, Int, HashableError>(
            defaultResult: defaultResult,
            resultQueue: resultQueue
        )

        let arguments = (0 ... 5).map(String.init(_:))
        let expectedResults = resultQueue + [defaultResult]
        for (argument, expectedResult) in zip(arguments, expectedResults) {
            let result = Result { () throws(HashableError) in
                try stub(argument)
            }

            #expect(result == expectedResult)
        }

        #expect(stub.calls.map(\.result) == expectedResults)
        #expect(stub.calls.map(\.arguments) == arguments)
        #expect(stub.callResults == expectedResults)
        #expect(stub.callArguments == arguments)

        stub.clearCalls()
        #expect(stub.calls.isEmpty)
    }


    @Test
    func callAsFunctionWithVoidReturnType() throws {
        let stub = ThrowingStub<Void, Double, HashableError>(defaultResult: .success(.pi))
        #expect(try stub() == .pi)

        let expectedError = HashableError(id: 3)
        stub.defaultResult = .failure(expectedError)
        do {
            _ = try stub()
            Issue.record("does not throw error")
        } catch {
            #expect(error == expectedError)
        }
    }


    @Test(arguments: [nil, HashableError(id: 5)])
    func voidReturnTypeInitAndCallAsFunction(defaultError: HashableError?) {
        let errorQueue = (0 ..< 5).map { (i) in i.isMultiple(of: 2) ? HashableError(id: 5) : nil }

        let stub = ThrowingStub<Int, Void, HashableError>(defaultError: defaultError, errorQueue: errorQueue)

        #expect(stub.defaultError == defaultError)
        #expect(stub.errorQueue == errorQueue)

        let arguments = Array(0 ... 5)
        let expectedErrors = errorQueue + [defaultError]
        for (argument, expectedError) in zip(arguments, expectedErrors) {
            do {
                try stub(argument)
                if expectedError != nil {
                    Issue.record("does not throw error")
                }
            } catch {
                #expect(error == expectedError)
            }
        }

        #expect(stub.errorQueue.isEmpty)

        #expect(stub.calls.map(\.error) == expectedErrors)
        #expect(stub.calls.map(\.arguments) == arguments)
        #expect(stub.callErrors == expectedErrors)
        #expect(stub.callArguments == arguments)
    }


    @Test
    func neverErrorTypeInitAndCallAsFunction() throws {
        let defaultReturnValue = true
        let returnValueQueue = [false, true, false, true, false]

        let stub = Stub<Int, Bool>(defaultReturnValue: defaultReturnValue, returnValueQueue: returnValueQueue)

        #expect(stub.defaultReturnValue == defaultReturnValue)
        #expect(stub.returnValueQueue == returnValueQueue)

        let arguments = Array(0 ... 5)
        let expectedReturnValues = returnValueQueue + [defaultReturnValue]
        for (argument, expectedResult) in zip(arguments, expectedReturnValues) {
            #expect(stub(argument) == expectedResult)
        }

        #expect(stub.returnValueQueue.isEmpty)

        #expect(stub.calls.map(\.returnValue) == expectedReturnValues)
        #expect(stub.calls.map(\.arguments) == arguments)
        #expect(stub.callReturnValues == expectedReturnValues)
        #expect(stub.callArguments == arguments)
    }


    @Test
    func convenenienceInitsOverloadWithoutColision() {
        let stub = Stub<Void, Void>()
        _ = Stub<Void, Int>(defaultReturnValue: 3)
        _ = ThrowingStub<Void, Void, any Error>(defaultError: nil)
        _ = ThrowingStub<Void, Int, any Error>(defaultError: HashableError(id: 2))

        // There’s nothing to actually test here, as the compiler guarantees everything we would test. Check the result
        // queue just for posterity
        #expect(stub.returnValueQueue.isEmpty)
    }


    // MARK: - Observable

    @Test
    func callAsFunctionTriggersObservation() async throws {
        // set up stub
        let stub = Stub<String, Int>(defaultReturnValue: 42)

        // set up observations stream
        let observations = Observations { stub.calls }
        var iterator = observations.makeAsyncIterator()

        // expect initial empty calls
        let initialCalls = await iterator.next()
        #expect(initialCalls?.isEmpty == true)

        // exercise by calling stub
        _ = stub("first")

        // expect calls updated with first call
        let callsAfterFirst = await iterator.next()
        #expect(callsAfterFirst?.count == 1)
        #expect(callsAfterFirst?.first?.arguments == "first")

        // exercise by calling stub again
        _ = stub("second")

        // expect calls updated with second call
        let callsAfterSecond = await iterator.next()
        #expect(callsAfterSecond?.count == 2)
        #expect(callsAfterSecond?.last?.arguments == "second")
    }


    @Test
    func clearCallsTriggersObservation() async throws {
        // set up stub with some calls
        let stub = Stub<String, Int>(defaultReturnValue: 42)
        _ = stub("first")
        _ = stub("second")

        // set up observations stream
        let observations = Observations { stub.calls }
        var iterator = observations.makeAsyncIterator()

        // expect initial calls
        let initialCalls = await iterator.next()
        #expect(initialCalls?.count == 2)

        // exercise by clearing calls
        stub.clearCalls()

        // expect calls cleared
        let clearedCalls = await iterator.next()
        #expect(clearedCalls?.isEmpty == true)
    }


    @Test
    mutating func observability() async {
        let arguments = [1, 2, 3, 4, 5]
        let stub = Stub<Int, Void>()

        Task {
            for value in arguments {
                try? await Task.sleep(for: .milliseconds(100))
                stub(value)
            }
        }

        let observationTask = Task {
            var i = 0
            for await argument in Observations({ stub.callArguments.last }).dropFirst() {
                #expect(argument == arguments[i])
                i += 1

                if argument == arguments.count {
                    break
                }
            }
        }

        await observationTask.value
        #expect(stub.callArguments == arguments)
    }
}
