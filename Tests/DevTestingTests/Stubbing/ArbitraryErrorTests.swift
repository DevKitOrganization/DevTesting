//
//  ArbitraryErrorTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 11/13/26.
//

import DevTesting
import Foundation
import Testing

struct ArbitraryErrorTests {
    @Test
    func initSetsDescription() {
        let error = ArbitraryError(description: "description")

        #expect(error.description == "description")
        #expect(error.debugDescription == "description")
    }
}
