//
//  AuthorizedUserCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 17-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import CodableCache

class AuthorizedUserCacheHandler: AuthorizedUserCacheDataSourceProtocol {
    
    static let shared = AuthorizedUserCacheHandler()
    
    private let cache: CodableCache<AuthorizedUser>!
    
    private init() {
        cache = CodableCache<AuthorizedUser>(key: String(describing: AuthorizedUser.self))
    }
    
    func get(id: String, completionHandler: @escaping (AuthorizedUser) -> Void) throws {
        guard let authorizedUser = cache.get() else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        completionHandler(authorizedUser)
    }
    
    func set(object: AuthorizedUser?) {
        guard let object = object else {
            return
        }
        try? cache.set(value: object)
    }
    
}
