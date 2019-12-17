//
//  AuthRepository.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class LoginRepository: LoginRepositoryProtocol {
    
    private let network: LoginDataSourceProtocol
    private let userCache: CacheDataSourceFactory<User>
    private let userSettingsCache: CacheDataSourceFactory<UserSettings>
    
    init(network: LoginDataSourceProtocol = LoginNetwork(),
         userCache: CacheDataSourceFactory<User> = CacheDataSourceFactory(UserCacheHandler.shared),
         userSettingsCache: CacheDataSourceFactory<UserSettings> = CacheDataSourceFactory(UserSettingsCacheHandler.shared)) {
        self.network = network
        self.userCache = userCache
        self.userSettingsCache = userSettingsCache
    }
    
    func login(loginUser: LoginUserModel, completionHandler: @escaping (Int) -> Void) {
        network.login(loginUser: LoginUser.mapToEntity(model: loginUser)) { (code, accessToken, user, userSettings) in
            self.userCache.set(object: user)
            self.userSettingsCache.set(object: userSettings)
            completionHandler(code)
        }
    }
    
}

class RegisterRepository: RegisterRepositoryProtocol {
    
    private let network: RegisterDataSourceProtocol
    private let userCache: CacheDataSourceFactory<User>
    private let userSettingsCache: CacheDataSourceFactory<UserSettings>
    
    init(network: RegisterDataSourceProtocol = RegistrationNetwork(),
         userCache: CacheDataSourceFactory<User> = CacheDataSourceFactory(UserCacheHandler.shared),
         userSettingsCache: CacheDataSourceFactory<UserSettings> = CacheDataSourceFactory(UserSettingsCacheHandler.shared)) {
        self.network = network
        self.userCache = userCache
        self.userSettingsCache = userSettingsCache
    }
    
    func register(registerUser: RegistrationUserModel, completionHandler: @escaping (Int) -> Void) {
        network.register(registrationUser: RegistrationUser.mapToEntity(model: registerUser)) { (code, accessToken, user, userSettings) in
            self.userCache.set(object: user)
            self.userSettingsCache.set(object: userSettings)
            completionHandler(code)
        }
    }
}
