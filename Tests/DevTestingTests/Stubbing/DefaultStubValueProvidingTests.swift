//
//  DefaultStubValueProvidingTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 11/13/26.
//

import DevTesting
import Foundation
import Testing

struct DefaultStubValueProvidingTests {
    @Test
    func collectionDefaultsAreEmpty() {
        #expect([Int].defaultStubValue.isEmpty)
        #expect([String: Int].defaultStubValue.isEmpty)
        #expect(Set<Int>.defaultStubValue.isEmpty)
    }


    @Test
    func boolDefaultIsFalse() {
        #expect(!Bool.defaultStubValue)
    }


    @Test
    func optionalDefaultIsNil() {
        #expect(Int?.defaultStubValue == nil)
    }


    @Test
    func floatingPointDefaults() {
        #expect(CGFloat.defaultStubValue == 1.234567890)
        #expect(Float32.defaultStubValue == 1.234567890)
        #expect(Float64.defaultStubValue == 1.234567890)
    }


    @Test
    func integerDefaults() {
        #expect(Int.defaultStubValue == 1_234_567_890)
        #expect(Int8.defaultStubValue == 123)
        #expect(Int16.defaultStubValue == 12_345)
        #expect(Int32.defaultStubValue == 1_234_567_890)
        #expect(Int64.defaultStubValue == 1_234_567_890)
        #expect(UInt.defaultStubValue == 1_234_567_890)
        #expect(UInt8.defaultStubValue == 123)
        #expect(UInt16.defaultStubValue == 12_345)
        #expect(UInt32.defaultStubValue == 1_234_567_890)
        #expect(UInt64.defaultStubValue == 1_234_567_890)
    }


    @Test
    func foundationDefaults() {
        #expect(Data.defaultStubValue == Data([0xDE, 0xAD, 0xC0, 0xDE]))
        #expect(Date.defaultStubValue == .distantPast)
        #expect(String.defaultStubValue == "default stub")
        #expect(URL.defaultStubValue == URL(string: "https://default.stub"))
        #expect(UUID.defaultStubValue == UUID(uuidString: "DEADC0DE-DEAD-C0DE-DEAD-C0DEDEADC0DE"))
    }
}
