//
//  VlogReactionCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import CodableCache

class VlogReactionCacheHandler: CacheDataSourceAllProtocol {
    typealias Entity = VlogReaction
    
    static let shared = VlogReactionCacheHandler()
    
    private let cache: CodableCache<[Entity]>!
    
    private init() {
        cache = CodableCache<[Entity]>(key: String(describing: Entity.self))
        try? cache.set(value: [] as! [Entity])
    }
    
    func getAll(completionHandler: @escaping ([VlogReaction]) -> Void) throws  {
        guard let vlogReactions = cache.get() else {
            throw NSError.init()
        }
        guard !vlogReactions.isEmpty else {
            throw NSError.init()
        }
        completionHandler(vlogReactions)
    }
    
    func get(id: String, completionHandler: @escaping (VlogReaction) -> Void) throws {
        guard let vlogReactions = cache.get() else {
            throw NSError.init()
        }
        guard let vlogReaction = vlogReactions.first(where: {$0.id == id}) else {
            throw NSError.init()
        }
        completionHandler(vlogReaction)
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
    
    func setAll(objects: [VlogReaction]) {
        try? cache.set(value: objects)
    }
    
}
