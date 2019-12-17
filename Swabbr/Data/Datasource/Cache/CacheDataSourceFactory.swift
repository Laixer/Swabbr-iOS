//
//  CacheDataSourceFactory.swift
//  Swabbr
//
//  Created by James Bal on 13-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct CacheDataSourceFactory<Entity: Decodable> {
    
    private var _get: ((String, (@escaping (Entity) -> Void)) throws -> Void)?
    private var _getAll: ((@escaping ([Entity]) -> Void) throws -> Void)?
    
    private var _set: ((Entity?) -> Void)?
    private var _setAll: (([Entity]) -> Void)?
    
    init<CacheDataSource: CacheDataSourceProtocol>(_ cacheDataSource: CacheDataSource) where CacheDataSource.Entity == Entity {
        _get = cacheDataSource.get
        _set = cacheDataSource.set
    }
    
    init<CacheDataSource: CacheDataSourceAllProtocol>(_ cacheDataSource: CacheDataSource) where CacheDataSource.Entity == Entity {
        _get = cacheDataSource.get
        _getAll = cacheDataSource.getAll
        _set = cacheDataSource.set
        _setAll = cacheDataSource.setAll
    }
    
    func get(id: String, completionHandler: @escaping (Entity) -> Void) throws {
        try _get?(id, completionHandler)
    }
    
    func getAll(completionHandler: @escaping ([Entity]) -> Void) throws {
        try _getAll?(completionHandler)
    }
    
    func set(object: Entity?) {
        _set?(object)
    }
    
    func setAll(objects: [Entity]) {
        _setAll?(objects)
    }
}
