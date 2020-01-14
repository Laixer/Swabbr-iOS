//
//  KeychainService.swift
//  Swabbr
//
//  Created by James Bal on 13-01-20.
//  Copyright © 2020 Laixer. All rights reserved.
//

import KeychainSwift

class KeychainService {
    
    static var shared: KeychainService = KeychainService(prefix: "swabbr-")
    
    private let keychain: KeychainSwift
    
    private init(prefix: String) {
        keychain = KeychainSwift(keyPrefix: prefix)
    }
    
    /**
     Set a string value in the keychain.
     - parameter key: The key of the value.
     - parameter value: The value.
    */
    func set(key: String, value: String) {
        keychain.set(value, forKey: key)
    }
    
    /**
     Get the string value with the key
     - parameter key: The key of the string that needs to be get.
     - Returns: A string value
    */
    func get(key: String) -> String? {
        return keychain.get(key)
    }
    
    /**
     Remove a value from the keychain.
     - parameter key: The key of the value that needs to be removed.
     */
    func remove(key: String) {
        keychain.delete(key)
    }
    
}
