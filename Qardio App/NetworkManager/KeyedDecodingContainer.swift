//
//  KeyedDecodingContainer.swift
//  Qardio App
//
//  Created by Alex K on 7.08.23.
//

import Foundation

extension KeyedDecodingContainer  {
    
    func decode<T: Decodable>(key: K) throws -> T {
        if T.self == Int.self || T.self == Int?.self {
            if let stringValue = try? decode(String.self, forKey: key) {
                if let object = Int(stringValue) {
                    return object as! T
                } else if let doubleValue = Double(stringValue) {
                    return Int(doubleValue) as! T
                }
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                return Int(doubleValue) as! T
            }
        } else if T.self == Int64.self || T.self == Int64?.self {
            if let stringValue = try? decode(String.self, forKey: key) {
                if let object = Int64(stringValue) {
                    return object as! T
                } else if let doubleValue = Double(stringValue) {
                    return Int64(doubleValue) as! T
                }
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                return Int64(doubleValue) as! T
            }
        } else if T.self == Decimal.self || T.self == Decimal?.self {
            if let stringValue = try? decode(String.self, forKey: key), let object = Decimal(string: stringValue) {
                return object as! T
            }
        } else if T.self == Bool.self || T.self == Bool?.self {
            if let stringValue = try? decode(String.self, forKey: key) {
                return (stringValue == "1") as! T
            } else if let intValue = try? decode(Int.self, forKey: key) {
                return (intValue == 1) as! T
            }
        } else if T.self == Double.self || T.self == Double?.self {
            if let stringValue = try? decode(String.self, forKey: key), let object = Double(stringValue) {
                return object as! T
            } else if let intValue = try? decode(Int.self, forKey: key) {
                return Double(intValue) as! T
            }
        } else if T.self == [Int].self || T.self == [Int]?.self {
            if let strings = try? decode([String].self, forKey: key) {
                return strings.compactMap({ Int($0) }) as! T
            }
        } else if T.self == String.self || T.self == String?.self {
            if let intValue = try? decode(Int.self, forKey: key) {
                return "\(intValue)" as! T
            }
        }
        return try decode(T.self, forKey: key)
    }
}
