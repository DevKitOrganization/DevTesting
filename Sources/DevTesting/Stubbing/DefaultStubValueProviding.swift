//
//  DefaultStubValueProviding.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 11/13/26.
//

import Foundation

/// A type that can provide a default value for use as a stub’s unconfigured return value.
///
/// Stubs whose return type conforms to this protocol can be created with no arguments, as in
/// `Stub<Void, String>()`. Such a stub returns its return type’s default stub value until it is configured, so a
/// test that calls an unconfigured stub gets a value instead of crashing on a force-unwrapped `nil`.
///
/// Where possible, choose a default value that is obviously a placeholder rather than realistic data, so that it is
/// easy to recognize when debugging and unlikely to make a test pass by accident. Complex types can compose their
/// default from their properties’ defaults:
///
///     extension Person: DefaultStubValueProviding {
///         public static var defaultStubValue: Person {
///             return Person(
///                 givenName: .defaultStubValue,
///                 familyName: .defaultStubValue,
///                 age: .defaultStubValue,
///             )
///         }
///     }
public protocol DefaultStubValueProviding {
    /// The value a stub returns before it is configured.
    static var defaultStubValue: Self { get }
}


extension Array: DefaultStubValueProviding {
    /// An empty array.
    public static var defaultStubValue: [Element] {
        return []
    }
}


extension Bool: DefaultStubValueProviding {
    /// `false`.
    public static var defaultStubValue: Bool {
        return false
    }
}


extension CGFloat: DefaultStubValueProviding {
    /// 1.234567890.
    public static var defaultStubValue: CGFloat {
        return 1.234567890
    }
}


extension Data: DefaultStubValueProviding {
    /// The bytes `DE AD C0 DE`.
    public static var defaultStubValue: Data {
        return Data([0xDE, 0xAD, 0xC0, 0xDE])
    }
}


extension Date: DefaultStubValueProviding {
    /// `Date.distantPast`.
    public static var defaultStubValue: Date {
        return .distantPast
    }
}


extension Dictionary: DefaultStubValueProviding {
    /// An empty dictionary.
    public static var defaultStubValue: [Key: Value] {
        return [:]
    }
}


extension Float32: DefaultStubValueProviding {
    /// 1.234567890.
    public static var defaultStubValue: Float32 {
        return 1.234567890
    }
}


extension Float64: DefaultStubValueProviding {
    /// 1.234567890.
    public static var defaultStubValue: Float64 {
        return 1.234567890
    }
}


extension Int: DefaultStubValueProviding {
    /// 1,234,567,890.
    public static var defaultStubValue: Int {
        return 1_234_567_890
    }
}


extension Int8: DefaultStubValueProviding {
    /// 123.
    public static var defaultStubValue: Int8 {
        return 123
    }
}


extension Int16: DefaultStubValueProviding {
    /// 12,345.
    public static var defaultStubValue: Int16 {
        return 12_345
    }
}


extension Int32: DefaultStubValueProviding {
    /// 1,234,567,890.
    public static var defaultStubValue: Int32 {
        return 1_234_567_890
    }
}


extension Int64: DefaultStubValueProviding {
    /// 1,234,567,890.
    public static var defaultStubValue: Int64 {
        return 1_234_567_890
    }
}


extension Optional: DefaultStubValueProviding {
    /// `nil`.
    public static var defaultStubValue: Wrapped? {
        return nil
    }
}


extension Set: DefaultStubValueProviding {
    /// An empty set.
    public static var defaultStubValue: Set<Element> {
        return []
    }
}


extension String: DefaultStubValueProviding {
    /// `"default stub"`.
    public static var defaultStubValue: String {
        return "default stub"
    }
}


extension UInt: DefaultStubValueProviding {
    /// 1,234,567,890.
    public static var defaultStubValue: UInt {
        return 1_234_567_890
    }
}


extension UInt8: DefaultStubValueProviding {
    /// 123.
    public static var defaultStubValue: UInt8 {
        return 123
    }
}


extension UInt16: DefaultStubValueProviding {
    /// 12,345.
    public static var defaultStubValue: UInt16 {
        return 12_345
    }
}


extension UInt32: DefaultStubValueProviding {
    /// 1,234,567,890.
    public static var defaultStubValue: UInt32 {
        return 1_234_567_890
    }
}


extension UInt64: DefaultStubValueProviding {
    /// 1,234,567,890.
    public static var defaultStubValue: UInt64 {
        return 1_234_567_890
    }
}


extension URL: DefaultStubValueProviding {
    /// `https://default.stub`.
    public static var defaultStubValue: URL {
        return URL(string: "https://default.stub")!
    }
}


extension UUID: DefaultStubValueProviding {
    /// `DEADC0DE-DEAD-C0DE-DEAD-C0DEDEADC0DE`.
    public static var defaultStubValue: UUID {
        return UUID(uuidString: "DEADC0DE-DEAD-C0DE-DEAD-C0DEDEADC0DE")!
    }
}
