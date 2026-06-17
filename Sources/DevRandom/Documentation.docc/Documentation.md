# ``DevRandom``

Generate random values of common types using a seedable random number generator.


## Overview

DevRandom is a small package that can generate random values of common types like data, dates,
strings, URLs, and UUIDs. It includes ``SeedableRandomNumberGenerator``, which will always produce
the same sequence of random numbers given the same seed, as well as numerous extensions for adding
random value generation to types in the Swift Standard Library and Foundation.


## Topics

### Generating Random Values

- ``SeedableRandomNumberGenerator``

### Random Value Generation Extensions

- ``Swift/BinaryFloatingPoint``
- ``Swift/CaseIterable``
- ``Foundation/Data``
- ``Foundation/Date``
- ``Swift/Optional``
- ``Swift/String``
- ``Foundation/URL``
- ``Foundation/URLComponents``
- ``Foundation/URLQueryItem``
- ``Foundation/UUID``
