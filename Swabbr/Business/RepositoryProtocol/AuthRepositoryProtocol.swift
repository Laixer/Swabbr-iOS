//
//  AuthRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol AuthRepositoryProtocol {
    func login(loginUser: LoginUserModel, completionHandler: @escaping (Int) -> Void)
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (Int) -> Void)
}
