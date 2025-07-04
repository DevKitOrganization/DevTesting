//
//  HashableError.swift
//  DevTesting
//
//  Created by Prachi Gauriar on 3/9/25.
//

import Foundation

struct HashableError: Error, Hashable {
    let id: Int
}
