//
//  CacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 02-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import CodableCache

class UserCacheHandler: UserCacheDataSourceProtocol {
    
    static let shared = UserCacheHandler()
    
    private let cache: CodableCache<[User]>!
    
    private init() {
        cache = CodableCache<[User]>(key: String(describing: User.self))
        try? cache.set(value: [User]())
    }
    
    func getAll(completionHandler: @escaping ([User]) -> Void) throws {
        guard let users = cache.get() else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        guard !users.isEmpty else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        completionHandler(users)
    }
    
    func get(id: String, completionHandler: @escaping (User) -> Void) throws {
        guard let users = cache.get() else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        guard let user = users.first(where: {$0.id == id}) else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        completionHandler(user)
    }
    
    func set(object: User?) {
        guard let object = object else {
            return
        }
        guard var users = cache.get() else {
            return
        }
        if let index = users.firstIndex(where: {$0.id == object.id}) {
            users[index] = object
        } else {
            users.append(object)
        }
        try? cache.set(value: users)
    }
    
    func setAll(objects: [User]) {
        try? cache.set(value: objects)
    }
    
}
