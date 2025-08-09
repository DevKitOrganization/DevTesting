//
//  RandomValueGeneratingTests.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/9/25.
//

import DevTesting
import Foundation
import Testing

struct RandomValueGeneratingTests {
    private let iterationRange = 0 ..< 10
    private var generator = RandomValueGenerator()
    private lazy var rng: SeedableRandomNumberGenerator = {
        return SeedableRandomNumberGenerator(seed: generator.randomSeed)
    }()


    @Test
    func makeRandomNumberGeneratorUsesSeed() {
        let seed = UInt64.random(in: 0 ... .max)
        let rng = RandomValueGenerator.makeRandomNumberGenerator(seed: seed)
        #expect(rng.seed == seed)
    }


    @Test
    mutating func randomSeedGetsAndSetsSeed() {
        #expect(generator.randomSeed == generator.randomNumberGenerator.seed)

        let newSeed = UInt64.random(in: 0 ... .max)
        generator.randomSeed = newSeed
        #expect(generator.randomSeed == newSeed)
        #expect(generator.randomSeed == generator.randomNumberGenerator.seed)
    }


    @Test
    mutating func randomBoolUsesRandomNumberGenerator() {
        for _ in iterationRange {
            #expect(generator.randomBool() == Bool.random(using: &rng))
        }
    }


    @Test
    mutating func randomCaseOfUsesRandomNumberGenerator() {
        for _ in iterationRange {
            #expect(generator.randomCase(of: InhabitedEnum.self) == InhabitedEnum.random(using: &rng))
        }
    }


    @Test
    mutating func randomElementUsesRandomNumberGenerator() {
        let set: Set<String> = ["a", "b", "c", "d", "e"]

        for _ in iterationRange {
            #expect(generator.randomElement(in: set) == set.randomElement(using: &rng))
        }
    }


    @Test
    mutating func randomDataUsesRandomNumberGenerator_whenCountIsNil() {
        for _ in iterationRange {
            let randomData = generator.randomData()
            let expectedData = Data.random(count: Int.random(in: 16 ... 128, using: &rng), using: &rng)
            #expect(randomData == expectedData)
        }
    }


    @Test
    mutating func randomDataUsesRandomNumberGenerator_whenCountIsSpecified() {
        for _ in iterationRange {
            let count = Int.random(in: 0 ... 1024, using: &rng)

            // Perform the same operation on generator’s random number generator to keep the generator state in sync
            _ = Int.random(in: 0 ... 1024, using: &generator.randomNumberGenerator)

            #expect(generator.randomData(count: count) == Data.random(count: count, using: &rng))
        }
    }


    @Test
    mutating func randomFloatUsesRandomNumberGenerator_halfOpenRange() {
        for _ in iterationRange {
            let actualFloat16 = generator.random(Float16.self, in: -1000 ..< 1000)
            let expectedFloat16 = Float16.randomPrintable(in: -1000 ..< 1000, using: &rng)
            #expect(actualFloat16 == expectedFloat16)

            let actualFloat32 = generator.random(Float32.self, in: -10_000 ..< 10_000)
            let expectedFloat32 = Float32.randomPrintable(in: -10_000 ..< 10_000, using: &rng)
            #expect(actualFloat32 == expectedFloat32)

            let actualFloat64 = generator.random(Float64.self, in: -100_000 ..< 100_000)
            let expectedFloat64 = Float64.randomPrintable(in: -100_000 ..< 100_000, using: &rng)
            #expect(actualFloat64 == expectedFloat64)
        }
    }


    @Test
    mutating func randomFloat64UsesRandomNumberGenerator_halfOpenRange() {
        for _ in iterationRange {
            let actualFloat64 = generator.randomFloat64(in: -100_000 ..< 100_000)
            let expectedFloat64 = Float64.randomPrintable(in: -100_000 ..< 100_000, using: &rng)
            #expect(actualFloat64 == expectedFloat64)
        }
    }


    @Test
    mutating func randomFloatUsesRandomNumberGenerator_closedRange() {
        for _ in iterationRange {
            let actualFloat16 = generator.random(Float16.self, in: -1000 ... 1000)
            let expectedFloat16 = Float16.randomPrintable(in: -1000 ... 1000, using: &rng)
            #expect(actualFloat16 == expectedFloat16)

            let actualFloat32 = generator.random(Float32.self, in: -10_000 ... 10_000)
            let expectedFloat32 = Float32.randomPrintable(in: -10_000 ... 10_000, using: &rng)
            #expect(actualFloat32 == expectedFloat32)

            let actualFloat64 = generator.random(Float64.self, in: -100_000 ... 100_000)
            let expectedFloat64 = Float64.randomPrintable(in: -100_000 ... 100_000, using: &rng)
            #expect(actualFloat64 == expectedFloat64)
        }
    }


    @Test
    mutating func randomFloat64UsesRandomNumberGenerator_closedRange() {
        for _ in iterationRange {
            let actualFloat64 = generator.randomFloat64(in: -100_000 ... 100_000)
            let expectedFloat64 = Float64.randomPrintable(in: -100_000 ... 100_000, using: &rng)
            #expect(actualFloat64 == expectedFloat64)
        }
    }


    @Test
    mutating func randomIntegertUsesRandomNumberGenerator_halfOpenRange() {
        for _ in iterationRange {
            let actualInt8 = generator.random(Int8.self, in: -100 ..< 100)
            let expectedInt8 = Int8.random(in: -100 ..< 100, using: &rng)
            #expect(actualInt8 == expectedInt8)

            let actualInt16 = generator.random(Int16.self, in: -10_000 ..< 10_000)
            let expectedInt16 = Int16.random(in: -10_000 ..< 10_000, using: &rng)
            #expect(actualInt16 == expectedInt16)

            let actualInt32 = generator.random(Int32.self, in: -1_000_000_000 ..< 1_000_000_000)
            let expectedInt32 = Int32.random(in: -1_000_000_000 ..< 1_000_000_000, using: &rng)
            #expect(actualInt32 == expectedInt32)

            let actualInt64 = generator.random(Int64.self, in: -1_000_000_000_000_000 ..< 1_000_000_000_000_000)
            let expectedInt64 = Int64.random(in: -1_000_000_000_000_000 ..< 1_000_000_000_000_000, using: &rng)
            #expect(actualInt64 == expectedInt64)

            let actualInt = generator.random(Int.self, in: -1_000_000_000 ..< 1_000_000_000)
            let expectedInt = Int.random(in: -1_000_000_000 ..< 1_000_000_000, using: &rng)
            #expect(actualInt == expectedInt)

            let actualUInt8 = generator.random(UInt8.self, in: 0 ..< 100)
            let expectedUInt8 = UInt8.random(in: 0 ..< 100, using: &rng)
            #expect(actualUInt8 == expectedUInt8)

            let actualUInt16 = generator.random(UInt16.self, in: 0 ..< 10_000)
            let expectedUInt16 = UInt16.random(in: 0 ..< 10_000, using: &rng)
            #expect(actualUInt16 == expectedUInt16)

            let actualUInt32 = generator.random(Int32.self, in: 0 ..< 1_000_000_000)
            let expectedUInt32 = UInt32.random(in: 0 ..< 1_000_000_000, using: &rng)
            #expect(actualUInt32 == expectedUInt32)

            let actualUInt64 = generator.random(Int64.self, in: 0 ..< 1_000_000_000_000_000)
            let expectedUInt64 = UInt64.random(in: 0 ..< 1_000_000_000_000_000, using: &rng)
            #expect(actualUInt64 == expectedUInt64)

            let actualUInt = generator.random(UInt.self, in: 0 ..< 1_000_000_000)
            let expectedUInt = UInt.random(in: 0 ..< 1_000_000_000, using: &rng)
            #expect(actualUInt == expectedUInt)
        }
    }


    @Test
    mutating func randomIntUsesRandomNumberGenerator_halfOpenRange() {
        for _ in iterationRange {
            let actualInt = generator.randomInt(in: -1_000_000_000 ..< 1_000_000_000)
            let expectedInt = Int.random(in: -1_000_000_000 ..< 1_000_000_000, using: &rng)
            #expect(actualInt == expectedInt)
        }
    }


    @Test
    mutating func randomIntegerRandomNumberGenerator_closedRange() {
        for _ in iterationRange {
            let actualInt8 = generator.random(Int8.self, in: -100 ... 100)
            let expectedInt8 = Int8.random(in: -100 ... 100, using: &rng)
            #expect(actualInt8 == expectedInt8)

            let actualInt16 = generator.random(Int16.self, in: -10_000 ... 10_000)
            let expectedInt16 = Int16.random(in: -10_000 ... 10_000, using: &rng)
            #expect(actualInt16 == expectedInt16)

            let actualInt32 = generator.random(Int32.self, in: -1_000_000_000 ... 1_000_000_000)
            let expectedInt32 = Int32.random(in: -1_000_000_000 ... 1_000_000_000, using: &rng)
            #expect(actualInt32 == expectedInt32)

            let actualInt64 = generator.random(Int64.self, in: -1_000_000_000_000_000 ... 1_000_000_000_000_000)
            let expectedInt64 = Int64.random(in: -1_000_000_000_000_000 ... 1_000_000_000_000_000, using: &rng)
            #expect(actualInt64 == expectedInt64)

            let actualInt = generator.random(Int.self, in: -1_000_000_000 ... 1_000_000_000)
            let expectedInt = Int.random(in: -1_000_000_000 ... 1_000_000_000, using: &rng)
            #expect(actualInt == expectedInt)

            let actualUInt8 = generator.random(UInt8.self, in: 0 ... 100)
            let expectedUInt8 = UInt8.random(in: 0 ... 100, using: &rng)
            #expect(actualUInt8 == expectedUInt8)

            let actualUInt16 = generator.random(UInt16.self, in: 0 ... 10_000)
            let expectedUInt16 = UInt16.random(in: 0 ... 10_000, using: &rng)
            #expect(actualUInt16 == expectedUInt16)

            let actualUInt32 = generator.random(Int32.self, in: 0 ... 1_000_000_000)
            let expectedUInt32 = UInt32.random(in: 0 ... 1_000_000_000, using: &rng)
            #expect(actualUInt32 == expectedUInt32)

            let actualUInt64 = generator.random(Int64.self, in: 0 ... 1_000_000_000_000_000)
            let expectedUInt64 = UInt64.random(in: 0 ... 1_000_000_000_000_000, using: &rng)
            #expect(actualUInt64 == expectedUInt64)

            let actualUInt = generator.random(UInt.self, in: 0 ... 1_000_000_000)
            let expectedUInt = UInt.random(in: 0 ... 1_000_000_000, using: &rng)
            #expect(actualUInt == expectedUInt)
        }
    }


    @Test
    mutating func randomIntUsesRandomNumberGenerator_closedRange() {
        for _ in iterationRange {
            let actualInt = generator.randomInt(in: -1_000_000_000 ... 1_000_000_000)
            let expectedInt = Int.random(in: -1_000_000_000 ... 1_000_000_000, using: &rng)
            #expect(actualInt == expectedInt)
        }
    }


    @Test
    mutating func randomOptionalUsesRandomNumberGenerator() {
        for _ in iterationRange {
            #expect(generator.randomOptional("🤓") == Optional.random("🤓", using: &rng))
        }
    }


    @Test
    mutating func randomAlphanumericStringUsesRandomNumberGenerator_whenCountIsNil() {
        for _ in iterationRange {
            let randomString = generator.randomAlphanumericString()
            let expectedString = String.randomAlphanumeric(count: Int.random(in: 5 ... 10, using: &rng), using: &rng)
            #expect(randomString == expectedString)
        }
    }


    @Test
    mutating func randomAlphanumericStringUsesRandomNumberGenerator_whenCountIsSpecified() {
        for _ in iterationRange {
            let count = Int.random(in: 0 ... 128, using: &rng)

            // Perform the same operation on generator’s random number generator to keep the generator state in sync
            _ = Int.random(in: 0 ... 128, using: &generator.randomNumberGenerator)

            let randomString = generator.randomAlphanumericString(count: count)
            let expectedString = String.randomAlphanumeric(count: count, using: &rng)
            #expect(randomString == expectedString)
        }
    }


    @Test
    mutating func randomBasicLatinStringUsesRandomNumberGenerator_whenCountIsNil() {
        for _ in iterationRange {
            let randomString = generator.randomBasicLatinString()
            let expectedString = String.randomBasicLatin(count: Int.random(in: 5 ... 10, using: &rng), using: &rng)
            #expect(randomString == expectedString)
        }
    }


    @Test
    mutating func randomBasicLatinStringUsesRandomNumberGenerator_whenCountIsSpecified() {
        for _ in iterationRange {
            let count = Int.random(in: 0 ... 128, using: &rng)

            // Perform the same operation on generator’s random number generator to keep the generator state in sync
            _ = Int.random(in: 0 ... 128, using: &generator.randomNumberGenerator)

            let randomString = generator.randomBasicLatinString(count: count)
            let expectedString = String.randomBasicLatin(count: count, using: &rng)
            #expect(randomString == expectedString)
        }
    }


    @Test
    mutating func randomStringUsesRandomNumberGenerator_whenCountIsNil() {
        for _ in iterationRange {
            let randomString = generator.randomString(withCharactersFrom: "🤓👾💀💩")
            let expectedString = String.random(
                withCharactersFrom: "🤓👾💀💩",
                count: Int.random(in: 5 ... 10, using: &rng),
                using: &rng
            )
            #expect(randomString == expectedString)
        }
    }


    @Test
    mutating func randomStringUsesRandomNumberGenerator_whenCountIsSpecified() {
        for _ in iterationRange {
            let count = Int.random(in: 0 ... 128, using: &rng)

            // Perform the same operation on generator’s random number generator to keep the generator state in sync
            _ = Int.random(in: 0 ... 128, using: &generator.randomNumberGenerator)

            let randomString = generator.randomString(withCharactersFrom: "🤓👾💀💩", count: count)
            let expectedString = String.random(withCharactersFrom: "🤓👾💀💩", count: count, using: &rng)
            #expect(randomString == expectedString)
        }
    }


    @Test
    mutating func randomUUIDRandomNumberGenerator() {
        for _ in iterationRange {
            #expect(UUID.random(using: &rng) == generator.randomUUID())
        }
    }


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
    mutating func randomURLUsesRandomNumberGenerator(includeFragment: Bool?, includeQueryItems: Bool?) {
        for _ in iterationRange {
            let randomURL = generator.randomURL(
                includeFragment: includeFragment,
                includeQueryItems: includeQueryItems
            )

            let expectedURL = URL.random(
                includeFragment: includeFragment,
                includeQueryItems: includeQueryItems,
                using: &rng
            )

            #expect(randomURL == expectedURL)
        }
    }


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
    mutating func randomURLComponentsUsesRandomNumberGenerator(includeFragment: Bool?, includeQueryItems: Bool?) {
        for _ in iterationRange {
            let randomURLComponents = generator.randomURLComponents(
                includeFragment: includeFragment,
                includeQueryItems: includeQueryItems
            )

            let expectedURLComponents = URLComponents.random(
                includeFragment: includeFragment,
                includeQueryItems: includeQueryItems,
                using: &rng
            )

            #expect(randomURLComponents == expectedURLComponents)
        }
    }


    @Test
    mutating func randomURLQueryItemRandomNumberGenerator() {
        for _ in iterationRange {
            let randomQueryItem = generator.randomURLQueryItem()
            let expectedURLQueryItem = URLQueryItem.random(using: &rng)
            #expect(randomQueryItem == expectedURLQueryItem)
        }
    }
}


private struct RandomValueGenerator: RandomValueGenerating {
    var randomNumberGenerator = makeRandomNumberGenerator()
}
