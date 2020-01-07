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
    
    func registerUser(registrationUserItem: RegistrationUserItem) {
        registerUseCase.register(registerUser: registrationUserItem) { (errorString) in
            self.delegate?.registeredUser(errorString: errorString)
        }
    }
    
}

protocol RegistrationViewControllerServiceDelegate: class {
    func registeredUser(errorString: String?)
}
