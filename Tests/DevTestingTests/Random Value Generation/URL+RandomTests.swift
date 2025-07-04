//
//  URL+RandomTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/14/25.
//

import DevTesting
import Foundation
import Testing

struct URL_RandomTests {
    @Test(
        arguments: [
            (nil, nil),
            (nil, false),
            (nil, true),
            (false, nil),
            (false, false),
            (false, true),
            (true, nil),
            (true, false),
            (true, true),
        ]
    )
    func randomReturnsIsSameAsURLComponents(
        includeFragment: Bool? = nil,
        includeQueryItems: Bool? = nil
    ) throws {
        let seed = UInt64.random(in: 0 ... .max)

        var rng1 = SeedableRandomNumberGenerator(seed: seed)
        var rng2 = rng1

        let url = URL.random(
            includeFragment: includeFragment,
            includeQueryItems: includeQueryItems,
            using: &rng1
        )

        let expectedURL = URLComponents.random(
            includeFragment: includeFragment,
            includeQueryItems: includeQueryItems,
            using: &rng2
        ).url

        #expect(url == expectedURL)
    }
}
