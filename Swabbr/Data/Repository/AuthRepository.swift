//
//  AuthRepository.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class AuthRepository: AuthRepositoryProtocol {
    
    private let network: AuthDataSourceProtocol
    private let userCache: UserCacheDataSourceProtocol
    private let userSettingsCache: UserSettingsCacheDataSourceProtocol
    private let authorizedUserCache: AuthorizedUserCacheDataSourceProtocol
    
    init(network: AuthDataSourceProtocol = AuthNetwork(),
         userCache: UserCacheDataSourceProtocol = UserCacheHandler.shared,
         userSettingsCache: UserSettingsCacheDataSourceProtocol = UserSettingsCacheHandler.shared,
         authorizedUserCache: AuthorizedUserCacheDataSourceProtocol = AuthorizedUserCacheHandler.shared) {
        self.network = network
        self.userCache = userCache
        self.userSettingsCache = userSettingsCache
        self.authorizedUserCache = authorizedUserCache
    }
    
    func login(loginUser: LoginUserModel, completionHandler: @escaping (String?) -> Void) {
        network.login(loginUser: LoginUser.mapToEntity(model: loginUser)) { (authorizedUser, errorString) in
            guard let authorizedUser = authorizedUser else {
                completionHandler(errorString)
                return
            }
            self.userCache.set(object: authorizedUser.user)
            self.userSettingsCache.set(object: authorizedUser.userSettings)
            self.authorizedUserCache.set(object: authorizedUser)
            completionHandler(nil)
        }
    }
    
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (String?) -> Void) {
        network.register(registrationUser: RegistrationUser.mapToEntity(model: registerUser)) { (authorizedUser, errorString) in
            guard let authorizedUser = authorizedUser else {
                completionHandler(errorString)
                return
            }
            self.userCache.set(object: authorizedUser.user)
            self.userSettingsCache.set(object: authorizedUser.userSettings)
            self.authorizedUserCache.set(object: authorizedUser)
            completionHandler(nil)
        }
    }
    
}
