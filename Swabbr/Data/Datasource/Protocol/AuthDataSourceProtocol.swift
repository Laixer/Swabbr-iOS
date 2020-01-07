//
//  AuthDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol AuthDataSourceProtocol {
    func login(loginUser: LoginUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void)
    func register(registrationUser: RegistrationUser, completionHandler: @escaping (AuthorizedUser?, String?) -> Void)
}
