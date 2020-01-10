//
//  AuthUseCase.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class AuthUseCase {
    
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let userSettingsRepository: UserSettingsRepositoryProtocol
    
    init(_ authRepository: AuthRepositoryProtocol = AuthRepository(),
         userRepository: UserRepositoryProtocol = UserRepository(),
         userSettingsRepository: UserSettingsRepositoryProtocol = UserSettingsRepository()) {
        self.authRepository = authRepository
        self.userRepository = userRepository
        self.userSettingsRepository = userSettingsRepository
    }
    
    func login(loginUser: LoginUserItem, completionHandler: @escaping (String?) -> Void) {
        authRepository.login(loginUser: loginUser.mapToBusiness()) { (authUserModel, errorString) in
            guard let authUserModel = authUserModel else {
                completionHandler(errorString)
                return
            }
            self.userRepository.setAuthUser(userModel: authUserModel.user)
            self.userSettingsRepository.setUserSettings(userSettings: authUserModel.userSettings)
            completionHandler(nil)
        }
    }
    
    func register(registerUser: RegistrationUserItem, completionHandler: @escaping (String?) -> Void) {
        authRepository.register(registerUser: registerUser.mapToBusiness()) { (authUserModel, errorString) in
            guard let authUserModel = authUserModel else {
                completionHandler(errorString)
                return
            }
            self.userRepository.setAuthUser(userModel: authUserModel.user)
            self.userSettingsRepository.setUserSettings(userSettings: authUserModel.userSettings)
            completionHandler(nil)
        }
    }
    
    func logout(completionHandler: @escaping (String?) -> Void) {
        authRepository.logout { (errorString) in
            guard errorString == nil else {
                completionHandler(errorString)
                return
            }
            completionHandler(nil)
        }
    }
    
}
