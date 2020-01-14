//
//  AuthRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol AuthRepositoryProtocol {
    
    /**
     Login the user.
     - parameter loginUser: A LoginUserModel.
     - parameter completionHandler: The callback will return an optional AuthorizedUserModel and an optional String.
    */
    func login(loginUser: LoginUserModel, completionHandler: @escaping (AuthorizedUserModel?, String?) -> Void)
    
    /**
     Register a user.
     - parameter registerUser: A RegistrationUserModel.
     - parameter completionHandler: The callback will return an optional AuthorizedUserModel and an optional String.
    */
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (AuthorizedUserModel?, String?) -> Void)
    
    /**
     Logout the current user.
     - parameter completionHandler: The callback will return an optional String.
    */
    func logout(completionHandler: @escaping (String?) -> Void)
}
