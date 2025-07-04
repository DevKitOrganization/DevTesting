//
//  Optional+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import DevTesting
import Foundation
import RealModule
import Testing

struct Optional_RandomTests {
    @Test
    func randomValuesAreEvenlyDistributed() {
        var rng = SystemRandomNumberGenerator()
        let results = (0 ..< 10_000).map { i in Optional.random(i, using: &rng) }
        let nonNilPercentage = results.reduce(0) { (sum, i) in sum + (i != nil ? 1 : 0) } / Double(results.count)

        #expect(nonNilPercentage.isApproximatelyEqual(to: 0.5, absoluteTolerance: 0.03))
    }
}
