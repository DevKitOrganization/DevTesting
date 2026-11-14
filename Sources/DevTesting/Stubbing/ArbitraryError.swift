//
//  ArbitraryError.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 11/13/26.
//

import Foundation

/// An error for use in tests, such as the error a stub throws.
///
/// Use an arbitrary error when a test needs an error whose only job is to be thrown and recognized, as in
///
///     let error = randomError()
///     mockFileManager.loadContentStub = ThrowingStub(defaultError: error)
///
///     #expect(throws: error) {
///         try documentLoader.loadDocument(at: path)
///     }
public struct ArbitraryError: Error, CustomDebugStringConvertible, Hashable, Sendable {
    /// A description of the error.
    public let description: String


    /// Creates a new arbitrary error with the specified description.
    ///
    /// - Parameter description: A description of the error.
    public init(description: String) {
        self.description = description
    }


    public var debugDescription: String {
        return description
    }
}
