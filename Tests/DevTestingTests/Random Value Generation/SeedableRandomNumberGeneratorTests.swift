//
//  SeedableRandomNumberGeneratorTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import DevTesting
import Foundation
import Testing

struct SeedableRandomNumberGeneratorTests {
    let iterationRange = 0 ..< 1000


    @Test
    func initSetsSeed() {
        let seed = UInt64.random(in: 0 ... .max)
        let rng = SeedableRandomNumberGenerator(seed: seed)
        #expect(rng.seed == seed)
    }


    @Test
    func settingSeedUpdatesInternalState() {
        let seed = UInt64.random(in: 0 ... .max)
        var rng = SeedableRandomNumberGenerator(seed: seed)

        let results1 = iterationRange.map { _ in rng.next() }
        rng.seed = seed
        let results2 = iterationRange.map { _ in rng.next() }

        #expect(results1 == results2)
    }


    @Test
    func sameSeedProduceSameResults() {
        let seed = UInt64.random(in: 0 ... .max)

        var rng1 = SeedableRandomNumberGenerator(seed: seed)
        var rng2 = SeedableRandomNumberGenerator(seed: seed)

        for _ in iterationRange {
            #expect(rng1.next() == rng2.next())
        }
    }


    @Test
    func differentSeedsProduceDifferentResults() {
        var rng1 = SeedableRandomNumberGenerator(seed: UInt64.random(in: 0 ... .max))
        var rng2 = SeedableRandomNumberGenerator(seed: UInt64.random(in: 0 ... .max))

        let results1 = iterationRange.map { _ in rng1.next() }
        let results2 = iterationRange.map { _ in rng2.next() }

        #expect(results1 != results2)
    }
}
