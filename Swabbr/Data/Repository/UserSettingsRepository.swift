//
//  UserSettingsRepository.swift
//  Swabbr
//
//  Created by James Bal on 10-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserSettingsRepository: UserSettingsRepositoryProtocol {

    typealias Model = UserSettingsModel
    
    private let network: DataSourceFactory<UserSettings>

    init(network: DataSourceFactory<UserSettings> = DataSourceFactory(UserSettingsNetwork.shared)) {
        self.network = network
    }
    
    func get(id: String, refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void) {
        network.get(id: id, completionHandler: { (userSettingsModel) in
            completionHandler(userSettingsModel?.mapToBusiness())
        })
    }
    
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping(Int) -> Void) {
        network.updateUserSettings(userSettings: UserSettings.mapToEntity(model: userSettings), completionHandler: completionHandler)
    }
}

