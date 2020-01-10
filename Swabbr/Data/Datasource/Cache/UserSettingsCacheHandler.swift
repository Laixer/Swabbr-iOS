//
//  UserSettingsCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import CodableCache

class UserSettingsCacheHandler: UserSettingsCacheDataSourceProtocol {
    
    static let shared = UserSettingsCacheHandler()
    
    private let cache: CodableCache<UserSettings>!
    
    private init() {
        cache = CodableCache<UserSettings>(key: String(describing: UserSettings.self))
    }
    
    func get(completionHandler: @escaping (UserSettings) -> Void) throws {
        guard let userSettings = cache.get() else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        completionHandler(userSettings)
    }
    
    func set(object: UserSettings?) {
        guard let object = object else {
            return
        }
        try? cache.set(value: object)
    }
    
    func remove() {
        try? cache.clear()
    }
    
}
