//
//  Data+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/6/25.
//

import DevTesting
import Foundation
import Testing


struct Data_RandomTests {
    @Test
    func randomReturnsEmptyDataWhenCountIsNonPositive() {
        var rng = SystemRandomNumberGenerator()

        #expect(Data.random(count: 0, using: &rng).isEmpty)

        let negativeCount = Int.random(in: -100 ..< 0, using: &rng)
        #expect(Data.random(count: negativeCount, using: &rng).isEmpty)
    }


    @Test(arguments: [3, 8, 65, 130, 258, 519, 1033])
    func randomReturnsCorrectDataWhenCountIsPositive(count: Int) {
        var rng = SystemRandomNumberGenerator()

        let data = Data.random(count: count, using: &rng)
        #expect(data.count == count)

        let minimumUniqueBytes = min(count / 2, 200)
        let uniqueBytes = Set(data)
        #expect(uniqueBytes.count >= minimumUniqueBytes)
    }
}
