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
    
    /**
     Login a user using the AuthUseCase.
     - parameter loginItem: A LoginUserItem object.
    */
    func login(_ loginItem: LoginUserItem) {
        loginUseCase.login(loginUser: loginItem) { (errorString) in
            self.delegate?.handleLoginResponse(errorString: errorString)
        }
    }
    
}

protocol LoginViewControllerServiceDelegate: class {
    /**
     Will be run when the login call has been completed.
     - parameter errorString: An optional String representing the error.
    */
    func handleLoginResponse(errorString: String?)
}
