//
//  UUID+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 4/28/25.
//

import Foundation


extension UUID {
    /// Returns a random UUID.
    ///
    /// - Parameter generator: The random number generator to use when creating the new random value.
    public static func random(using generator: inout some RandomNumberGenerator) -> UUID {
        // RFC 4122 sections 4.1.2 and 4.1.3 describe random (version 4) UUIDs.
        //
        //     https://datatracker.ietf.org/doc/html/rfc4122
        //
        // The general algorithm is that you generate 16 bytes of random data, but updated the first 4 bits of byte 6
        // to be the UUID version (4), and the first 2 bits of byte 8 to be the variant number (2).
        let bytes = Data.random(count: 16, using: &generator)

        let modifiedByte6 = bytes[6] & 0x0f | 0x40
        let modifiedByte8 = bytes[8] & 0x3f | 0x80
        return UUID(
            uuid: (
                bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], modifiedByte6, bytes[7],
                modifiedByte8, bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]
            )
        )
    }
}
