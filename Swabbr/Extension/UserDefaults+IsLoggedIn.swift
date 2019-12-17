//
//  UserDefaults+IsLoggedIn.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

extension UserDefaults {
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: "isLoggedIn")
    }
    
    func getIsLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
}
