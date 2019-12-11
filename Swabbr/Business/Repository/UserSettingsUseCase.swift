//
//  UserSettingsUseCase.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserSettingsUseCase {
    
    private let repository: RepositoryFactory<UserSettingsModel>
    
    init(_ repository: RepositoryFactory<UserSettingsModel> = RepositoryFactory(UserSettingsRepository())) {
        self.repository = repository
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void) {
        repository.get(id: id, refresh: refresh, completionHandler: completionHandler)
    }
    
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping (Int) -> Void) {
        repository.updateUserSettings(userSettings: userSettings, completionHandler: completionHandler)
    }
    
}

