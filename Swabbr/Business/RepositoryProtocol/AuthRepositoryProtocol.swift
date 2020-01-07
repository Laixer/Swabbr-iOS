//
//  AuthRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol AuthRepositoryProtocol {
    func login(loginUser: LoginUserModel, completionHandler: @escaping (String?) -> Void)
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (String?) -> Void)
}
