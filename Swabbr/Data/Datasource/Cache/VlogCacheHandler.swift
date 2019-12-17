//
//  VlogCacheHandler.swift
//  Swabbr
//
//  Created by James Bal on 04-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//
// swiftlint:disable force_cast

import CodableCache

class VlogCacheHandler: VlogCacheDataSourceProtocol {
    
    static let shared = VlogCacheHandler()
    
    private let cache: CodableCache<[Vlog]>!
    
    private init() {
        cache = CodableCache<[Vlog]>(key: String(describing: Vlog.self))
        try? cache.set(value: [] as! [Vlog])
    }
    
    func getAll(completionHandler: @escaping ([Vlog]) -> Void) throws {
        guard let vlogs = cache.get() else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        guard !vlogs.isEmpty else {
            throw NSError.init(domain: "cache", code: 400, userInfo: nil)
        }
        completionHandler(vlogs)
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
        if vlogs.contains(where: {$0.id == object.id}) {
            return
        }
        vlogs.append(object)
        try? cache.set(value: vlogs)
    }
    
    func setAll(objects: [Vlog]) {
        try? cache.set(value: objects)
    }
    
}
