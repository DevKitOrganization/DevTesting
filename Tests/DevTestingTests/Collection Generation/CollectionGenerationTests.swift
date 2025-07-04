//
//  CollectionGenerationTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/9/25.
//

import DevTesting
import Foundation
import Testing

struct CollectionGenerationTests {
    @Test
    func indexedArrayInit() {
        let count = Int.random(in: 2 ... 10)

        let array = Array(count: count) { count * $0 }
        let expectedArray = (0 ..< count).map { count * $0 }

        #expect(array == expectedArray)
    }


    @Test
    func indexedArrayInit_throws() {
        let count = Int.random(in: 3 ... 10)

        do {
            _ = try Array(count: count) { (i) throws(HashableError) in
                throw HashableError(id: count)
            }
            Issue.record("does not throw")
        } catch {
            #expect(error == HashableError(id: count))
        }
    }


    @Test
    func unindexedArrayInit() {
        let count = Int.random(in: 2 ... 10)

        let array = Array(count: count) { "🤓" }
        let expectedArray = Array(repeating: "🤓", count: count)

        #expect(array == expectedArray)
    }


    @Test
    func unindexedArrayInit_throws() {
        let count = Int.random(in: 3 ... 10)

        do {
            _ = try Array(count: count) { () throws(HashableError) in
                throw HashableError(id: count)
            }
            Issue.record("does not throw")
        } catch {
            #expect(error == HashableError(id: count))
        }
    }


    @Test
    func dictionaryInit() {
        let count = Int.random(in: 2 ... 10)


        var i = 0
        let dictionary = Dictionary(count: count) {
            defer { i += 1 }
            return (i, "\(i)")
        }
        let expectedDictionary = Dictionary(uniqueKeysWithValues: (0 ..< count).map { ($0, "\($0)") })

        #expect(dictionary == expectedDictionary)
    }


    @Test
    func dictionaryInit_throws() {
        let count = Int.random(in: 3 ... 10)

        do {
            _ = try Dictionary(count: count) { () throws(HashableError) -> (String, String) in
                throw HashableError(id: count)
            }
            Issue.record("does not throw")
        } catch {
            #expect(error == HashableError(id: count))
        }
    }


    @Test
    func setInit() {
        let count = Int.random(in: 2 ... 10)


        var i = 0
        let set = Set(count: count) {
            defer { i += 1 }
            return "\(i)"
        }
        let expectedSet = Set((0 ..< count).map { "\($0)" })

        #expect(set == expectedSet)
    }


    @Test
    func setInit_throws() {
        let count = Int.random(in: 3 ... 10)

        do {
            _ = try Set(count: count) { () throws(HashableError) -> (Float64) in
                throw HashableError(id: count)
            }
            Issue.record("does not throw")
        } catch {
            #expect(error == HashableError(id: count))
        }
    }
}
