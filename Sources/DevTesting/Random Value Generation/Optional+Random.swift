//
//  Optional+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import Foundation

extension Optional {
    /// Randomly returns a value or `nil`.
    ///
    /// - Parameters:
    ///   - value: An autoclosure that returns the non-`nil` value. This closure is only executed if the value will be
    ///     returned. If `nil` will be returned, it will not be called.
    ///   - generator: The random number generator to use when creating the new random optional.
    public static func random(
        _ value: @autoclosure () -> Wrapped,
        using generator: inout some RandomNumberGenerator
    ) -> Self {
        return Bool.random(using: &generator) ? value() : nil
    }
}
