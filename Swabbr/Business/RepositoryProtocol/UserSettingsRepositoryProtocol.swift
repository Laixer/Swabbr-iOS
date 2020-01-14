//
//  UserSettingsRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserSettingsRepositoryProtocol {
    func get(refresh: Bool, completionHandler: @escaping (UserSettingsModel?) -> Void)
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping (String?) -> Void)
    func setUserSettings(userSettings: UserSettingsModel)
}
