//
//  Stub.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/6/25.
//

import Foundation
import os

/// A stub for a function.
public final class ThrowingStub<Arguments, ReturnType, ErrorType> where ErrorType: Error {
    /// A recorded call to the stub.
    public struct Call {
        /// The call’s arguments.
        public let arguments: Arguments

        /// The result of the call.
        public let result: Result<ReturnType, ErrorType>
    }


    /// Mutable properties for a Stub.
    private struct MutableProperties {
        /// The stub’s default return value.
        var defaultResult: Result<ReturnType, ErrorType>

        /// The stub’s queue of results.
        var resultQueue: [Result<ReturnType, ErrorType>]

        /// The stub’s recorded calls.
        var calls: [Call] = []
    }


    /// The stub’s mutable properties.
    private let mutableProperties: OSAllocatedUnfairLock<MutableProperties>


    /// Creates a new throwing stub with the specified default result.
    ///
    /// - Parameters:
    ///   - defaultResult: The result of the stub when the result queue is empty.
    ///   - resultQueue: A queue of call results to use. If empty, `defaultResult` is used.
    public init(
        defaultResult: Result<ReturnType, ErrorType>,
        resultQueue: [Result<ReturnType, ErrorType>] = []
    ) {
        self.mutableProperties = .init(
            uncheckedState: .init(
                defaultResult: defaultResult,
                resultQueue: resultQueue
            )
        )
    }


    /// The stub’s default result.
    ///
    /// This result is used whenever the stub is called and ``resultQueue`` is empty.
    public var defaultResult: Result<ReturnType, ErrorType> {
        get {
            return mutableProperties.withLockUnchecked { $0.defaultResult }
        }

        set {
            mutableProperties.withLockUnchecked { $0.defaultResult = newValue }
        }
    }


    /// The stub’s queue of results.
    ///
    /// The first value of this queue is removed and used whenever the stub is called. If empty, ``defaultResult`` is
    /// used instead.
    public var resultQueue: [Result<ReturnType, ErrorType>] {
        get {
            return mutableProperties.withLockUnchecked { $0.resultQueue }
        }

        set {
            mutableProperties.withLockUnchecked { $0.resultQueue = newValue }
        }
    }


    /// The stub’s recorded calls.
    ///
    /// If you just need the call’s arguments, you can use ``callArguments`` instead.
    public var calls: [Call] {
        return mutableProperties.withLockUnchecked { $0.calls }
    }


    /// Clears the stub’s recorded calls.
    public func clearCalls() {
        mutableProperties.withLockUnchecked { $0.calls = [] }
    }


    /// Calls the stub with the specified arguments, recording the call.
    ///
    /// If the stub’s ``resultQueue`` is empty, returns or throws ``defaultResult``. Otherwise, removes the first
    /// element of the result queue and returns or throws that.
    ///
    /// - Parameter arguments: The arguments with which to call the stub.
    public func callAsFunction(_ arguments: Arguments) throws(ErrorType) -> ReturnType {
        let result = mutableProperties.withLockUnchecked { (properties) in
            let result =
                if properties.resultQueue.isEmpty {
                    properties.defaultResult
                } else {
                    properties.resultQueue.removeFirst()
                }

            properties.calls.append(
                .init(arguments: arguments, result: result)
            )

            return result
        }

        return try result.get()
    }
}


extension ThrowingStub {
    /// Creates a new throwing stub with a default success result.
    ///
    /// - Parameters:
    ///   - defaultReturnValue: The successful return value of the stub when the result queue is empty.
    ///   - resultQueue: A queue of call results to use. If empty, `defaultResult` is used.
    public convenience init(
        defaultReturnValue: ReturnType,
        resultQueue: [Result<ReturnType, ErrorType>] = []
    ) {
        self.init(defaultResult: .success(defaultReturnValue), resultQueue: resultQueue)
    }


    /// Creates a new throwing stub with a default failure result.
    ///
    /// - Parameters:
    ///   - defaultError: The error that the stub throws when its result queue is empty.
    ///   - resultQueue: A queue of call results to use. If empty, `defaultResult` is used.
    public convenience init(
        defaultError: ErrorType,
        resultQueue: [Result<ReturnType, ErrorType>] = []
    ) {
        self.init(defaultResult: .failure(defaultError), resultQueue: resultQueue)
    }


    /// The arguments of the stub’s recorded calls.
    public var callArguments: [Arguments] {
        return calls.map(\.arguments)
    }


    /// The return values of the stub’s recorded calls.
    public var callResults: [Result<ReturnType, ErrorType>] {
        return calls.map(\.result)
    }
}


extension ThrowingStub: Sendable where Arguments: Sendable, ReturnType: Sendable {}


// MARK: - Arguments is Void

extension ThrowingStub where Arguments == Void {
    /// Calls the stub with an empty tuple.
    public func callAsFunction() throws(ErrorType) -> ReturnType {
        return try callAsFunction(())
    }
}


// MARK: - ReturnType is Void

extension ThrowingStub where ReturnType == Void {
    /// Creates a new stub with the specified default error.
    ///
    /// For `nil` `defaultError` or `errorQueue` elements, the stub will return without throwing.
    ///
    /// - Parameters:
    ///   - defaultError: The error that the stub will throw when the error queue is empty.
    ///   - errorQueue: A queue of errors to throw. If empty, `defaultError` is used instead.
    public convenience init(defaultError: ErrorType? = nil, errorQueue: [ErrorType?] = []) {
        self.init(
            defaultResult: defaultError.map(Result.failure(_:)) ?? .success(()),
            resultQueue: errorQueue.map { $0.map(Result.failure(_:)) ?? .success(()) }
        )
    }


    /// The error that the stub will throw when the error queue is empty.
    ///
    /// `nil` indicates that the function will return without throwing.
    public var defaultError: ErrorType? {
        switch defaultResult {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }


    /// A queue of errors to throw.
    ///
    /// `nil` elements indicate that the function will return without throwing. If empty, ``defaultError`` is used
    /// instead.
    public var errorQueue: [ErrorType?] {
        return resultQueue.map { (result) in
            switch result {
            case .success:
                return nil
            case .failure(let error):
                return error
            }
        }
    }


    /// The errors thrown by stub’s recorded calls.
    public var callErrors: [ErrorType?] {
        return calls.map(\.error)
    }
}


extension ThrowingStub.Call where ReturnType == Void {
    /// The error that the call threw, or `nil` if no error was thrown.
    public var error: ErrorType? {
        switch result {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}


// MARK: - ErrorType is Never

/// A stub for a non-throwing function.
public typealias Stub<Arguments, ReturnType> = ThrowingStub<Arguments, ReturnType, Never>


extension ThrowingStub where ErrorType == Never {
    /// Creates a new stub with the specified default return value.
    ///
    /// - Parameters:
    ///   - defaultReturnValue: The return value of the stub when the return value queue is empty.
    ///   - returnValueQueue: A queue of values to return. If empty, `defaultReturnValue` is used.
    public convenience init(defaultReturnValue: ReturnType, returnValueQueue: [ReturnType] = []) {
        self.init(
            defaultResult: .success(defaultReturnValue),
            resultQueue: returnValueQueue.map(Result.success(_:))
        )
    }


    /// The stub’s default return value.
    ///
    /// This value is returned whenever the stub is called and ``returnValueQueue`` is empty.
    public var defaultReturnValue: ReturnType {
        switch defaultResult {
        case .success(let value):
            return value
        }
    }


    /// The stub’s queue of return values.
    ///
    /// The first value of this queue is removed and returned whenever the stub is called. If empty,
    /// ``defaultReturnValue`` is used instead.
    public var returnValueQueue: [ReturnType] {
        return resultQueue.map { (result) in
            switch result {
            case .success(let value):
                return value
            }
        }
    }


    /// The return values for stub’s recorded calls.
    public var callReturnValues: [ReturnType] {
        return calls.map(\.returnValue)
    }
}


extension ThrowingStub.Call where ErrorType == Never {
    /// The return value of the call.
    public var returnValue: ReturnType {
        switch result {
        case .success(let value):
            return value
        }
    }
}
