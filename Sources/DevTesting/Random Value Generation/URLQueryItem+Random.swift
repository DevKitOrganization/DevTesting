//
//  URLQueryItem+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/14/25.
//

import Foundation


extension URLQueryItem {
    /// Returns a random URL query item.
    ///
    /// The name and value are alphanumeric strings between 3–10 characters long. There is a 10% chance that the value
    /// is `nil`.
    ///
    /// - Parameter generator: The random number generator to use when creating the new random URL components.
    public static func random(using generator: inout some RandomNumberGenerator) -> URLQueryItem {
        return URLQueryItem(
            name: .randomAlphanumeric(
                count: Int.random(in: 3 ... 10, using: &generator),
                using: &generator
            ),
            value: Int.random(in: 0 ..< 10, using: &generator) == 0 ? nil : .randomAlphanumeric(
                count: Int.random(in: 3 ... 10, using: &generator),
                using: &generator
            )
        )
    }
}
