//
//  UserSettingsRepositoryProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserSettingsRepositoryProtocol {
    
    /**
     Get the UserSettings of the current logged in user.
     - parameter refresh: When true indicates it needs to get the data from the remote.
     - parameter completionHandler: The callback will return an optional UserSettingsModel and an optional String.
    */
    func get(refresh: Bool, completionHandler: @escaping (UserSettingsModel?, String?) -> Void)
    
    /**
     Update the current UserSettings.
     - parameter userSettings: A UserSettingsModel with an updated dataset.
     - parameter completionHandler: The callback will return an optional String.
    */
    func updateUserSettings(userSettings: UserSettingsModel, completionHandler: @escaping (String?) -> Void)
    
    /**
     Update the current UserSettings in the cache.
     - parameter userSettings: A UserSettingsModel with an updated dataset.
    */
    func setUserSettings(userSettings: UserSettingsModel)
}
