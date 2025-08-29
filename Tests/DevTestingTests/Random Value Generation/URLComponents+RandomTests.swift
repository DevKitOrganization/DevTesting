//
//  URLComponents+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/14/25.
//

import DevTesting
import Foundation
import RealModule
import Testing

struct URLComponents_RandomTests {
    @Test
    func randomReturnsCorrectComponentsWhenIncludeArgumentsAreNil() throws {
        let iterationCount = 1000
        var rng = SystemRandomNumberGenerator()
        let hostRegex = /subdomain[A-Za-z0-9]{5}\.domain[A-Za-z0-9]{5}\.(com|edu|gov|net|org)/
        let pathRegex = /(\/[A-Za-z0-9]{1,5}){1,5}/

        var nilFragmentCount = 0
        var nilQueryItemsCount = 0

        for _ in 0 ..< iterationCount {
            let components = URLComponents.random(using: &rng)

            #expect(components.scheme == "https")

            let host = try #require(components.host)
            #expect(try hostRegex.wholeMatch(in: host) != nil)

            #expect(try pathRegex.wholeMatch(in: components.path) != nil)

            if let fragment = components.fragment {
                #expect((3 ... 5).contains(fragment.count))
            } else {
                nilFragmentCount += 1
            }

            if let queryItems = components.queryItems {
                #expect((1 ... 5).contains(queryItems.count))
            } else {
                nilQueryItemsCount += 1
            }
        }

        let nilFragmentPercentage = Double(nilFragmentCount) / Double(iterationCount)
        let nilQueryItemsPercentage = Double(nilQueryItemsCount) / Double(iterationCount)

        #expect(nilFragmentPercentage.isApproximatelyEqual(to: 0.5, absoluteTolerance: 0.03))
        #expect(nilQueryItemsPercentage.isApproximatelyEqual(to: 0.5, absoluteTolerance: 0.03))
    }


    @Test(arguments: [(false, false), (false, true), (true, false), (true, true)])
    func randomReturnsCorrectComponentsWhenIncludeArgumentsAreNonNil(
        includeFragment: Bool,
        includeQueryItems: Bool
    ) throws {
        let iterationCount = 10
        var rng = SystemRandomNumberGenerator()

        for _ in 0 ..< iterationCount {
            let components = URLComponents.random(
                includeFragment: includeFragment,
                includeQueryItems: includeQueryItems,
                using: &rng
            )

            // The properties should be non-nil if and only if the corresponding boolean is true
            #expect((components.fragment != nil) == includeFragment)
            #expect((components.queryItems != nil) == includeQueryItems)
        }
    }
}
