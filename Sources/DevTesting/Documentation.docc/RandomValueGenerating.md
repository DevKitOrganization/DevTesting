# ``RandomValueGenerating``

## Topics

### Seedable Random Number Generation

- ``makeRandomNumberGenerator(seed:)``
- ``randomNumberGenerator``
- ``randomSeed``


### Collection Elements

- ``randomCase(of:)``
- ``randomElement(in:)``


### Dates

- ``defaultClosedDateRange``
- ``randomDate(in:)-(ClosedRange<Date>?)``
- ``randomDate(in:)-(Range<Date>)``


### Numeric Types

- ``randomFloat64(in:)-(Range<Float64>)``
- ``randomFloat64(in:)-(ClosedRange<Float64>)``
- ``randomInt(in:)-(Range<Int>)``
- ``randomInt(in:)-(ClosedRange<Int>)``
- ``random(_:in:)-(_,Range<Integer>)``
- ``random(_:in:)-(_,ClosedRange<Integer>)``
- ``random(_:in:)-(_,Range<FloatingPoint>)``
- ``random(_:in:)-(_,ClosedRange<FloatingPoint>)``


### Strings

- ``randomAlphanumericString(count:)``
- ``randomBasicLatinString(count:)``
- ``randomString(withCharactersFrom:count:)``


### URL Types

- ``randomURL(includeFragment:includeQueryItems:)``
- ``randomURLComponents(includeFragment:includeQueryItems:)``
- ``randomURLQueryItem()``


### Other Common Types

- ``randomBool()``
- ``randomData(count:)``
- ``randomOptional(_:)``
- ``randomUUID()``
