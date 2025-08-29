//
//  URLQueryItem+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/14/25.
//

import DevTesting
import Foundation
import RealModule
import Testing

struct URLQueryItem_RandomTests {
    @Test
    func randomReturnsCorrectQueryItems() {
        let iterationCount = 1000
        var rng = SystemRandomNumberGenerator()

        var nilValueCount = 0
        for _ in 0 ..< iterationCount {
            let queryItem = URLQueryItem.random(using: &rng)
            #expect((3 ... 10).contains(queryItem.name.count))

            if let value = queryItem.value {
                #expect((3 ... 10).contains(value.count))
            } else {
                nilValueCount += 1
            }
        }

        let nilValuePercentage = Double(nilValueCount) / Double(iterationCount)
        #expect(nilValuePercentage.isApproximatelyEqual(to: 0.1, absoluteTolerance: 0.03))
    }
}
