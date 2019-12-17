//
//  LoginUserItem.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct LoginUserItem {
    
    var email: String
    var password: String
    
    func mapToBusiness() -> LoginUserModel {
        return LoginUserModel(email: email,
                              password: password)
    }
    
}

