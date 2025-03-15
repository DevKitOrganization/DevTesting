//
//  URLComponents+Random.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/14/25.
//

import Foundation


extension URLComponents {
    /// Returns random URL components.
    ///
    /// The URL components are generated as follows:
    ///
    ///   - The scheme is `"https"`
    ///   - The host is of the form `subdomain<XXXXX>.domain<XXXXX>.<tld>`. Here, _<XXXXX>_ are five random
    ///     alphanumeric characters, and _<tld>_ is one of _com_, _edu_, _gov_, _net_, or _org_.
    ///   - The path contains 1–5 components, each of which are random alphanumeric strings between 1–5 characters long.
    ///   - If the function includes fragments, the fragment is a random alphanumeric string between 3–5 characters
    ///     long.
    ///   - If the function includes query items, it will contain between 1–5, each of which is generated using
    ///     ``Foundation/URLQueryItem/random(using:)``.
    ///
    /// - Parameters:
    ///   - includeFragment: Whether the components should include a fragment. If `nil`, the function will randomly
    ///     include a fragment or not.
    ///   - includeQueryItems: Whether the components should include query items. If `nil`, the function will randomly
    ///     include query items or not.
    ///   - generator: The random number generator to use when creating the new random URL components.
    public static func random(
        includeFragment: Bool? = nil,
        includeQueryItems: Bool? = nil,
        using generator: inout some RandomNumberGenerator
    ) -> URLComponents {
        var urlComponents = URLComponents()

        // The scheme is always https
        urlComponents.scheme = "https"

        // Generate the domain
        let subdomain = "subdomain\(String.randomAlphanumeric(count: 5, using: &generator))"
        let domain = "domain\(String.randomAlphanumeric(count: 5, using: &generator))"
        let tld = ["com", "edu", "gov", "net", "org"].randomElement(using: &generator)!
        urlComponents.host = "\(subdomain).\(domain).\(tld)"

        // Generate the path
        let pathComponents = Array(count: Int.random(in: 1 ... 5, using: &generator)) {
            String.randomAlphanumeric(
                count: Int.random(in: 1 ... 5, using: &generator),
                using: &generator
            )
        }
        urlComponents.path = "/\(pathComponents.joined(separator: "/"))"

        // Include a fragment if needed
        if includeFragment ?? Bool.random(using: &generator) {
            urlComponents.fragment = String.randomAlphanumeric(
                count: Int.random(in: 3 ... 5, using: &generator),
                using: &generator
            )
        }

        // Include query items if needed
        if includeQueryItems ?? Bool.random(using: &generator) {
            urlComponents.queryItems = Array(count: Int.random(in: 1 ... 5, using: &generator)) {
                return .random(using: &generator)
            }
        }

        return urlComponents
    }
}
