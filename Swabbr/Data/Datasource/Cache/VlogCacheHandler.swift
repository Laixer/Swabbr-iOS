//
//  VlogCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

import CodableCache

class VlogCacheHandler: VlogCacheDataSourceProtocol {
    
    static let shared = VlogCacheHandler()
    
    private let cache: CodableCache<[Vlog]>!
    
    private init() {
        cache = CodableCache<[Vlog]>(key: String(describing: Vlog.self))
        try? cache.set(value: [Vlog]())
    }
    
    func get(id: String, completionHandler: @escaping (Vlog) -> Void) throws {
        guard let vlogs = cache.get() else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        guard let vlog = vlogs.first(where: {$0.id == id}) else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        completionHandler(vlog)
    }
    
    func set(object: Vlog?) {
        guard let object = object else {
            return
        }
        guard var vlogs = cache.get() else {
            return
        }
        if let index = vlogs.firstIndex(where: {$0.id == object.id}) {
            vlogs[index] = object
        } else {
            vlogs.append(object)
        }
        try? cache.set(value: vlogs)
    }
    
}
