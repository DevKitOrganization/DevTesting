//
//  BinaryFloatingPoint+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/6/25.
//

import Foundation


extension BinaryFloatingPoint where RawSignificand: FixedWidthInteger {
    /// Returns a random value in the half-open range that almost always can be printed precisely in decimal.
    ///
    /// This function is useful when generating random values that need to be serialized as strings, e.g., in a JSON
    /// payload or property list and converted back to binary floating points. It works by attempting to produce a
    /// random value in the range as an integer plus a multiple of 1/256. Given this, if `range`’s width is sufficiently
    /// small, this function may not work. In that case, it will return a value within the range, but not necessarily
    /// printable.
    ///
    /// - Parameters:
    ///   - range: The range in which to create a random value. `range` must not be empty, and should generally be
    ///     wider than 1.
    ///   - generator: The random number generator to use when creating the new random value.
    public static func randomPrintable(
        in range: Range<Self>,
        using generator: inout some RandomNumberGenerator
    ) -> Self {
        let subdivisions = 256

        let random = random(in: range, using: &generator)
        let integer = random.rounded(.towardZero)
        let fraction = Self(Int.random(in: 0 ..< subdivisions, using: &generator)) / Self(subdivisions)
        let candidate = integer + fraction

        return range.contains(candidate) ? candidate : random
    }


    /// Returns a random value in the closed range that almost always can be printed precisely in decimal.
    ///
    /// This function is useful when generating random values that need to be serialized as strings, e.g., in a JSON
    /// payload or property list and converted back to binary floating points. It works by attempting to produce a
    /// random value in the range as an integer plus a multiple of 1/256. Given this, if `range`’s width is sufficiently
    /// small, this function may not work. In that case, it will return a value within the range, but not necessarily
    /// printable.
    ///
    /// - Parameters:
    ///   - range: The range in which to create a random value. `range` must not be empty, and should generally be
    ///     wider than 1.
    ///   - generator: The random number generator to use when creating the new random value.
    public static func randomPrintable(
        in range: ClosedRange<Self>,
        using generator: inout some RandomNumberGenerator
    ) -> Self {
        let subdivisions = 256

        let random = random(in: range, using: &generator)
        let integer = random.rounded(.towardZero)
        let fraction = Self(Int.random(in: 0 ..< subdivisions, using: &generator)) / Self(subdivisions)
        let candidate = integer + fraction

        return range.contains(candidate) ? candidate : random
    }
}
