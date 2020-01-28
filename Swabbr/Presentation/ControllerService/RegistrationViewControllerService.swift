//
//  RegistrationViewControllerService.swift
//  Swabbr
//
//  Created by James Bal on 12-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class RegistrationViewControllerService {
    
    weak var delegate: RegistrationViewControllerServiceDelegate?
    
    private let registerUseCase = AuthUseCase()
    
    /**
     Register a user using the AuthUseCase.
     - parameter registrationUserItem: A RegistrationUserItem object.
    */
    func registerUser(registrationUserItem: RegistrationUserItem) {
        registerUseCase.register(registerUser: registrationUserItem) { (errorString) in
            self.delegate?.registeredUser(errorString: errorString)
        }
    }
    
}

protocol RegistrationViewControllerServiceDelegate: class {
    /**
     Will be run when the register call has been completed.
     - parameter errorString: An optional String representing the error.
     */
    func registeredUser(errorString: String?)
}
