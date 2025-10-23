//
//  Date+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 10/2/25.
//

import Foundation

extension Date {
    /// Returns a random date in the specified half-open range.
    ///
    /// - Parameters:
    ///   - range: The closed range in which to create a random value. `range` must not be empty.
    ///   - generator: The random number generator to use when creating the new random value.
    /// - Returns: A random date within the bounds of range.
    public static func random(
        in range: Range<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        let lowerBound = range.lowerBound.timeIntervalSinceReferenceDate
        let upperBound = range.upperBound.timeIntervalSinceReferenceDate
        return Date(
            timeIntervalSinceReferenceDate: .randomPrintable(
                in: lowerBound ..< upperBound,
                using: &generator
            )
        )
    }


    /// Returns a random date in the specified closed range.
    ///
    /// - Parameters:
    ///   - range: The half-open range in which to create a random value.
    ///   - generator: The random number generator to use when creating the new random value.
    /// - Returns: A random date within the bounds of range.
    public static func random(
        in range: ClosedRange<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        let lowerBound = range.lowerBound.timeIntervalSinceReferenceDate
        let upperBound = range.upperBound.timeIntervalSinceReferenceDate
        return Date(
            timeIntervalSinceReferenceDate: .randomPrintable(
                in: lowerBound ... upperBound,
                using: &generator
            )
        )
    }
}
