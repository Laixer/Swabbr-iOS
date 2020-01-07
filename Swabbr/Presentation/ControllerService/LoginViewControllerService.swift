//
//  LoginViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 16-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class LoginViewControllerService {
    
    weak var delegate: LoginViewControllerServiceDelegate?
    
    private let loginUseCase = AuthUseCase()
    
    func login(_ loginItem: LoginUserItem) {
        loginUseCase.login(loginUser: loginItem) { (errorString) in
            self.delegate?.handleLoginResponse(errorString: errorString)
        }
    }
    
}

protocol LoginViewControllerServiceDelegate: class {
    func handleLoginResponse(errorString: String?)
}
