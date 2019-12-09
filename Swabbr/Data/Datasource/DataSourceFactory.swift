//
//  DataSourceFactory.swift
//  Swabbr
//
//  Created by James Bal on 06-12-19.
//  Copyright © 2019 Laixer. All rights reserved.
//

struct DataSourceFactory<Entity: Decodable>: DataSourceProtocol, DataSourceAllProtocol, DataSourceSingleMultipleProtocol {
    
    private var _getAll: ((@escaping ([Entity]?) -> Void) -> Void)?
    private var _getSingleMultiple: ((String, (@escaping ([Entity]?) -> Void)) -> Void)?
    private var _get: ((String, (@escaping (Entity?) -> Void)) -> Void)?
    
    init<DataSource: DataSourceProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
    }
    
    init<DataSource: DataSourceSingleMultipleProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getSingleMultiple = dataSource.getSingleMultiple
    }
    
    init<DataSource: DataSourceAllProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getAll = dataSource.getAll
    }
    
    init<DataSource: DataSourceSingleMultipleProtocol & DataSourceAllProtocol>(_ dataSource: DataSource) where DataSource.Entity == Entity {
        _get = dataSource.get
        _getSingleMultiple = dataSource.getSingleMultiple
        _getAll = dataSource.getAll
    }
    
    func getAll(completionHandler: @escaping ([Entity]?) -> Void) {
        _getAll?(completionHandler)
    }
    
    func getSingleMultiple(id: String, completionHandler: @escaping ([Entity]?) -> Void) {
        _getSingleMultiple?(id, completionHandler)
    }
    
    func get(id: String, completionHandler: @escaping (Entity?) -> Void) {
        _get?(id, completionHandler)
    }
}
