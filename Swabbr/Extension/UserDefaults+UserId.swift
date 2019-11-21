//
//  UserDefaults+UserId.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setUserId(value: Int) {
        set(value, forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    func getUserId() -> Int {
        return integer(forKey: UserDefaultsKeys.userId.rawValue)
    }
    
}

fileprivate enum UserDefaultsKeys: String {
    case userId
}
