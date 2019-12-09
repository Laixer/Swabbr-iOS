//
//  CacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import CodableCache

class UserCacheHandler: CacheDataSourceProtocol {
    typealias Entity = User
    
    static let shared = UserCacheHandler()
    
    private let cache: CodableCache<[Entity]>!
    
    private init() {
        cache = CodableCache<[Entity]>(key: String(describing: Entity.self))
        try? cache.set(value: [] as! [Entity])
    }
    
    func getAll(completionHandler: @escaping ([User]?) -> Void) {
        completionHandler(try cache.get())
    }
    
    func get(id: String, completionHandler: @escaping (User?) -> Void) {
        guard let users = cache.get() else {
            completionHandler(nil)
            return
        }
        completionHandler(users.first(where: {$0.id == id}))
    }
    
    func set(object: User?) {
        guard let object = object else {
            return
        }
        guard var users = cache.get() else {
            return
        }
        if users.contains(where: {$0.id == object.id}) {
            return
        }
        users.append(object)
        try? cache.set(value: users)
    }
    
    func set(objects: [User]?) {
        guard let objects = objects else {
            return
        }
        try? cache.set(value: objects)
    }
    
}
