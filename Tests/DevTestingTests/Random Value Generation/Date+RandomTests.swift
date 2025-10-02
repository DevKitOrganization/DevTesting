//
//  Date+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 10/2/25.
//

import DevTesting
import Foundation
import Testing

struct DateRandomTests {
    @Test
    func halfOpenRange() {
        var rng = SystemRandomNumberGenerator()

        let min = TimeInterval.random(in: -10_000_000 ..< 0)
        let max = TimeInterval.random(in: 0 ... 10_000_000)
        let range = Date(timeIntervalSinceReferenceDate: min) ..< Date(timeIntervalSinceReferenceDate: max)

        let dates = Set((0 ..< 100).map { _ in Date.random(in: range, using: &rng) })
        #expect(dates.count == 100)
        #expect(dates.allSatisfy { range.contains($0) })
    }


    @Test
    func closedRange() {
        var rng = SystemRandomNumberGenerator()

        let min = TimeInterval.random(in: -10_000_000 ..< 0)
        let max = TimeInterval.random(in: 0 ... 10_000_000)
        let range = Date(timeIntervalSinceReferenceDate: min) ... Date(timeIntervalSinceReferenceDate: max)

        let dates = Set((0 ..< 100).map { _ in Date.random(in: range, using: &rng) })
        #expect(dates.count == 100)
        #expect(dates.allSatisfy { range.contains($0) })
    }
}
