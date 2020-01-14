//
//  AuthDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol AuthDataSourceProtocol {
    
    /**
     Login the user.
     - parameter loginUser: A LoginUser.
     - parameter completionHandler: The callback will return an optional AuthorizedUser and an optional String.
     */
    func login(loginUser: LoginUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void)
    
    /**
     Register a user.
     - parameter registerUser: A RegistrationUser.
     - parameter completionHandler: The callback will return an optional AuthorizedUser and an optional String.
     */
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void)
    
    /**
     Logout the current user.
     - parameter completionHandler: The callback will return an optional String.
     */
    func logout(completionHandler: @escaping (String?) -> Void)
}
