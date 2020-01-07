//
//  UserSettingsDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserSettingsDataSourceProtocol {
    typealias SetHandler = (Int, UserSettings?) -> Void
    func get(completionHandler: @escaping (UserSettings?) -> Void)
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping SetHandler)
}
