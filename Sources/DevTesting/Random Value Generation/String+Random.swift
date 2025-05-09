//
//  String+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import Foundation


extension String {
    /// Returns a random string composed of characters from the specified collection.
    ///
    /// - Parameters:
    ///   - characters: The collection of characters from which the new string’s content is randomly selected. If
    ///     empty, `count` must be 0.
    ///   - count: The number of characters in the random string. Must be non-negative.
    ///   - generator: The random number generator to use when creating the new random string.
    public static func random(
        withCharactersFrom characters: some Collection<Character>,
        count: Int,
        using generator: inout some RandomNumberGenerator
    ) -> String {
        precondition(!characters.isEmpty || count == 0, "count must be 0 if characters is empty")
        guard count > 0 else {
            return ""
        }

        let randomCharacters = (0 ..< count).map { _ in characters.randomElement(using: &generator)! }
        return String(randomCharacters)
    }


    /// Returns a random string composed of alphanumeric Basic Latin characters.
    ///
    /// Specifically, the characters used are 0-9 (U+0030–U+0039), A-Z (U+0041–U+005A), and a-z (U+0061–U+007A).
    ///
    /// - Parameters:
    ///   - count: The number of characters in the random string. Must be non-negative.
    ///   - generator: The random number generator to use when creating the new random string.
    public static func randomAlphanumeric(
        count: Int,
        using generator: inout some RandomNumberGenerator
    ) -> String {
        return random(
            withCharactersFrom: characters(
                fromUnicodeScalarRanges: 0x30 ... 0x39, 0x41 ... 0x5a, 0x61 ... 0x7a
            ),
            count: count,
            using: &generator
        )
    }


    /// Returns a random string composed of printable Basic Latin characters.
    ///
    /// Specifically, the characters used are the printable characters in the Basic Latin Unicode block (U+0030–U+007E).
    /// This block includes ASCII digits, ASCII uppercase and lowercase letters, ASCII punctuation and symbols, and the
    /// space character.
    ///
    /// See [Wikipedia’s Basic Latin (Unicode block)](https://en.wikipedia.org/wiki/Basic_Latin_(Unicode_block)) for
    /// more information.
    ///
    /// - Parameters:
    ///   - count: The number of characters in the random string. Must be non-negative.
    ///   - generator: The random number generator to use when creating the new random string.
    public static func randomBasicLatin(
        count: Int,
        using generator: inout some RandomNumberGenerator
    ) -> String {
        return random(
            withCharactersFrom: characters(fromUnicodeScalarRanges: 0x20 ... 0x7e),
            count: count,
            using: &generator
        )
    }

    
    /// Returns an array of characters whose Unicode scalar values correspond to those in the specified ranges.
    ///
    /// Every scalar in the range must be a valid Unicode scalar or execution will halt.
    ///
    /// - Parameter unicodeScalarRanges: The ranges of Unicode scalar values to convert to characters.
    private static func characters(
        fromUnicodeScalarRanges unicodeScalarRanges: ClosedRange<Int> ...
    ) -> [Character] {
        return unicodeScalarRanges.flatMap { (unicodeScalarRange) in
            unicodeScalarRange.map { Character(UnicodeScalar($0)!) }
        }
    }
}
