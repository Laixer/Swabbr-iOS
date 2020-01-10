//
//  AuthRepository.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class AuthRepository: AuthRepositoryProtocol {
    
    private let network: AuthDataSourceProtocol
    private let authorizedUserCache: AuthorizedUserCacheDataSourceProtocol
    
    init(network: AuthDataSourceProtocol = AuthNetwork(),
         authorizedUserCache: AuthorizedUserCacheDataSourceProtocol = AuthorizedUserCacheHandler.shared) {
        self.network = network
        self.authorizedUserCache = authorizedUserCache
    }
    
    func login(loginUser: LoginUserModel, completionHandler: @escaping (AuthorizedUserModel?, String?) -> Void) {
        network.login(loginUser: LoginUser.mapToEntity(model: loginUser)) { (authUser, errorString) in
            guard let authUser = authUser else {
                completionHandler(nil, errorString)
                return
            }
            self.authorizedUserCache.set(object: authUser)
            completionHandler(authUser.mapToBusiness(), nil)
        }
    }
    
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (AuthorizedUserModel?, String?) -> Void) {
        network.register(registrationUser: RegistrationUser.mapToEntity(model: registerUser)) { (authUser, errorString) in
            guard let authUser = authUser else {
                completionHandler(nil, errorString)
                return
            }
            self.authorizedUserCache.set(object: authUser)
            completionHandler(authUser.mapToBusiness(), nil)
        }
    }
    
    func logout(completionHandler: @escaping (String?) -> Void) {
        network.logout { (errorString) in
            guard errorString == nil else {
                completionHandler(errorString)
                return
            }
            self.authorizedUserCache.remove()
            completionHandler(nil)
        }
    }
    
}
