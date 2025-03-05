//
//  CaseIterable+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/5/25.
//

import DevTesting
import Foundation
import Testing


struct CaseIterable_RandomTests {
    @Test
    func randomReturnsNilForUninhabitedEnum() {
        var rng = SystemRandomNumberGenerator()
        #expect(UninhabitedEnum.random(using: &rng) == nil)
    }


    @Test
    func randomReturnsNonNilForInhabitedEnum() throws {
        var rng = SystemRandomNumberGenerator()
        let results = (0 ..< 10_000).map { _ in InhabitedEnum.random(using: &rng) }

        let countsByCase: [InhabitedEnum: Int] = try results.reduce(into: [:]) { (countsByCase, caseValue) in
            let caseValue = try #require(caseValue)
            countsByCase[caseValue, default: 0] += 1
        }

        #expect(countsByCase.count == 3)
        for (_, count) in countsByCase {
            let caseProportion = Double(count) / Double(results.count)
            #expect(caseProportion.isApproximatelyEqual(to: 1/3, absoluteTolerance: 0.03))
        }
    }
}
