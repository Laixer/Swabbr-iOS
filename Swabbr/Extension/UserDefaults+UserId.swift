//
//  UserDefaults+UserId.swift
//  Swabbr
//
//  Created by James Bal on 20-11-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setUserId(value: String) {
        set(value, forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    func getUserId() -> String {
        return UserDefaultsKeys.userId.rawValue
    }
    
}

private enum UserDefaultsKeys: String {
    case userId
}
