//
//  ThrowingStub+DefaultStubValue.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 11/13/26.
//

import Foundation

extension ThrowingStub where ErrorType == Never, ReturnType: DefaultStubValueProviding {
    /// Creates a new stub that returns `ReturnType.defaultStubValue` until it is configured.
    public convenience init() {
        self.init(defaultReturnValue: .defaultStubValue)
    }
}


extension ThrowingStub where ErrorType == any Error {
    /// The error that an unconfigured throwing stub throws.
    private struct DefaultStubError: Error {}


    /// Creates a new throwing stub that throws an error until it is configured.
    ///
    /// The error is deliberately unspecified. A test that needs a stub to throw a particular error should configure it
    /// with that error.
    public convenience init() {
        self.init(defaultError: DefaultStubError())
    }
}
