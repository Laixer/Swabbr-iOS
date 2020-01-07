//
//  AuthUseCase.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class AuthUseCase {
    
    private let authRepository: AuthRepositoryProtocol
    
    init(_ authRepository: AuthRepositoryProtocol = AuthRepository()) {
        self.authRepository = authRepository
    }
    
    func login(loginUser: LoginUserItem, completionHandler: @escaping (String?) -> Void) {
        authRepository.login(loginUser: loginUser.mapToBusiness(), completionHandler: completionHandler)
    }
    
    func register(registerUser: RegistrationUserItem, completionHandler: @escaping (String?) -> Void) {
        authRepository.register(registerUser: registerUser.mapToBusiness(), completionHandler: completionHandler)
    }
    
}
