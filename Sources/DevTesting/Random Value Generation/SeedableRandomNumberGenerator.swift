//
//  SeedableRandomNumberGenerator.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import Foundation
import os

/// An efficient, thread-safe pseudo-random number generator that can be seeded to produce repeatable results.
///
/// This type is a Swift translation of Sebastiano Vigna’s [public domain C implementation of
/// xorshiro128++](https://prng.di.unimi.it/xoroshiro128plusplus.c), though that may change in the future. See [Vigna’s
/// PRNG shootout](https://prng.di.unimi.it) for more information about the xoroshiro128++.
public struct SeedableRandomNumberGenerator: RandomNumberGenerator, Sendable {
    /// The instance’s 128 bits of internal state.
    ///
    /// This state is mutated whenever ``next()`` is called or ``seed`` is set.
    private var state: (UInt64, UInt64)


    /// Creates a new seeded random number generator with the specified seed value.
    ///
    /// The seed is used to initialize a splitmix64 pseudo-random number generator, which is then used to initialize
    /// the new random number generator’s initial state.
    ///
    /// - Parameter seed: The initial seed of the instance.
    public init(seed: UInt64 = Date.timeIntervalSinceReferenceDate.bitPattern) {
        var splitMix64 = SplitMix64RandomNumberGenerator(state: seed)
        self.seed = seed
        self.state = (splitMix64.next(), splitMix64.next())
    }


    /// The random number generator’s seed.
    public var seed: UInt64 {
        didSet {
            var splitMix64 = SplitMix64RandomNumberGenerator(state: seed)
            state = (splitMix64.next(), splitMix64.next())
        }
    }


    public mutating func next() -> UInt64 {
        let state0 = state.0
        var state1 = state.1
        let result = (state0 &+ state1).rotatedLeft(by: 17) &+ state0

        state1 ^= state0

        state.0 = state0.rotatedLeft(by: 49) ^ state1 ^ (state1 << 21)
        state.1 = state1.rotatedLeft(by: 28)

        return result
    }
}


/// A splitmix64 pseudo-random number generator.
///
/// This type is used internally by `SeededRandomNumberGenerator` to seed its initial state. It is a Swift translation
/// of Sebastiano Vigna’s [public domain C implementation of splitmix64](https://prng.di.unimi.it/splitmix64.c).
private struct SplitMix64RandomNumberGenerator: RandomNumberGenerator, Sendable {
    /// The instance’s 64 bits of internal state.
    ///
    /// This value is mutated whenever ``next()`` is called.
    private var state: UInt64


    /// Creates a new `SplitMix64RandomNumberGenerator` using the specified initial state.
    ///
    /// - Parameter state: The initial state of the new random number generator.
    init(state: UInt64) {
        self.state = state
    }


    mutating func next() -> UInt64 {
        state = state &+ 0x9e37_79b9_7f4a_7c15

        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58_476d_1ce4_e5b9
        z = (z ^ (z >> 27)) &* 0x94d0_49bb_1331_11eb
        return z ^ (z >> 31)
    }
}


extension UInt64 {
    /// Returns a copy of the instance rotated left by the specified number of bits.
    ///
    /// - Parameter bits: The number of bits to rotate the instance.
    @usableFromInline
    func rotatedLeft(by bits: Int) -> UInt64 {
        return (self << bits) | (self >> (Self.bitWidth - bits))
    }
}
