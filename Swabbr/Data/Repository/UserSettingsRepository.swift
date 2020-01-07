//
//  UserSettingsRepository.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

// swiftlint:disable force_try

class UserSettingsRepository: UserSettingsRepositoryProtocol {
    
    private let network: UserSettingsDataSourceProtocol
    private let userSettingsCache: UserSettingsCacheDataSourceProtocol
    private let authorizedUserCache: AuthorizedUserCacheDataSourceProtocol

    init(network: UserSettingsDataSourceProtocol = UserSettingsNetwork(),
         userSettingsCache: UserSettingsCacheDataSourceProtocol = UserSettingsCacheHandler.shared,
         authorizedUserCache: AuthorizedUserCacheDataSourceProtocol = AuthorizedUserCacheHandler.shared) {
        self.network = network
        self.userSettingsCache = userSettingsCache
        self.authorizedUserCache = authorizedUserCache
    }
    
    func get(refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void) {
        if refresh {
            network.get(completionHandler: { (userSettingsModel) in
                self.userSettingsCache.set(object: userSettingsModel)
                completionHandler(userSettingsModel?.mapToBusiness())
            })
        } else {
            do {
                try userSettingsCache.get { (userSettings) in
                    completionHandler(userSettings.mapToBusiness())
                }
            } catch {
                self.get(refresh: !refresh, completionHandler: completionHandler)
            }
        }
    }
    
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping(String?) -> Void) {
        network.updateUserSettings(userSettings: UserSettings.mapToEntity(model: userSettings)) { (userSettings, errorString) in
            guard let userSettings = userSettings else {
                completionHandler(errorString)
                return
            }
            try! self.userSettingsCache.set(object: userSettings)
            completionHandler(nil)
        }
    }
}
