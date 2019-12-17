//
//  AuthUseCase.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class AuthUseCase {
    
    private let loginRepository: LoginRepositoryProtocol
    private let registerRepository: RegisterRepositoryProtocol
    
    init(_ loginRepository: LoginRepositoryProtocol = LoginRepository(), _ registerRepository: RegisterRepositoryProtocol = RegisterRepository()) {
        self.loginRepository = loginRepository
        self.registerRepository = registerRepository
    }
    
    func login(loginUser: LoginUserItem) {
        loginRepository.login(loginUser: loginUser.mapToBusiness()) { (code) in
            print(code)
        }
    }
    
    func register() {
        
    }
    
}
