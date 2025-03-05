//
//  BinaryFloatingPoint+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/6/25.
//

import DevTesting
import Foundation
import Testing


struct BinaryFloatingPoint_RandomTests {
    @Test
    func halfOpenRange() throws {
        var rng = SystemRandomNumberGenerator()
        let range: Range<Float64> = -1000 ..< 1000
        let expectedVariation = (range.upperBound - range.lowerBound) * 0.9

        var minValue = Float64.infinity
        var maxValue = -Float64.infinity

        for _ in 0 ..< 10_000 {
            let value = Float64.randomPrintable(in: range, using: &rng)
            #expect(range.contains(value))

            let codableBinaryFloat = CodableBinaryFloat(value: value)
            let encoded = try PropertyListEncoder().encode(codableBinaryFloat)
            let decoded = try PropertyListDecoder().decode(CodableBinaryFloat<Float64>.self, from: encoded).value
            #expect(value == decoded)

            minValue = min(minValue, value)
            maxValue = max(maxValue, value)
        }

        #expect(maxValue - minValue >= expectedVariation)
    }


    @Test
    func closedRange() throws {
        var rng = SystemRandomNumberGenerator()
        let range: ClosedRange<Float32> = -1000 ... 1000
        let expectedVariation = (range.upperBound - range.lowerBound) * 0.9

        var minValue = Float32.infinity
        var maxValue = -Float32.infinity

        for _ in 0 ..< 10_000 {
            let value = Float32.randomPrintable(in: range, using: &rng)
            #expect(range.contains(value))

            let codableBinaryFloat = CodableBinaryFloat(value: value)
            let encoded = try JSONEncoder().encode(codableBinaryFloat)
            let decoded = try JSONDecoder().decode(CodableBinaryFloat<Float32>.self, from: encoded).value
            #expect(value == decoded)

            minValue = min(minValue, value)
            maxValue = max(maxValue, value)
        }

        #expect(maxValue - minValue >= expectedVariation)
    }
}


fileprivate struct CodableBinaryFloat<Value>: Codable where Value: BinaryFloatingPoint & Codable {
    let value: Value
}
