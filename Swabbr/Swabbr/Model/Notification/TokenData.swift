//
//  TokenData.swift
//  Swabbr
//
//  Created by James Bal on 15-10-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

struct TokenData {
    
    let token: String
    let expiration: Int
    
    init(withToken token: String, andTokenExpiration expiration: Int) {
        self.token = token
        self.expiration = expiration
    }
    
}
