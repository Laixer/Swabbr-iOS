//
//  UserSettingsUseCase.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserSettingsUseCase {
    
    private let repository: UserSettingsRepositoryProtocol
    
    init(_ repository: UserSettingsRepositoryProtocol = UserSettingsRepository()) {
        self.repository = repository
    }
    
    func get(refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void) {
        repository.get(refresh: refresh, completionHandler: completionHandler)
    }
    
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping (String?) -> Void) {
        repository.updateUserSettings(userSettings: userSettings, completionHandler: completionHandler)
    }
    
}
