//
//  ThrowingStub+DefaultStubValueTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 11/13/26.
//

import DevTesting
import Foundation
import Testing

struct ThrowingStub_DefaultStubValueTests {
    @Test
    func stubInitReturnsDefaultStubValue() {
        let stub = Stub<String, Int>()

        #expect(stub.defaultReturnValue == Int.defaultStubValue)
        #expect(stub.returnValueQueue.isEmpty)
        #expect(stub.calls.isEmpty)

        #expect(stub("argument") == Int.defaultStubValue)
        #expect(stub.callArguments == ["argument"])
    }


    @Test
    func stubInitReturnsConfiguredValueAfterConfiguration() {
        let stub = Stub<Void, String>()
        stub.defaultResult = .success("configured")

        #expect(stub() == "configured")
    }


    @Test
    func throwingStubInitThrowsUntilConfigured() throws {
        let stub = ThrowingStub<String, Int, any Error>()

        #expect(stub.resultQueue.isEmpty)
        #expect(stub.calls.isEmpty)

        #expect(throws: (any Error).self) {
            try stub("argument")
        }
        #expect(stub.callArguments == ["argument"])

        stub.defaultResult = .success(3)
        #expect(try stub("argument") == 3)
    }


    @Test
    func throwingStubInitWithVoidReturnTypeThrowsUntilConfigured() {
        let stub = ThrowingStub<Void, Void, any Error>()

        #expect(throws: (any Error).self) {
            try stub()
        }
    }


    @Test
    func voidStubInitStillReturnsVoid() {
        // Void can’t conform to DefaultStubValueProviding, so this must use the existing Void initializer
        let stub = Stub<Void, Void>()

        stub()
        #expect(stub.calls.count == 1)
    }
}
