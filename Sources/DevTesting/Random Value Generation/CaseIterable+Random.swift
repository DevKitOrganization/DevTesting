//
//  CaseIterable+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import Foundation


extension CaseIterable {
    /// Returns a random value of this type.
    ///
    /// Returns `nil` only if the type has no values.
    ///
    /// - Parameter generator: The random number generator to use when creating the new random value.
    public static func random(using generator: inout some RandomNumberGenerator) -> Self? {
        return allCases.randomElement(using: &generator)
    }
}
