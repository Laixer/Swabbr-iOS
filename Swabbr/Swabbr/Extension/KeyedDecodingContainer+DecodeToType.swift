//
//  KeyedDecodingContainer+DecodeToType.swift
//  Swabbr
//
//  Created by James Bal on 22-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    
    /**
     Decode a string value to an int value.
     - parameter type: An int type.
     - parameter key: The key that needs to be decoded.
     - Throws: A data corrupted error.
     - Returns: An int value.
    */
    func decodeToType(_ type: Int.Type, key: K) throws -> Int {
        let currentValue = try self.decode(String.self, forKey: key)
        guard let newValue = Int(currentValue) else {
            let context = DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Could not parse json key to Int object")
            throw DecodingError.dataCorrupted(context)
        }
        return newValue
    }
    
    /**
     Decode a string value to a double value.
     - parameter type: A double type.
     - parameter key: The key that needs to be decoded.
     - Throws: A data corrupted error.
     - Returns: A double value.
     */
    func decodeToType(_ type: Double.Type, key: K) throws -> Double {
        let currentValue = try self.decode(String.self, forKey: key)
        guard let newValue = Double(currentValue) else {
            let context = DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Could not parse json key to Double object")
            throw DecodingError.dataCorrupted(context)
        }
        return newValue
    }
    
    /**
     Decode a string value to a float value.
     - parameter type: A float type.
     - parameter key: The key that needs to be decoded.
     - Throws: A data corrupted error.
     - Returns: A float value.
     */
    func decodeToType(_ type: Float.Type, key: K) throws -> Float {
        let currentValue = try self.decode(String.self, forKey: key)
        guard let newValue = Float(currentValue) else {
            let context = DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Could not parse json key to Float object")
            throw DecodingError.dataCorrupted(context)
        }
        return newValue
    }
    
}
