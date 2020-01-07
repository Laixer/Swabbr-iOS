//
//  UserDefaults+IsLoggedIn.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

extension UserDefaults {
    
    func setAccessToken(value: String) {
        set(value, forKey: "accessToken")
    }
    
    func getAccessToken() -> String? {
        return string(forKey: "accessToken")
    }
    
}
