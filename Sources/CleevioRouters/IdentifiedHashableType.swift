//
//  IdentifiedHashableType.swift
//
//
//  Created by Lukáš Valenta on 08.07.2023.
//

import Foundation
import CleevioCore

/// An enumeration representing the type of a hashable identifier.
///
/// You can use `IdentifiedHashableType` to associate a value with a key of a specific type.
/// It can be either a base type or an identified type with a specific identifier.
public enum IdentifiedHashableType<T>: Hashable {
    /// Represents a base type without an identifier.
    case base(HashableType<T>)
    
    /// Represents an identified type with a specific identifier.
    /// - Parameters:
    ///   - type: The type of the key.
    ///   - identifier: The specific identifier that specifies the key.
    case identified(HashableType<T>, identifier: String)
}

public extension Dictionary {
    /// Accesses the value associated with the specified key.
    ///
    /// - Parameters:
    ///   - key: The type of the key.
    ///   - identifier: The specific identifier that specifies the key. Use `nil` if the key is not identified.
    /// - Returns: The value associated with `key`, or `nil` if `key` is not in the dictionary.
    subscript<T>(key: T.Type, identifier: String? = nil) -> Value? where Key == IdentifiedHashableType<T> {
        get {
            let type = HashableType(key)

            if let identifier {
                return self[.identified(type, identifier: identifier)]
            }
            
            return self[IdentifiedHashableType.base(type)]
        }
        set {
            let type = HashableType(key)

            if let identifier {
                return self[IdentifiedHashableType.identified(type, identifier: identifier)] = newValue
            }
            
            self[IdentifiedHashableType.base(type)] = newValue
        }
    }
}
