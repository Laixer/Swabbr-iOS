//
//  LoginViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 16-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class LoginViewControllerService {
    
    private let loginUseCase = AuthUseCase()
    
    func login() {
        loginUseCase.login(loginUser: LoginUserItem(email: "test", password: "test"))
    }
    
}
