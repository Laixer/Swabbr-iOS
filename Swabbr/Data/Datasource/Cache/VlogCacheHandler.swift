//
//  VlogCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import CodableCache

class VlogCacheHandler: CacheDataSourceProtocol {
    typealias Entity = Vlog
    
    static let shared = VlogCacheHandler()
    
    private let cache: CodableCache<[Entity]>!
    
    private init() {
        cache = CodableCache<[Entity]>(key: String(describing: Entity.self))
        try? cache.set(value: [] as! [Entity])
    }
    
    func get(completionHandler: @escaping ([Vlog]?) -> Void) {
        completionHandler(try cache.get())
    }
    
    func get(id: Int, completionHandler: @escaping (Vlog?) -> Void) {
        guard let vlogs = cache.get() else {
            completionHandler(nil)
            return
        }
        completionHandler(vlogs.first(where: {$0.id == id}))
    }
    
    func set(object: Vlog?) {
        guard let object = object else {
            return
        }
        guard var vlogs = cache.get() else {
            return
        }
        if vlogs.contains(where: {$0.id == object.id}) {
            return
        }
        vlogs.append(object)
        try? cache.set(value: vlogs)
    }
    
    func set(objects: [Vlog]?) {
        guard let objects = objects else {
            return
        }
        try? cache.set(value: objects)
    }
    
}
