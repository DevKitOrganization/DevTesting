//
//  RandomValueGenerating.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/9/25.
//

import Foundation
import os
import Testing


/// A logger used to log random seeds.
fileprivate let randomizationLogger = Logger(subsystem: "DevTesting", category: "randomization")


/// A type that can generate random values.
///
/// Swift Testing test suites can conform to this type to use random values and gain many convenient functions for
/// generating random values. For example,
///
///     struct MyTests {
///         var randomNumberGenerator = makeRandomNumberGenerator()
///
///
///         @Test
///         mutating func testSomething() {
///             let string = randomBasicLatinString()
///             let int = random(Int.self, in: 0 ... 10)
///             let bool = randomBool()
///             let optional = randomOptional(randomAlphanumericString())
///
///             …
///         }
///     }
///
/// Importantly, ``makeRandomNumberGenerator(seed:)`` and ``randomSeed``’s setter log the seed (using subsystem
/// `DevTesting` and category `randomization`), which appear in Xcode’s output and can be queried via the command-line
/// 
public protocol RandomValueGenerating {
    /// The random number generator that the type uses to generate values.
    var randomNumberGenerator: SeedableRandomNumberGenerator { get set }

    /// The seed used by the random number generator.
    var randomSeed: UInt64 { get set }
}


extension RandomValueGenerating {
    /// Creates and returns a new seedable random number generator with the specified seed.
    ///
    /// Logs the seed to the standard output device before returning.
    ///
    /// - Parameter seed: The seed with which to initialize the random number generator. By default, this is a value
    ///   based on the the current time.
    public static func makeRandomNumberGenerator(
        seed: UInt64 = Date.timeIntervalSinceReferenceDate.bitPattern
    ) -> SeedableRandomNumberGenerator {
        Self.logSeed(seed)
        return SeedableRandomNumberGenerator(seed: seed)
    }


    /// The random number generator’s seed.
    ///
    /// This property’s setter logs the new seed to the standard output device.
    public var randomSeed: UInt64 {
        get {
            return randomNumberGenerator.seed
        }

        set {
            Self.logSeed(newValue)
            randomNumberGenerator.seed = newValue
        }
    }


    /// Outputs the current seed value to the standard output device.
    private static func logSeed(_ seed: UInt64) {
        let logPrefix = Test.current.map { (test) in
            "\(test.id.moduleName).\(test.id.nameComponents.joined(separator: ".")): "
        }

        randomizationLogger.log("\(logPrefix ?? "", privacy: .public)Using random seed \(seed)")
    }


    // MARK: - Booleans

    /// Returns a random boolean.
    public mutating func randomBool() -> Bool {
        return Bool.random(using: &randomNumberGenerator)
    }


    // MARK: - Collection Elements

    /// Returns a random case of the specified case iterable type.
    ///
    /// See ``Swift/CaseIterable/random(using:)`` for more information.
    ///
    /// - Parameter type: The type of case iterable.
    public mutating func randomCase<CaseIterableType>(
        of type: CaseIterableType.Type
    ) -> CaseIterableType?
    where CaseIterableType: CaseIterable {
        return CaseIterableType.random(using: &randomNumberGenerator)
    }


    /// Returns a random element in the specified collection.
    ///
    /// Returns `nil` if the collection is empty.
    ///
    /// - Parameter collection: The collection from which to select a random element.
    public mutating func randomElement<Element>(
        in collection: some Collection<Element>
    ) -> Element? {
        return collection.randomElement(using: &randomNumberGenerator)
    }


    // MARK: - Data

    /// Returns a data instance filled with random bytes.
    ///
    /// - Parameter count: The number of bytes that the random instance should contain. If `nil`, a random value between
    ///   16 and 128 will be chosen.
    public mutating func randomData(count: Int? = nil) -> Data {
        return Data.random(
            count: count ?? random(Int.self, in: 16 ... 128),
            using: &randomNumberGenerator
        )
    }


    // MARK: - Numeric Types

    /// Returns a random binary floating point of the specified type within the specified range.
    ///
    /// - Parameters:
    ///   - type: The type of binary floating point to create.
    ///   - range: The half-open range in which to create a random value.
    public mutating func random<FloatingPoint>(
        _ type: FloatingPoint.Type,
        in range: Range<FloatingPoint>
    ) -> FloatingPoint
    where FloatingPoint: BinaryFloatingPoint, FloatingPoint.RawSignificand: FixedWidthInteger {
        return FloatingPoint.randomPrintable(in: range, using: &randomNumberGenerator)
    }


    /// Returns a random binary floating point of the specified type within the specified range.
    ///
    /// - Parameters:
    ///   - type: The type of binary floating point to create.
    ///   - range: The closed range in which to create a random value.
    public mutating func random<FloatingPoint>(
        _ type: FloatingPoint.Type,
        in range: ClosedRange<FloatingPoint>
    ) -> FloatingPoint
    where FloatingPoint: BinaryFloatingPoint, FloatingPoint.RawSignificand: FixedWidthInteger {
        return FloatingPoint.randomPrintable(in: range, using: &randomNumberGenerator)
    }


    /// Returns a random integer of the specified type within the specified range.
    ///
    /// - Parameters:
    ///   - type: The type of fixed width integer to create.
    ///   - range: The half-open range in which to create a random value.
    public mutating func random<Integer>(
        _ type: Integer.Type,
        in range: Range<Integer>
    ) -> Integer
    where Integer: FixedWidthInteger {
        return Integer.random(in: range, using: &randomNumberGenerator)
    }


    /// Returns a random integer of the specified type within the specified range.
    ///
    /// - Parameters:
    ///   - type: The type of fixed width integer to create.
    ///   - range: The closed range in which to create a random value.
    public mutating func random<Integer>(
        _ type: Integer.Type,
        in range: ClosedRange<Integer>
    ) -> Integer
    where Integer: FixedWidthInteger {
        return Integer.random(in: range, using: &randomNumberGenerator)
    }


    // MARK: - Optionals

    /// Randomly returns a value or `nil`.
    ///
    /// - Parameter value: The value to randomly make optional.
    public mutating func randomOptional<Wrapped>(_ value: Wrapped) -> Wrapped? {
        return Optional.random(value, using: &randomNumberGenerator)
    }


    // MARK: - Strings

    /// Returns a random alphanumeric string.
    ///
    ///
    /// See ``Swift/String/randomAlphanumeric(count:using:)`` for more information.
    ///
    /// - Parameter count: The number of characters the string should contain. If `nil`, a random value between 5 and
    ///   10 is chosen.
    public mutating func randomAlphanumericString(count: Int? = nil) -> String {
        return String.randomAlphanumeric(
            count: count ?? Int.random(in: 5 ... 10, using: &randomNumberGenerator),
            using: &randomNumberGenerator
        )
    }


    /// Returns a random string containing Basic Latin characters.
    ///
    /// See ``Swift/String/randomBasicLatin(count:using:)`` for more information.
    ///
    /// - Parameter count: The number of characters the string should contain. If `nil`, a random value between 5 and
    ///   10 is chosen.
    public mutating func randomBasicLatinString(count: Int? = nil) -> String {
        return String.randomBasicLatin(
            count: count ?? Int.random(in: 5 ... 10, using: &randomNumberGenerator),
            using: &randomNumberGenerator
        )
    }


    /// Returns a random string containing characters from the specified collection.
    ///
    /// See ``Swift/String/random(withCharactersFrom:count:using:)`` for more information.
    ///
    /// - Parameters:
    ///   - characters: A collection of characters from which to randomly select the contents of the string.
    ///   - count: The number of characters the string should contain. If `nil`, a random value between 5 and 10 is
    ///     chosen.
    public mutating func randomString(
        withCharactersFrom characters: some Collection<Character>,
        count: Int? = nil
    ) -> String {
        return String.random(
            withCharactersFrom: characters,
            count: count ?? Int.random(in: 5 ... 10, using: &randomNumberGenerator),
            using: &randomNumberGenerator
        )
    }


    // MARK: - URLs

    /// Returns a random URL.
    ///
    /// See ``Foundation/URL/random(includeFragment:includeQueryItems:using:)`` for more information.
    ///
    /// - Parameters:
    ///   - includeFragment: Whether the components should include a fragment. If `nil`, the function will randomly
    ///     include a fragment or not.
    ///   - includeQueryItems: Whether the components should include query items. If `nil`, the function will randomly
    ///     include query items or not.
    public mutating func randomURL(
        includeFragment: Bool? = nil,
        includeQueryItems: Bool? = nil
    ) -> URL {
        return URL.random(
            includeFragment: includeFragment,
            includeQueryItems: includeQueryItems,
            using: &randomNumberGenerator
        )
    }


    /// Returns random URL components.
    ///
    /// See ``Foundation/URLComponents/random(includeFragment:includeQueryItems:using:)`` for more information.
    ///
    /// - Parameters:
    ///   - includeFragment: Whether the components should include a fragment. If `nil`, the function will randomly
    ///     include a fragment or not.
    ///   - includeQueryItems: Whether the components should include query items. If `nil`, the function will randomly
    ///     include query items or not.
    public mutating func randomURLComponents(
        includeFragment: Bool? = nil,
        includeQueryItems: Bool? = nil
    ) -> URLComponents {
        return URLComponents.random(
            includeFragment: includeFragment,
            includeQueryItems: includeQueryItems,
            using: &randomNumberGenerator
        )
    }


    /// Returns a random URL query item.
    ///
    /// See ``Foundation/URLQueryItem/random(using:)`` for more information.
    public mutating func randomURLQueryItem() -> URLQueryItem {
        return URLQueryItem.random(using: &randomNumberGenerator)
    }
}
