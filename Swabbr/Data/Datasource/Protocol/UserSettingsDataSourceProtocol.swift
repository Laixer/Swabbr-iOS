//
//  UserSettingsDataSourceProtocol.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

protocol UserSettingsDataSourceProtocol {
    /**
     Retrieve the usersettings from a source.
     - parameter completionHandler: A completionHandler which will return an optional UserSettings object.
    */
    func get(completionHandler: @escaping (UserSettings?) -> Void)
    
    /**
     Update the usersettings.
     - parameter userSettings: An UserSettings object.
     - parameter completionHandler: A completionHandler which will return an optional UserSettings object and optional Error String.
    */
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping (UserSettings?, String?) -> Void)
}
