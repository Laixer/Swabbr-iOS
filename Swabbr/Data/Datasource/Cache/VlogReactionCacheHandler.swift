//
//  VlogReactionCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import CodableCache

class VlogReactionCacheHandler: CacheDataSourceProtocol {
    typealias Entity = VlogReaction
    
    static let shared = VlogReactionCacheHandler()
    
    private let cache: CodableCache<[Entity]>!
    
    private init() {
        cache = CodableCache<[Entity]>(key: String(describing: Entity.self))
        try? cache.set(value: [] as! [Entity])
    }
    
    func get(completionHandler: @escaping ([VlogReaction]?) -> Void) {
        completionHandler(try cache.get())
    }
    
    func get(id: Int, completionHandler: @escaping (VlogReaction?) -> Void) {
        guard let vlogReactions = cache.get() else {
            completionHandler(nil)
            return
        }
        completionHandler(vlogReactions.first(where: {$0.id == id}))
    }
    
    func set(object: VlogReaction?) {
        guard let object = object else {
            return
        }
        guard var vlogReactions = cache.get() else {
            return
        }
        if vlogReactions.contains(where: {$0.id == object.id}) {
            return
        }
        vlogReactions.append(object)
        try? cache.set(value: vlogReactions)
    }
    
    func set(objects: [VlogReaction]?) {
        guard let objects = objects else {
            return
        }
        try? cache.set(value: objects)
    }
    
}
