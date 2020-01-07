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
    var rememberMe: Bool
    
    func mapToBusiness() -> LoginUserModel {
        return LoginUserModel(email: email,
                              password: password,
                              rememberMe: rememberMe)
    }
    
}

