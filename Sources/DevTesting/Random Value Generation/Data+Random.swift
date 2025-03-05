//
//  Data+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/6/25.
//

import Foundation


extension Data {
    /// Returns a data instance filled with random bytes.
    ///
    /// - Parameters:
    ///   - count: The number of random bytes that the new `Data` instance should contain. If 0 or less, an empty
    ///     data instance will be returned.
    ///   - generator: The random number generator to use when creating the new random data.
    public static func random(count: Int, using generator: inout some RandomNumberGenerator) -> Data {
        guard count > 0 else {
            return Data()
        }

        var data = Data(capacity: count)

        // Generate 8 bytes at a time, only copying the the number of bytes we need
        var remainingBytes = count
        while remainingBytes > 0 {
            // Append at most 8 bytes
            let bytesToAppend = Swift.min(remainingBytes, 8)

            let value = generator.next()
            withUnsafePointer(to: value) { (pointer) in
                pointer.withMemoryRebound(to: UInt8.self, capacity: 8) { (pointer) in
                    data.append(pointer, count: bytesToAppend)
                }
            }

            remainingBytes -= bytesToAppend
        }

        return data
    }
}
