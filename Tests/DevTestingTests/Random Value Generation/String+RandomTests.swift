//
//  String+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import Foundation
import Testing

@testable import DevTesting

struct String_RandomTests {
    #if os(macOS)
    @Test
    func randomWithCharactersHaltsWhenCharactersIsEmptyAndCountIsNonZero() async {
        await #expect(processExitsWith: .failure) {
            var rng = SystemRandomNumberGenerator()
            _ = String.random(withCharactersFrom: "", count: 1, using: &rng)
        }
    }
    #endif


    @Test
    func randomWithCharactersReturnsEmptyWhenCharactersIsEmptyOrCountIs0() {
        var rng = SystemRandomNumberGenerator()

        let nonEmptyCharactersResult = String.random(withCharactersFrom: "12345", count: 0, using: &rng)
        #expect(nonEmptyCharactersResult.isEmpty)

        let emptyCharactersResult = String.random(withCharactersFrom: "", count: 0, using: &rng)
        #expect(emptyCharactersResult.isEmpty)
    }


    @Test
    func randomWithCharactersReturnsStringWithCorrectCountAndCharacters() {
        var rng = SystemRandomNumberGenerator()
        let characters = Set("👍🏾👨🏾‍💻🏴‍☠️café")

        var selectedCharacters: Set<Character> = []
        for _ in 0 ... 1000 {
            let count = Int.random(in: 1 ... 32)
            let string = String.random(withCharactersFrom: characters, count: count, using: &rng)

            #expect(string.count == count)
            #expect(string.allSatisfy { characters.contains($0) })

            selectedCharacters.formUnion(string)
        }

        #expect(characters.symmetricDifference(selectedCharacters).isEmpty)
    }


    @Test
    func randomAlphanumericReturnsStringWithCorrectCountAndCharacters() {
        var rng = SystemRandomNumberGenerator()
        let characters = Set("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")

        var selectedCharacters: Set<Character> = []
        for _ in 0 ... 1000 {
            let count = Int.random(in: 1 ... 32)
            let string = String.randomAlphanumeric(count: count, using: &rng)

            #expect(string.count == count)
            #expect(string.allSatisfy { characters.contains($0) })

            selectedCharacters.formUnion(string)
        }

        #expect(characters.symmetricDifference(selectedCharacters).isEmpty)
    }


    @Test
    func randomBasicLatinReturnsStringWithCorrectCountAndCharacters() {
        var rng = SystemRandomNumberGenerator()

        let characters = Set(
            " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
        )

        for _ in 0 ... 1000 {
            let count = Int.random(in: 1 ... 32)
            let string = String.randomBasicLatin(count: count, using: &rng)
            #expect(string.count == count)
            #expect(string.allSatisfy { characters.contains($0) })
        }
    }
}
