//
//  UUID+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 4/28/25.
//

import DevTesting
import Foundation
import Testing


final class UUID_RandomTests {
    @Test
    func generatesUUIDFromTwoUInt64s() {
        let uint1 = UInt64.random(in: 0 ... .max)
        let uint2 = UInt64.random(in: 0 ... .max)
        var rng = MockRandomNumberGenerator(nextQueue: [uint1, uint2])

        let uuid = UUID.random(using: &rng)

        // Except for bytes 6 and 8, all bytes are just taken from the randomly generated values. Byte 6 starts with
        // 0x4 and is otherwise random. The first two bits of Byte 8 are 2, but is otherwise random.
        #expect(uuid.uuid.0  == UInt8((uint1 >> (0 * 8)) & 0xff))
        #expect(uuid.uuid.1  == UInt8((uint1 >> (1 * 8)) & 0xff))
        #expect(uuid.uuid.2  == UInt8((uint1 >> (2 * 8)) & 0xff))
        #expect(uuid.uuid.3  == UInt8((uint1 >> (3 * 8)) & 0xff))
        #expect(uuid.uuid.4  == UInt8((uint1 >> (4 * 8)) & 0xff))
        #expect(uuid.uuid.5  == UInt8((uint1 >> (5 * 8)) & 0xff))
        #expect(uuid.uuid.6  == UInt8((uint1 >> (6 * 8)) & 0x0f | 0x40))
        #expect(uuid.uuid.7  == UInt8((uint1 >> (7 * 8)) & 0xff))
        #expect(uuid.uuid.8  == UInt8((uint2 >> (0 * 8)) & 0x3f | 0x80))
        #expect(uuid.uuid.9  == UInt8((uint2 >> (1 * 8)) & 0xff))
        #expect(uuid.uuid.10 == UInt8((uint2 >> (2 * 8)) & 0xff))
        #expect(uuid.uuid.11 == UInt8((uint2 >> (3 * 8)) & 0xff))
        #expect(uuid.uuid.12 == UInt8((uint2 >> (4 * 8)) & 0xff))
        #expect(uuid.uuid.13 == UInt8((uint2 >> (5 * 8)) & 0xff))
        #expect(uuid.uuid.14 == UInt8((uint2 >> (6 * 8)) & 0xff))
        #expect(uuid.uuid.15 == UInt8((uint2 >> (7 * 8)) & 0xff))
    }
}


private struct MockRandomNumberGenerator: RandomNumberGenerator {
    var nextQueue: [UInt64] = []


    mutating func next() -> UInt64 {
        return nextQueue.removeFirst()
    }
}
