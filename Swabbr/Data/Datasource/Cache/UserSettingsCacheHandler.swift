//
//  UserSettingsCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import CodableCache

class UserSettingsCacheHandler: CacheDataSourceProtocol {
    
    typealias Entity = UserSettings
    
    static let shared = UserSettingsCacheHandler()
    
    private let cache: CodableCache<Entity>!
    
    private init() {
        cache = CodableCache<Entity>(key: String(describing: Entity.self))
    }
    
    func get(id: String, completionHandler: @escaping (UserSettings) -> Void) throws {
        guard let userSettings = cache.get() else {
            throw NSError.init()
        }
        completionHandler(userSettings)
    }
    
    func set(object: UserSettings?) {
        guard let object = object else {
            return
        }
        try? cache.set(value: object)
    }
    
}
