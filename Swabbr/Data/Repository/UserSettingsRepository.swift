//
//  UserSettingsRepository.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserSettingsRepository: UserSettingsRepositoryProtocol {
    
    
    private let network: UserSettingsDataSourceProtocol
    private let cache: UserSettingsCacheDataSourceProtocol

    init(network: UserSettingsDataSourceProtocol = UserSettingsNetwork(), cache: UserSettingsCacheDataSourceProtocol = UserSettingsCacheHandler.shared) {
        self.network = network
        self.cache = cache
    }
    
    func get(refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void) {
        if refresh {
            network.get(completionHandler: { (userSettingsModel) in
                self.cache.set(object: userSettingsModel)
                completionHandler(userSettingsModel?.mapToBusiness())
            })
        } else {
            do {
                try cache.get(id: "") { (userSettings) in
                    completionHandler(userSettings.mapToBusiness())
                }
            } catch {
                self.get(refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping(Int) -> Void) {
        network.updateUserSettings(userSettings: UserSettings.mapToEntity(model: userSettings), completionHandler: completionHandler)
    }
}
