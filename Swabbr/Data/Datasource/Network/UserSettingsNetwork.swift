//
//  UserSettingsNetwork.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

class UserSettingsNetwork: NetworkProtocol, UserSettingsDataSourceProtocol {
    
    typealias Entity = UserSettings
    
    static let shared = UserSettingsNetwork()
    
    var endPoint: String = "userSettings"
    
    func get(id: String, completionHandler: @escaping (UserSettings?) -> Void) {
        load(buildUrl(), withCompletion: { (userSettings) in
            completionHandler((userSettings != nil) ? userSettings![0] : nil)
        })
    }
    
    func updateUserSettings(userSettings: UserSettings, completionHandler: @escaping (Int) -> Void) {
        completionHandler(200)
    }
}
